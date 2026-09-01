//
//  ThemeManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-11-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public final class ThemeManager: NSObject, JsonManager, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public var selectedTheme: Dynamic<Bool>
    
    // userAgentStyleSheetURL is the particular css.css when creating
    // pseudo css styles,  text.css when creating a new css source style
    // sheet or html.css for the basic preview stylesheet.
    let previewUserAgentStyleSheetURL: URL
    
    /// Print user-agent stylesheet URL
    let printUserAgentStyleSheetURL: URL
    
    private var themeStyleStores: [ThemeId: StyleAssemblyStore] {
        return [
            §PrintThemeType.pdf: themes[.pdf]!,
            §PrintThemeType.word: themes[.word]!,
            §PrintThemeType.previewLight: themes[.previewLight]!,
            §PrintThemeType.previewDark: themes[.previewDark]!
        ]
    }
    
    var themes: [PrintThemeType: StyleAssemblyStore]
    
    weak var previewUserAgentStyleSheetDocumentStore: StylesheetDocumentStore!
    
    weak var printUserAgentStyleSheetDocumentStore: StylesheetDocumentStore!
    
    public let name: Dynamic<String>
    
    let applicationDispatcher: StyloApplicationDispatcher
    
    public var pendingContextChanges: Dynamic<Bool> = Dynamic<Bool>(false)
    
    weak var themeStore: ThemeStore!
    
    // load the theme context
    let jsonStore: JsonStore
    
    private let templateStore: TemplateStore
    
    // ccssStyle: style to apply to all pseudo-css files.
    // userAgentStyleSheetURL is css.css
    init(previewUserAgentStyleSheetResource: URL, printUserAgentStyleSheetURL: URL, applicationDispatcher: StyloApplicationDispatcher, templateStore: TemplateStore) {
        
        self.themes = [PrintThemeType: StyleAssemblyStore]()
        self.previewUserAgentStyleSheetURL = previewUserAgentStyleSheetResource
        self.printUserAgentStyleSheetURL = printUserAgentStyleSheetURL
        self.applicationDispatcher = applicationDispatcher
//        self.localTextStorage = NSTextStorage()
        self.selectedTheme = Dynamic<Bool>(false)
        self.name = Dynamic<String>("Untitled Theme")
        self.styleAssemblyStore = Dynamic<StyleAssemblyStore?>(nil)
        self.templateStore = templateStore
        // theme template store
        let jsonStore = JsonStore()
        applicationDispatcher.register(store: jsonStore)
        self.jsonStore = jsonStore
        
        super.init()
    }

    public func load() {
        
        loadUserAgentStylesheets()
        loadStyles()
        self.createThemeStore(name: name.value)
    }
    
    public func load(fromURL themeContextURL: URL) {
        
        loadUserAgentStylesheets()
        loadStyles(fromURL: themeContextURL)
        self.createThemeStore(name: name.value)
    }

    public func updateContext() {
        
        loadStyles()
    }
    
    private func createThemeStore(name: String) {
        
        let themeStore = ThemeStore(name: name)
        applicationDispatcher.register(store: themeStore)
        self.themeStore = themeStore
        
        let action = ThemeActionsFactory.setStylesAction(styles: self.themeStyleStores)
        applicationDispatcher.sync(store: themeStore, action: action)
    }
    
    // validate sync
    private func loadUserAgentStylesheets() {
        
        let previewUserAgentStyleSheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark))
        let printUserAgentStyleSheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark))
        
        applicationDispatcher.register(store: previewUserAgentStyleSheetDocumentStore)
        applicationDispatcher.register(store: printUserAgentStyleSheetDocumentStore)
        
        self.previewUserAgentStyleSheetDocumentStore = previewUserAgentStyleSheetDocumentStore
        self.printUserAgentStyleSheetDocumentStore = printUserAgentStyleSheetDocumentStore
        
        let previewAction = StylesheetDocumentActionsFactory.loadStylesheetAction(url: previewUserAgentStyleSheetURL)
        let printAction = StylesheetDocumentActionsFactory.loadStylesheetAction(url: printUserAgentStyleSheetURL)
        
        applicationDispatcher.sync(store: previewUserAgentStyleSheetDocumentStore, action: previewAction)
        applicationDispatcher.sync(store: printUserAgentStyleSheetDocumentStore, action: printAction)
        
        assert(self.previewUserAgentStyleSheetDocumentStore.stylesheet.value != nil)
        assert(self.printUserAgentStyleSheetDocumentStore.stylesheet.value != nil)
    }

    private func loadStyles(fromURL themeContextURL: URL) {
        
        let loadAction = EditableStoreActionsFactory.loadStringAction(url: themeContextURL)
        applicationDispatcher.sync(store: jsonStore, action: loadAction)
        
        self.loadStyles()
    }
    
    private func loadStyles() {
        
        let contextAction = JsonActionFactory.createMakeTemplateContextSyncAction()
        let contextResult = applicationDispatcher.sync(store: jsonStore, action: contextAction) as? JsonActionResult
        
        assert(contextResult != nil)
        if let contextResult = contextResult {
            
            switch contextResult {
                
            case .updatedContext(let context):
                
                // update the name from the context
                self.name.setValue(self.name(from: context) ?? "")
                
                // generate the theme and assign it
                for themeType in PrintThemeType.allCases {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Loading theme type %@", log: Log.WriterCommon.all, type: .info, %%themeType)
                    #endif
                    
                    guard let styleAssemblyStore = loadSubtheme(themeType: themeType, context: context) else {
                        assertionFailure("Error: styleAssemblyStore is nil")
                        continue
                    }
                    themes[themeType] = styleAssemblyStore
                }
            }
        }
    }
    
    private func loadSubtheme(themeType: PrintThemeType, context: [String: Any]?) -> StyleAssemblyStore? {
        
        guard let userAgentStyleSheetDocumentStore = userAgentStore(for: themeType) else {
            assertionFailure("Error: userAgentStyleSheetDocumentStore is nil for themeType: \(themeType)")
            return nil
        }
        
        guard let userAgentStyleSheet = userAgentStyleSheetDocumentStore.stylesheet.value else {
            assertionFailure("Error: userAgentStyleSheet is nil")
            return nil
        }
        
        guard let stylesheetManager = self.loadStylesheet(withTemplateName: §themeType, andContext: context) else {
            assertionFailure("Error: stylesheetManager is nil")
            return nil
        }
        
        stylesheetManager.compileInitialDocument()
        
        guard let authorStylesheet = stylesheetManager.stylesheet else {
            assertionFailure("Error: stylesheetManager.stylesheet is nil")
            return nil
        }
        
        let id = UUID().uuidString
        let cssStyle = CSSStyle(id: §themeType, userAgentStyleSheet: userAgentStyleSheet, authorStyleSheets: [authorStylesheet], userStyleSheet: nil, temporary: false, styleAssemblyIdentifier: id)
        
        let styleAssemblyStore = StyleAssemblyStore(editedLanguage: .CSS, id: id)
        styleAssemblyStore.style.setValue(cssStyle)
        return styleAssemblyStore
    }
    
    func loadStylesheet(withTemplateName templateName: String, andContext context: [String: Any]?) -> StylesheetManager? {
        
        let id = UUID().uuidString
        let stylesheetManager = StylesheetManager(title: id, id: id, dispatcher: self.dispatcher, editedStylesheetLanguage: .CSS, appearances: Set<AppearanceMode>(arrayLiteral: .dark, .light))
        
//        stylesheetManager.localTextStorage.delegate = nil
        
        let string = stylesheetManager.createStringResourceModelSync(templateName: templateName, from: self.templateStore, context: context)
        stylesheetManager.setText(string: string)
        return stylesheetManager
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
    
    public func highlightAllErrors(forEditorWithId editorId: EditorId) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("highlightAllErrors() missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    public func clearErrorHighlight(forEditorWithId editorId: EditorId) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("clearErrorHighlight() missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    public func highlightElementWithMessageId(_ messageId: String, forEditorWithId editorId: EditorId) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("highlightElementWithMessageId(...) missing implementation.", log: Log.WriterCommon.all, type: .error)
        #endif
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
    
    ///
    @objc public dynamic var title: String {
        
        get {
            return name.value
        }
        set {
            self.name.setValue(newValue)
        }
    }
    
    public var string: String = ""
    
    public let documentAttributes: Dynamic<DocumentAttributes?> = Dynamic<DocumentAttributes?>(nil)
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public var lastEditDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    public var currentChangeDescription: SourceStringChangeDescription?
    
    public var isEdited: Dynamic<Bool> = Dynamic<Bool>(false)
    
    public var dispatcher: Dispatcher {
        
        return self.applicationDispatcher
    }
    
    public var backgroundColor: Dynamic<PlateformColorType?> = Dynamic<PlateformColorType?>(nil)
    
    public var selectedTextAttributes: Dynamic<[NSAttributedString.Key : Any]?> = Dynamic<[NSAttributedString.Key : Any]?>(nil)
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var stylableDocumentStore: StylableStoreType? {
        
        return nil
    }
    
    public var styleAssemblyStore: Dynamic<StyleAssemblyStore?>
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FileWrapper implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func createFileWrapper() -> FileWrapper {
        
        let textData: Data = self.string.data(using: String.Encoding.utf8)!
        
        let textFileWrapper = FileWrapper(regularFileWithContents: textData)
        
        // we use the order in the style to name the specific stylesheet
        // since it gives us an indication of the order of the stylesheet
        // in the style.
        textFileWrapper.preferredFilename = "\(self.title).json"
        
        return textFileWrapper
    }
    
    private func name(from context: [String: Any]?) -> String? {
        
        return context?["name"] as? String
    }
    
    private func userAgentStore(for sourceType: SourceType) -> StylesheetDocumentStore? {
        
        if sourceType.print {
            
            assert(printUserAgentStyleSheetDocumentStore.stylesheet.value != nil)
            return printUserAgentStyleSheetDocumentStore
        }
        else {
            assert(previewUserAgentStyleSheetDocumentStore.stylesheet.value != nil)
            return previewUserAgentStyleSheetDocumentStore
        }
    }
    
}
