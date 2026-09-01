//
//  ResourceModelManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-14.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

public enum ResourceType {
    
    case Markdown
    case CSS
}

public protocol ResourceModelManager: class {
    
    var title: String { get set }
    
//    
    //    // - We want to know the type of
//    var resourceType: ResourceType { get }
    
    // Update the visibleRect:
//    var visibleRect: NSRect? { get set }
    
    //  Get the typping attributes
//    func typingAttributes(for selectedRange: NSRange) -> [NSAttributedString.Key: Any]?
}
