//
//  FormattableInput.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-05-24.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

public protocol FormattableInput: class {

    var textStorage: NSTextStorage? { get }
    
    var lastCharacterInserted: UInt16? { get set }
    
    var lastCharacterWhichCausedInsertion: UInt16? { get set }
    
    var insertingText: Bool { get set }
    
    var justInsertedBrace: Bool { get set }
    
    var string: String { get }
    
    var selectedRange: NSRange { get set }
    
    func insertText(_ string: Any, replacementRange: NSRange)
    
    func replaceCharacters(in range: NSRange, with string: String)
    
    func insertNewlineIgnoringFieldEditor(_ sender: Any?)
}
