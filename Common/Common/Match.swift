//
//  Match.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public struct Match {
    
    public let start: Int
    public let end: Int
    
    public var match: Bool {
        
        return start != end
    }
    
    public var length: Int {
        
        return end - start 
    }
    
    public init(start: Int, end: Int) {
        
        self.start = start
        self.end = end 
    }
}
