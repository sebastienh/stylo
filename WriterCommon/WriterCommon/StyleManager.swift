//
//  StyleResourceManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-08-29.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public typealias StyleAssemblyDescriptorKey = String

/// The user-agent style sheet along with the author style sheets and
/// the user style sheets constitute the style represented by the Style
/// class. The author style sheets are all kept in a directory inside a 
/// document. The StyleManager class is reponsible for managing a Style
/// i.e. loading it and keeping it up to date.
public class StyleManager: NSObject, Observer {
    
    public var currentAppearanceSourceDescriptor: StyleAssemblyDescriptor {
        let computedAppearance = StyloApplication.shared.computedAppearanceOrDefault
        switch computedAppearance {
        case .dark:
            return StyleAssemblyDescriptor.textDarkStyleAssemblyDescriptor
        case .light:
            return StyleAssemblyDescriptor.textLightStyleAssemblyDescriptor
        }
    }

    public var otherAppearanceSourceDescriptor: StyleAssemblyDescriptor {
        let computedAppearance = StyloApplication.shared.computedAppearanceOrDefault
        switch computedAppearance {
        case .dark:
            return StyleAssemblyDescriptor.textLightStyleAssemblyDescriptor
        case .light:
            return StyleAssemblyDescriptor.textDarkStyleAssemblyDescriptor
        }
    }
    
    var currentAppearanceStyleAssembly: StyleAssembly? {
        let computedAppearance = StyloApplication.shared.computedAppearanceOrDefault
        switch computedAppearance {
        case .dark:
            return sourceDarkStyleAssembly
        case .light:
            return sourceLightStyleAssembly
        }
    }
    
    public var priority: ObserverPriority {
        return .background
    }
    
    ///
    public let selectedStyle = Dynamic<Bool>(false)
    
    /// Reference to the Dispatcher
    public var dispatcher: Dispatcher
    
    /// We still need it because the maangers are the one keeping the refeecne
    /// to the StringResourceModelRenderingCoordinator. Once it is gone we should
    /// also remove those reference here.
    var stylesheetManagers: [StylesheetManager] {
        return  stylesheets.map { (arg) -> StylesheetManager in
            let (_, value) = arg
            return value
        }
    }
    
    /// reference to the managed stylesheet document stores
    var stylesheetDocumentStores: [WeakContainer<StylesheetDocumentStore>]
    
    ///
    let styleManagerOperationQueue: OperationQueue
    
    let styleManagerType: StyleManagerType
    
    public var resourcesCount: Int {
        
        return stylesheetManagers.count
    }
    
    let editedStyleLanguage: Language
    
    @objc public dynamic var title: String {
        get {
            return dynamicTitle.value
        }
        set {
            self.updateTitle(newValue)
        }
    }
    
    public let dynamicTitle = Dynamic<String>("Untitled")
    
    
    /// The cssUserAgentStyleSheetResource is the same object for all CCSS styles so we
    /// need to get it in parameter. 
    
    var order: UInt32 = 0
    
    @objc public let id: String
    
    public let hasPendingChanges: Dynamic<Bool>

    var sourceLightStyleAssembly: StyleAssembly? {
        
        return self.styleAssemblies[StyleAssemblyDescriptor.textLightStyleAssemblyDescriptor]
    }
    
    var sourceDarkStyleAssembly: StyleAssembly? {
        
        return self.styleAssemblies[StyleAssemblyDescriptor.textDarkStyleAssemblyDescriptor]
    }
    
    internal private(set) var styleAssemblies: [StyleAssemblyDescriptor: StyleAssembly]
    
    public var registrantCounts: [StyleAssemblyDescriptor: Int] = [:]
    
    public var stylesheets: OrderedDictionary<StylesheetId, StylesheetManager>
    
    public var nonUserAgentStylesheetsCount: Int {
        
        var count = 0
        for (index, (_, stylesheetManager)) in stylesheets.enumerated() {
            
            if stylesheetManager.origin != .userAgent {
                assert(index != 0)
                count += 1
            }
        }
        return count
    }
    
    public let stylePreviews = DynamicDictionary<StyleAssemblyDescriptor, StylePreview>()
    
    private var appearance: AppearanceMode? {
        
        let application = StyloApplication.shared
        
        guard let styloApplicationStore = application.styloApplicationStore else {
            assertionFailure("Error: styloApplicationStore is nil")
            return nil
        }
        
        return styloApplicationStore.computedAppearance.value
    }
    
    var userAgentStylesheetManager: StylesheetManager?
    
    weak var undoManager: UndoManager? {
        didSet {
            for stylesheetManager in self.stylesheets.orderedValues {
                stylesheetManager.undoManager = self.undoManager
            }
        }
    }
    
    private let styleStore: StyleStore
    
    init(title: String = "Untitled Style", id: String, order: UInt32, userAgentStyleSheetDocumentStore: StylesheetDocumentStore, dispatcher: Dispatcher, editedStyleLanguage: Language, styleManagerType: StyleManagerType) {
        
        // assign a new uuid if passed styleId is nil
//        self.title = title
        self.id = id
        self.order = order
        self.styleManagerOperationQueue = OperationQueue()
        self.stylesheetDocumentStores = [WeakContainer<StylesheetDocumentStore>]()
        
        self.dispatcher = dispatcher
        self.editedStyleLanguage = editedStyleLanguage
        self.styleManagerType = styleManagerType
        
        self.hasPendingChanges = Dynamic<Bool>(false)
        self.stylesheets = [:]
        self.styleAssemblies = [:]
        self.styleStore = StyleStore(title: title, editedLanguage: editedStyleLanguage)
        
        super.init()
        
        let userAgentStylesheetManager = StylesheetManager(title: "useragent", id: "useragent", dispatcher: self.dispatcher, editedStylesheetLanguage: editedStyleLanguage, appearances: Set<AppearanceMode>(arrayLiteral: .dark, .light))
        userAgentStylesheetManager.stylesheetDocumentStore = userAgentStyleSheetDocumentStore
        addHandledStylesheetManager(stylesheetManager: userAgentStylesheetManager)
        self.userAgentStylesheetManager = userAgentStylesheetManager
        self.subscribeToStyleStore()
    }
    
    public func applyAppearanceMode(_ appearanceMode: AppearanceMode) {
        
        self.clearStyleAssemblies()
        
        let targetDescriptor: StyleAssemblyDescriptor = self.targetDescriptor(forAppearanceMode: appearanceMode)
        
        self.registerStyleAssemblyIfNecessaryAsync(forStyleAssemblyDescriptor: targetDescriptor).then {_ in
            self.updateStylePreview(withDescriptor: targetDescriptor)
        }
    }
    
    func targetDescriptor(forAppearanceMode appearanceMode: AppearanceMode) -> StyleAssemblyDescriptor {
        switch appearanceMode {
        case .dark:
            return .textDarkStyleAssemblyDescriptor
        case .light:
            return .textLightStyleAssemblyDescriptor
        }
    }
    
    func addStylesheet(filename: String, content: String, appearances: Set<AppearanceMode>, stylingManager: StyleManager?) {
        
        // avoid loading any other file than css files
        let stylesheetManager = StylesheetManager(title: filename, id: UUID().uuidString, dispatcher: self.dispatcher, editedStylesheetLanguage: editedStyleLanguage, appearances: appearances)
        
        // in the old document format we dont keep
        // a text preview so we need to compile the stylesheets to get it
        compileStylesheet(stylesheetManager: stylesheetManager, title: title, string: content, stylingManager: stylingManager)
        
        addHandledStylesheetManager(stylesheetManager: stylesheetManager)
    }
    
    public func deleteStylesheet(withId id: StylesheetId) -> Int? {
        
        guard let index = self.stylesheets.index(forKey: id) else {
            // stylo #1157
            // if the index is not there we simply ignore the UI event
            return nil
        }
        
        guard let _ = self.stylesheets.removeValue(forKey: id) else {
            assertionFailure("Error: stylesheetManager is nil")
            return index
        }
        
        let stylesheetDocumentStoreContainter = stylesheetDocumentStores.remove(at: index)
        
        guard let stylesheetDocumentStore = stylesheetDocumentStoreContainter.value else {
            assertionFailure("Error: stylesheetDocumentStore is nil")
            return index
        }
        
        stylesheetDocumentStore.stylesheet.unsubscribe(observer: self)
        return index
    }
    
    public func addEmptyStylesheet(stylingManager: StyleManager? = nil) {
        
        let stylesheetManager = StylesheetManager(title: "Untitled", id: UUID().uuidString, dispatcher: self.dispatcher, editedStylesheetLanguage: .CSS, origin: .author, appearances: Set<AppearanceMode>())
        stylesheetManager.undoManager = self.undoManager
        
        if let stylingManager = stylingManager {
            try? stylesheetManager.setStyle(withStyleManager: stylingManager, visibleRanges: nil)
        }
        
        stylesheetManager.setText(string: "")
        addHandledStylesheetManager(stylesheetManager: stylesheetManager)
    }
    
    public func clearStyleAssemblies() {
        
        self.unregisterStyleAssembly(withDescriptor: StyleAssemblyDescriptor.textDarkStyleAssemblyDescriptor)
        self.unregisterStyleAssembly(withDescriptor: StyleAssemblyDescriptor.textLightStyleAssemblyDescriptor)
    }
    
    public func updateTitle(_ title: String) {
        
        self.dispatcher.async(store: self.styleStore, action: StyleAction.updateTitle(title: title).asyncAction)
    }
    
    public func select() {
        
        self.dispatcher.async(store: self.styleStore, action: StyleAction.select.asyncAction)
    }
    
    public func unselect() {
    
        self.dispatcher.async(store: self.styleStore, action: StyleAction.unselect.asyncAction)
    }
        
    func shouldCompileStylesheets(fromStyleMetadata styleMetadata: StyleMetadata?) -> Bool {
        
        guard let styleMetadata = styleMetadata else {
            return true
        }
     
        return !styleMetadata.containsStylePreviews
    }
    
    private func subscribeToStyleStore() {
        
        self.selectedStyle.bind(to: styleStore.selectedStyle)
        
        self.handleTitleChange(self.styleStore.title.value)
        self.styleStore.title.subscribe({ [weak self](newTitle) in
            self?.handleTitleChange(newTitle)
        }, observer: self)
    }
    
    private func handleTitleChange(_ title: String) {
        
        self.dynamicTitle.setValue(title)
    }
    
    private func unsubscribeFromStyleStore() {
        
        self.selectedStyle.unbind(from: styleStore.selectedStyle)
    }

    ///
    /// This method register a style assembly if it has not already been registered.
    /// We should not forget here that all editors in a file outline will register to
    /// the same descriptor when being applied highlight or any temporary style assembly
    /// and that all these editors share the same style manager.
    ///
    /// Here we basically make sure that we only do the registering work only once. 
    ///
    @discardableResult
    func registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor) -> StyleAssemblyStore {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyleManager.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: %@)", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        if Thread.isMainThread {
            return self._registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: descriptor)
        }
        else {
            return DispatchQueue.main.sync { [weak self] in
                return self!._registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: descriptor)
            }
        }
    }
    
    private func _registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor) -> StyleAssemblyStore {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("_registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: %@)", log: Log.WriterCommon.all, type: .info, %%descriptor)
        #endif
        
        assert(Thread.isMainThread)
        if let styleAssembly = self.styleAssemblies[descriptor] {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("descriptor with key %@ already registered.", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
            #endif
            
            return styleAssembly.styleAssemblyStore
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("creating new style assembly manager for descriptor with key %@.", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        assert(self.styleAssemblies[descriptor] == nil)
        return registerStyleAssembly(forStyleAssemblyDescriptor: descriptor)
    }
    
    @discardableResult
    private func registerStyleAssembly(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor) -> StyleAssemblyStore {
 
        assert(self.styleAssemblies[descriptor] == nil)
        let stylesheets = self.stylesheets(forStyleAssemblyDescriptor: descriptor)
        
        assert(self.styleAssemblies[descriptor] == nil)
        let styleAssembly = StyleAssembly(title: self.id+descriptor.key, dispatcher: self.dispatcher, editedStyleLanguage: self.editedStyleLanguage, descriptor: descriptor)
        
        assert(self.styleAssemblies[descriptor] == nil)
        styleAssembly.updateStyleStoreValue(withStylesheets: stylesheets)
        
        assert(self.styleAssemblies[descriptor] == nil)
        registerToStyleAssembly(styleAssembly, withDescriptor: descriptor)
        
        return styleAssembly.styleAssemblyStore
    }
    
    ///
    /// This method register a style assembly if it has not already been registered.
    /// We should not forget here that all editors in a file outline will register to
    /// the same descriptor when being applied highlight or any temporary style assembly
    /// and that all these editors share the same style manager.
    ///
    /// Here we basically make sure that we only do the registering work only once.
    ///
    @discardableResult
    func registerStyleAssemblyIfNecessaryAsync(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor) -> Promise<StyleAssemblyStore> {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("registerStyleAssemblyIfNecessaryAsync(forStyleAssemblyDescriptor: %@)", log: Log.WriterCommon.all, type: .info, %%descriptor)
        #endif
        
        return Promise<StyleAssemblyStore> { fulfill, reject in
            DispatchQueue.asyncOnMain { [weak self] in
                if let _self = self {
                    let styleAssemblyStore = _self.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: descriptor)
                    fulfill(styleAssemblyStore)
                }
                else {
                    reject(NWError.custom(message: "Error: self is nil"))
                }
            }
        }
    }
    
    private func registerToStyleAssembly(_ styleAssembly: StyleAssembly, withDescriptor descriptor: StyleAssemblyDescriptor) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("registerToStyleAssembly(%@)", log: Log.WriterCommon.all, type: .info, %%descriptor)
        #endif
        
        assert(self.styleAssemblies[descriptor] == nil)
        self.styleAssemblies[descriptor] = styleAssembly
        self.updateStylePreview(withDescriptor: descriptor)
    }
    
    func updateStylePreview(withDescriptor descriptor: StyleAssemblyDescriptor) {
        
        guard let styleAssembly = self.styleAssemblies[descriptor] else {
            assertionFailure("Error: styleAssembly is nil")
            return
        }
        
        let textStylePreviewAction = StyleAssemblyAction.updateStylePreview.syncAction
        self.dispatcher.sync(store: styleAssembly.styleAssemblyStore, action: textStylePreviewAction)

        guard let stylePreview = styleAssembly.styleAssemblyStore.stylePreview.value else {
            assertionFailure("Error: stylePreview is nil")
            return
        }
        
        self.stylePreviews.updateValue(stylePreview, forKey: descriptor)
        styleAssembly.stylePreview.subscribe({ [weak self](stylePreview) in
            guard let stylePreview = styleAssembly.stylePreview.value else {
                assertionFailure("Error: stylePreview is nil")
                return
            }
            self?.stylePreviews.updateValue(stylePreview, forKey: descriptor)
        }, observer: self)
    }
    
    private func unregisterStyleAssembly(withDescriptor descriptor: StyleAssemblyDescriptor) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyleManager.unregisterStyleAssembly(withDescriptor: %@)", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        guard let styleAssembly = self.styleAssemblies[descriptor] else {
            return
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Unsubscribing from styleAssembly with descripor: %@'s styleAssemblyStore", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        styleAssembly.styleAssemblyStore.style.unsubscribe(observer: self)
        
        styleAssembly.stylePreview.unsubscribe(observer: self)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Removing CSSStyle for descriptor: %@", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Removing styleAssembly for descriptor: %@", log: Log.WriterCommon.all, type: .info, %%descriptor.key)
        #endif
        
        self.styleAssemblies.removeValue(forKey: descriptor)
    }
    
    /// This method should return clones of the
    func stylesheets(forStyleAssemblyDescriptor styleAssemblyDescriptor: StyleAssemblyDescriptor) -> [CSSStyleSheet] {
        
        var stylesheets: [CSSStyleSheet] = []
        
        switch styleAssemblyDescriptor.appearance {
        case .dark:
            for (_, stylesheetManager) in self.stylesheets {
                if stylesheetManager.appearances.values.contains(.dark) {
                    compileStylesheetIfNecessary(stylesheetManager)
                    guard let stylesheet = stylesheetManager.stylesheet else {
                        assertionFailure("Error: stylesheet is nil")
                        continue
                    }
                    stylesheets.append(stylesheet)
                }
            }
        case .light:
            for (_, stylesheetManager) in self.stylesheets {
                if stylesheetManager.appearances.values.contains(.light) {
                    compileStylesheetIfNecessary(stylesheetManager)
                    guard let stylesheet = stylesheetManager.stylesheet else {
                        assertionFailure("Error: stylesheet is nil")
                        continue
                    }
                    stylesheets.append(stylesheet)
                }
            }
        }
        return stylesheets
    }
    
    func compileStylesheetIfNecessary(_ stylesheetManager: StylesheetManager) {
        
        guard stylesheetManager.stylesheet == nil else {
            return
        }
        
        self.compileStylesheet(stylesheetManager: stylesheetManager)
    }
    
    func compileStylesheet(stylesheetManager: StylesheetManager) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("compileStylesheet(stylesheetManager: %@)", log: Log.WriterCommon.all, type: .info, %%stylesheetManager)
        #endif
        
        let action = StylesheetDocumentAction.createInitialStylesheet(source: stylesheetManager.string).syncAction
        let result = self.dispatcher.sync(store: stylesheetManager.stylesheetDocumentStore, action: action)
        if let stylesheetDocumentResult = result as? StylesheetDocumentResult {
            
            resetPendingChangesAndSetBaseStylesheet(stylesheetManager)
            
            assert(stylesheetDocumentResult.stylesheet != nil)
            
            // in viewing mode we don't care about the errors messages
            let updateErrorMessagesAction = FailableActionsFactory.updateErrorMessagesSyncAction()
            self.dispatcher.sync(store: stylesheetManager.stylesheetDocumentStore, action: updateErrorMessagesAction)
        }
        else {
            assertionFailure("Invalid result \(String(describing: result)), expecting StylesheetDocumentResult.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Invalid result %@, expecting StylesheetDocumentResult.", log: Log.WriterCommon.all, type: .error, %%String(describing: result))
            #endif
        }
    }
    
    func compileStylesheet(stylesheetManager: StylesheetManager, title: String, string: String, stylingManager: StyleManager?) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Loading style %@ with string: %@.", log: Log.WriterCommon.all, type: .info, %%title, %%string)
        #endif
        let action = StylesheetDocumentActionsFactory.createInitialStylesheetAction(source: string)
        let result = self.dispatcher.sync(store: stylesheetManager.stylesheetDocumentStore, action: action)
        if let stylesheetDocumentResult = result as? StylesheetDocumentResult {
            
            resetPendingChangesAndSetBaseStylesheet(stylesheetManager)
            
            assert(stylesheetDocumentResult.stylesheet != nil)
            stylesheetManager.setText(string: string)
            if let stylingManager = stylingManager {
                try? stylesheetManager.setStyle(withStyleManager: stylingManager, visibleRanges: nil)
            }
            
            // in viewing mode we don't care about the errors messages
            let updateErrorMessagesAction = FailableActionsFactory.updateErrorMessagesSyncAction()
            self.dispatcher.sync(store: stylesheetManager.stylesheetDocumentStore, action: updateErrorMessagesAction)
        }
        else {
            assertionFailure("Invalid result \(String(describing: result)), expecting StylesheetDocumentResult.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Invalid result %@, expecting StylesheetDocumentResult.", log: Log.WriterCommon.all, type: .error, %%String(describing: result))
            #endif
        }
    }
    
    private func resetPendingChangesAndSetBaseStylesheet(_ stylesheetManager: StylesheetManager) {
        
        let resetPendingChangesAction = EditableStoreActionsFactory.resetPendingChangesActionSync()
        self.dispatcher.sync(store: stylesheetManager.stylesheetDocumentStore, action: resetPendingChangesAction)
    }
    
    func createEmptyStylesheetManager(with initialStringValue: String? = nil) {

        let application = StyloApplication.shared
        let styloApplicationStore = application.styloApplicationStore
        let appearance = styloApplicationStore?.computedAppearance.value ?? AppearanceMode.dark
        
        guard let cssStyleSetManager = application.cssStyleSetManager else {
            assertionFailure("Error: application.cssStyleSetManager is nil")
            return
        }
        
        guard let stylingStyleManager = cssStyleSetManager.selectedStyleManager.value else {
            assertionFailure("Error: stylingStyleManager is nil")
            return
        }
        
        let cssTemplateString = application.templateString(for: appearance)
        let id = nextId!
        let stylesheetManager = StylesheetManager(title: id, id: id, dispatcher: self.dispatcher, editedStylesheetLanguage: editedStyleLanguage, appearances: Set<AppearanceMode>())
        if let initialStringValue = initialStringValue {
            
            try? stylesheetManager.setStyle(withStyleManager: stylingStyleManager, visibleRanges: nil)
            stylesheetManager.setText(string: initialStringValue)
        }
        else {
            try? stylesheetManager.setStyle(withStyleManager: stylingStyleManager, visibleRanges: nil)
            stylesheetManager.setText(string: cssTemplateString)
        }
        addHandledStylesheetManager(stylesheetManager: stylesheetManager)
    }
    
    func addHandledStylesheetManager(stylesheetManager: StylesheetManager) {
     
        #if DEBUG
        if stylesheetManager.stylesheet?.origin == .userAgent {
            assert(self.stylesheets.count == 0)
        }
        #endif
        self.stylesheets[stylesheetManager.id] = stylesheetManager
        addHandledStylesheetDocumentStore(stylesheetDocumentStore: stylesheetManager.stylesheetDocumentStore)
    }
    
    private func addHandledStylesheetDocumentStore(stylesheetDocumentStore: StylesheetDocumentStore) {
        
        // when adding a stylesheet document store it should already have been computed, except when creating a new style.
        stylesheetDocumentStores.append(WeakContainer<StylesheetDocumentStore>(value: stylesheetDocumentStore))
        stylesheetDocumentStore.stylesheet.subscribe({ [weak self](stylesheet) in
            self?.updateStyleStoreValue()
        }, observer: self)
        self.hasPendingChanges.bind(to: stylesheetDocumentStore.hasPendingChanges)
    }
    
    func updateStyleStoreValue() {
        
        for (styleAssemblyDescriptor, styleAssembly) in self.styleAssemblies {
            let stylesheets = self.stylesheets(forStyleAssemblyDescriptor: styleAssemblyDescriptor)
            styleAssembly.updateStyleStoreValueAsync(withStylesheets: stylesheets)
        }
    }
    
    /// This function returns a String resulting from the serialisation
    /// of all author css style sheets included in this Style.
    ///
    /// There seems to be no need of synchronizing this operation since
    /// we take a copy of the string.
    public func serialize() -> String {
        
        var userAgentStyleSheetString = "\n/* user-agent stylesheet */\n"
        var authorStyleSheetsString = "/* author stylesheet */\n"
        var userStyleSheetString = "/* user stylesheet */\n"
        
        for stylesheetDocumentStore in stylesheetDocumentStores {
            
            if let styleSheetStoreValue = stylesheetDocumentStore.value {
                
                switch styleSheetStoreValue.origin {
                    
                case .userAgent:
                    
                    if let sourceString = styleSheetStoreValue.sourceString.value {
                        userAgentStyleSheetString += sourceString
                    }
                    
                case .author:
                    
                    if let sourceString = styleSheetStoreValue.sourceString.value {
                        authorStyleSheetsString += sourceString
                    }
                    
                case .user:
                    
                    if let sourceString = styleSheetStoreValue.sourceString.value {
                        userStyleSheetString += sourceString
                    }
                }
            }
        }
        return userAgentStyleSheetString + authorStyleSheetsString + userStyleSheetString
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: IdGenerator implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var _hashids: Hashids?
    
    public var nextIntegerSeed: Int {
        
        var currentMaximumOrder = 0
        
        for stylesheetManager in self.stylesheetManagers {
            
            let id = stylesheetManager.id
            let order = self.order(from: id)
            
            assert(order != nil)
            if let order = order {
                currentMaximumOrder = max(currentMaximumOrder, order)
            }
        }
        return currentMaximumOrder + 1
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: deinit implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    deinit {
        
        for weakContainer in stylesheetDocumentStores {
            if let stylesheetDocumentStore = weakContainer.value {
                stylesheetDocumentStore.stylesheet.unsubscribe(observer: self)
                self.hasPendingChanges.unbind(from: stylesheetDocumentStore.hasPendingChanges)
            }
        }
    }
}


