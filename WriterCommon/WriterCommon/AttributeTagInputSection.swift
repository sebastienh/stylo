//
//  AttributeTagInputSection.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct AttributeTagInputSection: InputSectionType {
    
    public let stringValue: String
       
    public func localizedStandardContains(_ str: String) -> Bool {
        return stringValue.localizedStandardContains(str)
    }
}

extension AttributeTagInputSection: ExpressibleByStringLiteral {
    
    public typealias StringLiteralType = String
    
    public init(stringLiteral value: String) {
        self.init(stringValue: value)
    }
}
