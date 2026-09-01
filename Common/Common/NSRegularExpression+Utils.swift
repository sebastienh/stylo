//
//  NSRegularExpression+Utils.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation

public func regex(_ pattern:String, options: NSRegularExpression.Options = NSRegularExpression.Options.caseInsensitive) -> NSRegularExpression {
    
    return try! NSRegularExpression(pattern: pattern, options: options)
}

extension NSRegularExpression {
    
    public func test(_ str: String) -> Bool {
        
        // We limit the search (Anchored) since we just want to know
        // if there is a match
        return numberOfMatches(in: str,
            options: NSRegularExpression.MatchingOptions.anchored, range: NSMakeRange(0, str.count)) > 0
    }
    
}
