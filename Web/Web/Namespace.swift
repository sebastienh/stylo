//
//  Namespace.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-18.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

struct ExtractResult {
    
    let namespace: DOMString?
    let prefix: DOMString?
    let localName: DOMString
    let qualifiedName: DOMString?
    
    init(namespace: DOMString?, prefix: DOMString?, localName: DOMString, qualifiedName: DOMString?) {
        
        self.namespace = namespace
        self.prefix = prefix
        self.localName = localName
        self.qualifiedName = qualifiedName
    }
}


public enum Namespace : String {
    
    case HTML   = "http://www.w3.org/1999/xhtml"
    case XML    = "http://www.w3.org/XML/1998/namespace"
    case XMLNS  = "http://www.w3.org/2000/xmlns/"
    case MATHML = "http://www.w3.org/1998/Math/MathML"
    case SVG    = "http://www.w3.org/2000/svg"
    case XLINK  = "http://www.w3.org/1999/xlink"
    case CSS    = "http://www.w3.org/Style/CSS/"
    case MD     = "https://commonmark.org"
    
    /// validate a qualifiedName
    /// see https://dom.spec.whatwg.org/#validate
    static func validateQualifiedName(_ qualifiedName: DOMString, exception: inout Exception) {
        
        // 1. If qualifiedName does not match the Name production, 
        // throw an InvalidCharacterError exception.
        // TODO: implement this validation
        
        // 2. If qualifiedName does not match the QName production, 
        // throw a NamespaceError exception.
        // TODO: Implement this validation.
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("validateQualifiedName(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
    
    /// validate and extract a namespace and qualifiedName
    /// see https://dom.spec.whatwg.org/#validate-and-extract
    static func validateAndExtract(_ namespace: DOMString?, qualifiedName: DOMString, exception: inout Exception) -> ExtractResult? {
        
        // 1. If namespace is the empty string, set it to null.
        // Note: implicit by the implementation
        
        // 2. [Validate](https://dom.spec.whatwg.org/#validate) 
        // qualifiedName. Rethrow any exceptions.
        validateQualifiedName(qualifiedName, exception: &exception)
        
        if exception.isError() {
            return nil
        }
        
        // 3. Let prefix be null.
        var prefix: DOMString? = nil
        
        // 4. Let localName be qualifiedName.
        var localname = qualifiedName
        
        // 5. If qualifiedName contains a ":" (U+003E), then split the string on it 
        // and set prefix to the part before and localName to the part after.
        let components = qualifiedName.components(separatedBy: CharacterSet(charactersIn: ":"))
        
        if components.count > 1 {
            
            if components.count != 2 {
                
                exception.code = ExceptionCode.namespaceError
                return nil
            }
            else {
                
                prefix = components[0]
                localname = components[1]
            }
        }
        
        // 6. If prefix is non-null and namespace is null, 
        // throw a NamespaceError exception.
        if prefix != nil {
         
            if namespace == nil {
             
                exception.code = ExceptionCode.namespaceError
                return nil
            }
        }
        
        // 7. If prefix is "xml" and namespace is not the XML namespace, 
        // throw a NamespaceError exception.
        if prefix != nil {
            
            if prefix == §Namespace.XML {
             
                // namespace is not the XML namespace
                // FIXME: need to implement this validation
            }
        }
        
        // 8. If either qualifiedName or prefix is "xmlns" and namespace is not the XMLNS namespace, 
        // throw a NamespaceError exception.
        if let prefix = prefix, let namespace = namespace {
            
            if prefix == §Namespace.XMLNS || qualifiedName == §Namespace.XMLNS {
                
                // namespace is not the XML namespace
                if namespace != §Namespace.XMLNS {
                    
                    exception.code = ExceptionCode.namespaceError
                    return nil
                }
            }
        }
        
        // 9. If namespace is the XMLNS namespace and neither qualifiedName nor prefix is "xmlns", 
        // throw a NamespaceError exception.
        if namespace == §Namespace.XMLNS {
        
            if prefix != §Namespace.XMLNS && qualifiedName != §Namespace.XMLNS {
                
                exception.code = ExceptionCode.namespaceError
                return nil
            }
        }
        
        // 10. Return namespace, prefix, localName, and qualifiedName.
        return ExtractResult(namespace: namespace, prefix: prefix, localName: localname, qualifiedName: qualifiedName)
    }
    
}
