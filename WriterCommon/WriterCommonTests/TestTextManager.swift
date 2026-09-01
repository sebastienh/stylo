//
//  TestTextManager.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-11-13.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
@testable import WriterCommon

class TestTextManager: NSObject, Editable, TextViewChangeHandler, AnyEditable {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Editable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var editedRange: NSRange?
    
    let editedLanguage: Language = .Markdown
    
    typealias StylableStore = MarkdownStyleStore
    
    typealias EditableStore = MarkdownDocumentStore
    
    
    // The reference to the stylableDocumentStore is weak since,
    // the StyloDocument.documentState is reponsible to hold a
    // strong reference to it.
    public var editableStore: MarkdownDocumentStore {
        
        return self.markdownDocumentStore
    }
    
    public var string: String = ""
    
    public var textStorages: [EditorId : NSTextStorage] = [:]
    
    public var undoManager: UndoManager?
    
    public let compilationQueue = DispatchQueue(label: "textmanager-compilation-\(UUID().uuidString)")
    
    public let styleManager = Dynamic<StyleManager?>(nil)
    
    public let editorManagers = DynamicDictionary<EditorId, EditorManager<StylableStore>>()
    
    public var pendingRequests = Queue<SourceStringChangeDescription>()
    
    public let compilationUnit: Dynamic<CompilationUnit?> = Dynamic<CompilationUnit?>(nil)
    
    public let lastEditDate: Dynamic<Date?> = Dynamic<Date?>(nil)
    
    public let isEdited: Dynamic<Bool> = Dynamic<Bool>(false)
    
    public var removeFlashTimer: Timer?
    
    public var dispatcher: Dispatcher
    
    private let markdownDocumentStore: MarkdownDocumentStore
    
    private let documentState: DocumentState
    
    private let textDocument = TextDocument()
    
    override init() {
        
        
        self.documentState = DocumentState()
        self.dispatcher = StyloDocumentDispatcher(state: self.documentState)
        
        let markdownDocumentStore = MarkdownDocumentStore(identifier: "id", name: "title", parentId: "parentID")
        self.dispatcher.register(store: markdownDocumentStore)
        self.markdownDocumentStore = markdownDocumentStore
        super.init()
        self.undoManager = StyloUndoManager(textDocument: self.textDocument)
    }
    
    func executeCompilation(withChangeDescription changeDescription: SourceStringChangeDescription) {
        
    }
    
//    func registerEditor(withRenderer renderer: SourceStringAttributesRenderer) throws {
//        
//    }
    
    func unregisterEditor(withId editorId: EditorId) {
        // do nothing
    }
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if editedMask.contains(.editedCharacters) {
            self.editedRange = editedRange
        }
    }
    
    public func textStorage(_ textStorage: NSTextStorage, willProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        
        if editedMask.contains(.editedCharacters) {
            
            guard let editorId = self.editorId(forTextStorage: textStorage) else {
                assertionFailure("Error: editorId is nil")
                return
            }
            
            guard let editorManager = self.editorManagers.values[editorId] else {
                assertionFailure("Error: editorManager is nil")
                return
            }
            
            #if false
            os_log("willProcessEditing start, in TextManager: editedRange: %@, changeInLength: %d", log: Log.WriterCommon.textStorage, type: .info, %%editedRange, delta)
            #endif
            
            let rangeString = textStorage.getRangeAndReplacementSubstring()
            
            #if false
            os_log("willProcessEditing rangeString: %@", log: Log.WriterCommon.textStorage, type: .info, %%rangeString)
            #endif
            
            assert(rangeString != nil)
            if let rangeString = rangeString {
                
                let changeDescription = SourceStringChangeDescription(range: rangeString.range, stringReplacement: rangeString.replacementSubstring, changeLength: delta, targetString: textStorage.string)
                
                #if false
                os_log("willProcessEditing changeDescription: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription)
                os_log("willProcessEditing changeDescription replacement string: %@", log: Log.WriterCommon.textStorage, type: .debug, %%changeDescription.stringReplacement)
                os_log("willProcessEditing currentChangeDescription: %@", log: Log.WriterCommon.textStorage, type: .debug, %%currentChangeDescription)
                #endif
                
                if changeDescription.changeType != .unchanged {
                    
                    //                    handleNewLineAttributes(textStorage, description: changeDescription)
                    
                    // pureAddition, range: {0, 0}, changeLength: 1, stringReplacement: Optional("^")
                    // pureReplace, range: {0, 1}, changeLength: 0, stringReplacement: Optional("ê")
                    let currentChangeDescription = editorManager.currentChangeDescription
                    
                    if let currentChangeDescription = currentChangeDescription, changeDescription.changeType == .pureReplace
                        && currentChangeDescription.changeLength == 1 && changeDescription.changeLength == 0
                        && currentChangeDescription.range.location == changeDescription.range.location
                        && currentChangeDescription.range.length == 0 && changeDescription.range.length == 1 {
                        
                        let changeDescription = currentChangeDescription.same(with: changeDescription.utf16SubsequenceReplacement, targetString: changeDescription.targetString)
                        
                        handleSourceChange(sourceStringChangeDescription: changeDescription, forEditorId: editorId)
                    }
                    else {

                        handleSourceChange(sourceStringChangeDescription: changeDescription, forEditorId: editorId)
                    }
                }
            }
            else {
                
                let sourceStringChangeDescription = SourceStringChangeDescription(attributedString: textStorage, originalAttributedString: nil)

                handleSourceChange(sourceStringChangeDescription: sourceStringChangeDescription, forEditorId: editorId)
            }
        }
        else {
            
            #if false
            os_log("willProcessEditing rangeString is nil.", log: Log.WriterCommon.textStorage, type: .debug)
            #endif
        }
    }
    
}
