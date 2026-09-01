//
//  DocumentType.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

/// Document type with associated UTI
public enum DocumentType: String {
    
    case stylo = "net.textually.stylo.document"
    case nodio = "net.textually.nodio.document"
    case text = "public.plain-text"
    case markdown = "net.daringfireball.markdown"
    
    public static func from(uti: String) -> DocumentType? {

        switch uti {
            
        case "net.textually.nodio.document":
            return .nodio
        case "net.textually.stylo": fallthrough
        case "net.textually.stylo.document":
            return .stylo
        case "net.textually.plain-text": fallthrough
        case "public.xml": fallthrough
        case "public.html": fallthrough
        case "public.source-code": fallthrough
        case "pro.writer.plain-text": fallthrough
        case "public.plain-text":
            return .text
        case "net.textually.markdown": fallthrough
        case "net.daringfireball.markdown":
            return .markdown
        default:
            assert(false, "Error: no document type for uti: \(uti)")
            return nil
        }
    }
    
    func isPlainText() -> Bool {
        
        switch self {
            
        case .stylo:
            
            return false
            
        default:
            
            return true
        }
    }
    
    static func isStyloDocumentUrl(_ url: URL) -> Bool {
        
        if url.pathExtension == "stylo" {
            
            return true
        }
        return false
    }
    
}


