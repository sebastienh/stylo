//
//  MarkdownAttributeType.swift
//  Web
//
//  Created by Sebastien hamel on 2019-10-29.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

public enum MarkdownAttributeType: String, ElementType, CaseIterable {
    
    public var name: String {
        return self.rawValue
    }
    
    public static func allValues() -> [ElementType] {
        
        return [MarkdownAttributeType.highlight]
    }
    
    case highlight = "highlight"
}

public func ==(lhs: MarkdownAttributeType, rhs: MarkdownAttributeType) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}
