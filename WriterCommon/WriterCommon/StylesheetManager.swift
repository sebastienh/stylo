//
//  StylesheetManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-07.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Igloo
import os

public typealias StylesheetId = String

@objc public class StylesheetManager: NSObject, ResourceModelManager, EditorToolsPresenter {
    
    /// This the style model for the DOMInspector.
    open var domResourceModel: CssDomResourceModel!
    
    @objc public dynamic var cssFailableResourceModel: CssFailableResourceModel!
    
    /// Utility variable for the UI
    @objc public dynamic var presentingDom: Int = 0
    
    /// Utility variable for the UI
    @objc public dynamic var presentingErrors: Int = 1
    
    /// Utility variable for the UI
    @objc public dynamic var presentingHelp: Int = 0
    
    @objc public dynamic var visible: Bool = false 
    
    ///
    let stylesheetManagerOperationQueue: OperationQueue
    
    let editedStylesheetLanguage: Language
    
    // we should removed to strong reference
    var stylesheetDocumentStore: StylesheetDocumentStore
    
    var stylesheet: CSSStyleSheet? {
        return self.stylesheetDocumentStore.stylesheet.value
    }
    
    var origin: CSSOrigin {
        return self.stylesheetDocumentStore.origin
    }
    
    public var dispatcher: Dispatcher
    
    public let id: StylesheetId
    
    public let appearances: DynamicSet<AppearanceMode>
    
    @objc public var title: String {
        get {
            return self.name.value
        }
        set {
            self.name.setValue(newValue)
        }
    }
    
    public let hasPendingChanges: Dynamic<Bool>
    
    /// The cssUserAgentStyleSheetResource is the same object for all CCSS styles so we
    /// need to get it in parameter.
    init(title: String, id: StylesheetId, dispatcher: Dispatcher, editedStylesheetLanguage: Language, origin: CSSOrigin? = nil, appearances: Set<AppearanceMode>) {
        
        self.stylesheetManagerOperationQueue = OperationQueue()
        self.id = id
        self.name = Dynamic<String>(title)
        self.appearances = DynamicSet<AppearanceMode>(appearances)
        self.dispatcher = dispatcher
        
        assert(id != ".DS_Store")
    
        self.editedStylesheetLanguage = editedStylesheetLanguage
        self.hasPendingChanges = Dynamic<Bool>(false)
        
        let stylesheetDocumentStore: StylesheetDocumentStore
        
        let origin = origin ?? (title == "user" ? .user : .author)
        
        stylesheetDocumentStore = StylesheetDocumentStore(origin: origin, appearances: appearances)
        
        dispatcher.register(store: stylesheetDocumentStore)
        self.stylesheetDocumentStore = stylesheetDocumentStore
        
        super.init()
        
        self.cssFailableResourceModel = CssFailableResourceModel(stylesheetManager: self)
        self.domResourceModel = CssDomResourceModel(cssDomRenderable: self)
        
        // themes style managers and styles listen to appearance change notification
        subscribeToStylesheetDocumentStore()
    }
    
    public func applyAppearanceMode(_ appearanceMode: AppearanceMode) {
        
        for (editorId, editorManager) in self.editorManagers.values {
            let newStyleAssemblyDescriptor = editorManager.styleAssemblyDescriptor.same(forAppearance: appearanceMode)
            self.setStyleAssemblyDescriptor(newStyleAssemblyDescriptor, forEditorId: editorId)
        }
    }
    
    public func removeAppearance(_ appearance: AppearanceMode) {
        
        self.dispatcher.sync(store: self.stylesheetDocumentStore, action: StylesheetDocumentAction.removeAppearance(appearance: appearance).syncAction)
        assert(!self.stylesheetDocumentStore.appearances.contains(appearance))
    }
    
    public func addAppearance(_ appearance: AppearanceMode) {
        
        self.dispatcher.sync(store: self.stylesheetDocumentStore, action: StylesheetDocumentAction.addAppearance(appearance: appearance).syncAction)
        assert(self.stylesheetDocumentStore.appearances.contains(appearance))
    }
    
    public var errorMessages: [Message] {
    
        return self.stylesheetDocumentStore.errorMessages.values
    }
    
    public func subscribeToStylesheetDocumentStore() {
        
        self.hasPendingChanges.bind(to: stylesheetDocumentStore.hasPendingChanges)
        self.appearances.bind(to: stylesheetDocumentStore.appearances)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Editable implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// The title of the stylesheet
    public let name: Dynamic<String>
    
    public var string: String = ""
    
    public var editedRange: NSRange? = nil  //{
//        didSet {
//            _editedRangeValueDidChange.send(self.editedRange)
//        }
//    }
//
//    private var _editedRangeValueDidChange = PassthroughSubject<NSRange?, Never>()
//
//    public var editedRangeValueDidChange: AnyPublisher<NSRange?, Never> {
//        return _editedRangeValueDidChange.eraseToAnyPublisher()
//    }
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var editableStore: StylesheetDocumentStore {
     
        return self.stylesheetDocumentStore
    }
    
    public weak var undoManager: UndoManager?
    
    public let compilationQueue = DispatchQueue(label: "stylesheetmanager-compilation-\(UUID().uuidString)")
    
    public var textStorages: [EditorId : NSTextStorage] = [:]
    
    public let styleManager = Dynamic<StyleManager?>(nil)
    
    public let editorManagers = DynamicDictionary<EditorId, EditorManager<StylableStore>>()
    
    public var pendingRequests = Queue<SourceStringChangeDescription>()
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public var lastEditDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    public var isEdited: Dynamic<Bool> = Dynamic<Bool>(false)
    
    public var removeFlashTimer: Timer?
    
    public var backgroundColor: Dynamic<PlateformColorType?> = Dynamic<PlateformColorType?>(Constants.Colors.GrayColor)
    
    public var selectedTextAttributes: Dynamic<[NSAttributedString.Key : Any]?> = Dynamic<[NSAttributedString.Key : Any]?>(nil)
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CssDomRenderable implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var cssDomRenderingComponent: DomRenderingComponent!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    deinit {
        
        self.hasPendingChanges.unbind(from: stylesheetDocumentStore.hasPendingChanges)
    }
}
