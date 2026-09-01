//
//  CompileStylesheetDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-06-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
import Igloo
import os
@testable import WriterCommon

class SourceStringChangedStylesheetDocumentStoreTests: StylesheetDocumentStoreTests {
    
    //    case pureAddition
    func testSourceStringChangedPureAdditionStart() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {106, 0}, changeLength: 10, stringReplacement: Optional(" important").
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(106, 0), replacementString: " important")
    }
    
    //    case pureAddition
    func testSourceStringChangedPureAdditionStart2() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {106, 0}, changeLength: 10, stringReplacement: Optional(" important").
        
        let replacement = """
        + test, h1 {

        }

        """

        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(0, 0), replacementString: replacement)
    }
    
    //    case pureAddition
    func testSourceStringChangedPureAdditionStart3() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {106, 0}, changeLength: 10, stringReplacement: Optional(" important").
        
        let replacement = """
        h2 + test, h1 {

        }

        """
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(0, 0), replacementString: replacement)
    }
    
    func testSourceStringChangedUnterminatedRulePureAdditionBetween() {
        
        // changeType: pureAddition, range: {9, 0}, changeLength: 1, stringReplacement: Optional("}").
        executeTest(sourceFilename: "test-4.css", affectedRange: NSMakeRange(9, 0), replacementString: "}")
    }
    
    func testSourceStringChangedUnterminatedRulePureAdditionInside() {
        
        // Will apply change: changeType: pureAddition, range: {2, 0}, changeLength: 1, stringReplacement: Optional("d").
        executeTest(sourceFilename: "test-5.css", affectedRange: NSMakeRange(2, 0), replacementString: "d")
    }
    
    func testSourceStringChangedPureAdditionExclusivelyInside1() {
        
        // textStorage(_:willProcessEditing:range:changeInLength:): sourceStringChangeDescription: changeType: pureAddition, range: {241, 0}, changeLength: 1, stringReplacement: Optional("1").
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(241, 0), replacementString: "1")
    }
    
    func testSourceStringChangedPureAdditionExclusivelyInside2() {
        
        // Will apply change: changeType: pureAddition, range: {2, 0}, changeLength: 1, stringReplacement: Optional("d").
        executeTest(sourceFilename: "test3.css", affectedRange: NSMakeRange(2, 0), replacementString: "d")
    }
    
    func testSourceStringChangedPureAdditionBetween() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {298, 0}, changeLength: 1, stringReplacement: Optional("\n").
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(298, 0), replacementString: "\n")
    }
    
   
    func testSourceStringChangedPureAdditionBetween2() {
        
         // sourceStringChangeDescription: changeType: pureAddition, range: {45, 0}, changeLength: 1, stringReplacement: Optional("\n").
        executeTest(sourceFilename: "test-7.css", affectedRange: NSMakeRange(45, 0), replacementString: "\n")
    }
    
    func testSourceStringChangedPureAdditionEnd() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {582, 0}, changeLength: 1, stringReplacement: Optional("h").
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(582, 0), replacementString: "h")
    }
    
    func testSourceStringChangedPureAdditionEnd2() {
        
        // changeType: pureAddition, range: {584, 0}, changeLength: 1, stringReplacement: Optional("{").
        executeTest(sourceFilename: "test.css", affectedRange: NSMakeRange(584, 0), replacementString: "{")
    }
    
    func testSourceStringChangedPureAdditionEnd3() {
        
        // changeType: pureAddition, range: {584, 0}, changeLength: 1, stringReplacement: Optional("{").
        executeTest(sourceFilename: "test2.css", affectedRange: NSMakeRange(584, 0), replacementString: "\n")
    }
    
    func testSourceStringChangedPureAdditionEnd4() {
        
        // sourceStringChangeDescription: changeType: pureAddition, range: {582, 0}, changeLength: 1, stringReplacement: Optional("h").
        executeTest(sourceFilename: "new-rule-open-bracket.css", affectedRange: NSMakeRange(5, 0), replacementString: "{")
    }
    
    //    case pureRemoval
    func testSourceStringChangedPureRemovalStart() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(34, 72), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalExclusivelyInside1() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(201, 71), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalExclusivelyInside2() {
        
        // sourceStringChangeDescription: changeType: pureRemoval, range: {44, 1}, changeLength: -1, stringReplacement: Optional("").
        executeTest(sourceFilename: "test-8.css", affectedRange: NSMakeRange(51, 1), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalBetween() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(297, 1), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalEnd() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(580, 2), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringOneStart() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(0, 154), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringOneMiddle() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(298, 142), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringOneEnd() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(441, 141), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringMutlipleStart() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(111, 186), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringMutlipleMiddle() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(155, 284), replacementString: "")
    }
    
    func testSourceStringChangedPureRemovalCoveringMultipleEnd() {
        
        executeTest(sourceFilename: "simple.css", affectedRange: NSMakeRange(299, 283), replacementString: "")
    }
    
    func testChange1() {
        
        executeTest(sourceFilename: "full-v1.css", affectedRange: NSMakeRange(1216, 4), replacementString: " red")
    }
    
    func testMultipleChanges1() {
        
        let changes = [
            
            // sourceStringChangeDescription: changeType: pureRemoval, range: {20, 1}, changeLength: -1, stringReplacement: Optional("").
            StringChange(affectedRange: NSMakeRange(23, 1), replacementString: ""),
            
            // sourceStringChangeDescription: changeType: pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional("}").
            StringChange(affectedRange: NSMakeRange(23, 0), replacementString: "}")
        ]
        
        executeTest(sourceFilename: "test-6.css", stringChanges: changes)
        
    }
    
    
    //    case pureReplace
    //    case replaceAddition
    
    
    
    //    case replaceRemoval
    //    case unchanged
    
    
    
    func testRandomSourceStringChanged() {
        
        //
        
        
    }
    
    
    private func executeTest(sourceFilename: String, affectedRange: NSRange, replacementString: String) {

        let stringChange = StringChange(affectedRange: affectedRange, replacementString: replacementString)
        
        executeTest(sourceFilename: sourceFilename, stringChanges: [stringChange])
    }
    
    private func executeTest(sourceFilename: String, stringChanges: [StringChange]) {
        
        let url = urlOfFile(named: sourceFilename)
        var stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        for stringChange in stringChanges {
            
            let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
            
            let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: stringChange.affectedRange, replacementString: stringChange.replacementString)
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            compare(change: change, fromSourceString: stylesheetString, to: destination)
            
            stylesheetString = destination
        }
    }
    
    private func replacementAndDestinationSubtring(fromSourceFile sourceFilename: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        let url = urlOfFile(named: sourceFilename)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: range, replacementString: replacementString)
    }
    
    private func replacementAndDestinationSubtring(fromSourceString stylesheetString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        var _stylesheetString = stylesheetString
        
        let startRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.upperBound)
        _stylesheetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
        return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _stylesheetString)
    }
    
    private func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String) {
        
        let dispatcher = createDispatcher()
        let stylesheetDocumentStore = createStylesheetDocumentStore(origin: .userAgent)
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = createBasicStyle()
        
        compileStylesheet(fromSourceString: sourceString, in: stylesheetDocumentStore, dispatcher: dispatcher, with: style)
        
        let sourceStringChangedAction = EditableStoreActionsFactory.sourceStringChangedActionSync(description: change)
        dispatcher.sync(store: stylesheetDocumentStore, action: sourceStringChangedAction)
        
        let expectedStylesheet = compileExpectedStylesheet(source: destinationString)
        let compilationResultStylesheet = stylesheetDocumentStore.stylesheet.value
        
        XCTAssert(compilationResultStylesheet != nil, "compilationResultStylesheet is nil")
        if let compilationResultStylesheet = compilationResultStylesheet {
            
            //////////////////////////////////////////////////////////////////
            /////////// make sure both stylesheets are equals ////////////////
            //////////////////////////////////////////////////////////////////
            XCTAssert(expectedStylesheet.equals(to: compilationResultStylesheet, comparePositions: true),"Didn't receive expectedStylesheet stylesheet.")
            
            let expectedStylesheetDomDocument = createCssDom(from: expectedStylesheet)
            
            //////////////////////////////////////////////////////////////////
            ///////////////////// compare the DOMs ///////////////////////////
            //////////////////////////////////////////////////////////////////
            let compiledStylesheetDomDocument = stylesheetDocumentStore.document.value
            
            XCTAssert(compiledStylesheetDomDocument != nil, "compiledStylesheetDomDocument is nil")
            if let compiledStylesheetDomDocument = compiledStylesheetDomDocument {
                
                let documentEquals = expectedStylesheetDomDocument.equals(to: compiledStylesheetDomDocument, comparePositions: true)
                
                if !documentEquals {
                    
                    let serializer = HTMLSerializer.createDefault()
                    
                    let expected = serializer.serializeHTMLFragment(expectedStylesheetDomDocument)
                    let compiled = serializer.serializeHTMLFragment(compiledStylesheetDomDocument)
                    
                    print("expected: \(expected)")
                    
                    print("compiled: \(compiled)")
                }
                
                
                XCTAssert(documentEquals, "Didn't receive expectedStylesheetDomDocument.")
                
                //////////////////////////////////////////////////////////////////
                ///////////////////// compare the Styles /////////////////////////
                //////////////////////////////////////////////////////////////////
                
                let resourcComputedStyle = ResourceComputedStyle(styleDefinition: style)
                
                let stylesheetStyleStore = StylesheetStyleStore(string: stylesheetDocumentStore.sourceString.value!, focusMode: .disabled, resourceComputedStyle: resourcComputedStyle)
                
                dispatcher.sync(store: stylesheetStyleStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: compiledStylesheetDomDocument, isFirstResponder: true, selectedRange: NSMakeRange(0, 0)).syncAction)
                
//                let compiledResourceComputedStyle = stylesheetStyleStore.resourceComputedStyle
                
                let expectedResourceComputedStyle = computesElementsStyle(using: compiledStylesheetDomDocument, and: style)
                
//                XCTAssert(expectedResourceComputedStyle.equals(compiledResourceComputedStyle), "Didn't receive expectedResourceComputedStyle.")
                
                //////////////////////////////////////////////////////////////////
                ///////////////// compare the Attributes /////////////////////////
                //////////////////////////////////////////////////////////////////
                let compiledAttributes = stylesheetStyleStore.attributesStore.attributedString
                
                let expectedAttributes = applyAttributes(using: compiledStylesheetDomDocument, and: expectedResourceComputedStyle, to: destinationString, stringChange: change)
                
                XCTAssert(compiledAttributes.length == expectedAttributes.length)
                
//                if !expectedAttributes.isEqual(to: compiledAttributes) {
                
//                    os_log("Expected string attributes...", log: Log.WriterCommon.all, type: .debug)
//                    os_log("attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range)
//                    os_log("Received string attributes...", log: Log.WriterCommon.all, type: .debug)
////                    compiledAttributes.enumerateAttributes(in: NSMakeRange(0, compiledAttributes.length), options: NSAttributedString.EnumerationOptions.longestEffectiveRangeNotRequired) { (attributes, range, stop) in
////                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range)
////                    }
////
////                    let differentAttributes = expectedAttributes.differentAttributesRanges(from: compiledAttributes, in: [NSMakeRange(0, expectedAttributes.length)])
////
////                    for (attributes, range) in differentAttributes {
////
////                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("different attributes: %@ in range: %@", log: Log.WriterCommon.all, type: .debug, %%attributes, %%range)
////                    }
//                    
//                    XCTAssert(false)
//                }
            }
        }
    }
    
    private func compileExpectedStylesheet(source string: String) -> CSSStyleSheet {
        
        return loadStylesheet(stylesheetString: string, origin: .userAgent)
    }
    
    private func createCssDom(from stylesheet: CSSStyleSheet) -> CSSDOMDocument {
        
        let cssDomRenderer = CSSDOMRenderer(document: CSSDOMDocument.Create())
        return cssDomRenderer.renderStylesheet(stylesheet)!
    }
    
    private func computesElementsStyle(using document: Document, and style: CSSStyle) -> ResourceComputedStyle {
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        resourceComputedStyle.computeElementsStyles(document: document, filterContext: FilterContext())
        return resourceComputedStyle
    }
    
    private func applyAttributes(using document: Document, and resourceComputedStyle: ResourceComputedStyle, to string: String, stringChange: SourceStringChangeDescription?) -> NSAttributedString {
        
        let stylableString = AttributedStringChangeRecorder(string: string)
        
        let renderingContext = RenderingContext(contentString: stylableString, renderingType: .edit, filterContext: FilterContext())
        let domRenderer = CssRenderer(resourceComputedStyle: resourceComputedStyle, renderingContext: renderingContext, document: document as! CSSDOMDocument)
        domRenderer.process(document)
        
        return stylableString.attributedString
    }
    
    private func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationFileName: String) -> SourceStringChangeDescription? {
        
        let url = urlOfFile(named: destionationFileName)
        
        XCTAssert(url != nil)
        if let url = url {
            return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetStringUrl: url)
        }
        return nil
    }
    
    private func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationString: String) -> SourceStringChangeDescription? {
        
        return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: destionationString)
    }
    
    private func compileStylesheet(from url: URL, in store: StylesheetDocumentStore, dispatcher: StylesheetDocumentDispatcher, with style: CSSStyle) {
        
        let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
        let result = dispatcher.sync(store: store, action: loadAction)
        
        XCTAssert(result is EditableActionResult)
        
        if let editableActionResult = result as? EditableActionResult {
            
            let loadedString = editableActionResult.loadedString
            XCTAssert(loadedString != nil)
            XCTAssert(loadedString! == contentOfFile(at: url))
            
            compileStylesheet(fromSourceString: loadedString!, in: store, dispatcher: dispatcher, with: style)
        }
    }
    
    private func compileStylesheet(fromSourceString loadedString: String, in store: StylesheetDocumentStore, dispatcher: StylesheetDocumentDispatcher, with style: CSSStyle) {
     
        // compile first stylesheet
        let createStylesheetAction = StylesheetDocumentAction.createInitialStylesheet(source: loadedString).syncAction
        let result = dispatcher.sync(store: store, action: createStylesheetAction)
        
        XCTAssert(result != nil)
        if let result = result {
            
            XCTAssert(result is StylesheetDocumentResult)
            if let stylesheetDocumentResult = result as? StylesheetDocumentResult {
                
                let stylesheet = stylesheetDocumentResult.stylesheet
                XCTAssert(stylesheet != nil)
            }
        }
    }
    
}

