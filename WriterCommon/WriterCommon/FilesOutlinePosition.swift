//
//  FilesOutlinePosition.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct FilesOutlinePosition: TextPositionType, CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "textId: \(textId), range: \(range)"
    }
    
    public var value: Int {
        return range.location
    }
    
    public let textId: TextId
    
    public let range: NSRange
    
    public init(textId: TextId, range: NSRange) {
        
        self.textId = textId
        self.range = range
    }
    
}
