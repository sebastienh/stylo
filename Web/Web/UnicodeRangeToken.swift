//
//  UnicodeRangeToken.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

struct UnicodeRangeToken: CSSTokenCompositor, Equatable, Hashable {
    
    let startOfRange: Character
    let endOfRange: Character
    var token: CSSToken

    init(sourceStringSegment: SourceStringSegment, rawStringValue: String, startOfRange: Character, endOfRange: Character) {
        
        self.startOfRange = startOfRange
        self.endOfRange = endOfRange
        self.token = CSSToken(sourceStringSegment: sourceStringSegment, tokenId: §CSTokenId.unicodeRangeToken, rawStringValue: rawStringValue, formattedStringValue: nil)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.token)
        hasher.combine(self.startOfRange)
        hasher.combine(self.endOfRange)
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
        
            if let other = other as? UnicodeRangeToken {
            
                if !self.token.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: token are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.startOfRange != other.startOfRange {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: startOfRange are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.endOfRange != other.endOfRange {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: endOfRange are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not UnicodeRangeToken.", log: Log.Web.all, type: .debug)
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

func ==(lhs: UnicodeRangeToken, rhs: UnicodeRangeToken) -> Bool {
    
    return lhs.equals(to: rhs)
}
