//
//  AttributesTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-04-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class AttributesTests: XCTestCase {

    func testEscapingAttributesValue() {
        
        let src = "{ value=\"te\\\"st1\" }"
        var pos = 0
        let attributesBloc = parseAttributesBloc(src, pos: &pos, max: 19)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 0..<1)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 18..<19)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let expectedAttribute = Attribute(type: .keyValue, nameSegment: 2..<7, nameString: "value", indicatorRange: 7..<8, attributeValueSegment: AttributeValueSegment(openingQuoteRange: 8..<9, closingQuoteRange: 16..<17, valueRange: 9..<16, valueString: "te\\\"st1"))
            
            XCTAssert(attributes.first != nil)
            if let attribute = attributes.first {
            
                XCTAssert(expectedAttribute == attribute)
                let escapedValue = attribute.attributeValueSegment.escapedValueString
                print("escapedValue: \(escapedValue)")
                XCTAssert(escapedValue == "te&quot;st1")
            }
        }
    }
    
    func testEscapingAttributesValue2() {
        
        let src = "{ value=te\"st1 }"
        var pos = 0
        let attributesBloc = parseAttributesBloc(src, pos: &pos, max: 19)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 0..<1)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 15..<16)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let expectedAttribute = Attribute(type: .keyValue, nameSegment: 2..<7, nameString: "value", indicatorRange: 7..<8, attributeValueSegment: AttributeValueSegment(valueRange: 8..<14, valueString: "te\"st1"))
            
            XCTAssert(attributes.first != nil)
            if let attribute = attributes.first {
                
                XCTAssert(expectedAttribute == attribute)
                let escapedValue = attribute.attributeValueSegment.escapedValueString
                print("escapedValue: \(escapedValue)")
                XCTAssert(escapedValue == "te&quot;st1")
            }
        }
    }
    
    func testAttributeValueSegmentEquatable() {
        
        let first = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        let second = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        XCTAssert(first == second)
    }
    
    func testAttributeValueSegmentEquatableNilValue() {
        
        let first = AttributeValueSegment(valueRange: 1..<5, valueString: "test")
        let second = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        XCTAssert(first != second)
    }
    
    func testAttributeValueEquatable() {
    
        let firstAVS = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        let secondAVS = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        
        let firstA = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: firstAVS)
        let secondA = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: secondAVS)
        
        XCTAssert(firstA == secondA)
    }
    
    func testAttributeValueEquatableNotNilQuoteRanges() {
        
        let firstAVS = AttributeValueSegment(valueRange: 1..<5, valueString: "test")
        let secondAVS = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        
        let firstA = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: firstAVS)
        let secondA = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: secondAVS)
        
        XCTAssert(firstA != secondA)
    }
    
    func testAttributeValueEquatableNotDifferentAttributesTypes() {
        
        let firstAVS = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        let secondAVS = AttributeValueSegment(openingQuoteRange: 0..<1, closingQuoteRange: 5..<6, valueRange: 1..<5, valueString: "test")
        
        let firstA = Attribute(type: .keyValue, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: firstAVS)
        let secondA = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: secondAVS)
        
        XCTAssert(firstA != secondA)
    }
    
    func testClassNamesListParsing() {
        
        var pos = 6
        let attributesBloc = parseAttributes("::::: test1 test2 test3 ::::", pos: &pos, max: 28)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .classNamesList)
            XCTAssert(attributesBloc.openingCurlyBraquetRange == nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange == nil)
            XCTAssert(attributesBloc.attributes.count == 3)
            
            let firstAttribute = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: AttributeValueSegment(valueRange: 6..<11, valueString: "test1"))
            
            let secondAttribute = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: AttributeValueSegment(valueRange: 12..<17, valueString: "test2"))
            
            let thirdAttribute = Attribute(type: .className, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: AttributeValueSegment(valueRange: 18..<23, valueString: "test3"))
            
            var firstAttrFound = false
            var secondAttrFound = false
            var thirdAttrFound = false
            
            for attribute in attributesBloc.attributes {
                
                if attribute == firstAttribute {
                    firstAttrFound = true
                }
                
                if attribute == secondAttribute {
                    secondAttrFound = true
                }
                if attribute == thirdAttribute {
                    thirdAttrFound = true
                }
            }
            XCTAssert(firstAttrFound && secondAttrFound && thirdAttrFound)
            
        }
    }
    
    func testFencedAttributesBlocParsingOneClassWithSpaces() {
        
        var pos = 3
        let attributesBloc = parseAttributes("::: { .test1 } ::::", pos: &pos, max: 19)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 4..<5)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 13..<14)
            }
            
            let attributes = attributesBloc.attributes
                
            XCTAssert(attributes.count == 1)
            let attribute = Attribute(type: .class, nameSegment: nil, nameString: nil, indicatorRange: 6..<7, attributeValueSegment: AttributeValueSegment(valueRange: 7..<12, valueString: "test1"))
            
            XCTAssert(attribute == attributes.first!)
        }
    }
    
    func testAttributesParsingWithoutClosingDoubleQuotes() {
    
        var pos = 3
        let attributesBloc = parseAttributes("::: {class=\"ssss} ", pos: &pos, max: 18)
        
        XCTAssert(attributesBloc == nil)
    }

    func testAttributesParsingWithoutClosingDoubleQuotes2() {
        
        var pos = 0
        let attributesBloc = parseAttributes("{#test class=\"ssss} ", pos: &pos, max: 20)
        
        XCTAssert(attributesBloc == nil)
    }
    
    func testFencedAttributesBlocParsingOneClass() {
        
        var pos = 3
        let attributesBloc = parseAttributes("::: {.test1} ::::", pos: &pos, max: 17)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 4..<5)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 11..<12)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let attribute = Attribute(type: .class, nameSegment: nil, nameString: nil, indicatorRange: 5..<6, attributeValueSegment: AttributeValueSegment(valueRange: 6..<11, valueString: "test1"))
            
            XCTAssert(attribute == attributes.first!)
        }
    }
    
    func testFencedAttributesBlocParsingOneId() {
        
        var pos = 3
        let attributesBloc = parseAttributes("::: {#id} ::::", pos: &pos, max: 17)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 4..<5)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 8..<9)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let attribute = Attribute(type: .id, nameSegment: nil, nameString: nil, indicatorRange: 5..<6, attributeValueSegment: AttributeValueSegment(valueRange: 6..<8, valueString: "id"))
            
            XCTAssert(attribute == attributes.first!)
        }
    }
    
    func testFencedAttributesBlocParsingOneKeyValue() {
        
        var pos = 3
        let attributesBloc = parseAttributes("::: {name=value} ::::", pos: &pos, max: 21)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 4..<5)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 15..<16)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let attribute = Attribute(type: .keyValue, nameSegment: 5..<9, nameString: "name", indicatorRange: 9..<10, attributeValueSegment: AttributeValueSegment(valueRange: 10..<15, valueString: "value"))
            
            XCTAssert(attribute == attributes.first!)
        }
    }
    
    func testFencedAttributesBlocParsingElementNameValue() {
        
        var pos = 3
        let attributesBloc = parseAttributes("::: {name} ::::", pos: &pos, max: 21)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 4..<5)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 9..<10)
            }
            
            let attributes = attributesBloc.attributes
            
            XCTAssert(attributes.count == 1)
            let attribute = Attribute(type: .elementName, nameSegment: nil, nameString: nil, indicatorRange: nil, attributeValueSegment: AttributeValueSegment(valueRange: 5..<9, valueString: "name"))
            
            XCTAssert(attribute == attributes.first!)
        }
    }
    
    func testFencedAttributesBlocParsing() {
        
        var pos = 5
        let attributesBloc = parseAttributes("::::: {.test1 .test2 attr=test3 #idName} ::::", pos: &pos, max: 46)
        
        XCTAssert(attributesBloc != nil)
        if let attributesBloc = attributesBloc {
            
            XCTAssert(attributesBloc.type == .fencedAttributes)
            XCTAssert(attributesBloc.openingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.closingCurlyBraquetRange != nil)
            XCTAssert(attributesBloc.attributes.count == 4)
            
            if let openingCurlyBraquetRange = attributesBloc.openingCurlyBraquetRange {
                XCTAssert(openingCurlyBraquetRange == 6..<7)
            }
            
            if let closingCurlyBraquetRange = attributesBloc.closingCurlyBraquetRange {
                XCTAssert(closingCurlyBraquetRange == 39..<40)
            }
            
            let firstAttribute = Attribute(type: .class, nameSegment: nil, nameString: nil, indicatorRange: 7..<8, attributeValueSegment: AttributeValueSegment(valueRange: 8..<13, valueString: "test1"))
            
            let secondAttribute = Attribute(type: .class, nameSegment: nil, nameString: nil, indicatorRange: 14..<15, attributeValueSegment: AttributeValueSegment(valueRange: 15..<20, valueString: "test2"))
            
            let thirdAttribute = Attribute(type: .keyValue, nameSegment: 21..<25, nameString: "attr", indicatorRange: 25..<26, attributeValueSegment: AttributeValueSegment(valueRange: 26..<31, valueString: "test3"))
            
            let fourthAttribute = Attribute(type: .id, nameSegment: nil, nameString: nil, indicatorRange: 32..<33, attributeValueSegment: AttributeValueSegment(valueRange: 33..<39, valueString: "idName"))
            
            var firstAttrFound = false
            var secondAttrFound = false
            var thirdAttrFound = false
            var fourthAttrFound = false
            
            for attribute in attributesBloc.attributes {
                
                if attribute == firstAttribute {
                    firstAttrFound = true
                }
                if attribute == secondAttribute {
                    secondAttrFound = true
                }
                if attribute == thirdAttribute {
                    thirdAttrFound = true
                }
                if attribute == fourthAttribute {
                    fourthAttrFound = true
                }
            }
            XCTAssert(firstAttrFound && secondAttrFound && thirdAttrFound && fourthAttrFound)
        }
    }
    
    func testParseUnquotedAttributeValueSimple() {
        
        let pos = 0
        let attributeValueSegment = parseUnquotedAttributeValue("value", pos: pos, max: 5)
        
        XCTAssert(attributeValueSegment != nil)
        if let attributeValueSegment = attributeValueSegment {
            
            XCTAssert(attributeValueSegment.openingQuoteRange == nil)
            XCTAssert(attributeValueSegment.closingQuoteRange == nil)
            XCTAssert(attributeValueSegment.valueRange.lowerBound == 0)
            XCTAssert(attributeValueSegment.valueRange.upperBound == 5)
        }
    }
    
    func testParseUnquotedAttributeValueSimpleBefore() {
        
        let pos = 0
        let attributeValueSegment = parseUnquotedAttributeValue(":::: value", pos: pos, max: 5)
        
        XCTAssert(attributeValueSegment == nil)
    }
    
    func testParseUnquotedAttributeValueSimpleAfterColons() {
        
        let pos = 5
        let attributeValueSegment = parseUnquotedAttributeValue(":::: value ", pos: pos, max: 11)
        
        XCTAssert(attributeValueSegment != nil)
        if let attributeValueSegment = attributeValueSegment {
            
            XCTAssert(attributeValueSegment.openingQuoteRange == nil)
            XCTAssert(attributeValueSegment.closingQuoteRange == nil)
            XCTAssert(attributeValueSegment.valueRange.lowerBound == 5)
            XCTAssert(attributeValueSegment.valueRange.upperBound == 10)
        }
    }
    
    
    func testConversionToTokenAttributes() {
        
        let src = "::::: {.test1 .test2 attr=test3 #idName} ::::"
        var pos = 5
        let attributesBloc = parseAttributes(src, pos: &pos, max: 46)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 3)
        
        for (attrName, attrValue) in tokenAttributes {
            
            if attrName == "class" {
                XCTAssert(attrValue == "test1 test2" || attrValue == "test2 test1", "Received: \(attrValue)")
            }
            if attrName == "id" {
                XCTAssert(attrValue == "idName".lowercased())
            }
            if attrName == "attr" {
                XCTAssert(attrValue == "test3")
            }
        }
        
        
    }
    
    func testConversionToTokenAttributesOverrideId() {
        
        let src = "::::: {.test1 .test2 attr=test3 #idName #id2} ::::"
        var pos = 5
        let attributesBloc = parseAttributes(src, pos: &pos, max: 46)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 3)
        
        for (attrName, attrValue) in tokenAttributes {
            
            if attrName == "class" {
                XCTAssert(attrValue == "test1 test2" || attrValue == "test2 test1", "Received: \(attrValue)")
            }
            if attrName == "id" {
                XCTAssert(attrValue == "id2")
            }
            if attrName == "attr" {
                XCTAssert(attrValue == "test3")
            }
        }
    }
    
    func testConversionToTokenAttributesMutlipleAttributesKey() {
        
        let src = "::::: {.test1 .test2 attr=test3 attr=test4 #idName #id2} ::::"
        var pos = 5
        let attributesBloc = parseAttributes(src, pos: &pos, max: 56)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 3)
        
        for (attrName, attrValue) in tokenAttributes {
            
            if attrName == "class" {
                XCTAssert(attrValue == "test1 test2" || attrValue == "test2 test1", "Received: \(attrValue)")
            }
            if attrName == "id" {
                XCTAssert(attrValue == "id2")
            }
            if attrName == "attr" {
                XCTAssert(attrValue == "test3 test4" || attrValue == "test4 test3")
            }
        }
    }
    
    func testAttributesParsingEndsAtNextNonWhitespaceCharacter() {
        
        var pos = 5
        let src = "::::: {.test1 .test2 attr=test3 attr=test4 #idName #id2} ::::"
        let attributesBloc = parseAttributes(src, pos: &pos, max: 56)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 3)
        XCTAssert(pos == 56, "received: \(pos)")
        
        for (attrName, attrValue) in tokenAttributes {
            
            if attrName == "class" {
                XCTAssert(attrValue == "test1 test2" || attrValue == "test2 test1", "Received: \(attrValue)")
            }
            if attrName == "id" {
                XCTAssert(attrValue == "id2")
            }
            if attrName == "attr" {
                XCTAssert(attrValue == "test3 test4" || attrValue == "test4 test3")
            }
        }
    }
    
    func testAttributesParsingEndsAtMax() {
        
        var pos = 5
        let src = "::::: {.test1 .test2 attr=test3 attr=test4 #idName #id2}   "
        let attributesBloc = parseAttributes(src, pos: &pos, max: 56)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 3)
        XCTAssert(pos == 56, "received: \(pos)")
        
        for (attrName, attrValue) in tokenAttributes {
            
            if attrName == "class" {
                XCTAssert(attrValue == "test1 test2" || attrValue == "test2 test1", "Received: \(attrValue)")
            }
            if attrName == "id" {
                XCTAssert(attrValue == "id2")
            }
            if attrName == "attr" {
                XCTAssert(attrValue == "test3 test4" || attrValue == "test4 test3")
            }
        }
    }
    
    func testErrorParsing() {
        
        // {.abc4443334dhhjkhhdddef .bsiuiuiuissssssssasasassss .cgggggdddddgggg .diiih .efhi .fghijk att="tjkjkjkjhjhjhjest"}
        let src = "{.abc4443334dhhjkhhdddef .bsiuiuiuissssssssasasassss .cgggggdddddgggg .diiih .efhi .fghijk att=\"tjkjkjkjhjhjhjest\"}"
        
        var pos = 0
        let attributesBloc = parseAttributesBloc(src, pos: &pos, max: src.count)
        let tokenAttributes = attributesBloc!.convertToTokenAttributes(using: src)
        XCTAssert(tokenAttributes.count == 2)
        XCTAssert(pos == src.count, "received: \(pos)")
        
        let expectedClassValues = Set<String>([
            "abc4443334dhhjkhhdddef",
            "bsiuiuiuissssssssasasassss",
            "cgggggdddddgggg",
            "diiih",
            "efhi",
            "fghijk"
        ])
        
        for (attrName, attrValue) in tokenAttributes {
            if attrName == "class" {
                let classValues = attrValue.split(separator: " ")
                let classSet = Set<String>(classValues.map({ (substring) -> String in
                    return String(substring)
                }) )
                
                XCTAssert(expectedClassValues == classSet)
            }
        }
    }
    
}
