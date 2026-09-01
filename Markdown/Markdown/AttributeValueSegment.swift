//
//  AttributeValueSegment.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

struct AttributeValueSegment: Equatable, Hashable {
    
    var openingQuoteRange: Range<Int>?
    var closingQuoteRange: Range<Int>?
    var valueRange: Range<Int>
    let valueString: String
    
    var escapedValueString: String {
        
        let removedEscapes = removeEscapes(from: valueString)
        return escapeHtml(removedEscapes)
    }
    
    var startPosition: Int {
        
        if let openingQuoteRange = openingQuoteRange {
            return openingQuoteRange.startIndex
        }
        return valueRange.startIndex
    }
    
    var endPosition: Int {
        
        if let closingQuoteRange = closingQuoteRange {
            return closingQuoteRange.endIndex
        }
        return valueRange.endIndex
    }
    
    var range: Range<Int> {
        
        return startPosition..<endPosition
    }
    
    init(valueRange: Range<Int>, valueString: String) {
        
        self.openingQuoteRange = nil
        self.closingQuoteRange = nil
        self.valueRange = valueRange
        self.valueString = valueString.lowercased()
    }
    
    init(openingQuoteRange: Range<Int>, closingQuoteRange: Range<Int>, valueRange: Range<Int>, valueString: String) {
        
        self.openingQuoteRange = openingQuoteRange
        self.closingQuoteRange = closingQuoteRange
        self.valueRange = valueRange
        self.valueString = valueString.lowercased()
    }
    
    public mutating func move(_ count: Int) {
        
        self.openingQuoteRange = openingQuoteRange?.moved(count)
        self.closingQuoteRange = closingQuoteRange?.moved(count)
        self.valueRange = valueRange.moved(count)
    }
    
    public func valueEquals(to other: AttributeValueSegment) -> Bool {
        

        if valueString != other.valueString {
            return false
        }
        return true
    }
    
    private func removeEscapes(from valueString: String) -> String {
        
        if valueString.isEmpty {
            return valueString
        }
        
        var unescapedValueString = ""

        var index = valueString.startIndex
        var nextIndex = valueString.index(after: index)
        let endIndex = valueString.endIndex
        
        while index != endIndex && nextIndex != endIndex {
            
            if valueString[index] == "\\" && valueString[nextIndex] == "\"" {
             
                // we keep only the second
                unescapedValueString += "\""
                index = valueString.index(after: nextIndex)
            }
            else {
                
                unescapedValueString += String(valueString[index])
                index = valueString.index(after: index)
            }
            nextIndex = valueString.index(after: index)
        }
        
        if index != endIndex {
            unescapedValueString += String(valueString[index])
        }
        
        return unescapedValueString
    }
    
    static func ==(lhs: AttributeValueSegment, rhs: AttributeValueSegment) -> Bool {
        
        if lhs.openingQuoteRange != rhs.openingQuoteRange {
            return false
        }
        if lhs.closingQuoteRange != rhs.closingQuoteRange {
            return false
        }
        if lhs.valueRange != rhs.valueRange {
            return false
        }
        if lhs.valueString != rhs.valueString {
            return false
        }
        return true
    }
}
