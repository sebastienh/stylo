//
//  TextPosition.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct TextPosition: TextPositionType {

    public let textId: String

    public let range: NSRange
    
    init(textId: String, range: NSRange) {
        
        self.textId = textId
        self.range = range
    }
    
}
