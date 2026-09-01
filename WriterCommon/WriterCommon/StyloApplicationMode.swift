//
//  StyloApplicationMode.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-07-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public enum StyloApplicationMode {
    
    case `default`
    case advanced
    
    static var key: String {
        
        return "StyloApplicationMode"
    }
}
