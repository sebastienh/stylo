//
//  Delimiters.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-02.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

struct Delimiters {
    
    var delimiterValues: [Delimiter]
    
    var length: Int {
        
        return delimiterValues.count
    }
    
    init() {
        
        self.delimiterValues = [Delimiter]()
    }
    
    subscript(index: Int) -> Delimiter? {
        
        get {
            
            if index < delimiterValues.count {
                
                return delimiterValues[index]
            }
            
            return nil
        }
        set(delimiter) {
            
            if let delimiter = delimiter {
                
                delimiterValues[index] = delimiter
            }
        }
    }
    
    /// Simple method to push a new Delimiter
    @discardableResult
    mutating func push(_ delimiter: Delimiter) -> Delimiter {
        
        delimiterValues.append(delimiter)
        
        return delimiter
    }
}
