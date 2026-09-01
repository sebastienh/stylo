//
//  AttributeValueItem.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Common

public protocol OutputItemType: Hashable, Comparable {
    
    associatedtype S: OutputSectionType
    
    associatedtype I: InputItemType
    
    var stringValue: String { get }
    
    var valueOccurencesPositions: [TextId: [NSRange]] { get }
    
    var section: S { get }
    
    static func from(inputItem: I, outputSection: S) -> Self
    
    static func from(outputItems: [Self]) -> Self
}
