//
//  AutocompletionType.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-06-01.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public enum AutocompletionType  {
    
    case htmlElement(name: String?)
    case cssProperty(name: String?)
    
    
    var stringValue: String {
        
        switch self {
            
        case .htmlElement(let name):
            
            if let name = name {
                
                return name
            }
            return "HTML Element"
            
        case .cssProperty(let name):
            
            if let name = name {
                
                return name
            }
            return "CSS PRoperty"
        }
    }
}
