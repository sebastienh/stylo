//
//  Language.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-15.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import os

public enum Language: String {

    case All = "*"
    
    case json = "text/json"
    
    case CSS = "text/css"
    
    case CCSS = "text/ccss"
    
    case HTML = "text/html"
    
    case markdownHtml = "text/markdown-html"
    
    case Stella = "text/stella"
    
    case Markdown = "text/markdown"
    
    case None = ""
    
    
    
    public var supportsAutocompletion: Bool {
        
        switch self {
            
        case .All:
            return true
            
        case .CSS:
            return true
            
        case .CCSS:
            return true
            
        case .Stella:
            return true
            
        case .markdownHtml:
            return true
            
        case .json:
            return false
            
        case .HTML:
            return false
            
        case .Markdown:
            return false
            
        case .None:
            return false
        }
        
    }
    
    
    func allElementTypes() -> [ElementType] {
        
        switch self {

        case .All:
            return [CoreDOMElementType.All]
            
        case .CSS:
            return CSSElementType.allValues()
            
        case .CCSS:
            return CSSElementType.allValues()
            
        case .Stella:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .Stella requested", log: Log.Common.all, type: .fault)
            #endif
            return []
            
        case .json:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .json requested", log: Log.Common.all, type: .fault)
            #endif
            return []
            
        case .HTML:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .HTML requested", log: Log.Common.all, type: .fault)
            #endif
            return []
            
        case .Markdown:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .Markdown requested", log: Log.Common.all, type: .fault)
            #endif
            return []
            
        case .None:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .None requested", log: Log.Common.all, type: .fault)
            #endif
            return []
        case .markdownHtml:
            
            assert(false, "Missing implementation.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("allElementTypes() for language .markdownHtml requested", log: Log.Common.all, type: .fault)
            #endif
            return []
        }
    }
    
    public func languageSimpleString() -> String {
        
        switch self {
            
        case .All: return "All"
        case .CSS: return "CSS"
        case .CCSS: return "CCSS"
        case .Stella: return "Stella"
        case .json: return "Json"
        case .HTML: return "HTML"
        case .Markdown: return "Markdown"
        case .None: return "None"
        case .markdownHtml: return "Markdown HTML"
        }
    }
    
}
