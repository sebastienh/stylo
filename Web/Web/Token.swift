//
//  Token.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-07-15.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// this method should be provided
//typealias SkipPolicy = (readerPosition: Int, )

//
// The syntax becomes let Rule: Parser = ...TokenName | ...TokenName2 ^^^ action + retry

// Note : at this point it should be noticed that the retry can execute grammar options using the
// already defined rules.
//
// It should be noted that the error handling becomes almost part of the language

// Failure should also return the deepness of it's investigation
// before returning a failure from the last retry

// Token can be a generic type used by everyone.
protocol Token: MessageContainer, Positionnable, CustomStringConvertible {

    var tokenId: Int { get }
    
    var rawStringValue: String { get set }
    
    var formattedStringValue: String? { get }
    
    var stringRepresentation: String { get }
    
    func equals(to other: Any?, comparePositions: Bool) -> Bool
}

extension Token {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? Token {
    
                if comparePositions && self.sourceStringSegment != other.sourceStringSegment {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: sourceStringSegment are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.tokenId != other.tokenId {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: tokenId are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.rawStringValue != other.rawStringValue {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: rawStringValue are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.formattedStringValue != other.formattedStringValue {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: formattedStringValue are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Token.", log: Log.Web.all, type: .debug)
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
