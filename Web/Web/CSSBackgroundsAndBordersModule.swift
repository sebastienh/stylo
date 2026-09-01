//
//  CSSBackgroundsAndBordersModuleLevel3.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import os

final class CSSBackgroundsAndBordersModule : CSSModule {
    
    /// Singleton instance.
    static var shared = CSSBackgroundsAndBordersModule()
    
    fileprivate init() {
        
    }

    func parsePropertyValueToDOM(_ declaration: CSDeclaration, parentPropertyValueElement: CSSDOMElement) {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("parsePropertyValueToDOM(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
    }
}
