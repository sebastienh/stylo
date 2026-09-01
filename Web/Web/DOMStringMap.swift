//
//  DOMStringMap.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

//[OverrideBuiltins]
//interface DOMStringMap {
//    getter DOMString (DOMString name);
//    setter creator void (DOMString name, DOMString value);
//    deleter void (DOMString name);
//};
// see http://www.w3.org/TR/html5/infrastructure.html#domstringmap-0

/// The DOMStringMap interface represents a set of name-value pairs.
public struct DOMStringMap {
    
    var internalDictionary: [DOMString: DOMString]
    
    //    getter DOMString (DOMString name);
    subscript(name: DOMString) -> DOMString? {
        
        return internalDictionary[name]
    }
    
    init() {
        
        self.internalDictionary = [DOMString: DOMString]()
    }
    
    //    setter creator void (DOMString name, DOMString value);
    mutating func set(_ name: DOMString, value: DOMString) {
        
        internalDictionary[name] = value
    }
    
    //    deleter void (DOMString name);
    mutating func delete(_ name: String) {
        
        internalDictionary.removeValue(forKey: name)
    }
}
