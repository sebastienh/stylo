//
//  CSSActualStyleDeclaration.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web
import os

/// This class is the final result of the CSS computation
/// is contains added methods for later handling by rendering 
/// classes and simple methods for cascading process like 
/// evaluating x-height and cm value.
final class CSSActualStyleDeclaration: CSSStyleDeclaration {
    
    func oAdvance() -> CGFloat {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("oAdvance() missing implementation", log: Log.WriterCommon.all, type: .error)
        #endif
        return 1.0
    }
    
    func xHeight() -> CGFloat {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("xHeight() missing implementation", log: Log.WriterCommon.all, type: .error)
        #endif
        return 1.0
    }
    
}
