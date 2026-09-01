//
//  Reader.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-07-20.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

typealias ScannerMethod = (_ characterIndex : Int) -> (Token)


// the reader contains all the states that have been
// reached so far, it also contains the string on which
// we are working
// The reader contains an array of tuple of the form (ReaderPosition, Token)
// which can be access by index (as any array). So each time we ask the Reader (from a readerPosition)
// to return the next ReaderPosition, The reader state ask the next ReaderPosition, if it does not
// exists, the reader will create a new reader state for the parsing result Token he has found,
// it will then add this ReaderPosition to the array of ReaderPositions along with the Token result
// and will finally return the tuple value containing the new ReaderPosition and the Token that
// correspond to it.
struct TokenStreamReader: TokenReader {
    
    let stringReader: UnicodeStringReader
    var nextTokenIndexToRead: Int
    var currentToken: Token?
    
    var tokens = [Token]()
    
    init(stringReader: UnicodeStringReader) {
        self.stringReader = stringReader
        self.nextTokenIndexToRead = 0
    }
    
    mutating func reRead() -> Token {
        
        if let currentToken = currentToken {
            
            return currentToken
        }
        return read()
    }
    
    /**
     *  Utility method to read sequentially the tokens 
     *  in the TokenStream
     */
    mutating func read() -> Token {
        
        let token: Token = read(nextTokenIndexToRead)
        nextTokenIndexToRead += 1
        return token
    }
    
    fileprivate mutating func read(_ tokenIndex: Int) -> Token {
        
        // start of the stream
        if tokenIndex == 0 {
            
            currentToken = stringReader.scan(0) as Token
            
        }
        // somewhere further in the stream
        else {

            // scan starting from the previous position
            // we know we always have a previous position
            // since we have returned from the recursive call.
            
            currentToken = stringReader.scan((currentToken!.sourceStringFragment as! SourceStringSegment).endIndex) as Token
        }
        
        // return the token value
        return currentToken!
    }
}
