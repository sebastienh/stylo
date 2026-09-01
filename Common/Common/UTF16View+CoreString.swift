//
//  UTF16View+CoreString.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String.UTF16View {
    
    public var length: Int {
        
        return count
    }
    
    /// Method that return the substring based on the String.Index unit, the Character.
    /// The end index is the up-to index (not including)
    public func slice(_ start: Int, end: Int? = nil) -> String.UTF16View? {
        
        guard start >= 0 else {
            return nil
        }
        
        let length = self.length
        var localEnd = end
        let localStart = start < 0 ? length + start : start
        
        if let _localEnd = localEnd {
            
            if start == _localEnd {
                return String("").utf16
            }
            
            if _localEnd < 0 {
                localEnd = length + _localEnd
            }
        }
        else {
            
            localEnd = length
        }
        
        let _startIndex = self.index(startIndex, offsetBy: localStart)
        
        if localEnd! == count {
            return String(describing: [_startIndex..<endIndex]).utf16
        }
        else {
            let _endIndex = self.index(_startIndex, offsetBy: localEnd! - localStart)
            return String(describing: [_startIndex..<_endIndex]).utf16
        }
    }

    
}
