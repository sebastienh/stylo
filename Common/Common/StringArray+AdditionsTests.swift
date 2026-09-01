//
//  StringArray+AdditionsTests.swift
//  Common
//
//  Created by Sebastien hamel on 2019-08-17.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import Common

class StringArray_AdditionsTests: XCTestCase {

    func testArrayEditOperations1() {
        
        var origin = ["1","2","3"]
        let other = ["1","2","3"]
        
        let operations = origin.editOperations(to: other)
        XCTAssert(operations.isEmpty)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }

    func testArrayEditOperations2() {
        
        var origin = ["1","2","3"]
        let other = ["1","4","3"]
        
        let operations = origin.editOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations3() {
        
        var origin = ["1","2","3"]
        let other = ["1","4","3", "5", "6"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    
    func testArrayEditOperations4() {
        
        var origin = ["1","2","3"]
        let other = ["1","4"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations5() {
        
        var origin = ["1","2","3"]
        let other = ["0"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations6() {
        
        var origin = ["1","2","3"]
        let other = ["0", "4", "5"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations7() {
        
        var origin = ["1","2"]
        let other = ["1", "4", "5"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations8() {
        
        var origin: [String] = []
        let other = ["1", "4", "5"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations9() {
        
        var origin = ["1", "4", "5"]
        let other: [String] = []
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations10() {
        
        var origin = ["1dasad", "4dasdas", "4dasdas", "sas"]
        let other: [String] = ["4dasdas", "4dasdas4dasdas", "3221321"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    
    func testArrayEditOperations11() {
        
        var origin = ["1dasad", "4dasdsas", "4dasdas", "sas"]
        let other = ["4dasdas", "4dasdas4dasdas", "3221321"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayEditOperations12() {
        
        var origin = ["4dasdas", "4dasdas4dasdas", "3221321"]
        let other = ["1dasad", "4dasdsas", "4dasdas", "sas"]
        
        let operations = origin.editOperations(to: other)
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayUpdateOperations() {
        
        var origin = ["12","2","3"]
        let other = ["1","2","3"]
        
        let operations = origin.editOperations(to: other)
        XCTAssert(operations.count == 1)
        XCTAssert(operations.first! == ArrayEdit<String>.replace(index: 0, value: "1"))
        origin.applyEditOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperations() {
        
        var origin = ["1","2","3"]
        let other = ["1","3","2"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperations2() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["2","3", "4", "5", "6", "1"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperations3() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["3","4","5","6","1","2"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 2)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperations4() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["5","6","1","2","3","4"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 2)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperations5() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["4","5","6","1","2","3"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 3)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves2() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["3","1","2","4","5","6"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves3() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["1","2","4","5","6","3"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    
    func testArrayMoveOperationsTowDifferentMoves4() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["1","2","3","6","4","5"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves5() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["1","3","5","2","4","6"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 2)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves6() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["1","2","4","6","3","5"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 2)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves7() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["2","3","4","5","6","1"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
    
    func testArrayMoveOperationsTowDifferentMoves9() {
        
        var origin = ["1","2","3","4","5","6"]
        let other = ["2","3","4","5","1","6"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }


    
    func testArrayMoveOperationsTowDifferentMoves8() {
        
        var origin = ["B94D984E-6A7D-4FDD-A19A-07EB530F3AA7", "A0B0F1D5-2DE9-427D-8B99-F78B1C61DB6C", "98F393C1-77D8-4FD9-A542-79EEEB58A8CF", "4AD9FFE8-4EEF-488F-AC0A-79BB2A03DC43", "F5ECFC85-344A-47FF-A11E-FEF77D2A9275", "74D90EB8-60A0-4D5E-80C5-A190E6B70D90", "8128D187-4685-4BC2-8EE8-9777603DE604"]
        
        let other = ["A0B0F1D5-2DE9-427D-8B99-F78B1C61DB6C", "98F393C1-77D8-4FD9-A542-79EEEB58A8CF", "4AD9FFE8-4EEF-488F-AC0A-79BB2A03DC43", "F5ECFC85-344A-47FF-A11E-FEF77D2A9275", "B94D984E-6A7D-4FDD-A19A-07EB530F3AA7", "74D90EB8-60A0-4D5E-80C5-A190E6B70D90", "8128D187-4685-4BC2-8EE8-9777603DE604"]
        
        let operations = origin.movesOperations(to: other)
        XCTAssert(operations.count == 1)
        origin.applyMoveOperations(operations)
        XCTAssert(origin == other)
    }
}
