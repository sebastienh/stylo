//
//  MarkdownElementType.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-04-03.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common

public enum MarkdownElementType: String, ElementType, CaseIterable {
    
    /// This is the document element of the MarkdownDomDocument
    case HtmlBlock = "html-block"
    case Reference = "reference"
    
    public var name: String {
        
        return self.rawValue
    }
    
    public static func allValues() -> [ElementType] {
        
        return [
            MarkdownElementType.Reference,
            MarkdownElementType.HtmlBlock
        ]
    }
    
}

public func ==(lhs: MarkdownElementType, rhs: MarkdownElementType) -> Bool {
    
    return lhs.rawValue == rhs.rawValue
}
