//
//  OrderedSetParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


/// see https://dom.spec.whatwg.org/#concept-ordered-set-parser
final class OrderedSetParser {
    
    static func parse(_ input: DOMString) -> [DOMString] {
        
        let tokens = input.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        
        return tokens
    }
    
}
