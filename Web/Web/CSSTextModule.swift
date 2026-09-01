//
//  CSSTextModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-27.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// http://www.w3.org/TR/css3-color/
final class CSSTextModule : CSSModule {
    
    /// Singleton instance.
    static var shared = CSSTextModule()
    
    fileprivate init() {
        
    }
    
    /// TextIndent = "text-indent"
    /// TextTransform = "text-transform"
    /// TextAlign = "text-align"
    func parsePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyValuePseudoElement: CSSDOMElement) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation.", log: Log.Web.all, type: .error)
        #endif
        
        let propertyName = declaration.propertyName
        
        if let property = CSSProperty(rawValue: propertyName) {
        
            switch property {
                
            default:
                assert(false, "Unsupported property in text module.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Unsupported property in text module: %@", log: Log.Web.all, type: .error, %%propertyName)
                #endif
            }
            
            
//        if propertyName == §CSSProperty.TextIndent {
//        
//            // example implementation
//            //            let domFontStyleParser = CSSDOMFontStyleParser(componentValueArray: declaration.value, document: document )
//            //
//            //            return domFontStyleParser.parseFontStyleValueToDOM()
//            
//            
//            fatalError("Missing implementation.")
//        }
//        else if propertyName == §CSSProperty.TextTransform {
//            
//            fatalError("Missing implementation.")
//        }
//        else if propertyName == §CSSProperty.TextAlign {
//            
//            fatalError("Missing implementation.")
//        }
        }
        assert(false, "see previous errors.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("see previous errors.", log: Log.Web.all, type: .error)
        #endif
    }
    
}
