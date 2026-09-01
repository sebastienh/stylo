//
//  Attribute.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct Attribute: Hashable {
    
    enum AttributeType: String {
        
        case `class` = "class"
        case className
        case id
        case keyValue
        case elementName
    }
    
    let type: AttributeType
    
    /// The indicator range may refer to the "." in the
    /// class case, the "=" in the key value case or the
    /// "#" in the id case. There is no indicator in the
    /// className case (form: "::: className ::::::")
    var indicatorRange: Range<Int>?
    
    var nameSegment: Range<Int>?
    
    var nameString: String?
    
    var attributeValueSegment: AttributeValueSegment
    
    var startPosition: Int {
        
        if let nameSegment = nameSegment {
            return nameSegment.startIndex
        }
        if let indicatorRange = indicatorRange {
            return indicatorRange.startIndex
        }
        return attributeValueSegment.startPosition
    }
    
    var endPosition: Int {
        
        return attributeValueSegment.endPosition
    }
    
    var range: Range<Int> {
        
        return startPosition..<endPosition
    }
    
    init(attributeValueSegment: AttributeValueSegment) {
        
        self.indicatorRange = nil
        self.nameSegment = nil
        self.nameString = nil
        self.type = .className
        self.attributeValueSegment = attributeValueSegment
    }
    
    init(type: AttributeType, nameSegment: Range<Int>? = nil, nameString: String?, indicatorRange: Range<Int>? = nil, attributeValueSegment: AttributeValueSegment) {
        
        self.indicatorRange = indicatorRange
        self.nameSegment = nameSegment
        self.type = type
        self.attributeValueSegment = attributeValueSegment
        self.nameString = nameString
    }
    
    public mutating func move(_ count: Int) {
        
        self.indicatorRange = indicatorRange?.moved(count)
        self.nameSegment = nameSegment?.moved(count)
        self.attributeValueSegment.move(count)
    }
    
    public func isEqualWithIntersectingRange(to other: Attribute) -> Bool {
        
        if self.range.overlaps(other.range) {
            
            if type != other.type {
                return false
            }
            if nameString != other.nameString {
                return false
            }
            if !attributeValueSegment.valueEquals(to: other.attributeValueSegment) {
                return false
            }
            return true
        }
        return false
    }
    
    public static func ==(lhs: Attribute, rhs: Attribute) -> Bool {
        
        if lhs.type != rhs.type {   
            return false
        }
        if lhs.nameSegment != rhs.nameSegment {
            return false
        }
        if lhs.indicatorRange != rhs.indicatorRange {
            return false
        }
        if lhs.attributeValueSegment != rhs.attributeValueSegment {
            return false
        }
        if lhs.nameString != rhs.nameString {
            return false
        }
        return true
    }
    
}

extension Collection where Element == Attribute {
    
    public func convertToAttributesMap() -> [String: Set<String>] {
        
        var attributesMap = [String: Set<String>]()
        
        for attribute in self {
            
            let attributeValueString = attribute.attributeValueSegment.valueString
            
            switch attribute.type {
                
            case .class:
                
                if attributesMap[§Attribute.AttributeType.class] == nil {
                    attributesMap[§Attribute.AttributeType.class] = Set<String>()
                }
                attributesMap[§Attribute.AttributeType.class]!.insert(attributeValueString)
                
            case .className:
                
                if attributesMap[§Attribute.AttributeType.class] == nil {
                    attributesMap[§Attribute.AttributeType.class] = Set<String>()
                }
                attributesMap[§Attribute.AttributeType.class]!.insert(attributeValueString)
                
            case .id:
                
                // we always override the old value if there was one
                attributesMap[§Attribute.AttributeType.id] = Set<String>(arrayLiteral: attributeValueString)
                
            case .keyValue:
                
                let attributeNameString = attribute.nameString
                
                assert(attributeNameString != nil)
                if let attributeNameString = attributeNameString {
                    
                    if attributesMap[attributeNameString] == nil {
                        attributesMap[attributeNameString] = Set<String>()
                    }
                    // we support multiple values for the same attribute key
                    attributesMap[attributeNameString]!.insert(attributeValueString)
                }
                
            case .elementName:
                break
            }
        }
        return attributesMap
    }
}
