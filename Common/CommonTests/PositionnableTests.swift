//
//  PositionnableTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-04.
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

class PositionnableTests: XCTestCase {

    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnableBefore() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 2, endIntegerIndex: 4))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:         ----------
        
        // substract:
        // change:   ______----------------------------
        // element:  ------
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 2, endIntegerIndex: 4)), "Received: \(positionnable.sourceStringFragment!)")
    }
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnableSame() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 6, endIntegerIndex: 34))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:         ----------
        
        // substract:
        // change:   ______----------------------------
        // element:  ------
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment == nil)
    }
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnableAfter() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 34, endIntegerIndex: 40))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:         ----------
        
        // substract:
        // change:   ______----------------------------
        // element:  ------
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 6, endIntegerIndex: 12)), "Received: \(positionnable.sourceStringFragment!)")
    }
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnableInside() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 7, endIntegerIndex: 17))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:         ----------
        
        // substract:
        // change:   ______----------------------------
        // element:  ------
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment == nil)
    }
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnableContains() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 5, endIntegerIndex: 35))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------
        // element:       ------------------------------
        // result:        --
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 5, endIntegerIndex: 7)), "Received: \(positionnable.sourceStringFragment!)")
    }
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnablePartiallyBefore() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 0, endIntegerIndex: 10))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:  ----------                               to 012345-
        
        // substract:
        // change:   ______----------------------------
        // element:  ------
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 0, endIntegerIndex: 6)))
    }
    
    
    //    description Common.SourceStringChangeDescription
    //    range   NSRange location=6, length=28
    //    stringReplacement   String.UTF16View.SubSequence
    //    changeLength    Int -28
    func testPositionnablePartiallyAfter() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 12, endIntegerIndex: 35))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(6, 28), stringReplacement: "", changeLength: -28, targetString: NSMutableAttributedString(string: "sourceString"))
        
        // change:   012345----------------------------       to 012345
        // element:  012345678901-----------------------      to 012345-
        
        // substract:
        // change:   ______----------------------------
        // element:  __________________________________-
        
        
        // move:
        // change:   ______----------------------------
        // element:  ______-
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 6, endIntegerIndex: 7)))
    }
    
    
    //    description    Common.SourceStringChangeDescription
    //    range    NSRange    location=70, length=78
    //    stringReplacement    String.UTF16View.SubSequence
    //    changeLength    Int    -78
    //    sourceString    NSMutableAttributedString    0x0000608002a29c80
    //
    //    Before: range to validate {70, 147} in element named: Web.CSSDOMElement with classes:
    //    [2018-07-05 09:35:38 +0000] DEBUG in computeCssSurvivingDeletedNodes(store:topDeletedNodes:description:): After: range to validate {18446744073709551608, 147} in element named: Web.CSSDOMElement with classes:
    //    [2018-07-05 09:35:38 +0000] DEBUG in isValidRange: range.location: -8
    func testError1() {
        
        // Before: range to validate {12, 23} in element named: Web.CSSDOMElement with classes:  error warning
        var positionnable = Element(sourceStringFragment: SourceStringSegment(startIntegerIndex: 70, endIntegerIndex: 217))
        
        let description = SourceStringChangeDescription(range: NSMakeRange(70, 78), stringReplacement: "", changeLength: -78, targetString: NSMutableAttributedString(string: "sourceString"))
        
        positionnable.applyStringChange(with: description)
        
        debugPrint("positionnable sourceStringSegment: \(String(describing: positionnable.sourceStringFragment))")
        
        XCTAssert(positionnable.sourceStringFragment!.equals(to: SourceStringSegment(startIntegerIndex: 70, endIntegerIndex: 139)))
        
    }
}
