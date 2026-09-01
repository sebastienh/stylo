//
//  Failable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol Failable: class {
    
    var errors: [Message] { get }
    
    subscript(index: Int) -> Message { get }
    
    var issuesCount: Int { get }
    
    func highlightAllErrors(forEditorWithId editorId: EditorId)
    
    func clearErrorHighlight(forEditorWithId editorId: EditorId)
    
    func highlightElementWithMessageId(_ messageId: String, forEditorWithId editorId: EditorId)
    
    func messages(at textIndex: Int) -> [Message]?
    
    func subscribeToMessages(observer: Observer, closure: @escaping (DynamicArray<Message>.Change) -> Void)
    
    func unsubscribeToMessages(observer: Observer)
}
