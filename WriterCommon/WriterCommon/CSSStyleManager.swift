//
//  CSSStyleManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-10.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import os
import Web

public class CSSStyleManager: StyleManager, JsonManager {
    
    enum CSSStyleType: String, CaseIterable {
        case cssSourceLight = "css.source.light"
        case cssSourceDark = "css.source.dark"
        case cssErrorsDark = "css.errors.dark"
        case cssErrorsLight = "css.errors.light"
        case cssErrorDark = "css.error.dark"
        case cssErrorLight = "css.error.light"
    }
    
    // load the theme context
    let jsonStore: JsonStore
    
    public override var currentAppearanceSourceDescriptor: StyleAssemblyDescriptor {
        let computedAppearance = StyloApplication.shared.computedAppearanceOrDefault
        switch computedAppearance {
        case .dark:
            return StyleAssemblyDescriptor.cssDarkStyleAssemblyDescriptor
        case .light:
            return StyleAssemblyDescriptor.cssLightStyleAssemblyDescriptor
        }
    }
    
    public override var otherAppearanceSourceDescriptor: StyleAssemblyDescriptor {
        let computedAppearance = StyloApplication.shared.computedAppearanceOrDefault
        switch computedAppearance {
        case .dark:
            return StyleAssemblyDescriptor.cssLightStyleAssemblyDescriptor
        case .light:
            return StyleAssemblyDescriptor.cssDarkStyleAssemblyDescriptor
        }
    }

    override var sourceLightStyleAssembly: StyleAssembly? {
        
        return self.styleAssemblies[StyleAssemblyDescriptor.cssLightStyleAssemblyDescriptor]
    }
    
    override var sourceDarkStyleAssembly: StyleAssembly? {
        
        return self.styleAssemblies[StyleAssemblyDescriptor.cssDarkStyleAssemblyDescriptor]
    }
    
    override init(title: String = "Untitled Style", id: String, order: UInt32, userAgentStyleSheetDocumentStore: StylesheetDocumentStore, dispatcher: Dispatcher, editedStyleLanguage: Language, styleManagerType: StyleManagerType) {
        
        self.styleAssemblyStore = Dynamic<StyleAssemblyStore?>(nil)
        self.localTextStorage = NSTextStorage()
        
        // theme template store
        let jsonStore = JsonStore()
        dispatcher.register(store: jsonStore)
        self.jsonStore = jsonStore
        
        super.init(title: title, id: id, order: order, userAgentStyleSheetDocumentStore: userAgentStyleSheetDocumentStore, dispatcher: dispatcher, editedStyleLanguage: editedStyleLanguage, styleManagerType: styleManagerType)
    }
    
    override func shouldCompileStylesheets(fromStyleMetadata styleMetadata: StyleMetadata?) -> Bool {
        return true
    }
    
    override func targetDescriptor(forAppearanceMode appearanceMode: AppearanceMode) -> StyleAssemblyDescriptor {
        switch appearanceMode {
        case .dark:
            return .cssDarkStyleAssemblyDescriptor
        case .light:
            return .cssLightStyleAssemblyDescriptor
        }
    }
    
    override func stylesheets(forStyleAssemblyDescriptor styleAssemblyDescriptor: StyleAssemblyDescriptor) -> [CSSStyleSheet] {
        
        var stylesheets: [CSSStyleSheet] = []
        
        for trait in styleAssemblyDescriptor.traits {
            switch trait {
            case .source:
                stylesheets.append(contentsOf: sourceStylesheets(forAppearance: styleAssemblyDescriptor.appearance))
            case .error(let messageId):
                stylesheets.append(contentsOf: self.createSingleErrorStylesheet(withErrorId: messageId, forAppearance: styleAssemblyDescriptor.appearance))
            case .errors:
                stylesheets.append(contentsOf: self.createAllErrorsStylesheet(forAppearance: styleAssemblyDescriptor.appearance))
            }
        }
        
        return stylesheets
    }
    
    private func createSingleErrorStylesheet(withErrorId errorId: String, forAppearance appearance: AppearanceMode) -> [CSSStyleSheet] {
        
        var  stylesheets: [CSSStyleSheet] = []
        
        assert(self.userAgentStylesheetManager != nil)
        if let userAgentStylesheetManager = self.userAgentStylesheetManager {
            guard let stylesheet = userAgentStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            stylesheets.append(stylesheet)
        }
        
        if let commonErrorStylesheetManager = self.stylesheets[§CssStylesheetDescriptor.commonError] {
            guard let stylesheet = commonErrorStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            
            let temporarySingleErrorStylesheet = stylesheet.clone()
            temporarySingleErrorStylesheet.origin = .author
            temporarySingleErrorStylesheet.updateErrorIdAttributeSelectorValue(withErrorId: errorId)
            
            stylesheets.append(temporarySingleErrorStylesheet)
        }
        
        let _errorStylesheetManager: StylesheetManager? = {
            switch appearance {
            case .dark:
                return self.stylesheets[§CssStylesheetDescriptor.cssErrorDark]
            case .light:
                return self.stylesheets[§CssStylesheetDescriptor.cssErrorLight]
            }
        }()
        
        guard let errorStylesheetManager = _errorStylesheetManager else {
            assertionFailure("Error: errorStylesheet is nil")
            return []
        }
        
        guard let stylesheet = errorStylesheetManager.stylesheet else {
            assertionFailure("Error: errorStylesheet.stylesheet is nil")
            return []
        }
        
        let temporarySingleErrorStyle = stylesheet.clone()
        stylesheets.append(temporarySingleErrorStyle)
        return stylesheets
    }

    private func sourceStylesheets(forAppearance appearance: AppearanceMode) -> [CSSStyleSheet] {
        
        var  stylesheets: [CSSStyleSheet] = []
        
        assert(self.userAgentStylesheetManager != nil)
        if let userAgentStylesheetManager = self.userAgentStylesheetManager {
            compileStylesheetIfNecessary(userAgentStylesheetManager)
            guard let stylesheet = userAgentStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            stylesheets.append(stylesheet)
        }
        
        if let commonSourceStylesheetManager = self.stylesheets[§CssStylesheetDescriptor.commonSource] {
            compileStylesheetIfNecessary(commonSourceStylesheetManager)
            guard let stylesheet = commonSourceStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            stylesheets.append(stylesheet)
        }
        
        switch appearance {
        case .light:
            if let lightSourceStylesheetManager = self.stylesheets[§CssStylesheetDescriptor.sourceLight] {
                compileStylesheetIfNecessary(lightSourceStylesheetManager)
                guard let stylesheet = lightSourceStylesheetManager.stylesheet else {
                    assertionFailure("Error: stylesheet is nil")
                    return stylesheets
                }
                stylesheets.append(stylesheet)
            }
        case .dark:
            if let darkSourceStylesheetManager = self.stylesheets[§CssStylesheetDescriptor.sourceDark] {
                compileStylesheetIfNecessary(darkSourceStylesheetManager)
                guard let stylesheet = darkSourceStylesheetManager.stylesheet else {
                    assertionFailure("Error: stylesheet is nil")
                    return stylesheets
                }
                stylesheets.append(stylesheet)
            }
        }
        
        return stylesheets
    }
    
    private func createAllErrorsStylesheet(forAppearance appearance: AppearanceMode) -> [CSSStyleSheet] {
        
        var  stylesheets: [CSSStyleSheet] = []
        
        assert(self.userAgentStylesheetManager != nil)
        if let userAgentStylesheetManager = self.userAgentStylesheetManager {
            compileStylesheetIfNecessary(userAgentStylesheetManager)
            guard let stylesheet = userAgentStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            stylesheets.append(stylesheet)
        }
        
        if let commonErrorsStylesheetManager = self.stylesheets[§CssStylesheetDescriptor.commonErrors] {
            compileStylesheetIfNecessary(commonErrorsStylesheetManager)
            guard let stylesheet = commonErrorsStylesheetManager.stylesheet else {
                assertionFailure("Error: stylesheet is nil")
                return stylesheets
            }
            stylesheets.append(stylesheet)
        }
        
        let _errorsStylesheet: StylesheetManager? = {
            switch appearance {
            case .dark:
                return self.stylesheets[§CssStylesheetDescriptor.cssErrorsDark]
            case .light:
                return self.stylesheets[§CssStylesheetDescriptor.cssErrorsLight]
            }
        }()
        
        guard let errorsStylesheet = _errorsStylesheet else {
            assertionFailure("Error: errorsStylesheet is nil")
            return []
        }
        
        guard let stylesheet = errorsStylesheet.stylesheet else {
            assertionFailure("Error: errorStylesheet.stylesheet is nil")
            return []
        }
        
        let temporaryErrorsStyle = stylesheet.clone()
        temporaryErrorsStyle.origin = .user
        stylesheets.append(temporaryErrorsStyle)
        
        return stylesheets
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: JsonManager protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var errors: [Message] = [Message]()
    
    public subscript(index: Int) -> Message {
        
        assert(index >= 0 && index < errors.count)
        return errors[index]
    }
    
    public var issuesCount: Int {
        
        return errors.count
    }
    
    public func updateStoreState(state: FailableStoreState) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("updateStoreState(...) missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    public func highlightAllErrors(forEditorWithId editorId: EditorId) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("highlightAllErrors(...)", log: Log.WriterCommon.all, type: .error)
        #endif
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }
        
        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: [.errors])
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: [.errors])
            }
        }()
        
        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    public func clearErrorHighlight(forEditorWithId editorId: EditorId) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("clearErrorHighlight()", log: Log.WriterCommon.all, type: .error)
        #endif
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }
        
        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: [.source])
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: [.source])
            }
        }()
        
        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    public func highlightElementWithMessageId(_ messageId: String, forEditorWithId editorId: EditorId) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("highlightElementWithMessageId(...)", log: Log.WriterCommon.all, type: .error)
        #endif
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }
        
        let traits = [StyleTrait.error(messageId: messageId)]
        
        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: traits)
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: traits)
            }
        }()
        
        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    public func messages(at textIndex: Int) -> [Message]? {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("messages(...) missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
        return nil
    }
    
    public func subscribeToMessages(observer: Observer, closure: @escaping (DynamicArray<Message>.Change) -> Void) {
        
        self.jsonStore.errorMessages.subscribe({ (change: DynamicArray<Message>.Change) in
            
            closure(change)
        }, observer: observer)
    }
    
    public func unsubscribeToMessages(observer: Observer) {
        
        if self.jsonStore.errorMessages.subscribed(observer: observer) {
            
            self.jsonStore.errorMessages.unsubscribe(observer: observer)
        }
    }
    
    public var presentingDom: Int = 0
    
    public var presentingErrors: Int = 1
    
    public var presentingHelp: Int = 0
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Editable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var editableStore: JsonStore {
     
        return self.jsonStore
    }
    
    public var string: String = ""
    
    public var editedRange: NSRange? = nil  //{

    public override var undoManager: UndoManager? {
        didSet {
            for stylesheetManager in self.stylesheets.orderedValues {
                stylesheetManager.undoManager = self.undoManager
            }
        }
    }
    
    public var textStorages: [EditorId : NSTextStorage] = [:]
    
    public let styleManager = Dynamic<StyleManager?>(nil)
    
    public let editorManagers = DynamicDictionary<EditorId, EditorManager<StylableStore>>()
    
    public let compilationQueue = DispatchQueue(label: "stylemanager-compilation-\(UUID().uuidString)")
    
    public var editedLanguage: Language = .json
    
    public var pendingRequests = Queue<SourceStringChangeDescription>()
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public var lastEditDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    public var isEdited: Dynamic<Bool> = Dynamic<Bool>(false)
    
    public var removeFlashTimer: Timer?
    
    public var backgroundColor: Dynamic<PlateformColorType?> = Dynamic<PlateformColorType?>(nil)
    
    public var selectedTextAttributes: Dynamic<[NSAttributedString.Key : Any]?> = Dynamic<[NSAttributedString.Key : Any]?>(nil)
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var stylableDocumentStore: StylableStoreType? {
        
        return nil
    }
    
    public var styleAssemblyStore: Dynamic<StyleAssemblyStore?>
    
    @objc public let localTextStorage: NSTextStorage
    
    public func initializeRendererAttributes() {
        
        do {
            let attributedString = try self.dispatcher.readSync(store: self.jsonStore, in: self.jsonStore.jsonConcurrentQueue, with: { () throws -> NSMutableAttributedString in
                
                if let jsonString = self.jsonStore.jsonString.value {
                    
                    return NSMutableAttributedString(string: jsonString)
                    
                }
                else {
                    throw NWError.errorApplyingAttributes(description: "Nil attributes store")
                }
            })
            assert(self.localTextStorage.length == 0)
            // we need to remove the delegate at this step otherwise
            // we will trigger a recompilation but we just come there
            let delegate = self.localTextStorage.delegate
            self.localTextStorage.delegate = nil
            self.localTextStorage.setAttributedString(attributedString)
            self.localTextStorage.delegate = delegate
        }
        catch let error {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error in initializeRendererAttributes(): %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
            assertionFailure("Error in initializeRendererAttributes(): \(error)")
        }
    }
    
}
