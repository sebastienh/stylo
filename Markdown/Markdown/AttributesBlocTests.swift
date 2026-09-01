//
//  AttributesBlocTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Markdown

class AttributesBlocTests: XCTestCase {

    func testSameAttributes() {

        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc1
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isNone)
    }
    
    func testOneAttributeChanged() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{ .test1 .test2 .test33 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 2)
    }

    func testTwoAttributeChanged() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .tesst2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{ .test1 .tes1t2 .test33 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 4)
    }
    
    func testAttributePositionChanged1() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{ .test1 .test2  .test3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isNone)
    }
    
    func testAttributePositionChangedWithIntersection() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{     .test1 .test2 .test3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isNone)
    }
    
    func testAttributePositionChangedWithoutIntersection() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{         .test1 .test2 .test3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 6)
    }
    
    func testAttributePositionChangedWithOneIntersection() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{      .test1    .test2 .test3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 4)
    }
    
    func testAttributePositionChangedWithTwoIntersection() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{      .test1 .test2    .test3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 2, "received: \(blocsAttributesChange.modifiedCount!)")
    }
    
    func testMultipleAttributesBlocs() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{      .test1 .test2    .test3 }")
        let attributesBloc3 = attributesBloc(from: "{                                 .tes1 .tst2    .tst3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2, attributesBloc3)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isModified)
        XCTAssert(blocsAttributesChange.modifiedCount! == 5, "received: \(blocsAttributesChange.modifiedCount!)")
    }
    
    func testMultipleAttributesBlocs2() {
        
        let attributesBloc1 = attributesBloc(from: "{ .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{      .tes1 .tst2    .tst3 }")
        let attributesBloc3 = attributesBloc(from: "{ .test1 .test2    .test3 }")
        let attributesBloc4 = attributesBloc(from: "{      .tes1 .tst2    .tst3 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1, attributesBloc2)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc3, attributesBloc4)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2)
        
        XCTAssert(blocsAttributesChange.isNone)
//        let modifiedCount = blocsAttributesChange.modifiedCount
//        XCTAssert(modifiedCount != nil)
//        if let modifiedCount = modifiedCount {
//            XCTAssert(modifiedCount == 2, "received: \(blocsAttributesChange.modifiedCount!)")
//        }
    }
    
    func testOneAttributeChangedWithChangedPosition() {
        
        let attributesBloc1 = attributesBloc(from: "          { .test1 .test2 .test3 }")
        let attributesBloc2 = attributesBloc(from: "{ .test1 .test2 .test33 }")
        
        let attributesBlocsSet1 = Set<AttributesBloc>(arrayLiteral: attributesBloc1)
        let attributesBlocsSet2 = Set<AttributesBloc>(arrayLiteral: attributesBloc2)
        
        let blocsAttributesChange = attributesBlocsSet1.attributesBlocsChange(from: attributesBlocsSet2, otherPositionChange: 10)
        
        XCTAssert(blocsAttributesChange.isModified)
        
        let modifiedCount = blocsAttributesChange.modifiedCount
        XCTAssert(modifiedCount! == 2)
    }
    
    private func attributesBloc(from string: String) -> AttributesBloc {
        
        var pos = 0
        return parseAttributes(string, pos: &pos, max: string.count)!
    }
    
}
