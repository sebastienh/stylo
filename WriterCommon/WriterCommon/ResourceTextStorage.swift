//
//  DebugTextStorage.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-27.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os
import Common

class ResourceTextStorage: NSTextStorage {
    
    private var storage = NSTextStorage()
    
    // MARK: NSTextStorage Primitive Methods
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TextStorageLayer/Tasks/Subclassing.html
    
    override var string: String {
        return storage.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key : Any] {
        
        let attributes = storage.attributes(at: location, effectiveRange: range)
         
        return attributes
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        storage.replaceCharacters(in: range, with: str)
        edited(.editedCharacters, range: range, changeInLength: (str as NSString).length - range.length)
    }
    
    override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
        storage.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    
}
