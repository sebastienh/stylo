//
//  String+UniChar.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-07-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public prefix func §(lhs: String) -> UTF16Char {

    #if DEBUG
    assert(lhs.length == 1)
    #endif 
        
    return lhs.utf16.first!
}

extension String {

    
    public static func fromCharCode(_ codeUnit: UTF16Char) -> String {
        
        return String(describing: UnicodeScalar(codeUnit)!)
    }
    
    fileprivate func stringFromSegment(_ segment: SourceStringSegment) -> String? {
        
        if segment.length > 0 {
            return slice(segment.startIndex.integerValue, end: segment.endIndex.integerValue)?.string
        }
        return nil
    }
    
    public func utf16IndexFromIntegerIndex(_ integerIndex: Int) -> String.UTF16View.Index? {
        
        if integerIndex == length {
            return utf16.endIndex
        }
        else if integerIndex < length {
            return utf16.index(utf16.startIndex, offsetBy: integerIndex)
        }
        
        return nil
    }
    
    public func substr(_ start: Int, end: Int) -> String? {
     
        if start > end {
            
            return slice(end, end: start)?.string
        }
        
        return slice(start, end: end)?.string
    }
    
    public mutating func replaceAll(_ expression: NSRegularExpression, options: NSRegularExpression.MatchingOptions = [], from fromIndex: Index, withTemplate template: String) {
        
        replaceAll(expression, options: options, subrange: fromIndex ..< endIndex, withTemplate: template)
    }
        
    public mutating func replaceAll(_ expression: NSRegularExpression, options: NSRegularExpression.MatchingOptions = [], subrange: Range<Index>, withTemplate template: String) {
        
        let foundationString = substring(with: subrange)
            
        let result = expression.stringByReplacingMatches(in: foundationString, options: options, range: NSMakeRange(0, foundationString.count), withTemplate: template)
            
        self = substring(to: subrange.lowerBound) + result + substring(from: subrange.upperBound)
    }

    
    public func utf16Index(_ index: Int) -> String.UTF16View.Index {
        
        return utf16.index(utf16.startIndex, offsetBy: index, limitedBy: utf16.endIndex)!
    }
    
    public func utf16CharAt(_ index: Int) -> UniChar? {
            
        let index = utf16.index(utf16.startIndex, offsetBy: index, limitedBy: utf16.endIndex)
            
        if index != utf16.endIndex{
            return utf16[index!]
        }
            
        return nil
    }
    
    public func substringFromIndex(_ index: Int) -> String? {
        
        if index < self.utf16.count {
        

            return String(utf16[utf16Index(index)..<utf16.endIndex])
        }
        
        return nil
    }
    
    public func substringToIndex(_ index: Int) -> String? {
        
        if index <= self.utf16.count {
            
            return String(utf16[utf16.startIndex..<utf16Index(index)])
        }
        
        return nil
    }
    
    public func substringWithUTF16Range(_ range: NSRange) -> String? {
        
        if range.upperBound <= self.utf16.count {
        
            return String(utf16[utf16Index(range.location)..<utf16Index(range.upperBound)])
        }
        
        return nil
    }
    
    
    public mutating func append(_ codePoint: unichar) {
        
        let unicodeValue = UnicodeScalar(codePoint)!
        
        self.append(String(describing: unicodeValue))
    }
    

    
}
