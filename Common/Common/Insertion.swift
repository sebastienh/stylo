//
//  Insertion.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-20.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

/// This struct is used to modify an insertion in an NSTextView.
public struct Insertion {
    
    public let replacementString: String
    
    public let locationVariation: Int
    
    public let replacementRange: NSRange
    
    public init(replacementString: String, locationVariation: Int, replacementRange: NSRange) {
        
        self.replacementString = replacementString
        self.locationVariation = locationVariation
        self.replacementRange = replacementRange
    }
    
}
