//
//  DimensionToken.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

struct DimensionToken: CSSTokenCompositor, Equatable, Hashable {
    
    let unit: String
    
    let number: Number?
    
    var token: CSSToken
    
    var numberSegment: SourceStringSegment
    
    var unitSegment: SourceStringSegment
    
    init(sourceStringSegment: SourceStringSegment, numberSegment: SourceStringSegment, unitSegment: SourceStringSegment, tokenId: Int, rawStringValue: String, number: Number, unit: String) {
        self.number = number
        self.unit = unit
        self.token = CSSToken(sourceStringSegment: sourceStringSegment, tokenId: tokenId, rawStringValue: rawStringValue, formattedStringValue: nil)
        self.numberSegment = numberSegment
        self.unitSegment = unitSegment
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.token)
        hasher.combine(self.number)
        hasher.combine(self.unit)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public mutating func move(_ count: Int) {
        
        self.token.move(count)
        self.numberSegment.move(count)
        self.unitSegment.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? DimensionToken {
            
                if !self.token.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: token are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.number != other.number {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: number are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.unit != other.unit {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: unit are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not DimensionToken.", log: Log.Web.all, type: .debug)
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

func ==(lhs: DimensionToken, rhs: DimensionToken) -> Bool {
    
    return lhs.equals(to: rhs)
}
