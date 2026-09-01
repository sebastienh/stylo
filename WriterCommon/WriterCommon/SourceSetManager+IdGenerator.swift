//
//  SourceSetManager+IdGenerator.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

fileprivate var value = 10

extension SourceSetManager: IdGenerator {
    
    public var nextId: String? {
        value += 1
        return String(value)
    }
    
    public var idPrefix: String {
        return "source"
    }
    
}
