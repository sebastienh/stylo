//
//  CSLanguageObject.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

open class CSLanguageObject: LanguageObject {
    
    var sourceStringSegment: SourceStringSegment? {
        get {
            return super.sourceStringFragment as? SourceStringSegment
        }
        set {
            super.sourceStringFragment = newValue
        }
    }
    
    init(sourceStringSegment: SourceStringSegment?) {
        
        super.init(sourceStringFragment: sourceStringSegment)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSLanguageObject {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSLanguageObject.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
}
