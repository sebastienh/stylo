//
//  MessageDomain.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation


public enum MessageDomain : Int {
    
    case css = 1000
    case dom = 2000
    
    func tableFromDomain() -> String {
    
        switch self {
            
        case .css:
            return §MessageTable.CSSErrorMessages
            
        case .dom:
            return §MessageTable.DOMErrorMessages
            
            
        }
    }
    
}
