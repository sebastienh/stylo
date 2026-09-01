//
//  CSSRuleType.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-15.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

//    const unsigned short STYLE_RULE = 1;
//    const unsigned short CHARSET_RULE = 2;
//    const unsigned short IMPORT_RULE = 3;
//    const unsigned short MEDIA_RULE = 4;
//    const unsigned short FONT_FACE_RULE = 5;
//    const unsigned short PAGE_RULE = 6;
//    const unsigned short MARGIN_RULE = 9;
//    const unsigned short NAMESPACE_RULE = 10;

/// The type attribute must return the CSS rule type.
/// see http://dev.w3.org/csswg/cssom/#dom-cssrule-type
public enum CSSRuleType : UInt16 {
    
    case style_rule = 1;
    case charset_rule = 2
    case import_rule = 3
    case media_rule = 4
    case font_face_rule = 5
    case page_rule = 6
    case margin_rule = 9
    case namespace_rule = 10
    case invalid_at_rule = 11
    case invalidNamespaceRule = 12
}
