//
//  TestTstDictionary.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-02-10.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest
import Common

extension String: CompletionValueType {
    
    public var shortDescription: String {
        return self
    }
    
    public var desc: String {
        
        return self
    }
    
    public var language: Language {
        
        return Language.All
    }
}

class TestTstDictionary: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testContainsFalse() {

        let dict = TstDictionary<String>()
        
        try! dict.add("test", value: "testvalue")
        try! dict.add("test2", value: "testvalue2")
        try! dict.add("test3", value: "testvalue3")
        
        dict.keys
        dict.values
        
        
        XCTAssert(dict.contains("test"))
        XCTAssert(!dict.contains("test5"), "Dict should not contain test5")
        
    }

    func testPartialMatch() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("test", value: "testvalue")
        try! dict.add("test2", value: "testvalue2")
        try! dict.add("test3", value: "testvalue3")
        
        let result = try! dict.partialMatch("te...")
        
        XCTAssert(result.count == 2, "Expected 2 received: \(result.count)")
    }
    
    func testPrefixMatch() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("test", value: "testvalue")
        try! dict.add("test2", value: "testvalue2")
        try! dict.add("test3", value: "testvalue3")
        try! dict.add("tst3", value: "testvalue4")
        
        
        let result = try! dict.prefixMatch("te")
        
        XCTAssert(result.count == 3, "Expected 3 received: \(result.count)")
        
        for entry in result {
            
            debugPrint("entry: \(entry.key)")
        }
    }
    
    
    func testPrefixMatch1() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("dtest", value: "testvalue")
        try! dict.add("test2", value: "testvalue2")
        try! dict.add("test3", value: "testvalue3")
        try! dict.add("tst3", value: "testvalue4")
        try! dict.add("tdist4di", value: "testvalue4")
        try! dict.add("tst5", value: "testvalue4")
        try! dict.add("di", value: "testvalue4")
        try! dict.add("dist", value: "testvalue4")
        
        let result = try! dict.prefixMatch("di")
        
        XCTAssert(result.count == 2, "Expected 2 received: \(result.count)")
        
        for entry in result {
            
            debugPrint("entry: \(entry.key)")
        }
    }
    
    func testPrefixMatch2() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("dtest", value: "testvalue")
        try! dict.add("test2", value: "testvalue2")
        try! dict.add("test3", value: "testvalue3")
        try! dict.add("tst3", value: "testvalue4")
        try! dict.add("tdist4di", value: "testvalue4")
        try! dict.add("tst5", value: "testvalue4")
        try! dict.add("di", value: "testvalue4")
        try! dict.add("dist", value: "testvalue4")
        
        let result = try! dict.prefixMatch("t")
        
        XCTAssert(result.count == 5, "Expected 5 received: \(result.count)")
        
        for entry in result {
            
            debugPrint("entry: \(entry.key)")
        }
    }
    
    func testPrefixMatch3() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("code", value: "testvalue")
        try! dict.add("coda", value: "testvalue2")
        try! dict.add("coma", value: "testvalue3")
        try! dict.add("soda", value: "testvalue4")
        try! dict.add("tdist4di", value: "testvalue4")
        try! dict.add("tst5", value: "testvalue4")
        try! dict.add("yoda", value: "testvalue4")
        try! dict.add("sfga", value: "testvalue4")
        
        let result = try! dict.prefixMatch("co")
        
        XCTAssert(result.count == 3, "Expected 3 received: \(result.count)")
        
        for entry in result {
            
            debugPrint("entry: \(entry.key)")
        }
        
        /// For instance, a search for all words within
        /// distance two of soda finds code, coma and 117 other
        /// words.
    }
    
    func testNearNeighborSearch() {
        
        let dict = TstDictionary<String>()
        
        try! dict.add("coma", value: "testvalue3")
        try! dict.add("code", value: "testvalue")
        try! dict.add("coda", value: "testvalue2")
        try! dict.add("soda", value: "testvalue4")
        try! dict.add("sodu", value: "testvalue4")
        try! dict.add("roda", value: "testvalue4")
        try! dict.add("tdist4di", value: "testvalue4")
        try! dict.add("tst5", value: "testvalue4")
        try! dict.add("yoda", value: "testvalue4")
        try! dict.add("sfga", value: "testvalue4")
        try! dict.add("mmda", value: "testvalue4")
        try! dict.add("mssmda", value: "testvalue4")
        try! dict.add("msasasamda", value: "testvalue4")
        try! dict.add("mssssasasamda", value: "testvalue4")
        try! dict.add("sssmsasasamda", value: "testvalue4")
        try! dict.add("sasasmsasasamda", value: "testvalue4")
        try! dict.add("dgfgmsasasamda", value: "testvalue4")
        
        let result = try! dict.nearNeighborMatch("soda", distance: 2)
        
        XCTAssert(result.count == 9, "Expected 9 received: \(result.count)")
        
        for entry in result {
            
            debugPrint("entry: \(entry.key)")
        }
        
        /// For instance, a search for all words within
        /// distance two of soda finds code, coma and 117 other
        /// words.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
