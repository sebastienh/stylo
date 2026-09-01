//
//  CSSFontFaceRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-21.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSFontFaceRule: CSSRule {

    public override var description: String {
        
        return "CSSFontFaceRule"
    }
    
    init(cssText: DOMString, styleSheet: CSSStyleSheet) {
        
        super.init(cssText: cssText, type: CSSRuleType.font_face_rule, parentStyleSheet: styleSheet)
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
