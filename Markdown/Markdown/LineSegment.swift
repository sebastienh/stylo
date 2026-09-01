//
//  LineSegment.swift
//  Markdown
//
//  Created by Sebastien hamel on 2018-10-26.
//  Copyright © 2018 Textually Inc All rights reserved.
//

import Foundation

struct LineSegment {
    
    let line: Int
    let start: Int
    let end: Int
    let prefixSpaces: Int?
    
    init(line: Int, start: Int, end: Int, prefixSpaces: Int? = nil) {
        
        self.line = line
        self.start = start
        self.end = end
        self.prefixSpaces = prefixSpaces
    }
}
