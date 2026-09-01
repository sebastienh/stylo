//
//  TextManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import Igloo
import PromiseKit
import os
import Markdown
import Combine

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public final class TextManager: NSObject, ResourceModelManager, Observer {

    public var priority: ObserverPriority {
        return .background
    }
    
    public var title: String {
        get {
            return self.name.value
        }
        set {
            let renameAction = MarkdownDocumentActionsFactory.renameAction(to: newValue)
            self.dispatcher.sync(store: self.markdownDocumentStore, action: renameAction)
        }
    }
    
    public var resourceType: ResourceType = .Markdown
    
    /// This the text model for the DOMInspector.
    public var markdownDomResourceModel: DomRenderableResourceModel!

    ///
    public weak var textDocument: TextDocument? {
        
        return self.sourceSetManager?.document
    }
    
    public var documentManager: DocumentManager? {
        
        return textDocument?.documentManager
    }
    
    public weak var sourceSetManager: SourceSetManager?
    
    var htmlRenderable: HtmlRenderable {
        
        return self
    }
    
    var stringRenderable: StringRenderable {
        
        return self
    }
    
    let markdownDocumentStore: MarkdownDocumentStore
    
    let ext: Dynamic<String>
    
    public let parentID: Dynamic<String>
    
    public let pathComponents: DynamicArray<String>
    
    public let id: TextId
    
    public var name: Dynamic<String>
    
    public var tokensAttributes = Dynamic<[AttributeTagInputSection : Set<AttributeTagInputItem>]?>(nil)
        
    public let totalTextStatistics: Dynamic<TextStatistics?> =  Dynamic<TextStatistics?>(nil)
    
    public let writingSessionHidden: Dynamic<Bool?> =  Dynamic<Bool?>(nil)
    
    public let sessionStatistics: Dynamic<TextStatistics?> =  Dynamic<TextStatistics?>(nil)
    
    public let sessionStartDate:  Dynamic<Date?> =  Dynamic<Date?>(nil)
    
    /// A ContentManager is anything that contains cont
    var _pluginsBackgroundActivities: DynamicDictionary<String, BackgroundActivity>
    
    public var editedRange: NSRange? = nil  {
        didSet {
            _editedRangeValueDidChange.send(self.editedRange)
        }
    }

    private var _editedRangeValueDidChange = PassthroughSubject<NSRange?, Never>()
    
    public var editedRangeValueDidChange: AnyPublisher<NSRange?, Never> {
        return _editedRangeValueDidChange.eraseToAnyPublisher()
    }
    
    var updateTokenAttributesTimer: Timer?
    
    init(title: String, id: String, sourceSetManager: SourceSetManager, parentID: String, dispatcher: Dispatcher) {
        
        self.name = Dynamic<String>(title)
        self.sourceSetManager = sourceSetManager
        self.dispatcher = dispatcher
        self.ext = Dynamic<String>("md")
        self.id = id
        self.parentID = Dynamic<String>(parentID)
        self.pathComponents = DynamicArray<String>()
        
        let markdownDocumentStore = MarkdownDocumentStore(identifier: id, name: title, parentId: parentID)
        self.dispatcher.register(store: markdownDocumentStore)
        self.markdownDocumentStore = markdownDocumentStore

        self._pluginsBackgroundActivities = DynamicDictionary<String, BackgroundActivity>()
        super.init()
        registerStoresListeners()
        NSTextStorage.swizzleFixParagraphAttributes()
        subscribeToDocumentManager()
    }
    
    init(name: String, sourceSetManager: SourceSetManager, fileMetadata: FileMetadata, parentId: String, dispatcher: Dispatcher) {
        
        self.name = Dynamic<String>(name)
        self.sourceSetManager = sourceSetManager
        self.dispatcher = dispatcher
        self.ext = Dynamic<String>("md")
        self.id = fileMetadata.id
        self.parentID = Dynamic<String>(parentId)
        self.pathComponents = DynamicArray<String>()
        
        let markdownDocumentStore = MarkdownDocumentStore(fileMetadata: fileMetadata, name: name, parentId: parentId)
        self.dispatcher.register(store: markdownDocumentStore)
        self.markdownDocumentStore = markdownDocumentStore
        self._pluginsBackgroundActivities = DynamicDictionary<String, BackgroundActivity>()
        super.init()
        registerStoresListeners()
        NSTextStorage.swizzleFixParagraphAttributes()
        subscribeToDocumentManager()
    }
    
    private func subscribeToDocumentManager() {
        
        self.subscribeToFocusMode()
        self.subscribeToFocusedEditorId() 
    }
    
    public func rename(to name: String) throws {
        
        try canRename(to: name)
        try dispatcher.online(store: self.markdownDocumentStore, action: DirectoryAction.rename(name: name))
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MarkdownDomRenderable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var markdownDomRenderingComponent: DomRenderingComponent!
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StaticHtmlPreviewable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var htmlStyleStore: Dynamic<StyleAssemblyStore?> = Dynamic<StyleAssemblyStore?>(nil)
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Editable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var editableStore: MarkdownDocumentStore {
     
        return self.markdownDocumentStore
    }
    
    public var string: String = ""
    
    public var textStorages: [EditorId : NSTextStorage] = [:]
    
    public weak var undoManager: UndoManager?
    
    public let compilationQueue = DispatchQueue(label: "textmanager-compilation-\(UUID().uuidString)")
    
    public let styleManager = Dynamic<StyleManager?>(nil)
    
    public let editorManagers = DynamicDictionary<EditorId, EditorManager<StylableStore>>()
    
    public var pendingRequests = Queue<SourceStringChangeDescription>()
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public let lastEditDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    public let isEdited: Dynamic<Bool> = Dynamic<Bool>(false)
    
    public var removeFlashTimer: Timer?
    
    public let dispatcher: Dispatcher
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ViewableManager protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var attributedStringBackup: NSAttributedString?
    
    private func registerStoresListeners() {
        
        self.writingSessionHidden.bind(to: markdownDocumentStore.writingSessionHidden)
        self.totalTextStatistics.setValue(self.markdownDocumentStore.totalStatistics.value)
        self.totalTextStatistics.bind(to: self.markdownDocumentStore.totalStatistics)
        self.sessionStatistics.setValue(self.markdownDocumentStore.sessionStatistics.value)
        self.sessionStatistics.bind(to: self.markdownDocumentStore.sessionStatistics)
        self.sessionStartDate.setValue(self.markdownDocumentStore.sessionStartDate.value)
        self.sessionStartDate.bind(to: self.markdownDocumentStore.sessionStartDate)
        self.ext.bind(to: self.markdownDocumentStore.ext)
        self.markdownDocumentStore.name.subscribe({ [weak self](newName) in
            self?.handleNameDidChange(newName)
        }, observer: self)
        self.markdownDocumentStore.parentID.subscribe({ [weak self](newParentId) in
            self?.parentID.setValue(newParentId)
            try? self?.self.updatePathComponents()
        }, observer: self)
        self.markdownDocumentStore.pathComponents.subscribe({ [weak self](change) in
            self?.handlePathComponentsChange(change)
        }, observer: self)
        self.tokensAttributes.setValue(self.markdownDocumentStore.tokensAttributes.value)
        self.tokensAttributes.bind(to: self.markdownDocumentStore.tokensAttributes)
    }
    
    private func handleNameDidChange(_ newName: String) {
        if newName != self.name.value {
            self.name.setValue(newName)
            try? self.self.updatePathComponents()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    deinit {
        
        self.ext.unbind(from: self.markdownDocumentStore.ext)
        self.markdownDocumentStore.name.unsubscribe(observer: self)
        self.markdownDocumentStore.parentID.unsubscribe(observer: self)
        self.markdownDocumentStore.pathComponents.unsubscribe(observer: self)
        self.totalTextStatistics.unbind(from: self.markdownDocumentStore.totalStatistics)
        self.writingSessionHidden.unbind(from: self.markdownDocumentStore.writingSessionHidden)
        self.sessionStatistics.unbind(from: self.markdownDocumentStore.sessionStatistics)
        self.sessionStartDate.unbind(from: self.markdownDocumentStore.sessionStartDate)
        self.unsubscribeFromFocusMode()
        self.unsubscribeFromClearFocusRequest()
        self.unsubscribeFromFocusedEditorId()
    }
    
}
