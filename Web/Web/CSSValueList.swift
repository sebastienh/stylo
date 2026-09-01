//
//  CSSValueList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-22.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

final class CSSValueList {
    
    var values: [CSSValue]
    
    init() {
        
        values = [CSSValue]()
    }
    
    func addValue(_ value: CSSValue) {
        
        values.append(value)
    }

    func valueAtIndex(_ index: Int) -> CSSValue? {
        
        if index < values.count {
            return values[index]
        }
        
        return nil
    }
    
}
