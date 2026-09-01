//
//  SourceStringChangeDescription+PositionnableTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-07.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Common

fileprivate struct Element: Positionnable {
    
    var sourceStringFragment: SourceStringFragment?
    
    init(sourceStringFragment: SourceStringFragment?) {
        
        self.sourceStringFragment = sourceStringFragment
    }
}

class SourceStringChangeDescription_PositionnableTests: XCTestCase {

    let spaces = "    "
    
    let element = "1234"
    
    // "    1234    1234    1234    "
    var completeString: String {
        return spaces + element + spaces + element + spaces + element + spaces
    }
    
    fileprivate var collection: [Element] {
        return buildBasicCollection()
    }
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // public func changedString(before element: Positionnable) -> String?
    func testChangedStringDeleteBefore1() {
        
        let string = "  " + element + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(2, 2), stringReplacement: "", changeLength: -2, targetString: targetString)
        
        let changedString = description.changedString(before: collection.first!)
        
        XCTAssert(changedString == "  ")
    }
    
    func testChangedStringNoChangeBefore1() {
    
        let string = " 12 " + element + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(1, 2), stringReplacement: "12", changeLength: 0, targetString: targetString)
        
        let changedString = description.changedString(before: collection.first!)
        
        XCTAssert(changedString == " 12 ")
    }
    
    
    func testChangedStringRangeDeletionRangeAdditionBefore1() {
     
        let string = " 123 " + element + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(1, 2), stringReplacement: "123", changeLength: 1, targetString: targetString)
        
        let changedString = description.changedString(before: collection.first!)
        
        XCTAssert(changedString == " 123 ")
    }
    
    func testChangedStringAdditionBefore1() {
        
        let string = "  123  " + element + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(2, 0), stringReplacement: "123", changeLength: 3, targetString: targetString)
        
        let changedString = description.changedString(before: collection.first!)
        
        XCTAssert(changedString == "  123  ")
    }
    
    // public func changedString(inside element: Positionnable) -> String?
    func testChangedStringDeleteInside1() {
        
                            //"1234"
        let string = spaces + "12" + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 2), stringReplacement: "", changeLength: -2, targetString: targetString)
        
        let changedString = description.changedString(inside: collection.first!)
        
        XCTAssert(changedString == "12")
    }
    
    func testChangedStringNoChangeInside1() {
        
                            //"1234"
        let string = spaces + "12dd" + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 2), stringReplacement: "dd", changeLength: 0, targetString: targetString)
        
        let changedString = description.changedString(inside: collection.first!)
        
        XCTAssert(changedString == "12dd")
    }
    
    
    func testChangedStringRangeDeletionRangeAdditionInside1() {
        
                            //"1234"
        let string = spaces + "123ddd" + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(7, 3), stringReplacement: "ddd", changeLength: 2, targetString: targetString)
        
        let changedString = description.changedString(inside: collection.first!)
        
        XCTAssert(changedString == "123ddd")
    }
    
    func testChangedStringAdditionInside1() {
        
                            //"1234"
        let string = spaces + "1234dd" + spaces + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(8, 0), stringReplacement: "dd", changeLength: 2, targetString: targetString)
        
        let changedString = description.changedString(inside: collection.first!)
        
        XCTAssert(changedString == "1234dd")
    }
    
    // public func changedString(between low: Positionnable, and up: Positionnable) -> String?
    func testChangedStringDeleteSpaceBetween1() {
        
                                      //"    "
        let string = spaces + element + "  " + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(8, 0), stringReplacement: "", changeLength: -2, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[1])
        
        XCTAssert(changedString == "  ")
    }
    
    func testChangedStringNoChangeSpaceBetween1() {
        
                                      //"    "
        let string = spaces + element + " 34 " + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(10, 2), stringReplacement: "34", changeLength: 0, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[1])
        
        XCTAssert(changedString == " 34 ")
    }
    
    func testChangedStringRangeDeletionRangeAdditionSpaceBetween1() {
        
                                      //"    "
        let string = spaces + element + " 345 " + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(10, 3), stringReplacement: "345", changeLength: 1, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[1])
        
        XCTAssert(changedString == " 345 ")
    }
    
    func testChangedStringAdditionSpaceBetween1() {
        
                                      //"    "
        let string = spaces + element + "  345  " + element + spaces + element + spaces
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(10, 0), stringReplacement: "345", changeLength: 3, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[1])
        
        XCTAssert(changedString == "  345  ")
    }
    
    func testChangedStringDeleteBetweenDistantElements1() {
        
        let string = spaces + element +
            //"    1234    "
              "  "
            + element + spaces
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(10, 10), stringReplacement: "", changeLength: -10, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[2])
        
        XCTAssert(changedString == "  ")
    }
    
    func testChangedStringNoChangeBetweenDistantElements1() {
        
        let string = spaces + element +
            //"    1234    "
              "      1234  "
            + element + spaces
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(12, 6), stringReplacement: "  1234", changeLength: 0, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[2])
        
        XCTAssert(changedString == "      1234  ")
    }
    
    func testChangedStringRangeDeletionRangeAdditionBetweenDistantElements1() {
        
        let string = spaces + element +
            //"    1234    "
              " NSMutableAttributedString "
            + element + spaces
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(9, 10), stringReplacement: "  1234", changeLength: 15, targetString: targetString)
        
        let changedString = description.changedString(between: collection[0], and: collection[2])
        
        XCTAssert(changedString == " NSMutableAttributedString ")
    }
    
    // public func changedString(after element: Positionnable) -> String?
    func testChangedStringDeleteAfter1() {
        
        let string = spaces + element + spaces + element + spaces + element +
            // "    "
               "  "
        
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(24, 2), stringReplacement: "", changeLength: -2, targetString: targetString)
        
        let changedString = description.changedString(after: collection.last!)
        
        XCTAssert(changedString == "  ")
    }
    
    func testChangedStringNoChangeAfter1() {
        
        let string = spaces + element + spaces + element + spaces + element +
            // "    "
               " 22 "
        
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(25, 2), stringReplacement: "22", changeLength: 0, targetString: targetString)
        
        let changedString = description.changedString(after: collection.last!)
        
        XCTAssert(changedString == " 22 ")
    }
    
    
    func testChangedStringRangeDeletionRangeAdditionAfter1() {
        
        let string = spaces + element + spaces + element + spaces + element +
            // "    "
               " 222 "
        
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(25, 2), stringReplacement: "222", changeLength: 1, targetString: targetString)
        
        let changedString = description.changedString(after: collection.last!)
        
        XCTAssert(changedString == " 222 ")
    }
    
    func testChangedStringAdditionAfter1() {
        
        let string = spaces + element + spaces + element + spaces + element +
            // "    "
               "  222  "
        
        let targetString = NSMutableAttributedString(string: string)
        
        let description = SourceStringChangeDescription(range: NSMakeRange(26, 0), stringReplacement: "222", changeLength: 3, targetString: targetString)
        
        let changedString = description.changedString(after: collection.last!)
        
        XCTAssert(changedString == "  222  ")
    }
    
    
    
    private func buildBasicCollection() -> [Element] {
        
        let element1 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(4, 4)))
        // 4 spaces
        let element2 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(12, 4)))
        // 8 spaces
        let element3 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(20, 4)))
        return [element1, element2, element3]
    }


}
