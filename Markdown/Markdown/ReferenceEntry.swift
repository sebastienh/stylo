//
//  ReferenceEntry.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2018-10-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public struct ReferenceEntry {
    
    let label: String
    let href: String
    let title: String
    var utf16Range: NSRange?
    var attrsBlocs: [AttributesBloc]?
    
    /// Since there can be many references with the same
    /// label and we keep only the first one in a document
    /// all the references except the first one are inactive.
    ///
    /// By default a reference is active.
    var active: Bool = false
    
    public var signature: String {
        
        return "label:\(label),to:\(href),titled:\(title),active:\(active)"
    }
    
    init(label: String, href: String, title: String, utf16Range: NSRange? = nil) {
        
        self.label = label
        self.href = href
        self.title = title
        self.utf16Range = utf16Range
        self.attrsBlocs = nil
    }
    
    public mutating func move(_ count: Int) {
        
        self.utf16Range?.location += count
    }
    
}
