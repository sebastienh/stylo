//
//  SymbolItem.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import os

open class LanguageObject: Syntagm, MessageContainer, Positionnable, EquatableLanguageObject {


    public convenience init() {
        
        self.init(sourceStringFragment: nil)
    }
    
    public init(sourceStringFragment: SourceStringFragment?) {
        
        self.sourceStringFragment = sourceStringFragment
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open var sourceStringFragment: SourceStringFragment?
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MessageContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    open lazy var messageHandler = MessageHandler()
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? LanguageObject {
            
                if comparePositions {
                    
                    if let sourceStringFragment = self.sourceStringFragment {
                        
                        return sourceStringFragment.equals(to: other.sourceStringFragment)
                    }
                    else {
                        
                        if other.sourceStringFragment != nil {
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("Not equals: other sourceStringFragment is not nil.", log: Log.Common.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: other is not LanguageObject.", log: Log.Common.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not equals: other is nil.", log: Log.Common.all, type: .debug)
            #endif
            return false
        }
        return true
    }
}
