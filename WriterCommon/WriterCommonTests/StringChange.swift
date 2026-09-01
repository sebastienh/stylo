//
//  StringChange.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-21.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

struct StringChange: CustomDebugStringConvertible, CustomStringConvertible {
    
    let affectedRange: NSRange
    let replacementString: String    
    
    var debugDescription: String {
        
        return description
    }
    
    var description: String {
        
        return "{ affectedRange: \(affectedRange), replacementString: ->\(replacementString)<-}"
    }
    
    init(affectedRange: NSRange, replacementString: String) {
        
        self.affectedRange = affectedRange
        self.replacementString = replacementString
    }
}
