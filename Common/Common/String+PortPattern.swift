//
//  String+PortPattern.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-10.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension String {
    
    // /:[0-9]*$/,
    func matchPortPattern(fromPosition position: Int = 0, toPosition endPosition: Int? = nil) -> [Match]? {
        
        var localEndPosition = endPosition
        
        if localEndPosition == nil {
            
            localEndPosition = self.length
        }

        if let colonIndex = lastIndexOf(§":") {
            
            var i = colonIndex + 1
            
            // [0-9]*
            while i < length {
                
                let char = charAt(i)!
                
                if UnicodeDigit.isUnicodeDigit(char) {
                    
                    i += 1
                }
                else {
                    
                    return nil
                }
            }
            
            if i == localEndPosition {
                
                return [Match(start: colonIndex, end: i)]
            }
        }
        
        return nil
    }
    
}
