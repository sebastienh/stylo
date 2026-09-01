//
//  AttributesBloc.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

public struct AttributesBloc: Hashable {
    
    enum AttributesBlocType {
        
        // of the form: ::::: test1 test2 test3 ::::
        case classNamesList
        
        // of the form: { value=te\"st1 }
        case fencedAttributes
    }
    
    public var range: Range<Int> {
        
        if let openingCurlyBraquetRange = openingCurlyBraquetRange, let closingCurlyBraquetRange = closingCurlyBraquetRange {
            return openingCurlyBraquetRange.lowerBound..<closingCurlyBraquetRange.upperBound
        }
        else {
            if let first = attributes.first, let last = attributes.last {
                return first.startPosition..<last.endPosition
            }
        }
        assert(false, "error: empty AttributesBloc")
        return 0..<0
    }
    
    let type: AttributesBlocType
    var openingCurlyBraquetRange: Range<Int>?
    var closingCurlyBraquetRange: Range<Int>?
    public internal(set) var attributes: [Attribute]
    var startPosition: Int
    
    init(type: AttributesBlocType, attributes: [Attribute], openingCurlyBraquetRange: Range<Int>? = nil, closingCurlyBraquetRange: Range<Int>? = nil, startPosition: Int) {
        
        self.type = type
        self.attributes = attributes
        self.startPosition = startPosition
        self.openingCurlyBraquetRange = openingCurlyBraquetRange
        self.closingCurlyBraquetRange = closingCurlyBraquetRange
    }
    
    public func differentAttributes(from other: AttributesBloc) -> Set<Attribute> {
        
        return self.attributes.symmetricDifferenceWithIntersectingRanges(other.attributes)
    }
    
    public mutating func move(_ count: Int) {
        
        // we need to move everything... even the attributes because
        // we may use them.
        self.openingCurlyBraquetRange = openingCurlyBraquetRange?.moved(count)
        self.closingCurlyBraquetRange = closingCurlyBraquetRange?.moved(count)
        
        for i in 0..<attributes.count {
            attributes[i].move(count)
        }
        startPosition += count
    }
    
    func pushAttributesBlocTokens<S: State>(in state: S) -> (start: Token, close: Token)? {
        
        switch type {
            
        case .classNamesList:
            
            var attrBlocRegion = SourceStringRegion()
            
            let attrClassesTokenOpen = state.push(.attrClassesOpen, tag: "attr-bloc", nesting: .opening)
            
            attrClassesTokenOpen.attrsBlocs = [self]
            
            for attribute in attributes {
                
                assert(attribute.indicatorRange == nil)
                assert(attribute.nameSegment == nil)
                assert(attribute.type == .className)
                
                let attrTokenOpen = state.push(.classNameAttr, tag: §TokenType.classNameAttr, nesting: .selfClosing)
                let range = attribute.attributeValueSegment.valueRange
                let attrSegment = state.sourceStringSegment(from: range)
                attrTokenOpen.content = attribute.attributeValueSegment.valueString
                
                assert(attrSegment != nil)
                if let attrSegment = attrSegment {
                    
                    attrBlocRegion.addSourceStringSegment(attrSegment)
                    attrTokenOpen.setSourceFragment(attrSegment, for: .All)
                    attrTokenOpen.setSourceFragment(attrSegment, for: .AttributeValue)
                }
                
                attrTokenOpen.attr = attribute
            }
            
            attrClassesTokenOpen.setSourceFragment(attrBlocRegion, for: .All)
            let close = state.push(.attrClassesClose, tag: "attr-bloc", nesting: .closing)
            
            return (attrClassesTokenOpen, close)
            
        case .fencedAttributes:
            
            var attrBlocRegion = SourceStringRegion()
            let attrBlocTokenOpen = state.push(.attrBlocOpen, tag: "attr-bloc", nesting: .opening)
            
            attrBlocTokenOpen.attrsBlocs = [self]
            
            var tagRegion = SourceStringRegion()
            
            assert(openingCurlyBraquetRange != nil)
            if let openingCurlyBraquetRange = openingCurlyBraquetRange {
                
                let openingCurlyBraquetSegment = state.sourceStringSegment(from: openingCurlyBraquetRange)
                
                assert(openingCurlyBraquetSegment != nil)
                if let openingCurlyBraquetSegment = openingCurlyBraquetSegment {
                    attrBlocRegion.addSourceStringSegment(openingCurlyBraquetSegment)
                    tagRegion.addSourceStringSegment(openingCurlyBraquetSegment)
                }
            }
            
            for attribute in attributes {
                
                assert(attribute.type != .className)
                
                var attributeRegion = SourceStringRegion()
                var attributeNameRegion: SourceStringRegion?
                var attributeIndicatorRegion: SourceStringRegion?
//                var attributeQuotesRegion = SourceStringRegion()
                
                if let nameRange = attribute.nameSegment {
                    
                    attributeNameRegion = SourceStringRegion()
                    let nameSegment = state.sourceStringSegment(from: nameRange)
                    
                    assert(nameSegment != nil)
                    if let nameSegment = nameSegment {
                        
                        attrBlocRegion.addSourceStringSegment(nameSegment)
                        attributeRegion.addSourceStringSegment(nameSegment)
                        attributeNameRegion!.addSourceStringSegment(nameSegment)
                    }
                }
                
                if let indicatorRange = attribute.indicatorRange {
                    
                    attributeIndicatorRegion = SourceStringRegion()
                    let indicatorSegment = state.sourceStringSegment(from: indicatorRange)
                    
                    assert(indicatorSegment != nil)
                    if let indicatorSegment = indicatorSegment {
                        
                        attrBlocRegion.addSourceStringSegment(indicatorSegment)
                        attributeRegion.addSourceStringSegment(indicatorSegment)
                        attributeIndicatorRegion!.addSourceStringSegment((indicatorSegment))
                    }
                }
                
                if let openingQuoteRange = attribute.attributeValueSegment.openingQuoteRange {
                    
                    let openingQuoteSegment = state.sourceStringSegment(from: openingQuoteRange)
                    
                    assert(openingQuoteSegment != nil)
                    if let openingQuoteSegment = openingQuoteSegment {
                        
//                        attributeQuotesRegion.addSourceStringSegment(openingQuoteSegment)
                        attrBlocRegion.addSourceStringSegment(openingQuoteSegment)
                        tagRegion.addSourceStringSegment(openingQuoteSegment)
                    }
                }
                
                //// value range /////////////
                let range = attribute.attributeValueSegment.valueRange
                let valueSegment = state.sourceStringSegment(from: range)
                
                assert(valueSegment != nil)
                if let valueSegment = valueSegment {
                    
                    attrBlocRegion.addSourceStringSegment(valueSegment)
                    attributeRegion.addSourceStringSegment(valueSegment)
                }
                
                if let closingQuoteRange = attribute.attributeValueSegment.closingQuoteRange {
                    
                    let closingQuoteSegment = state.sourceStringSegment(from: closingQuoteRange)
                    
                    assert(closingQuoteSegment != nil)
                    if let closingQuoteSegment = closingQuoteSegment {

                        attrBlocRegion.addSourceStringSegment(closingQuoteSegment)
                        tagRegion.addSourceStringSegment(closingQuoteSegment)
                    }
                }
                
                var token: Token?
                
                switch attribute.type {
                    
                case .class:
                    
                    assert(attribute.type == .class)
                    assert(attribute.indicatorRange != nil)
                    assert(attribute.nameSegment == nil)
                    
                    token = state.push(.classAttr, tag: §TokenType.classAttr, nesting: .selfClosing)
                    
                    assert(attributeIndicatorRegion != nil)
                    if let attributeIndicatorRegion = attributeIndicatorRegion {
                        token!.setSourceFragment(attributeIndicatorRegion, for: .Tag)
                    }
                    
                    token!.setSourceFragment(attributeRegion, for: .All)
                    token!.setSourceFragment(valueSegment, for: .AttributeValue)
                    token?.content = ".\(attribute.attributeValueSegment.valueString)"
                    
                case .className:
                    assert(false, "should not have className attribute type in fenced attributes bloc")
                    break
                    
                case .id:
                    
                    assert(attribute.type == .id)
                    assert(attribute.indicatorRange != nil)
                    assert(attribute.nameSegment == nil)
                    
                    token = state.push(.idAttr, tag: §TokenType.idAttr, nesting: .selfClosing)
                    
                    assert(attributeIndicatorRegion != nil)
                    if let attributeIndicatorRegion = attributeIndicatorRegion {
                        token!.setSourceFragment(attributeIndicatorRegion, for: .Tag)
                    }
                    
                    token!.setSourceFragment(attributeRegion, for: .All)
                    token!.setSourceFragment(valueSegment, for: .AttributeValue)
                    token?.content = "#\(attribute.attributeValueSegment.valueString)"
                    
                case .keyValue:
                    
                    assert(attribute.type == .keyValue)
                    assert(attribute.indicatorRange != nil)
                    assert(attribute.nameSegment != nil)
                    
                    token = state.push(.keyValueAttr, tag: §TokenType.keyValueAttr, nesting: .selfClosing)
                    
                    assert(attributeNameRegion != nil)
                    if let attributeNameRegion = attributeNameRegion {
                        token!.setSourceFragment(attributeNameRegion, for: .AttributeName)
                    }
                    
                    assert(attributeIndicatorRegion != nil)
                    if let attributeIndicatorRegion = attributeIndicatorRegion {
                        token!.setSourceFragment(attributeIndicatorRegion, for: .Tag)
                    }
                    
                    token!.setSourceFragment(attributeRegion, for: .All)
                    token!.setSourceFragment(valueSegment, for: .AttributeValue)
                    if let nameString = attribute.nameString {
                        token?.content = "\(nameString)=\(attribute.attributeValueSegment.escapedValueString)"
                    }
                    else {
                        token?.content = "?=\(attribute.attributeValueSegment.escapedValueString)"
                    }
                    
                case .elementName:
                    
                    assert(attribute.type == .elementName)
                    assert(attribute.indicatorRange == nil)
                    assert(attribute.nameSegment == nil)
                    
                    token = state.push(.elementNameAttr, tag: §TokenType.elementNameAttr, nesting: .selfClosing)
                    
                    token!.setSourceFragment(attributeRegion, for: .All)
                    token!.setSourceFragment(valueSegment, for: .ElementName)
                }
                
                
                token?.attr = attribute
            }
            
            assert(closingCurlyBraquetRange != nil)
            if let closingCurlyBraquetRange = closingCurlyBraquetRange {
                
                let closingCurlyBraquetSegment = state.sourceStringSegment(from: closingCurlyBraquetRange)
                
                assert(closingCurlyBraquetSegment != nil)
                if let closingCurlyBraquetSegment = closingCurlyBraquetSegment {
                    
                    attrBlocRegion.addSourceStringSegment(closingCurlyBraquetSegment)
                    tagRegion.addSourceStringSegment(closingCurlyBraquetSegment)
                }
            }
            
            if tagRegion.length != 0 {
                attrBlocTokenOpen.setSourceFragment(tagRegion, for: .Tag)
            }
            
            attrBlocTokenOpen.setSourceFragment(attrBlocRegion, for: .All)
            let close = state.push(.attrBlocClose, tag: "attr-bloc", nesting: .closing)
            return (attrBlocTokenOpen, close)
        }
        return nil
    }
    
    public func convertToTokenAttributes(using src: String) -> [(String, String)] {
        
        var tokenAttributes = [(String, String)]()
        
        let attributesMap = self.attributes.convertToAttributesMap()
        
        for attribute in attributesMap {
            
            switch attribute.key {
            
            case §Attribute.AttributeType.elementName:
                break
                
            case §Attribute.AttributeType.class:
            
                let classesString = attribute.value.joined(separator: " ")
                tokenAttributes.append((§Attribute.AttributeType.class, classesString))
                
            case §Attribute.AttributeType.id:
                
                let idString = attribute.value.joined(separator: " ")
                tokenAttributes.append((§Attribute.AttributeType.id, idString))
                
            default:
                
                let attributeValueString = attribute.value.joined(separator: " ")
                tokenAttributes.append((attribute.key, attributeValueString))
            }
        }
        
        return tokenAttributes
    }
    
    public static func ==(lhs: AttributesBloc, rhs: AttributesBloc) -> Bool {
        
        // let type: AttributesBlocType
        if lhs.type != rhs.type {
            return false
        }
        
        // var openingCurlyBraquetRange: Range<Int>?
        if lhs.openingCurlyBraquetRange != rhs.openingCurlyBraquetRange {
            return false
        }
        
        // var closingCurlyBraquetRange: Range<Int>?
        if lhs.closingCurlyBraquetRange != rhs.closingCurlyBraquetRange {
            return false
        }
        
        // var attributes: [Attribute]
        if lhs.attributes.count != rhs.attributes.count {
            return false
        }
        
        for i in 0..<lhs.attributes.count {
            
            if lhs.attributes[i] != rhs.attributes[i] {
                return false
            }
        }
        
        // var startPosition: Int
        if lhs.startPosition != rhs.startPosition {
            return false
        }
        return true
    }
    
}
