//
//  PreservedCSLanguageObject.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

import Common
import os

open class PreservedCSLanguageObject: CSSOMLanguageObject {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing subclass implementation!", log: Log.Web.all, type: .fault)
        #endif
    }
    
}
