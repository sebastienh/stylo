//
//  StylableReducerTypeTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-07-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
import Common

class StylableReducerTypeTests: XCTestCase {

    func testAddBefore() {
        
        var renderingProcessingResults = [RenderingProcessingResult]()
        
        let addedAttributes = [AttributesRange([NSAttributedString.Key.backgroundColor : NSColor.white], NSMakeRange(0, 10), "nodeName")]
        
        let renderingProcessingResult = RenderingProcessingResult(documentAttributes: nil, addedAttributes: addedAttributes, setAttributes: [], deletedAttributes: [], renderedTopElements: nil, focusType: nil)
            
        renderingProcessingResults.append(renderingProcessingResult)
        
        let stylableActionResult = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingProcessingResults)
        
        var pendingChanges = Queue<SourceStringChangeDescription>()
        
        let pendingChange1 = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange1)
        
        let pendingChange2 = SourceStringChangeDescription(range: NSMakeRange(1, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange2)
        
        let pendingChange3 = SourceStringChangeDescription(range: NSMakeRange(2, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange3)
        
        let updatedStylableActionResult = stylableActionResult.updatedAttributesRanges(with: pendingChanges)
        
        XCTAssert(updatedStylableActionResult.addedAttributesRanges?.count == 1)
        
        let attributesRange = updatedStylableActionResult.addedAttributesRanges!.first!
        XCTAssert(attributesRange.range == NSMakeRange(3, 10))
    }
    
    func testAddBefore2() {
        
        var renderingProcessingResults = [RenderingProcessingResult]()
        
        let addedAttributes = [AttributesRange([NSAttributedString.Key.backgroundColor : NSColor.white], NSMakeRange(0, 10), "nodeName")]
        
        let renderingProcessingResult = RenderingProcessingResult(documentAttributes: nil, addedAttributes: addedAttributes, setAttributes: [], deletedAttributes: [], renderedTopElements: nil, focusType: nil)
        
        renderingProcessingResults.append(renderingProcessingResult)
        
        let stylableActionResult = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingProcessingResults)
        
        var pendingChanges = Queue<SourceStringChangeDescription>()
        
        let pendingChange1 = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange1)
        
        let pendingChange2 = SourceStringChangeDescription(range: NSMakeRange(0, 1), stringReplacement: "", changeLength: -1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange2)
        
        let addedAttributesRanges = stylableActionResult.update(attributesRanges: stylableActionResult.addedAttributesRanges!, with: pendingChanges)
        
        XCTAssert(addedAttributesRanges.count == 1)
        
        let attributesRange = addedAttributesRanges.first!
        XCTAssert(attributesRange.range == NSMakeRange(0, 10))
    }
    
    
    
    
    func testAddInside() {
        
        var renderingProcessingResults = [RenderingProcessingResult]()
        
        let addedAttributes = [AttributesRange([NSAttributedString.Key.backgroundColor : NSColor.white], NSMakeRange(0, 10), "nodeName")]
        
        let renderingProcessingResult = RenderingProcessingResult(documentAttributes: nil, addedAttributes: addedAttributes, setAttributes: [], deletedAttributes: [], renderedTopElements: nil, focusType: nil)
        
        renderingProcessingResults.append(renderingProcessingResult)
        
        let stylableActionResult = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingProcessingResults)
        
        var pendingChanges = Queue<SourceStringChangeDescription>()
        
        let pendingChange = SourceStringChangeDescription(range: NSMakeRange(2, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange)
        
        let updatedStylableActionResult = stylableActionResult.updatedAttributesRanges(with: pendingChanges)
        
        XCTAssert(updatedStylableActionResult.addedAttributesRanges?.count == 2)
        
        let attributesRange1 = updatedStylableActionResult.addedAttributesRanges!.first!
        XCTAssert(attributesRange1.range == NSMakeRange(0, 2))
        
        let attributesRange2 = updatedStylableActionResult.addedAttributesRanges!.last!
        XCTAssert(attributesRange2.range == NSMakeRange(3, 8))
    }
    
    func testReplaceAll() {
        
        var renderingProcessingResults = [RenderingProcessingResult]()
        
        let addedAttributes = [AttributesRange([NSAttributedString.Key.backgroundColor : NSColor.white], NSMakeRange(0, 10), "nodeName")]
        
        let renderingProcessingResult = RenderingProcessingResult(documentAttributes: nil, addedAttributes: addedAttributes, setAttributes: [], deletedAttributes: [], renderedTopElements: nil, focusType: nil)
        
        renderingProcessingResults.append(renderingProcessingResult)
        
        let stylableActionResult = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingProcessingResults)
        
        var pendingChanges = Queue<SourceStringChangeDescription>()
        
        let pendingChange = SourceStringChangeDescription(range: NSMakeRange(0, 10), stringReplacement: "1234567890", changeLength: 0, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange)
        
        let updatedStylableActionResult = stylableActionResult.updatedAttributesRanges(with: pendingChanges)
        
        XCTAssert(updatedStylableActionResult.addedAttributesRanges?.count == 0)
    }
    
    
    
    func testAddAfter() {
        
        var renderingProcessingResults = [RenderingProcessingResult]()
        
        let addedAttributes = [AttributesRange([NSAttributedString.Key.backgroundColor : NSColor.white], NSMakeRange(0, 10), "nodeName")]
        
        let renderingProcessingResult = RenderingProcessingResult(documentAttributes: nil, addedAttributes: addedAttributes, setAttributes: [], deletedAttributes: [], renderedTopElements: nil, focusType: nil)
        
        renderingProcessingResults.append(renderingProcessingResult)
        
        let stylableActionResult = StylableActionResult.renderedAttributesRanges(renderingProcessingResult: renderingProcessingResults)
        
        var pendingChanges = Queue<SourceStringChangeDescription>()
        
        let pendingChange = SourceStringChangeDescription(range: NSMakeRange(10, 0), stringReplacement: "t", changeLength: 1, targetString: NSMutableAttributedString())
        pendingChanges.enqueue(pendingChange)
        
        let updatedStylableActionResult = stylableActionResult.updatedAttributesRanges(with: pendingChanges)
        
        XCTAssert(updatedStylableActionResult.addedAttributesRanges?.count == 1)
        
        let attributesRange1 = updatedStylableActionResult.addedAttributesRanges!.first!
        XCTAssert(attributesRange1.range == NSMakeRange(0, 10))
        
    }
}
