//
//  PourcentageToken.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-20.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

struct PourcentageToken: CSSTokenCompositor, Equatable, Hashable {
    
    let number: Number
    var token: CSSToken
    
    init(sourceStringSegment: SourceStringSegment, tokenId: Int, rawStringValue: String, number: Number) {
        
        self.number = number
        self.token = CSSToken(sourceStringSegment: sourceStringSegment, tokenId: tokenId, rawStringValue: rawStringValue, formattedStringValue: nil)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.token)
        hasher.combine(self.number)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public mutating func move(_ count: Int) {
        
        self.token.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? PourcentageToken {
            
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
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not PourcentageToken.", log: Log.Web.all, type: .debug)
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

func ==(lhs: PourcentageToken, rhs: PourcentageToken) -> Bool {
    
    return lhs.equals(to: rhs)
}
