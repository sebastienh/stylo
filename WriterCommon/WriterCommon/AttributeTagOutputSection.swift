//
//  AttributeTagOutputSection.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public typealias AttributeTagOutputSectionValue = AttributeTagOutputSection<AttributeTagInputSection>

public struct AttributeTagOutputSection<I: InputSectionType>: OutputSectionType {
    
    public static func < (lhs: AttributeTagOutputSection<I>, rhs: AttributeTagOutputSection<I>) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
    
    public typealias I = I
    
    public let stringValue: String
    
    public static func from(inputSection: I) -> AttributeTagOutputSection {
        
        return AttributeTagOutputSection(string: inputSection.stringValue)
    }
    
    public init(string: String) {
        
        self.stringValue = string
    }
    
    public func localizedStandardContains(_ str: String) -> Bool {
        return stringValue.localizedStandardContains(str)
    }
}
