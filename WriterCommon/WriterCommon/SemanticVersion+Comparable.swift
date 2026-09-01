//
//  SemanticVersion+Comparable.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-23.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension SemanticVersion: Comparable {
    
    public static func < (lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        
        // major
        if lhs.major < rhs.major {
            return true
        }
        else if lhs.major > rhs.major {
            return false
        }
        assert(lhs.major == rhs.major)
        
        // minor
        if lhs.minor < rhs.minor {
            return true
        }
        else if lhs.minor > rhs.minor {
            return false
        }
        assert(lhs.minor == rhs.minor)
        
        // patch
        if lhs.patch < rhs.patch {
            return true
        }
        return false
    }
    
}
