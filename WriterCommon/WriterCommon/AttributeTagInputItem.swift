//
//  AttributeTagInputItem.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol TextRanges {
    
    var ranges: [NSRange] { get }
    
    var textId: TextId? { get }
}


public struct AttributeTagInputItem: InputItemType, TextRanges {
    
    public let stringValue: String
    
    public let ranges: [NSRange]
    
    public let textId: TextId?
    
    init(stringValue: String) {
        
        self.init(stringValue: stringValue, ranges: [], textId: nil)
    }
    
    init(stringValue: String, ranges: [NSRange], textId: TextId?) {
        
        self.ranges = ranges
        self.textId = textId
        self.stringValue = stringValue
    }
    
    public func localizedStandardContains(_ str: String) -> Bool {
        return stringValue.localizedStandardContains(str)
    }
}

extension AttributeTagInputItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.stringValue)
    }
}

extension AttributeTagInputItem: Comparable {
    public static func < (lhs: AttributeTagInputItem, rhs: AttributeTagInputItem) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
}

extension AttributeTagInputItem: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}
