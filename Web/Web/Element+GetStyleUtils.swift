//
//  Element+GetStyleUtils.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-05.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import os
//
//extension Element: GetStyleUtils {
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: GetStyleUtils protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    /// [SameObject] readonly attribute CSSStyleDeclaration cascadedStyle;
//    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
//    public var cascadedStyle: CSSStyleDeclaration {
//        
//        assert(document.styleContainer != nil, "document.styleContainer == nil")
//        if let styleContainer = document.styleContainer {
//            
//            return styleContainer.cascadedStyleForElement(self)
//        }
//        else {
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("document.styleContainer is nil.", log: Log.Web.all, type: .error)
//            #endif
//        }
//        return CSSStyleDeclaration()
//    }
//    
//    /// [SameObject] readonly attribute CSSStyleDeclaration defaultStyle;
//    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-defaultstyle
//    public var defaultStyle: CSSStyleDeclaration {
//        
//        assert(document.styleContainer != nil, "document.styleContainer == nil")
//        if let styleContainer = document.styleContainer {
//            
//            return styleContainer.defaultStyleForElement(self)
//        }
//        else {
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("document.styleContainer is nil.", log: Log.Web.all, type: .error)
//            #endif
//        }
//        return CSSStyleDeclaration()
//    }
//    
//    /// [SameObject] readonly attribute CSSStyleDeclaration rawComputedStyle;
//    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
//    public var rawComputedStyle: CSSStyleDeclaration {
//        
//        asse
//        
//        
//        assert(document.styleContainer != nil, "document.styleContainer == nil")
//        if let styleContainer = document.styleContainer {
//            
//            return styleContainer.rawComputedStyleForElement(self)
//        } else {
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("document.styleContainer is nil.", log: Log.Web.all, type: .error)
//            #endif
//        }
//        
//        return CSSStyleDeclaration()
//    }
//    
//    /// [SameObject] readonly attribute CSSStyleDeclaration usedStyle;
//    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-usedstyle
//    public var usedStyle: CSSStyleDeclaration {
//        
//        assert(document.styleContainer != nil, "document.styleContainer == nil")
//        if let styleContainer = document.styleContainer {
//            
//            return styleContainer.usedStyleForElement(self)
//        } else {
//            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("document.styleContainer is nil.", log: Log.Web.all, type: .error)
//            #endif
//        }
//        return CSSStyleDeclaration()
//    }
//    
//    
//}
