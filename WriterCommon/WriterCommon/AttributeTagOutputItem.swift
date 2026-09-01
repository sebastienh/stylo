//
//  AttributeTagOutputItem.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public typealias AttributeTagOutputItemValue = AttributeTagOutputItem<AttributeTagOutputSectionValue, AttributeTagInputItem>

public struct AttributeTagOutputItem<S: OutputSectionType, I: InputItemType & TextRanges>: OutputItemType {
    
    public typealias S = S
    
    public typealias I = I
    
    public static func from(inputItem: I, outputSection: S) -> AttributeTagOutputItem<S, I> {
        
        guard let textId = inputItem.textId else {
            assertionFailure("Error: inputItem.textId is nil")
            return AttributeTagOutputItem(string: inputItem.stringValue, section: outputSection, valueOccurencesPositions: [:])
        }
        
        return AttributeTagOutputItem(string: inputItem.stringValue, section: outputSection, valueOccurencesPositions: [textId: inputItem.ranges])
    }
    
    public static func from(outputItems: [AttributeTagOutputItem<S, I>]) -> AttributeTagOutputItem<S, I> {
        
        assert(!outputItems.isEmpty)
        
        // populate [TextId: [NSRange]]
        var valuesPositions: [TextId: [NSRange]] = [:]
        let attributeValueName = outputItems.first!.itemString
        let section = outputItems.first!.section
        // When merging attributes values in the UI
        // the sections may be different.
        //
        // let sectionString = section.stringValue
        for outputItem in outputItems {
            
            // we should normally have same attribute values for all output items
            assert(attributeValueName == outputItem.itemString)
            // see comment above
            // assert(sectionString == outputItem.section.stringValue)
            valuesPositions.merge(outputItem.valueOccurencesPositions, uniquingKeysWith: { (firstRanges, secondRanges) -> [NSRange] in
                return firstRanges + secondRanges
            })
        }
        
        return AttributeTagOutputItem(string: attributeValueName, section: section, valueOccurencesPositions: valuesPositions)
    }
    
    public var stringValue: String {
        return itemString
    }
    
    let itemString: String
    
    public let section: S
    
    public let valueOccurencesPositions: [TextId: [NSRange]]
    
    ///
    /// @param string: the string value of this item
    /// @param section: the associated section of this item
    /// @param tagsTextsPositions: the positions of this tag item in the texts
    ///
    init(string: String, section: S, valueOccurencesPositions: [TextId: [NSRange]]) {
        self.itemString = string
        self.section = section
        self.valueOccurencesPositions = valueOccurencesPositions
    }
    
    func localizedStandardContains(_ str: String) -> Bool {
        return stringValue.localizedStandardContains(str)
    }
}

extension AttributeTagOutputItem: Equatable {
    public static func ==(lhs: AttributeTagOutputItem, rhs: AttributeTagOutputItem) -> Bool {
        // we don't care about the positions
        return lhs.itemString == rhs.itemString && lhs.section == rhs.section
    }
}

extension AttributeTagOutputItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.itemString)
        hasher.combine(self.section)
    }
}

extension AttributeTagOutputItem: Comparable {
    public static func < (lhs: AttributeTagOutputItem, rhs: AttributeTagOutputItem) -> Bool {
        return lhs.stringValue < rhs.stringValue
    }
}
