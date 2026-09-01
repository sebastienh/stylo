//
//  TstDictionary+PartialMatch.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension TstDictionary {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PartialMatch implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// @param key
    /// @exception TstDictionaryError.EmptyKey: key is an empty string
    ///
    public func partialMatch(_ key: String) throws -> [TstDictionaryEntry<T>] {
        
        return try partialMatch(key, wildChar: ".")
    }
    
    ///
    /// Partial match search with wild char character.
    ///
    /// @param key: key to match
    /// @param wildChar: don't care" character
    /// @exception TstDictionaryError.EmptyKey: key is an empty string
    ///
    /// Searching the dictionary for the pattern
    /// "*o*o*o" matches the single word rococo,
    /// while the pattern
    /// "*a*a*a" matches many words, including banana,
    /// casaba, and pajama.
    ///
    fileprivate func partialMatch(_ key: String, wildChar: UnicodeScalar) throws -> [TstDictionaryEntry<T>]{
        
        if key.isEmpty {
            
            throw TstDictionaryError.emptyKey
        }
        
        var matches = [TstDictionaryEntry<T>]()
        
        partialMatchSearch(root!, key: key, index: 0, wildChar: wildChar, matches: &matches)
        
        return matches
    }
    
    /// <summary>
    ///
    /// </summary>
    /// <param name="p"></param>
    /// <param name="key"></param>
    /// <param name="index"></param>
    /// <param name="wildChar"></param>
    /// <param name="matches"></param>
    fileprivate func partialMatchSearch(_ p: TstDictionaryEntry<T>?, key: String, index: Int, wildChar: UnicodeScalar, matches: inout [TstDictionaryEntry<T>]) {
        
        if p == nil {
            
            return
        }
        
        let c: UnicodeScalar = key.unicodeScalars[key.unicodeScalars.index(key.unicodeScalars.startIndex, offsetBy: index)]
        
        if c.value == wildChar.value || c.value < p!.splitChar.value {
            
            partialMatchSearch(p!.lowChild,key: key,index: index,wildChar: wildChar,matches: &matches)
        }
        
        if c.value == wildChar.value || c.value == p!.splitChar.value {
            
            if index < key.length - 1 {
                
                partialMatchSearch(p!.eqChild, key: key,index: index+1,wildChar: wildChar,matches: &matches)
            }
            else if let _ = p!.key {
                
                matches.append(p!)
            }
        }
        
        if c.value == wildChar.value || c.value > p!.splitChar.value {
            
            partialMatchSearch(p!.highChild, key: key,index: index,wildChar: wildChar,matches: &matches);
        }
    }

    
}
