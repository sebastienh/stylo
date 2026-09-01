//
//  StyloDocument.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-08.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import WebKit
import Web
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
public typealias PlateformDocumentType = NSDocument
#else
public typealias PlateformDocumentType = UIDocument
#endif

let MaxUntitledNumber = 1000000

#if os(OSX)
public typealias PlateformFontType = NSFont
#else
public typealias PlateformFontType = UIFont
#endif

#if os(OSX)
public typealias PlateformViewControllerType = NSViewController
#else
public typealias PlateformViewControllerType = UIViewController
#endif

enum ErrorCode: Int {
    
    // We couldn't find the document at all
    case cannotAccessDocument
    
    // We couldn't access any file wrappers inside this document
    case cannotLoadFileWrappers
    
    // We couldn't load the Stylo document
    case cannotLoadStyloDocument
    
}

func err(_ code: ErrorCode,
                _ userInfo: [String: Any]? = nil) -> NSError {
    
    return NSError(domain: Constants.ErrorDomain.Stylo,
                   code: code.rawValue,
                   userInfo: userInfo)
}

open class TextDocument: PlateformDocumentType, Observer {

    public var priority: ObserverPriority {
        return .background
    }
    
    /////////////////////////////////////////////////
    /// MARK: Document methods
    /////////////////////////////////////////////////
    override open class var autosavesInPlace: Bool {

        return true
    }
    
    /// The StyloDocument keeps a reference to the TstDictionary
    /// used for all languages. There is one copy of this dictionary 
    /// for each language per document
    
    /// CCSS language completions dictionary
    fileprivate let ccssCompletionsDictionary: TstDictionary<CompletionValue>
    
    /// CSS language completions dictionary
    fileprivate let cssCompletionsDictionary: TstDictionary<CompletionValue>
    
    /// Markdown language completions dictionary
    fileprivate let markdownCompletionsDictionary: TstDictionary<CompletionValue>
    
    /// Determine of the application is in Light or Dark mode.
    public var documentAppearanceMode: AppearanceMode!
    
    /// The style to apply to exported word documents 
    var wordDocumentStyle: StyleAssemblyStore? {
        
        return printThemeSetManager.selectedThemeManager?.themes[.word]
    }
    
    /// This variable is used by the preview window to remember
    /// the last position of the preview window
    public var previewWindowOrigin: NSPoint?
    
    /// This variable is used by the preview window to remember
    /// the last size of the preview window
    public var previewWindowSize: NSSize?
    
    /// This variable is used by the preview window to remember
    /// the last scroll position of the preview window
    public var previewWindowScrollPosition: NSPoint?
    
    /// The style to apply to exported pdf documents 
    var pdfDocumentStyle: StyleAssemblyStore? {
        
        return printThemeSetManager.selectedThemeManager?.themes[.pdf]
    }
    
    var currentCssSourceStyle: StyleManager? {
        guard let sourceStyle = StyloApplication.shared.cssStyleSetManager.selectedStyleManager.value else {
            assertionFailure("Error: selectedCssStyle is nil")
            return nil
        }
        return sourceStyle
    }
    
    /// Bindable variable that keeps the actual value of the
    /// html preview background color.
    public var htmlPreviewBackgroundColor: Dynamic<PlateformColorType?> = Dynamic<PlateformColorType?>(nil)
    
    var documentURL: Dynamic<URL?> = Dynamic<URL?>(nil)
    
    public var selectedStyleManager: StyleManager? {
        
        return self.styleSetManager?.selectedStyleManager.value
    }
    
    // This variable is used to know at save time if we should save
    // the styles with the document or not. It is a temporary macanism until
    // we move everything to the StyleEditorPlugin.
    public var stylesLoadedFromOldStyloDocument: Bool = false
    
    open weak var printThemeSetManager: ThemeSetManager! {
        
        return StyloApplication.shared.printThemeSetManager
    }
    
    open var styleSetManager: StyleSetManager? {
        
        return documentManager?.styleSetManager
    }
    
    public var sourceSetManager: SourceSetManager? {
        get {
            assert(documentManager != nil)
            return documentManager?._sourceSetManager.value
        }
        set(sourceSetManager) {
            assert(documentManager != nil)
            documentManager?._sourceSetManager.setValue(sourceSetManager)
        }
    }
    
    public var filesOutlineSetManager: FilesOutlineSetManager? {
        
        return documentManager?.filesOutlineSetManager.value
    }
    
    public var selectedFilesOutlineManager: FilesOutlineManager? {
        
        guard let filesOutlineSetManager = filesOutlineSetManager else {
            assert(false)
            return nil
        }
        return filesOutlineSetManager.selectedFilesOutlineManager.value
    }
        
    open var textManager: TextManager! {
        
        guard let selectedFilesOutlineManager = self.selectedFilesOutlineManager else {
            assert(false)
            return nil
        }
        
        guard let itemId = selectedFilesOutlineManager.userSelectedItems.values.first else {
            assert(false, "error: not possible")
            return nil
        }
        
        guard let sourceSetManager = documentManager?._sourceSetManager.value else {
            assert(false, "sourceSetManager is nil")
            return nil
        }
        
        guard let item = sourceSetManager.directoryItemManager(withId: itemId) else {
            assert(false, "item is nil")
            return nil
        }
        
        guard let textManager = item as? TextManager else {
//            assert(false, "selected item is not text")
            return nil
        }
        return textManager
    }
    
    open var documentManager: DocumentManager?
    
    open var currentHTMLPreviewStyle: StyleAssemblyStore! {
        
        return StyloApplication.shared.printThemeSetManager.selectedThemeManager?.themes[.previewLight]
    }
    
    private var usedEncoding: String.Encoding?
    
    public let documentDispatcher: StyloDocumentDispatcher
    
    public var styloDocumentStore: StyloDocumentStore? {
        return documentManager?.documentStore
    }
    
    public let documentState: DocumentState
    
    // the release version that wrote the file
    var originReleaseVersion: SemanticVersion?
    
    var pdfExportJobs: [URL: (webView: WebView, delegate: WebFrameLoaderDelegate)]
    
    public var isRevertingDocument: Bool = false
    
    override open var fileType: String? {
        
        didSet {
            if let fileType = self.fileType {
                self.documentType.setValue(DocumentType.from(uti: fileType))
            }
            else {
                assert(false, "Setting document type to nil for file type \(fileType)")
                self.documentType.setValue(nil)
            }
        }
    }
    
    public var documentType: Dynamic<DocumentType?> = Dynamic<DocumentType?>(nil)
    
    open override var displayName: String! {
        didSet {
            self.documentManager?.namedChanged(to: self.displayName)
        }
    }
    
    open var initiallyCreatedTextStyleId: String? {
        
        if let globalStyleId = self.documentManager?.globalStyleId.value {
            return globalStyleId
        }
        
        guard let styleId = self.styleSetManager?.defaultStyleStore?.id else {
            assertionFailure("Error: self.styleSetManager?.defaultStyleStore?.id is nil")
            return nil
        }
        return styleId
    }
    
    open func initiallyLoadedTextStyleId(forFileMetadata fileMetadata: FileMetadata) -> String? {
        
        return self.documentManager?.globalStyleId.value
    }
    
    public override init() {
        
        /// CCSS language completions dictionary
        self.ccssCompletionsDictionary = CCSSCompletionsTstDictionaryFactory.GetCcssTstDictionary()
        
        /// CSS language completions dictionary
        self.cssCompletionsDictionary = CSSCompletionsTstDictionaryFactory.GetCssTstDictionary()
        
        /// Markdown language completions dictionary
        self.markdownCompletionsDictionary = MarkdownCompletionsTstDictionaryFactory.GetMarkdownTstDictionary()
        
        // by default we are in dark mode
        self.documentAppearanceMode = AppearanceMode.dark
        self.documentState = DocumentState()
        self.documentDispatcher = StyloDocumentDispatcher(state: self.documentState)
        
        self.pdfExportJobs = [URL: (webView: WebView, delegate: WebFrameLoaderDelegate)]()
        
        super.init()
        self.undoManager = StyloUndoManager(textDocument: self)
    }
    
    /// If you perform initializations that must be done when creating new documents but not 
    /// when opening existing documents, override initWithType:error:.
    /// see [Document Based App](https://developer.apple.com/library/mac/documentation/DataManagement/Conceptual/DocBasedAppProgrammingGuideForOSX/ManagingLifecycle/ManagingLifecycle.html#//apple_ref/doc/uid/TP40011179-CH4-SW1)
    public convenience init(type typeName: String) throws {
        
        self.init()
        try createDocument()
        
        // didSet is not triggered at init time ...
        self.documentManager?.namedChanged(to: self.displayName)
    }
    
    /// This method is called by the Text editors instance AutocompleteWindowController's 
    /// AutocompleteViewController is the init method based on the target language they are 
    /// used to edit.
    open func completionsDictionaryForTargetLanguage(_ targetLanguage: Language) -> TstDictionary<CompletionValue>? {
        
        switch targetLanguage {
        case .CSS:
            return cssCompletionsDictionary
        case .CCSS:
            return ccssCompletionsDictionary
        case .Markdown:
            return markdownCompletionsDictionary
        default:
            // FIXME: add support for those languages
            //        case Markdown = "text/markdown"
            //        case HTML = "text/html"
            //        case Stella = "text/stella"
            return nil
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////
    ///                               MARK: Reading file method
    //////////////////////////////////////////////////////////////////////////////
    
    override open func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Loading fileWrapper content: %@", log: Log.WriterCommon.all, type: .info, %%fileWrapper.fileWrappers!)
        #endif
        
        if let documentType = DocumentType.from(uti: typeName) {
            
            switch documentType {
                
            case .nodio: fallthrough
            case .stylo:
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Starting loading document.", log: Log.WriterCommon.all, type: .info)
                #endif
                
                showLoadingWindow(with: fileWrapper.filename)
                do {
                    try loadStyloDocument(from: fileWrapper)
                    hideLoadingWindow()
                }
                catch let error {
                    hideLoadingWindow()
                    throw error
                }

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Document loaded.", log: Log.WriterCommon.all, type: .info)
                #endif
                
            case .text: fallthrough
            case .markdown:
                assert(false)
                break
            }
        }
        else {
    
            assert(false, "cannot load document")
            throw err(.cannotLoadStyloDocument)
        }
    }
    
    override open func read(from url: URL, ofType typeName: String) throws {
        
        if let documentType = DocumentType.from(uti: typeName) {
            
            switch documentType {
                
            case .nodio: fallthrough
            case .stylo:
                
                try super.read(from: url, ofType: typeName)
                
            default:
                
                // here we will set the id to the url string
                if !isBrowsingVersions && !isInViewingMode {
                    
                    showLoadingWindow(with: url.lastPathComponent)
                    var encoding: UInt = 0
                    let string = try NSString(contentsOf: url, usedEncoding: &encoding)
                    try createDocument(from: string as String)
                    self.usedEncoding = String.Encoding(rawValue: encoding)
                    hideLoadingWindow()
                }
            }
        }
        else {
            
            assert(false, "cannot load document")
            throw err(.cannotLoadStyloDocument)
        }
    }

    open func showLoadingWindow(with filename: String?) {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("missing subclass implementation", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    open func hideLoadingWindow() {

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("missing subclass implementation", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    open func showDocumentWindow() {
        
        // overriden
    }
    
    private func createDocument() throws {
        
        let styleSetManager = self.createEmptyStyleSet()
        styleSetManager.selectStyle(atIndex: 2)
        guard let initialStyleId = styleSetManager.defaultStyleId else {
            assertionFailure("Error: initialStyleId is nil")
            throw NWError.custom(message: "initialStyleId is nil")
        }
        
        #if DEBUG
        let id = styleSetManager.selectedStyleManager.value!.id
        assert(initialStyleId == id)
        #endif
        
        self.documentManager = DocumentManager(document: self, globalStyleId: initialStyleId, styleSetManager: styleSetManager)
        
        try self.documentManager?.applyGlobalStyle(styleId: initialStyleId)
        self.sourceSetManager = try self.createSourceSet(styleId: initialStyleId)
        
        guard let globalStyleId = documentManager?.globalStyleId.value else {
            assertionFailure("Error: globalStyleId is nil")
            throw NWError.nilStyle
        }
        
        self.styleSetManager?.updateSelectedStyle(to: globalStyleId)
        
        self.documentManager?.initSubscriptions()
        self.documentManager?.loadPluginManager()
        self.documentManager?.initPluginsData()
        try self.selectFirstTextManager()
        self.documentManager?.loading.setValue(false)
    }
    
    private func createDocument(from string: String) throws {

        let styleSetManager = self.createEmptyStyleSet()
        
        guard let initialStyleId = styleSetManager.defaultStyleStore?.id else {
            assertionFailure("Error: initialStyleId is nil")
            throw NWError.custom(message: "initialStyleId is nil")
        }
        
        self.documentManager = DocumentManager(document: self, globalStyleId: initialStyleId, styleSetManager: styleSetManager)
        
        try self.documentManager?.applyGlobalStyle(styleId: initialStyleId)
        self.sourceSetManager = try self.createSourceSet(from: string, styleId: initialStyleId)
        
        guard let globalStyleId = documentManager?.globalStyleId.value else {
            assertionFailure("Error: globalStyleId is nil")
            throw NWError.nilStyle
        }
        
        self.styleSetManager?.updateSelectedStyle(to: globalStyleId)
        
        self.documentManager?.initSubscriptions()
        self.documentManager?.loadPluginManager()
        self.documentManager?.initPluginsData()
        try self.selectFirstTextManager()
        self.documentManager?.loading.setValue(false)
    }
    
    private func loadStyloDocument(from fileWrapper: FileWrapper) throws {

        // version one of the metadata
        if let documentMetadata1 = try? self.loadMetadata1(from: fileWrapper) {

            guard let styleId = documentMetadata1.styleId else {
                assertionFailure("Error: documentMetadata1.styleId is nil")
                throw NWError.custom(message: "documentMetadata1.styleId is nil")
            }
            
            let styleSetManager = self.loadStyleSet1(from: fileWrapper, styleSetMetadata: documentMetadata1.styleSet)
            // should add the styles from the application here 
            
            let documentManager = DocumentManager(documentMetadata: documentMetadata1, document: self, globalStyleId: styleId, styleSetManager: styleSetManager)

            self.documentManager = documentManager
            self.styleSetManager?.updateSelectedStyle(to: styleId)
            
            self.sourceSetManager = try self.loadSourceSet1(from: fileWrapper, sourceSetMetadata: documentMetadata1.sourceSet)
            documentManager.initSubscriptions()
            guard let sourceSetManager = self.sourceSetManager else {
                assert(false)
                throw NWError.custom(message: "sourceSetManager is nil")
            }

            try self.selectFirstTextManager()
            
            assert(sourceSetManager.textManagersArray.count == 1)
            
            // change the id of the text manager and rename it to "Untitled text"
            sourceSetManager.textManagersArray.first?.title = "Untitled text"
            
            assert(documentManager.filesOutlineSetManager.value != nil)
            documentManager.filesOutlineSetManager.value?.updateAllSelectedItems()
            
            self.documentManager?.loadPluginManager()
            self.documentManager?.initPluginsData()
        }
        else if let documentMetadata: DocumentMetadata = try? self.loadMetadata(from: fileWrapper) {
            
            let styleSetManager: StyleSetManager = self.loadStyleSet1(from: fileWrapper, styleSetMetadata: nil)
            let documentManager = DocumentManager(documentMetadata: documentMetadata, document: self, styleSetManager: styleSetManager)
            self.documentManager = documentManager

            guard let globalStyleId = documentManager.globalStyleId.value else {
                assertionFailure("Error: globalStyleId is nil")
                throw NWError.nilStyle
            }
            
            self.styleSetManager?.updateSelectedStyle(to: globalStyleId)
            
            self.sourceSetManager = try self.loadSourceSet(from: fileWrapper, sourceSetMetadata: documentMetadata.sourceSet)
            
            assert(documentManager._sourceSetManager.value != nil)
            documentManager.initSubscriptions()
            assert(documentManager.filesOutlineSetManager.value != nil)
            documentManager.filesOutlineSetManager.value?.updateAllSelectedItems()
            
            documentManager.loadPluginManager()
            
            // depending if we have a plugins directory and plugins metadata
            // we init or read data.
            try loadPluginsData(from: fileWrapper, in: documentManager)
        }
        
        assert(self.styleSetManager != nil)
        self.styleSetManager?.setUndoManager(self.undoManager!)
        self.documentManager?.loading.setValue(false)
    }
    
    public func loadPluginsData(from documentFileWrapper: FileWrapper, in documentManager: DocumentManager) throws {
        
        // this is only to support old document format we should delete
        // as soon as we have opened enough documents since it 
        if let pluginsDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.PluginsDataDirectoryFilename] {
            
            try documentManager.readPluginsData(from: pluginsDirectoryFileWrapper)
        }
        else {
            let styloProjDirectoryFileWrapper = documentFileWrapper.fileWrappers?[Constants.Filename.StyloProjectDirectoryName]
            let pluginsDirectoryFileWrapper = styloProjDirectoryFileWrapper?.fileWrappers?[Constants.Filename.PluginsDataDirectoryFilename]
            try documentManager.readPluginsData(from: pluginsDirectoryFileWrapper)
        }
    }
    
    open func content(withId id: String, wasSelectedByPluginWithName pluginName: String) {
        
        // nothing to do here, this should handled on a case by case basis
        // by the os specific document
    }
    
    private func selectFirstTextManager() throws {
        
        guard let sourceSetManager = self.sourceSetManager else {
            assert(false)
            throw NWError.custom(message: "Error: sourceSetManager is nil")
        }
        
        guard let topDirectory = sourceSetManager.topDirectory else {
            assertionFailure("Error: sourceSetManager.topDirectory is nil")
            throw NWError.custom(message: "Error: sourceSetManager.topDirectory is nil")
        }
        
        // The following only selects the first text manager.
        var selectedTextManager: TextManager?
         
         // at this point there should be only one text manager
         // in the source set manager
         for directoryItemManager in sourceSetManager.directoryItemsManagersArray {
             if let textManager = directoryItemManager as? TextManager {
                 selectedTextManager = textManager
             }
         }
        
         assert(selectedTextManager != nil)
         if let selectedTextManager = selectedTextManager {
        
            guard let selectedFilesOutlineManager = self.documentManager?.selectedFilesOutlineManager else {
                assertionFailure("Error: no selectedFilesOutlineManager")
                throw NWError.custom(message: "Error: no selectedFilesOutlineManager")
            }
            
            let topDirectoryId = topDirectory.id
            var parentId = selectedTextManager.parentID.value
            while parentId != topDirectoryId {
                
                guard let parent = sourceSetManager.directoryItemManager(withId: parentId) else {
                    assertionFailure("Error: no directory item with id: \(parentId)")
                    break
                }
                
                selectedFilesOutlineManager.addExpandedItem(with: parentId, increaseChangeCount: false)
                parentId = parent.parentID.value
            }
            
            selectedFilesOutlineManager.appendItemToExistingUserSelection(with: selectedTextManager.id, increaseChangeCount: false)
            selectedFilesOutlineManager.resetHistoryToLastValue()
        }
    }

    /////////////////////////////////////////////////
    /// MARK: Writing file method
    /////////////////////////////////////////////////

    override open var fileURL: URL? {
        get {
            return super.fileURL
        }
        set {
            if newValue == self.fileURL {
                renamed = false
            }
            super.fileURL = newValue
            self.documentURL.setValue(newValue)
        }
    }
    
    override open var fileModificationDate: Date? {
        get {
            return super.fileModificationDate
        }
        set {
            if newValue == self.fileModificationDate {
                renamed = false
            }
            super.fileModificationDate = newValue
        }
    }
    
    private var renamed: Bool = false
    
    override open func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("fileWrapper of type: %@", log: Log.WriterCommon.all, type: .info, %%typeName)
        #endif
        
        let documentType = DocumentType.from(uti: typeName)
        
        if let documentType = documentType {
            switch documentType {
            case .stylo: fallthrough
            case .nodio:
                return try createFileWrapper()
            default:
                return try super.fileWrapper(ofType: typeName)
            }
        }
        return try super.fileWrapper(ofType: typeName)
    }
    
    override open func data(ofType typeName: String) throws -> Data {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log(" data(ofType %@: String) throws -> Data", log: Log.WriterCommon.all, type: .debug, %%typeName)
        #endif
        
        let documentType = DocumentType.from(uti: typeName)
        
        assert(documentType != nil)
        if let documentType = documentType {
        
            switch documentType {
                
            case .nodio: fallthrough
            case .stylo:
                assert(false, "this option should not be called.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("this option should not be called.", log: Log.WriterCommon.all, type: .error)
                #endif
                return try super.data(ofType: typeName)
                
            default:
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("documentType is not stylo: %@", log: Log.WriterCommon.all, type: .info, %%typeName)
                #endif
                return createData()
            }
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("documentType is not stylo: %@", log: Log.WriterCommon.all, type: .error, %%typeName)
        #endif
        return createData()
    }
    

    /////////////////////////////////////////////////
    /// MARK: Public style management methods
    /////////////////////////////////////////////////
    
    @discardableResult
    public func applyAppearance(_ appearance: AppearanceMode) -> Promise<Void> {
        
        guard let documentManager = self.documentManager else {
            let errorText = "Error: self.documentManager is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        return documentManager.applyAppearance(appearance)
    }
    
    /// In Stylo, by default, this method change the global style id.
    /// Note: We don't use listeners to global style id for now for
    /// simplicity purpose.
    @discardableResult
    open func applyTextStyle(from styleManager: StyleManager) -> Promise<Void> {
        
        guard let documentManager = self.documentManager else {
            let errorText = "Error: self.documentManager is nil"
            assertionFailure(errorText)
            return Promise(error: NWError.custom(message: errorText))
        }
        
        return Promise<Void> { fulfill, reject in
            firstly {
                documentManager.applyTextStyleToEditedTextManagers(styleManager)
            }.then {
                documentManager.applyTextStyleToNotEditedTextManagers(styleManager)
            }.then {
                documentManager.applyGlobalStyleSync(styleId: styleManager.id)
            }.then { _ -> Void in
                fulfill(())
            }.catch { error in
                assertionFailure("Error: \(error)")
                reject(error)
            }
        }
    }
    
    /// Method that allows to change the focus mode.
    open func applyFocusMode(_ focusMode: FocusMode) {
        
        guard let documentManager = self.documentManager else {
            let errorText = "Error: self.documentManager is nil"
            assertionFailure(errorText)
            return
        }
        
        documentManager.applyFocusMode(focusMode)
    }
    
    ///////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Data implementation
    ///////////////////////////////////////////////////////////////////////////////////////////////
    
    func createData() -> Data {
        
        let usedEncoding = self.usedEncoding ?? String.Encoding.utf8
        return textManager.string.data(using: usedEncoding)!
    }
    
    private func removeExtension(from displayName: String) -> String {
        
        return (displayName as NSString).deletingPathExtension as String
    }
    
    private func styloDisplayName(from displayName: String) -> String {

        return displayName
    }
    
    func styloDocumentUrl(from url: URL) -> URL {
        
        var _url = url
        _url.deletePathExtension()
        return _url.appendingPathExtension("stylo")
    }
    
    open override func save(withDelegate delegate: Any?, didSave didSaveSelector: ObjectiveC.Selector?, contextInfo: UnsafeMutableRawPointer?) {
        
        self.documentManager?.pluginManager?.documentWillSave()
        super.save(withDelegate: delegate, didSave: didSaveSelector, contextInfo: contextInfo)
        self.documentManager?.pluginManager?.documentDidSave()
    }
    
    open override var isDraft: Bool {
        get {
            return super.isDraft || self.documentManager?.pluginManager?.isDraft == true
        }
        set {
            super.isDraft = newValue
        }
    }
    
    open override func canClose(withDelegate delegate: Any, shouldClose shouldCloseSelector: ObjectiveC.Selector?, contextInfo: UnsafeMutableRawPointer?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("canClose", log: Log.WriterCommon.all, type: .debug)
        #endif
        
        self.documentManager?.pluginManager?.documentWillClose()
        
        if isDocumentEdited || self.documentManager?.pluginManager?.isEdited == true {
            self.updateChangeCount(NSDocument.ChangeType.changeDone)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Calling save(withDelegate: nil, didSave: nil, contextInfo: nil)", log: Log.WriterCommon.all, type: .debug)
        os_log("isDraft: %@", log: Log.WriterCommon.all, type: .debug, %%self.isDraft)
        os_log("isDocumentEdited: %@", log: Log.WriterCommon.all, type: .debug, %%self.isDocumentEdited)
        os_log("self.documentManager?.pluginManager?.isEdited: %@", log: Log.WriterCommon.all, type: .debug, %%self.documentManager?.pluginManager?.isEdited)
        #endif
        
        self.documentManager?.pluginManager?.documentWillSave()
        super.canClose(withDelegate: delegate, shouldClose: shouldCloseSelector, contextInfo: contextInfo)
        self.documentManager?.pluginManager?.documentDidSave()
    }

    deinit {
        
        StyloApplication.shared.computedAppearance.unsubscribe(observer: self)
    }
    
}


