//
//  CodeMarkdownTokensTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-09-20.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest

class StyloUserGuide1MarkdownTokensTests: MarkdownTokensTests {

    private var singleSpaceAfterContentHeaderStringChanges: [StringChange] {
        
        var changes = [StringChange]()
        
        changes.append(StringChange(affectedRange: NSMakeRange(32, 0), replacementString: " "))
        
        return changes
    }
    
    private var multipleSpacesAfterContentHeaderStringChanges: [StringChange] {
        
        var changes = [StringChange]()
        
        changes.append(StringChange(affectedRange: NSMakeRange(32, 0), replacementString: " "))
        changes.append(StringChange(affectedRange: NSMakeRange(33, 0), replacementString: " "))
        changes.append(StringChange(affectedRange: NSMakeRange(34, 0), replacementString: " "))
        changes.append(StringChange(affectedRange: NSMakeRange(35, 0), replacementString: " "))
        
        return changes
    }
    
    private var allStringChange: [StringChange] {
        
        var stringChanges = [StringChange]()
        stringChanges.append(contentsOf: multipleSpacesAfterContentHeaderStringChanges)
        stringChanges.append(contentsOf: singleSpaceAfterContentHeaderStringChanges)
        return stringChanges
    }
    
    override func setUp() {
        
        filename = "stylo-user-guide-fr-1.md"
        super.setUp()
    }

    func testSourceStringChangedPureAdditionBefore() {
        
        executeTests(stringChanges: singleSpaceAfterContentHeaderStringChanges)
    }
    
    func testSourceStringChangedPureAdditionsBefore() {
        
        executeTests(stringChanges: multipleSpacesAfterContentHeaderStringChanges)
    }
    
    func testAll() {
        
        executeTests(stringChanges: allStringChange)
    }
    
    func testChangeAtIndex48() {
        
        let change = StringChange(affectedRange: NSMakeRange(48, 0), replacementString: " ")
        executeTests(stringChanges: [change])
    }
    
    func testChangeAtIndex49() {
        
        let change = StringChange(affectedRange: NSMakeRange(49, 0), replacementString: " ")
        executeTests(stringChanges: [change])
    }
    
    func testChangeAtIndex50() {
        
        let change = StringChange(affectedRange: NSMakeRange(50, 0), replacementString: " ")
        executeTests(stringChanges: [change])
    }
    
//    func testAddSingleSpaceEverywhere() {
//        
//        for i in 0...sourceString!.count {
//            
//            debugPrint("Testing at index: \(i)")
//            
//            setUp()
//            let change = StringChange(affectedRange: NSMakeRange(i, 0), replacementString: " ")
//            let result = executeTests(stringChanges: [change])
//            
//            if !result {
//                
//                debugPrint("Failed at index: \(i)")
//            }
//        }
//    }
    
    
}
