//
//  StyloAttribute.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-01-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

public enum AttributesStatusValue {
    
    case unapplied
    case pending
}

public enum StyloAttribute: String {
    
    case overlineStyle
    case overlineColor
    case strikethroughColor
    case headingTagBefore
    case headingTagAfter
    case caretColor
    
    public var key: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: §self)
    }
    
}
