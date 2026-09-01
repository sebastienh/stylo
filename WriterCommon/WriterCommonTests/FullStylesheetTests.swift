//
//  FullStylesheetTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-01-09.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
@testable import WriterCommon

class FullStylesheetTests: StylesheetDocumentStoreTests {
    
    private var nextChangeType: SourceStringChangeDescription.ChangeType? {
        
        let changeType = Int.random(in: 0..<6)
        switch changeType {
        case 0:
            return .pureAddition
        case 1:
            return .pureRemoval
        case 2:
            return .pureReplace
        case 3:
            return .replaceAddition
        case 4:
            return .replaceRemoval
        case 5:
            return .unchanged
        default:
            return nil
        }
    }
    
    private func nextStringChange(from sourceString: String) -> StringChange? {
        
        if let changeType = nextChangeType {
            
            switch changeType {
                
            case .pureAddition:
                
                let changeLenght = Int.random(in: 1..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, 0), replacementString: replacementString)
                
            case .pureRemoval:
                
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: 1..<10)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: "")
                
            case .pureReplace:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, changeLenght), replacementString: replacementString)
                
            case .replaceAddition:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: 1..<changeLenght)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: replacementString)
                
            case .replaceRemoval:
                
                let changeLenght = Int.random(in: 2..<10)
                let replacemenntStringSourceIndex = Int.random(in: 0..<sourceString.count - changeLenght)
                let replacementString = sourceString.substring(replacemenntStringSourceIndex, length: changeLenght)!
                let insertionIndex = Int.random(in: 0..<sourceString.count-1)
                let insertionLenght = Int.random(in: changeLenght..<changeLenght+10)
                return StringChange(affectedRange: NSMakeRange(insertionIndex, insertionLenght), replacementString: replacementString)
                
            case .unchanged:
                
                return nil
            }
        }
        return nil
    }
    
    // { affectedRange: {1216, 4}, replacementString: -> red<-}"
    func testChange1() {

        let stringChange = StringChange(affectedRange: NSMakeRange(1216, 4), replacementString: " red")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
    // "failure: { affectedRange: {441, 3}, replacementString: ->color: r<-}"
    func testChange2() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(441, 3), replacementString: "color: r")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
    // "failure: { affectedRange: {508, 3}, replacementString: ->t-d<-}"
    func testChange3() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(508, 3), replacementString: "t-d")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
    // "failure: { affectedRange: {49, 7}, replacementString: ->:tag, i<-}"
    func testChange4() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(49, 7), replacementString: ":tag, i<")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
    // "failure: { affectedRange: {1402, 4}, replacementString: ->b(25<-}"
    func testChange5() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(1402, 4), replacementString: "b(25<<")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
    // { affectedRange: {713, 8}, replacementString: ->b(255,0,0<-}"
    func testChange6() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(713, 8), replacementString: "b(255,0,0")
        XCTAssert(executeTest(sourceFilename: "full-v1.css", stringChange: stringChange), "failed")
    }
    
//    func testRandomSourceStringChanged() {
//        
//        
//        let filename = "full-v1.css"
//        var failedChanges = [StringChange]()
//        var passed: Int = 0
//        
//        let url = urlOfFile(named: filename)
//        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
//        
//        
//        for _ in 0..<2000 {
//            
//            autoreleasepool {
//                
//                if let stringChange = nextStringChange(from: sourceString) {
//                    
//                    debugPrint("\(passed) -> testing: \(stringChange)")
//                    
//                    if !executeTest(sourceFilename: filename, stringChange: stringChange) {
//                        
//                        debugPrint("failure: \(stringChange)")
//                        failedChanges.append(stringChange)
//                    }
//                    else {
//                        
//                        passed += 1
//                    }
//                }
//            }
//        }
//        
//        debugPrint("number of passed: \(passed)")
//        
//        debugPrint("Failed changes: ")
//        for failedChange in failedChanges {
//            
//            debugPrint("failed change: \(failedChange)")
//        }
//        XCTAssert(failedChanges.isEmpty, "Failed changed: \(failedChanges)")
//    }
    
    
    
    func executeTest(sourceFilename: String, stringChange: StringChange) -> Bool {
        
        let url = urlOfFile(named: sourceFilename)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        stylesheetString.printCharactersIndexes()
        
        let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
        
        if let (replacement, destination) = replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: stringChange.affectedRange, replacementString: stringChange.replacementString) {
            
            let change = SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacement, changeLength: changeLength, targetString: destination)
            
            return compare(change: change, fromSourceString: stylesheetString, to: destination)
        }
        return true
    }
    
    private func replacementAndDestinationSubtring(fromSourceFile sourceFilename: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String)? {
        
        let url = urlOfFile(named: sourceFilename)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: range, replacementString: replacementString)
    }
    
    private func replacementAndDestinationSubtring(fromSourceString stylesheetString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String)? {
        
        var _stylesheetString = stylesheetString
        
        let startRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.upperBound)
        if _stylesheetString.startIndex <= startRangeIndex && endRangeIndex <= _stylesheetString.endIndex {
            _stylesheetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
            return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _stylesheetString)
        }
        return nil
    }
    
    private func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String) -> Bool  {
        
        let dispatcher = StylesheetDocumentDispatcher(state: StylesheetDocumentState())
        
        let stylesheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: [.dark, .light])
        dispatcher.register(store: stylesheetDocumentStore)
        
        let style = createBasicStyle()
        
        compileStylesheet(fromSourceString: sourceString, in: stylesheetDocumentStore, dispatcher: dispatcher, with: style)
        
        let sourceStringChangedAction = EditableStoreAction.sourceStringChanged(description: change).syncAction
        dispatcher.sync(store: stylesheetDocumentStore, action: sourceStringChangedAction)
        
        let expectedStylesheet = compileExpectedStylesheet(source: destinationString)
        let compilationResultStylesheet = stylesheetDocumentStore.stylesheet.value
        
        XCTAssert(compilationResultStylesheet != nil, "compilationResultStylesheet is nil")
        if let compilationResultStylesheet = compilationResultStylesheet {
            
            //////////////////////////////////////////////////////////////////
            /////////// make sure both stylesheets are equals ////////////////
            //////////////////////////////////////////////////////////////////
            
            if expectedStylesheet.equals(to: compilationResultStylesheet, comparePositions: true) {
                
                let expectedStylesheetDomDocument = createCssDom(from: expectedStylesheet)
                
                //////////////////////////////////////////////////////////////////
                ///////////////////// compare the DOMs ///////////////////////////
                //////////////////////////////////////////////////////////////////
                let compiledStylesheetDomDocument = stylesheetDocumentStore.document.value
                
                XCTAssert(compiledStylesheetDomDocument != nil, "compiledStylesheetDomDocument is nil")
                if let compiledStylesheetDomDocument = compiledStylesheetDomDocument {
                    
                    let documentEquals = expectedStylesheetDomDocument.equals(to: compiledStylesheetDomDocument, comparePositions: true)
                    
                    if !documentEquals {
                        
                        let serializer = HTMLSerializer.createDefault(rangesEnabled: true)
                        
                        let expected = serializer.serializeHTMLFragment(expectedStylesheetDomDocument)
                        let compiled = serializer.serializeHTMLFragment(compiledStylesheetDomDocument)
                        
                        print("expected: \(expected)")
                        
                        print("compiled: \(compiled)")
                        
                        return false
                    }
                    return true
                }
            }
            else {
                
                XCTAssert(false,"Didn't receive expectedStylesheet stylesheet.")
                return false
            }
        }
        return false
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

