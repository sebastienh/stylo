//
//  String+UniChar.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-07-09.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

extension String {
    
    mutating func append(_ codePoint: unichar) {
        
        let unicodeValue = UnicodeScalar(codePoint)
        
        self.append(String(describing: unicodeValue!))
    }
    
}
