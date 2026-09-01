//
//  CompilationUnit.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-11-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct CompilationUnit {
    
    public let id = UUID().uuidString
    
    // not necessarly an edit 
    public let change: SourceStringChangeDescription?
    
    public let result: StylableActionResult
    
    var containsFocusAttributes: Bool {
        return result.containsFocusAttributes
    }
    
    init(change: SourceStringChangeDescription?, result: StylableActionResult) {
        
        self.change = change
        self.result = result
    }
}
