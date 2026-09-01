//
//  SourceStringChangeDescription+Positionnable.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-07.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import os

extension SourceStringChangeDescription {
    
    public func changedString(before element: Positionnable) -> String? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("element sourceStringSegment: %@.", log: Log.Common.sourceStringChangeDecription, type: .info, %%element.sourceStringFragment)
        #endif
        
        let string = targetString.string
        let startStringIndex = element.startStringIndex
        
        assert(startStringIndex != nil)
        if let startStringIndex = startStringIndex {
            
            let length = startStringIndex + changeLength
            let startIndex = string.utf16.startIndex
            let endIndex = string.utf16.index(startIndex, offsetBy: length)
            let utf16String = string.utf16[startIndex..<endIndex]
            return String(utf16String)
        }
        return nil
    }
    
    public func changedString(inside element: Positionnable) -> String? {
        
        let string = targetString.string
        let startStringIndex = element.startStringIndex
        let endStringIndex = element.endStringIndex
        
        assert(startStringIndex != nil)
        assert(endStringIndex != nil)
        if let startStringIndex = startStringIndex, let endStringIndex = endStringIndex {
            
            let length = endStringIndex + changeLength - startStringIndex
            let startIndex = string.utf16.index(string.utf16.startIndex, offsetBy: startStringIndex)
            let endIndex = string.utf16.index(startIndex, offsetBy: length)
            let utf16String = string.utf16[startIndex..<endIndex]
            return String(utf16String)
        }
        return nil
    }
    
    public func changedString(startingFrom element: Positionnable) -> String? {
        
        let string = targetString.string
        let startStringIndex = element.startStringIndex
        
        assert(startStringIndex != nil)
        if let startStringIndex = startStringIndex {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("string utf16 count: %d", log: Log.Common.sourceStringChangeDecription, type: .info, string.utf16.count)
            #endif
            if startStringIndex < string.utf16.count {
                
                let startIndex = string.utf16.index(string.utf16.startIndex, offsetBy: startStringIndex)
                let utf16String = string.utf16.suffix(from: startIndex)
                return String(utf16String)
            }
        }
        return nil
    }
    
    public func changedString(between low: Positionnable, and up: Positionnable) -> String? {
        
        let string = targetString.string
        
        let startStringIndex = low.endStringIndex
        let endStringIndex = up.startStringIndex
        
        assert(startStringIndex != nil)
        assert(endStringIndex != nil)
        if let startStringIndex = startStringIndex, let endStringIndex = endStringIndex {

            let length = endStringIndex + changeLength - startStringIndex
            let startIndex: String.UTF16View.Index = string.utf16.index(string.utf16.startIndex, offsetBy: startStringIndex)
            let endIndex: String.UTF16View.Index = string.utf16.index(startIndex, offsetBy: length)
            let utf16String = string.utf16[startIndex..<endIndex]
            return String(utf16String)
        }
        return nil
    }
    
    public func changedString(after element: Positionnable) -> String? {
        
        let string = targetString.string
        
        let endStringIndex = element.endStringIndex
        
        assert(endStringIndex != nil)
        if let endStringIndex = endStringIndex {

            let startIndex = string.utf16.index(string.utf16.startIndex, offsetBy: endStringIndex)
            let utf16String = string.utf16[startIndex..<string.utf16.endIndex]
            return String(utf16String)
        }
        return nil
    }
    
}
