//
//  TstDictionary+PrefixMatch.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension TstDictionary {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PrefixMatch implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    ///
    /// @param key
    /// @exception TstDictionaryError.EmptyKey: key is an empty string
    ///
    public func prefixMatch(_ prefix: String?) -> [TstDictionaryEntry<T>] {
        
        var matches = [TstDictionaryEntry<T>]()
        
        // in case the prefix is nil we want to return 
        // all available completions.
        if prefix == nil || prefix!.isEmpty {
            
            allKeyEntries(root, matches: &matches)
        }
        else {

            let head = find(root, key: prefix!, d: 0)
        
            if let head = head {
            
                if let _ = head.key {
                
                    matches.append(head)
                }
            
                allKeyEntries(head.eqChild, matches: &matches)
            }
        }
            
        return matches
    }
    
    ///
    /// Returns all of the keys from the specified root parameter.
    ///
    /// @param root The root to start to accumulate entries.
    ///
    fileprivate func allKeyEntries(_ root: TstDictionaryEntry<T>?, matches: inout [TstDictionaryEntry<T>]) {
        
        if root == nil {
            
            return
        }
        
        allKeyEntries(root!.lowChild, matches: &matches)
        
        if let _ = root!.key {
            
            matches.append(root!)
        }
        
        allKeyEntries(root!.eqChild, matches: &matches)
        allKeyEntries(root!.highChild, matches: &matches)
    }

    
}
