//
//  Editable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-08.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public protocol Editable: NSTextStorageDelegate, Observer {
    
    associatedtype StylableStore: Store & StylableStoreType & IdentifiableStoreType
    
    associatedtype EditableStore: Store & EditableStoreType & DocumentStoreType
    
    ///
    /// We keep only one value of pending requests, but to avoid
    /// discrepancies between the displayed text and the attributes
    /// ranges, we must make sure that when we come back from attributes compilation
    /// we make a coordinated affort to to not leave the main thread before
    /// applying the attributes and removing the associated pending request.
    ///
    var pendingRequests: Queue<SourceStringChangeDescription> { get set }
    
    var editedRange: NSRange? { get set }
    
    var visibleRanges: [EditorId: NSRange?] { get }
    
    var string: String { get set }
    
    var undoManager: UndoManager? { get }
    
    /// The store that is edited by this Editable manager.
    var editableStore: EditableStore { get }
    
    var editorManagers: DynamicDictionary<EditorId, EditorManager<StylableStore>> { get }
    
    /// NSTextStorage is independant from the EditorManager
    /// because we need it to create the NSTextView (SourceStringAttributesRenderer)
    /// this could be changed later by making the SourceStringAttributesRenderer
    /// optional in the EditorManager
    var textStorages: [EditorId: NSTextStorage] { get set }
    
    var lastEditDate: Dynamic<Date?> { get }
    
    var isEdited: Dynamic<Bool> { get }
    
    var styleManager: Dynamic<StyleManager?> { get }
    
    var editedLanguage: Language { get }
    
    var dispatcher: Dispatcher { get }
    
    var compilationQueue: DispatchQueue { get }
    
    func editor(for editorId: EditorId) -> AnyEditor?
    
    
    
    ///
    /// This method needs to be at the Editable level (the one containing the document store)
    /// because before being able to flash attributes we need the top elements in the Editable.
    ///
    func flashAttributes(forEditorWithId editorId: EditorId, inRange range: NSRange) -> [AttributesRange]?
    
    func executeCompilation(withChangeDescription changeDescription: SourceStringChangeDescription)
    
    func textStorage(forEditorWithId id: EditorId) -> NSTextStorage
    
    func editorId(forTextStorage textStorage: NSTextStorage) -> EditorId?
    
    ///
    /// Method to manage the edit. It handles the undo redo
    /// also and can therefore be called from the
    /// Editable manager. This means that we need a way to differentiate if we need to update all text
    /// storages or if the change is coming from a text
    /// storage that has already been updated. This is the
    /// role of updateAll which is set to false when the
    /// change comes from an editor.
    ///
    ///
    func doEdit(toChangeDescription currentChangeDescription: SourceStringChangeDescription, forEditorWithId editorId: EditorId, withUndoManager undoManager: StyloUndoManager?, updateAll: Bool)
    
    /// ************************************************* ///
    /// Editable store and and permanent style management ///
    /// ************************************************* ///
    
    ///
    /// This method is responsible for setting the initial text
    /// and setting up the EditableStore at initialization time.
    ///
    /// This method should always be the first method called when
    /// setting up a new Editable manager.
    ///
    /// Note: This method always in synchronous execution mode.
    ///
    /// @precondition: no StyleManager is set at this time.
    /// @postcondition: an EditableStore has been created
    ///
    func setText(string: String)
    
    /// This method compiles the document.
    func compileInitialDocument()
    
    ///
    /// This method is responsible for handling source string change
    /// caused by the user editing the document.
    ///
    /// Note: The sync, async nature of this method is determined
    /// while executing it.
    ///
    /// @precondition: styleManager is not nil
    /// @precondition: renderers is not empty
    ///
    func handleSourceChange(sourceStringChangeDescription: SourceStringChangeDescription, forEditorId editorId: EditorId)

    ///
    /// This method is responsible for setting up permanent style
    /// and the temporary styles chain according to the registered
    /// style assemblies.
    ///
    /// @precondition: an EditableStore is initialized
    ///
    ///
    /// Get the computed appearance and forward call to:
    /// setStyle(withStyleManager styleManager: StyleManager, forAppearance appearance: AppearanceMode)
    ///
    func setStyle(withStyleManager styleManager: StyleManager, visibleRanges: [EditorId : NSRange?]?) throws
    
    ///
    /// Async version
    ///
    @discardableResult
    func setStyleAsync(withStyleManager styleManager: StyleManager) -> Promise<Void>
    
    ///
    /// This method is responsible for registering a new renderer
    ///
    /// @precondition: editableStore is initialized
    /// @precondition: styleManager is not nil
    ///
    func registerEditor(withRenderer renderer: SourceStringAttributesRenderer) throws
    
    func setStyleAssemblyDescriptor(_ descriptor: StyleAssemblyDescriptor, forEditorId editorId: EditorId, visibleRange: NSRange?)
    
    ///
    /// This method removes all references to this renderer. It should also
    /// make sure that if a StyledStoreManager referenced by a StyleAssemblyDescriptor
    /// is not used anymore it is removed from the styledStoreManagers dictionary.
    ///
    func unregisterEditor(withId editorId: EditorId)
}

extension Editable {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public var visibleRanges: [EditorId: NSRange?] {
        assert(Thread.isMainThread)
        var visibleRanges: [EditorId: NSRange?] = [:]
        for (id, editorManager) in self.editorManagers.values {
            visibleRanges[id] = editorManager.visibleRange
        }
        return visibleRanges
    }
    
    public func editorId(forTextStorage textStorage: NSTextStorage) -> EditorId? {
        for (editorId, editorManagers) in self.editorManagers.values {
            if textStorage === editorManagers.textStorage {
                return editorId
            }
        }
        return nil
    }
    
    public func editor(for editorId: EditorId) -> AnyEditor? {
        
        return self.editorManagers.values[editorId]
    }
    
    public func updateStylableResultsWithPendingResquest(_ stylableResults: [EditorId: StylableActionResult], pendingRequests: Queue<SourceStringChangeDescription>) -> [EditorId: StylableActionResult] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateStylableResultsWithPendingResquest(stylableResults: %@)", log: Log.WriterCommon.all, type: .info, %%stylableResults)
        #endif
        
        assert(Thread.isMainThread)
        var result: [EditorId: StylableActionResult] = [:]
        
        for (styleDescriptor, stylableActionResult) in stylableResults {
            result[styleDescriptor] = stylableActionResult.updatedAttributesRanges(with: pendingRequests)
        }
        
        return result
    }

    /// ************************************************* ///
    /// Editable store and and permanent style management ///
    /// ************************************************* ///
    
    ///
    /// textStorage is used to create the renderer and is therefore created
    /// before we can register the renderer. For this reason we cannot register
    /// both at the same time. But they are both deregistered at the same time
    /// when unregistering the renderer. 
    public func textStorage(forEditorWithId id: EditorId) -> NSTextStorage {
        
        let textStorage = NSTextStorage(string: self.string)
        textStorage.delegate = self
        self.textStorages[id] = textStorage
        return self.textStorages[id]!
    }
    
    ///
    /// This method is responsible for setting the initial text
    /// and setting up the EditableStore at initialization time.
    ///
    /// This method should always be the first method called when
    /// setting up a new Editable manager.
    ///
    /// Note: This method always in synchronous execution mode.
    ///
    /// @precondition: no StyleManager is set at this time.
    /// @postcondition: an EditableStore has been created
    ///
    public func setText(string: String) {
        precondition(self.styleManager.value == nil)
        
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Loading string: %@.", log: Log.WriterCommon.all, type: .debug, %%string)
        #endif
        
        self.string = string
        let stringAction = EditableStoreAction.setString(string: string).syncAction
        self.dispatcher.sync(store: self.editableStore, action: stringAction)
    }
    
    public func compileInitialDocument() {
        
        let description = SourceStringChangeDescription(string: string, originalString: nil)
        let loadAction = DocumentStoreAction.compileInitialDocument(description: description).syncAction
        self.dispatcher.sync(store: self.editableStore, action: loadAction)
    }
    
    ///
    /// This method is responsible for handling source string change
    /// caused by the user editing the document.
    ///
    /// Note: The sync, async nature of this method is determined
    /// while executing it.
    ///
    /// @precondition: styleManager is not nil
    /// @precondition: renderers is not empty
    /// @precondition: renderersStyleAssemblies is not empty
    ///
    public func handleSourceChange(sourceStringChangeDescription: SourceStringChangeDescription, forEditorId editorId: EditorId) {
        precondition(self.styleManager.value != nil)
        
        self.lastEditDate.setValue(Date())
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handleSourceChange replaced currentChangeDescription with: %@", log: Log.WriterCommon.textStorage, type: .debug, %%sourceStringChangeDescription)
        #endif
        
        self.editorManagers.values[editorId]?.currentChangeDescription = sourceStringChangeDescription
    }
    
    public func updateStylePreviewSync() {
        for (_, editorManager) in self.editorManagers.values {
            editorManager.updateStylePreviewSync()
        }
    }
    
    public func updateStylePreviewAsync() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            var promises: [Promise<Void>] = []
            for (_, editorManager) in self.editorManagers.values {
                promises.append(editorManager.updateStylePreviewAsync())
            }
            when(fulfilled: promises).then {
                fulfill(())
            }.catch { error in
                reject(error)
            }
        }
    }
    
    ///
    /// This method is called when the editable store type's document
    /// has been through a complete compilation.
    ///
    func compileCompleteAttributes(withDocument document: Document, withSourceStringChangeDescription changeDescription: SourceStringChangeDescription, visibleRanges: [EditorId: NSRange?]) throws -> [EditorId: StylableActionResult] {
        
        var result: [EditorId: StylableActionResult] = [:]
        
        // we need to update all permanent styles..
        for (editorId, editorManager) in self.editorManagers.values {
            
            guard let editorVisibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: editorVisibleRange is nil")
                continue
            }
            
            let visibleTopElements = self.visibleTopElementsIfNecessary(inVisibleRange: editorVisibleRange)
            guard let stylableActionResult = try editorManager.reinitializeStyledStore(withDocument: document, withSourceStringChangeDescription: changeDescription, visibleTopElements: visibleTopElements) else {
                assertionFailure("Error: stylableActionResult is nil")
                continue
            }
            
            result[editorId] = stylableActionResult
        }
        return result
    }
    
    func compilePartialAttributes(using documentStoreActionResult: DocumentStoreActionResult, change: SourceStringChangeDescription, visibleRanges: [EditorId: NSRange?]) -> [EditorId: StylableActionResult] {
        
        var result: [EditorId: StylableActionResult] = [:]

        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return result
        }
        
        // we need to update all permanent styles..
        for (editorId, editorManager) in self.editorManagers.values {
        
            guard let editorVisibleRange = visibleRanges[editorId] else {
                assertionFailure("Error: editorVisibleRange is nil")
                continue
            }
            
            let visibleTopElements = self.visibleTopElementsIfNecessary(inVisibleRange: editorVisibleRange)
            guard let stylableActionResult = editorManager.updateAttributes(using: documentStoreActionResult, withChange: change, visibleTopElements: visibleTopElements, document: document) else {
                assertionFailure("Error: stylableActionResult is nil")
                continue
            }
            result[editorId] = stylableActionResult
        }
        
        return result
    }
    
    func compileAttributesAsync(using documentStoreActionResult: DocumentStoreActionResult, change: SourceStringChangeDescription) -> Promise<[EditorId: StylableActionResult]> {
        
        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return Promise(error: NWError.custom(message: "Error: document is nil"))
        }
        
        return Promise<[EditorId: StylableActionResult]> { fulfill, reject in
            
            var promises: [Promise<(EditorId, StylableActionResult)>] = []

            // we need to update all permanent styles..
            for (editorId, editorManager) in self.editorManagers.values {
                
                let promise = Promise<(EditorId, StylableActionResult)> { fulfill, reject in
                    
                    firstly {
                        self.visibleTopElementsIfNecessaryAsync(forEditorWithId: editorId)
                    }.then { visibleTopElements in
                        return editorManager.updateAttributesAsync(using: documentStoreActionResult, withChange: change, visibleTopElements: visibleTopElements, document: document)
                    }.catch { error in
                        reject(error)
                    }
                }
                
                promises.append(promise)
            }
            when(fulfilled: promises).then { results in
                
                var dict: [EditorId: StylableActionResult] = [:]
                for (editorId, stylableActionResult) in results {
                    assert(dict[editorId] == nil)
                    dict[editorId] = stylableActionResult
                }
                fulfill(dict)
            }.catch { error in
                reject(error)
            }
        }
    }
}


extension Editable where Self: NSObject, Self: TextViewChangeHandler {
    
    ///
    /// This method is responsible for registering a new renderer
    ///
    /// @precondition: editableStore is initialized
    /// @precondition: styleManager is not nil
    ///
    public func registerEditor(withRenderer renderer: SourceStringAttributesRenderer) throws {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("registerEditor with id: %@", log: Log.WriterCommon.textStorage, type: .debug, %%renderer.id)
        #endif
        
        NotificationCenter.default.addObserver(forName: NSText.didChangeNotification, object: renderer, queue: nil) { [weak self] notification in
            assert(self != nil)
            self?.textViewDidChange(notification)
        }
        
        guard let styleManager = self.styleManager.value else {
            assertionFailure("Error: styleManager is nil")
            return
        }

        guard let textStorage = self.textStorages[renderer.id] else {
            assertionFailure("Error: textStorage is nil")
            return
        }
        
        guard let currentAppearanceStyleAssembly = styleManager.currentAppearanceStyleAssembly else {
            assertionFailure("Error: currentAppearanceStyleAssembly is nil")
            return
        }
        
        let descriptor = styleManager.currentAppearanceSourceDescriptor
        
        guard let document = editableStore.document.value else {
            assertionFailure("Error: document is nil")
            return 
        }
        
        guard let resourceComputedStyle = currentAppearanceStyleAssembly.styleAssemblyStore.resourceComputedStyle else {
            assertionFailure("Error: resourceComputedStyle is nil")
            return
        }
        
        let styledStore = StylableStore(string: self.string, focusMode: StyloApplication.shared.focusMode.value, resourceComputedStyle: resourceComputedStyle, highlightSelectors: nil)
        
        let styledStoreManager = StyledStoreManager<StylableStore>(styleAssemblyDescriptor: descriptor, styledStore: styledStore, styleAssemblyStore: currentAppearanceStyleAssembly.styleAssemblyStore, dispatcher: self.dispatcher)
        
        // when we register an editor, the editor is not visible yet.
        // so visibleTopElements is nil
        guard let stylableActionResult = try styledStoreManager.compileInitialAttributes(visibleTopElements: nil, document: document, isFirstResponder: false, selectedRange: nil) else {
            assertionFailure("Error: stylableActionResult is nil")
            return
        }
        
        styledStoreManager.updateDocumentAttributes(stylableActionResult.documentAttributes)
        styledStoreManager.updateStylePreviewSync()
        // We call this method for both Markdown and CSS sources.
        styledStoreManager.precomputeFadeStyles(document: document)
        
        let editorManager = EditorManager(renderer: renderer, styledStoreManager: styledStoreManager, styleAssemblyDescriptor: descriptor, textStorage: textStorage, dispatcher: self.dispatcher)
        self.editorManagers.updateValue(editorManager, forKey: renderer.id)
    }
    
    ///
    /// This method removes all references to this renderer. It should also
    /// make sure that if a StyledStoreManager referenced by a StyleAssemblyDescriptor
    /// is not used anymore it is removed from the styledStoreManagers dictionary.
    ///
    public func unregisterEditor(withId editorId: EditorId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("unregisterEditor with id: %@", log: Log.WriterCommon.textStorage, type: .debug, %%editorId)
        #endif
        
        guard let editorManager = self.editorManagers.values[editorId] else {
            assertionFailure("Error: editorManager is nil")
            return
        }
        
        NotificationCenter.default.removeObserver(self, name: NSText.didChangeNotification, object: editorManager.renderer)

        self.editorManagers.removeValue(forKey: editorId)
        self.textStorages.removeValue(forKey: editorId)
        assert(self.textStorages[editorId] == nil)
    }
    
    
    
}

