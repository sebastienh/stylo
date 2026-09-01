//
//  HashToken.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-11.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

struct HashToken: CSSTokenCompositor, Equatable, Hashable {
    
    let type: String
    var token: CSSToken
    
    init(sourceStringSegment: SourceStringSegment, tokenId: Int, rawStringValue: String, formattedString: String, type: String) {
        self.type = type        
        self.token = CSSToken(sourceStringSegment: sourceStringSegment, tokenId: tokenId, rawStringValue: rawStringValue, formattedStringValue: formattedString)
    }
    
    init(sourceStringSegment: SourceStringSegment, tokenId: Int, rawStringValue: String, type: String) {
        self.type = type
        self.token = CSSToken(sourceStringSegment: sourceStringSegment, tokenId: tokenId, rawStringValue: rawStringValue, formattedStringValue: nil)
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
        
            if let other = other as? HashToken {
            
                if !self.token.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: token are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.type != other.type {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: hash token type are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not HashToken.", log: Log.Web.all, type: .debug)
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

func ==(lhs: HashToken, rhs: HashToken) -> Bool {
    
    return lhs.equals(to: rhs)
}
