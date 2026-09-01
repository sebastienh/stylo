//
//  NSAttributedString+Debug.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-07-30.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

extension NSAttributedString {
    
    public var attributesString: String {
        
        var _attributes = ""
        
        enumerateAttributes(in: NSMakeRange(0, self.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired, using: {
            
            (attributes, range, stop) in
            
            // Get the attributes
            let attributeDictionary = NSDictionary(dictionary: attributes)
            
            _attributes += "range: \(NSStringFromRange(range))  attributes: \(attributeDictionary)"
        })
        
        return _attributes
    }
    
}
