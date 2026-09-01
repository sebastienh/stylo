//
//  OccurencesNavigatorTests.swift
//  Common
//
//  Created by Sebastien Hamel on 2020-05-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Common

struct TestTextElementOccurence: TextElementOccurence {
    var range: NSRange
    
    let textId: String
    
    let value: Int
    
    init(textId: String, value: Int) {
        self.textId = textId
        self.value = value
        self.range = NSMakeRange(0, 0)
    }
}

class OccurencesNavigatorTests: XCTestCase {

    var testOccurences: [TestTextElementOccurence]?
    
    override func setUpWithError() throws {
        
        self.testOccurences = [
            TestTextElementOccurence(textId: "1", value: 34),
            TestTextElementOccurence(textId: "1", value: 104),
            TestTextElementOccurence(textId: "1", value: 234),
            TestTextElementOccurence(textId: "2", value: 14),
            TestTextElementOccurence(textId: "3", value: 54),
            TestTextElementOccurence(textId: "4", value: 84),
            TestTextElementOccurence(textId: "4", value: 134),
            TestTextElementOccurence(textId: "4", value: 400),
            TestTextElementOccurence(textId: "4", value: 534),
            TestTextElementOccurence(textId: "4", value: 1334),
            TestTextElementOccurence(textId: "4", value: 2234),
            TestTextElementOccurence(textId: "5", value: 4),
            TestTextElementOccurence(textId: "5", value: 234),
            TestTextElementOccurence(textId: "6", value: 234),
            TestTextElementOccurence(textId: "6", value: 334),
            TestTextElementOccurence(textId: "6", value: 734)
        ]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNext1() throws {
         
        guard let testOccurences = self.testOccurences else {
            XCTAssert(false)
            return
        }
        
        var occurencesNavigator = OccurencesNavigator<TestTextElementOccurence>(occurences: testOccurences, orderedTextIds: ["1","2","3","4","5","6"])
        
        let next = occurencesNavigator.next()
        
        XCTAssert(next != nil)
        XCTAssert(next!.textId == "1")
        XCTAssert(next!.value == 34)
    }

    func testNext2() throws {
         
        guard let testOccurences = self.testOccurences else {
            XCTAssert(false)
            return
        }
        
        var occurencesNavigator = OccurencesNavigator<TestTextElementOccurence>(occurences: testOccurences, orderedTextIds: ["1","2","3","4","5","6"])
        
        let next = occurencesNavigator.next()
        
        XCTAssert(next != nil)
        XCTAssert(next!.textId == "1")
        XCTAssert(next!.value == 34)
        
        let next2 = occurencesNavigator.next()
        
        XCTAssert(next2 != nil)
        XCTAssert(next2!.textId == "1")
        XCTAssert(next2!.value == 104)
        
        let next3 = occurencesNavigator.next()
        
        XCTAssert(next3 != nil)
        XCTAssert(next3!.textId == "1")
        XCTAssert(next3!.value == 234)
        
        let next4 = occurencesNavigator.next()
        
        XCTAssert(next4 != nil)
        XCTAssert(next4!.textId == "2")
        XCTAssert(next4!.value == 14)
        
        let next5 = occurencesNavigator.next()
        
        XCTAssert(next5 != nil)
        XCTAssert(next5!.textId == "3")
        XCTAssert(next5!.value == 54)

        // TestTextElementOccurence(textId: "4", value: 84),
        let next6 = occurencesNavigator.next()
        
        XCTAssert(next6 != nil)
        XCTAssert(next6!.textId == "4")
        XCTAssert(next6!.value == 84)
        
        // TestTextElementOccurence(textId: "4", value: 134),
        let next7 = occurencesNavigator.next()
        
        XCTAssert(next7 != nil)
        XCTAssert(next7!.textId == "4")
        XCTAssert(next7!.value == 134)
        
        
        // TestTextElementOccurence(textId: "4", value: 400),
        let next8 = occurencesNavigator.next()
        
        XCTAssert(next8 != nil)
        XCTAssert(next8!.textId == "4")
        XCTAssert(next8!.value == 400)
        
        // TestTextElementOccurence(textId: "4", value: 534),
        let next9 = occurencesNavigator.next()
        
        XCTAssert(next9 != nil)
        XCTAssert(next9!.textId == "4")
        XCTAssert(next9!.value == 534)
        
        // TestTextElementOccurence(textId: "4", value: 1334),
        let next10 = occurencesNavigator.next()
        
        XCTAssert(next10 != nil)
        XCTAssert(next10!.textId == "4")
        XCTAssert(next10!.value == 1334)
        
        // TestTextElementOccurence(textId: "4", value: 2234),
        let next11 = occurencesNavigator.next()
        
        XCTAssert(next11 != nil)
        XCTAssert(next11!.textId == "4")
        XCTAssert(next11!.value == 2234)
        
        // TestTextElementOccurence(textId: "5", value: 4),
        let next12 = occurencesNavigator.next()
        
        XCTAssert(next12 != nil)
        XCTAssert(next12!.textId == "5")
        XCTAssert(next12!.value == 4)
        
        // TestTextElementOccurence(textId: "5", value: 234),
        let next13 = occurencesNavigator.next()
        
        XCTAssert(next13 != nil)
        XCTAssert(next13!.textId == "5")
        XCTAssert(next13!.value == 234)
        
        // TestTextElementOccurence(textId: "6", value: 234),
        let next14 = occurencesNavigator.next()
        
        XCTAssert(next14 != nil)
        XCTAssert(next14!.textId == "6")
        XCTAssert(next14!.value == 234)
        
        // TestTextElementOccurence(textId: "6", value: 334),
        let next15 = occurencesNavigator.next()
        
        XCTAssert(next15 != nil)
        XCTAssert(next15!.textId == "6")
        XCTAssert(next15!.value == 334)
        
        // TestTextElementOccurence(textId: "6", value: 734)
        let next16 = occurencesNavigator.next()
        
        XCTAssert(next16 != nil)
        XCTAssert(next16!.textId == "6")
        XCTAssert(next16!.value == 734)

        // TestTextElementOccurence(textId: "1", value: 34),
        let next17 = occurencesNavigator.next()
        
        XCTAssert(next17 != nil)
        XCTAssert(next17!.textId == "1")
        XCTAssert(next17!.value == 34)
        
    }
    
    
}
