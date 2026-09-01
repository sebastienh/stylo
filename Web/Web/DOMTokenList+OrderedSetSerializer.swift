//
//  DOMTokenList+OrderedSetSerializer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension DOMTokenList : OrderedSetSerializer {
    
    /// Method to return a list of items as a string :
    /// "item1String item2String item3String"
    func stringify() -> DOMString {
        
        var string: DOMString = ""
        
        for item in self {
         
            if string.length > 0 {
                
                string += " "
            }
            
            string += "\(item)"
        }
        
        return string
    }
}
