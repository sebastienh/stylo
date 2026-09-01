//
//  GenericTokenId.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-07-05.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

// These tokens should not be declared by any TokenDefinition
// they are generic tokens used by the geenric reader in certain 
// situations.
enum GenericTokenId : Int {
    
    case error = 254
    case eof = 255
    
}
