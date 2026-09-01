//
//  CSSActualStyleDeclaration.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

/// This class is the final result of the CSS computation
/// is contains added methods for later handling by rendering
/// classes and simple methods for cascading process like
/// evaluating x-height and cm value.
final class CSSActualStyleDeclaration: CSSStyleDeclaration {
    
    override init(sourceStringSegment: SourceStringSegment?) {
        
        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    func oAdvance() -> CGFloat {
        
        assert(false, "oAdvance() missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return 1.0
    }
    
    func xHeight() -> CGFloat {
        
        assert(false, "Missing implementation")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("xHeight() missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return 1.0
    }
    
}
