//
//  OrderedDictionary+EditTests.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-07-06.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Common

class OrderedDictionary_EditsTests: XCTestCase {

    func testArrayEditOperations1() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3"])
        
        let operations = origin.editOperations(to: other)
        XCTAssert(operations.isEmpty)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

    func testArrayEditOperations2() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","4": "test4","3": "test3"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations3() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","4": "test4","3": "test3", "5": "test5", "6": "test6"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    
    func testArrayEditOperations4() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","4": "test4"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations5() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["0": "test"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations6() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["0": "test", "4": "test4", "5": "test5"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations7() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1", "4": "test4", "5": "test5"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations8() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: [:])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1", "4": "test4", "5": "test5"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations9() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1", "4": "test4", "5": "test5"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: [:])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    
    func testArrayEditOperations10() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3", "4": "test4", "5": "test5", "6": "test6"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","4": "test4", "2": "test2", "3": "test3", "5": "test5", "6": "test6"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

    func testArrayEditOperations11() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test1","2": "test2","3": "test3", "4": "test4", "5": "test5", "6": "test6"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["4": "test4", "2": "test2", "3": "test3", "5": "test5", "6": "test6"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

    func testArrayEditOperations12() {
        
        var origin = OrderedDictionary<String, String>(uniqueKeysWithValues: ["1": "test","2": "test2","3": "test3", "4": "test4", "5": "test5", "6": "test6"])
        let other = OrderedDictionary<String, String>(uniqueKeysWithValues: ["4": "test4", "2": "test2", "3": "test3", "6": "test6", "5": "test5"])
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

}
