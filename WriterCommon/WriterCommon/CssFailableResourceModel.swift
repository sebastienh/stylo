//
//  CssFailableResourceModel.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-17.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import os

fileprivate enum ErrorMode {
    
    case NotInErrorMode
    case SingleError
    case AllErrors
}

@objc public final class CssFailableResourceModel: NSObject, Failable, Observer  {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    @objc dynamic var displayedErrors: [ObjcMessage] = []
    
    // see http://stackoverflow.com/questions/29089383/key-value-observe-in-swift-not-showing-insertions-and-removals-in-arrays
    public var errors: [Message] {
        didSet {
            self.displayedErrors = self.errors.map({ (message) -> ObjcMessage in
                return ObjcMessage(error: message)
            })
        }
    }
    
    var actualSourceCssStyleStore: StyleAssemblyStore?
    
    var pendingHighlightAllErrors: Operation?
    
    /// This reference is mainly used to send Notifications
    weak var stylesheetManager: StylesheetManager!
    
    private var listeningToErrorMessages: Bool = false
    
    private var sourceStyleStore: StyleAssemblyStore? {

        fatalError("missing implementation")
    }
    
    private var allErrorsStyleStore: StyleAssemblyStore? {
        
        fatalError("missing implementation")
    }
    
    private var singleSourceErrorStyle: CSSStyle? {
        
        fatalError("missing implementation")
    }
    
    var singleErrorStyle: StyleAssemblyStore?
    
    init(stylesheetManager: StylesheetManager) {
    
        self.errors = [Message]()
        self.stylesheetManager = stylesheetManager
        super.init()
        register(with: stylesheetManager)
    }
    
    public func updateStoreState(state: FailableStoreState) {
        
        let action = FailableActionsFactory.updateFailableStateAction(state: state)
        self.stylesheetManager.dispatcher.async(store: stylesheetManager.stylesheetDocumentStore, action: action)
    }
    
    public func messages(at textIndex: Int) -> [Message]? {
        
        var messagesArray = [Message]()
        
        for error in errors {
            
            if let segment = error.fragment as? SourceStringSegment {
                
                if segment.containsIndex(textIndex) {
                    
                    messagesArray.append(error)
                }
            }
        }
        return messagesArray.count != 0 ? messagesArray : nil
    }
    
    fileprivate func register(with stylesheetManager: StylesheetManager) {
        
        if !listeningToErrorMessages {
            
            stylesheetManager.subscribeToMessages(observer: self) { [weak self](change: DynamicArray<Message>.Change) -> Void in
                
                switch change {
                case .insert(let newElement, let index, _):
                    self?.errors.insert(newElement, at: index)
                case .deletes(let deletedIndexes, _, _):
                    assert(deletedIndexes.sorted() == deletedIndexes, "Error: deleted indexes should be sorted in ascending order.")
                    for deletedIndex in deletedIndexes.reversed() {
                        self?.errors.remove(at: deletedIndex)
                    }
                case .inserts(_, _, let updatedArray):
                    self?.errors = updatedArray
                    
//                    assert(indexes.sorted() == indexes, "Error: newElements indexes should be sorted in ascending order.")
//                    assert(newElements.count == indexes.count)
//                    for (index, insertionIindex) in indexes.enumerated() {
//                        let newElement = newElements[index]
//                        if insertionIindex == self.errors.count {
//                            self.errors.append(newElement)
//                        }
//                        else {
//                            self.errors.insert(newElement, at: insertionIindex)
//                        }
//                    }
                case .move(_, _ , _, let messagesArray):
                    self?.handleErrorMessagesChange(messagesArray: messagesArray)
                case .end: fallthrough
                case .start:
                    break
                }
            }
            listeningToErrorMessages = true
        }
        self.handleErrorMessagesChange(messagesArray: stylesheetManager.errorMessages)
    }
    
    private func handleErrorMessagesChange(messagesArray: [Message]) {
        
        self.errors = messagesArray
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FailableResourceModel protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var issuesCount: Int {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Failable resource model issuesCount: %d", log: Log.WriterCommon.all, type: .info, %%errors.count)
        #endif
        
        return errors.count
    }
    
    public subscript(index: Int) -> Message {
    
        return errors[index]
    }
    
    public func highlightAllErrors(forEditorWithId editorId: EditorId) {
        fatalError("missing implementation")
    }
    
    public func clearErrorHighlight(forEditorWithId editorId: EditorId) {
        fatalError("missing implementation")
    }
    
    public func highlightElementWithMessageId(_ messageId: String, forEditorWithId editorId: EditorId) {
        fatalError("missing implementation")
    }
    
    public func subscribeToMessages(observer: Observer, closure: @escaping (DynamicArray<Message>.Change) -> Void) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("subscribeToMessages(...) missing implementation", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
    public func unsubscribeToMessages(observer: Observer) {
        
        assert(false, "missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("unsubscribeToMessages(...) missing implementation", log: Log.WriterCommon.all, type: .error)
        #endif
    }
    
}

















