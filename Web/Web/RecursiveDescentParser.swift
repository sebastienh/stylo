//
//  RecursiveDescentParser.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-26.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

open class RecursiveDescentParser {
    
    var tokenReader: TokenStreamReader
    
    var reconsume: Bool
    
    public init(reader: UnicodeStringReader, currentInputTokenIndex: Int) {
        self.tokenReader = TokenStreamReader(stringReader: reader)
        self.reconsume = false
    }
    
    func currentInputToken() -> Token {
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        let token = tokenReader.reRead()
        os_log("token: %@ id: %d sourceStringSegment: %@", log: Log.Web.all, type: .debug, %%token.rawStringValue, token.tokenId, %%String(describing: token.sourceStringSegment))
        return token
        #else
        return tokenReader.reRead()
        #endif
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-the-next-input-token
    func consumeNextInputToken(resetReconsume: Bool = false) -> Token {
        
        if resetReconsume {
            reconsume = false
        }
        
        if !reconsume {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let token = tokenReader.read()
            os_log("token: %@ id: %d sourceStringSegment: %@", log: Log.Web.all, type: .debug, %%token.rawStringValue, token.tokenId, %%String(describing: token.sourceStringSegment))
            return token
            #else
            return tokenReader.read()
            #endif
        }
        else {
            
            reconsume = false
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let token = tokenReader.reRead()
            os_log("token: %@ id: %d sourceStringSegment: %@", log: Log.Web.all, type: .debug, %%token.rawStringValue, token.tokenId, %%String(describing: token.sourceStringSegment))
            return token
            #else
            return tokenReader.reRead()
            #endif
        }
    }
    
    func reconsumeCurrentInputToken() {
        reconsume = true
    }
    
}
