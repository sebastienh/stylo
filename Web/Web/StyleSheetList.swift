//
//  StyleSheetList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//http://dev.w3.org/csswg/cssom/#stylesheetlist
//[ArrayClass]
//interface StyleSheetList {
//    getter StyleSheet? item(unsigned long index);
//    readonly attribute unsigned long length;
//};

protocol IStyleSheetList: class {
    
    var length: Int { get }
    
    func item(_ index: Int) -> CSSStyleSheet?
}

final class StyleSheetList : CSSOMLanguageObject, IStyleSheetList {
    
    var styleSheetList: [CSSStyleSheet]
    
    var length: Int {
        
        get {
            return styleSheetList.count
        }
    }
    
    subscript(index: Int) -> CSSStyleSheet? {
        
        get {
            
            return item(index)
        }
        
        set(newValue) {
            
            if let newValue = newValue {
            
                styleSheetList[index] = newValue
            }
        }
    }
    
    init() {
        self.styleSheetList = [CSSStyleSheet]()
        super.init(sourceStringSegment: nil)
    }

    /// Extend the StyleSheetList with styleSheetList parameter.
    func extend(_ styleSheetList: StyleSheetList) {
        
        self.styleSheetList.append(contentsOf: styleSheetList.styleSheetList)
    }
    
    
    func item(_ index: Int) -> CSSStyleSheet? {
        
        if index < styleSheetList.count {
            return styleSheetList[index]
        }
        
        return nil
    }
    
    func addStyleSheet(_ styleSheet: CSSStyleSheet) {
        
        styleSheetList.append(styleSheet)
    }
    
    func removeStyleSheet(_ styleSheet: CSSStyleSheet) {
        
        var index: Int = 0
        var found: Bool = false
        
        for styleSheetItem in self {
            
            if styleSheet.href == styleSheetItem.href {
                found = true
                break
            }
            index += 1
        }
        if found {

            styleSheetList.remove(at: index)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func accept(_ visitor: CSSVisitor) {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
}
