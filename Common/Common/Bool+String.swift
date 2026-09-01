//
//  Bool+String.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-05-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

extension Bool {
    
    public static func from(_ string: String) -> Bool? {
        
        if string == "false" {
            return false
        }
        else if string == "true" {
            return true
        }
        return nil
    }
    
}
