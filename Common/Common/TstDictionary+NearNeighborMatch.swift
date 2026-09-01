//
//  TstDictionary+NearNeighborMatch.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension TstDictionary {
    
    
    ///
    /// Near-neighbor search in the key string set.
    ///
    /// @param key key to search for.
    /// @param distance Hamming distance
    /// @return near-neighbor search within Hamming distance.
    ///
    /// This methods finds all words in
    /// the dictionary that are within a given Hamming distance of
    /// a query word.
    ///
    /// For instance, a search for all words within
    /// distance two of soda finds code, coma and 117 other
    /// words.  
    ///
    public func nearNeighborMatch(_ key: String, distance: Int) throws -> [TstDictionaryEntry<T>] {
        
        if distance < 0 {
            
            throw TstDictionaryError.argumentException("dist is negative");
        }

        var matches = [TstDictionaryEntry<T>]()
        
        nearNeighborsSearch(root, key: key, index: 0, dist: distance, matches: &matches)
        
        return matches
    }
    
    
    func nearNeighborsSearch(_ p: TstDictionaryEntry<T>?, key: String, index: Int, dist: Int, matches: inout [TstDictionaryEntry<T>]) {
        
        if p == nil || dist < 0 {
            
            return
        }
        
        let c: UnicodeScalar = key.unicodeScalars[key.unicodeScalars.index(key.unicodeScalars.startIndex, offsetBy: index)]
        
        // low child
        if dist > 0 || c.value < p!.splitChar.value {
        
            nearNeighborsSearch(p!.lowChild, key: key, index: index, dist: dist, matches: &matches)
        }
        
        // eq child
        if let _ = p!.key {
            
            
            // FIXME: this test seems to disallow certain good results 
            // from the list.
//            if key.length - index <= dist  {
            
                matches.append(p!)
//            }
//            else {
//                
//                debugPrint("key.length: \(key.length)")
//                debugPrint("index: \(index)")
//                debugPrint("key.length - index: \(key.length - index), dist: \(dist)")
//            }
        }
        else {
            
            var localIndex = index

            if localIndex != key.length - 1 {
            
                localIndex += 1
            }
            var localDist = dist

            if c.value != p!.splitChar.value {

                localDist -= 1
            }
            
            nearNeighborsSearch(p!.eqChild, key: key, index: localIndex, dist: localDist, matches: &matches)
        }
        
        // highchild
        if dist > 0 || c.value > p!.splitChar.value {

            nearNeighborsSearch(p!.highChild, key: key, index: index, dist: dist, matches: &matches)
        }
    }
}
