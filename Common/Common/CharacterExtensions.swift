//
//  CharacterExtensions.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-12.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

extension Character {

    public func unicodeScalarCodePoint() -> UInt32 {
    
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return scalars[scalars.startIndex].value
    }
}
