//
//  CSSSupportedProperty.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

final class CSSSupportedElement: Hashable {
    
    let languageName: String
    let elementName: String
    
    var hashValue: Int {

        return languageName.hashValue ^ elementName.hashValue
    }
    
    init(languageName: String, elementName: String) {
        
        self.languageName = languageName
        self.elementName = elementName
    }
}

func ==(lhs: CSSSupportedElement, rhs: CSSSupportedElement) -> Bool {
    
    if lhs.languageName != rhs.languageName {
        
        return false
    }
    
    if lhs.elementName != rhs.elementName {
        
        return false
    }
    
    return true
}
