//
//  CSSDOMFontFamilyNamePseudoElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-16.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontFamilyNameElement: CSSDOMElement, CSSDOMSelectableValueElement {
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMSelectableValueElement protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// NW-160 : selected-value
    /// This property value container is used to keep a reference to the value
    /// that this element express e.g.
    ///
    /// font-family : "arial";
    ///
    /// This container would contain
    /// CSSPropertyValueContainer.FontFamily(CSSFontFamily.Custom("arial"))
    var propertyValue: CSSPropertyValueContainer?
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSDOMFontFamilyNameElement {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let propertyValue = propertyValue {
                    
                    if let otherPropertyValue = other.propertyValue {
                        
                        if propertyValue != otherPropertyValue {
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("Not equals: propertyValue are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Not equals: other propertyValue is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.propertyValue != nil {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Not equals: other propertyValue is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: other is not CSSDOMFontFamilyNameElement.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
}
