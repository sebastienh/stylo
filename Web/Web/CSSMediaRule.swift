//
//  CSSMediaRule.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-21.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSMediaRule: CSSRule {
    
    public override var description: String {
        
        return "CSSMediaRule"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////override
    
    override func accept(_ visitor: CSSVisitor) {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing implementation!", log: Log.Web.all, type: .fault)
        #endif
    }
    
}
