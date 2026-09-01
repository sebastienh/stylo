//
//  HistoryTest.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-05-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Igloo
import Markdown
import os
@testable import WriterCommon
@testable import Web

extension HtmlDocument {
    
    func findSamePositionAndLocalnameElement(as element: Element) -> Element? {
        
        if let pseudoElement = element as? PseudoElement {
            
            let childNode = pseudoElement.firstChild
            
            if let childNode = childNode {
            
                // in this case we use the text element because the pseudo element
                // doesn't have it's source fragment set.
                let descendants = self.body.descendants()
                
                for selfNode in descendants.nodes {
                    if selfNode.nodeType == childNode.nodeType {
                        
                        if let selfSourceStringFragment = childNode.sourceStringFragment, let sourceStringFragment = childNode.sourceStringFragment {
                            
                            if selfSourceStringFragment.equals(to: sourceStringFragment) {
                                return selfNode.parentElement
                            }
                        }
                    }
                }
            }
            return nil
            
        }
        else {
            return findEquivalentElement(as: element)
        }
    }
    
    private func findEquivalentElement(as element: Element) -> Element? {

        if let _ = element as? HTMLHeadElement {
            return self.head
        }
        
        if let _ = element as? HTMLBodyElement {
            return self.body
        }
        
        let elements = self.body.descendantElements.elements
        for selfElement in elements {
            if selfElement.localName == element.localName {
                
                if let selfSourceStringFragment = selfElement.sourceStringFragment, let sourceStringFragment = element.sourceStringFragment {
                    
                    
                    
                    if selfSourceStringFragment.equals(to: sourceStringFragment) {
                        return selfElement
                    }
                }
            }
        }
        return nil
    }
    
    
}


class HistoryTest: MarkdownDocumentStoreTests {

    var dispatcher: MarkdownDocumentDispatcher?
    
    var markdownDocumentStore: MarkdownDocumentStore?
    
    var style: CSSStyle?
    
    override func setUp() {
        
        super.setUp()
    }
    
    override func tearDown() {
        
        self.dispatcher = nil
        self.markdownDocumentStore = nil
        self.style = nil
        super.tearDown()
    }
    
    func createStyle(authorStylesheetFilename: String) -> CSSStyle {
        
        let authorStylesheet = loadStylesheet(named: authorStylesheetFilename, origin: .author)
        let style = CSSStyle(id: "markdown-source-style", authorStyleSheets: [authorStylesheet])
        return style
    }
    
    func replacementAndDestinationSubtring(fromSourceFile sourceFilename: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        let url = urlOfFile(named: sourceFilename)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return replacementAndDestinationSubtring(fromSourceString: stylesheetString, range: range, replacementString: replacementString)
    }
    
    func replacementAndDestinationSubtring(fromSourceString stylesheetString: String, range: NSRange, replacementString: String) -> (replacement: String.UTF16View.SubSequence, destination: String) {
        
        var _stylesheetString = stylesheetString
        
        let startRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = _stylesheetString.utf16.index(_stylesheetString.utf16.startIndex, offsetBy: range.upperBound)
        _stylesheetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
        return (replacementString.utf16[replacementString.utf16.startIndex..<replacementString.utf16.endIndex], _stylesheetString)
    }
    
    func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String, markdownStyleStore: inout MarkdownStyleStore) -> Bool {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("sourceString:\n\"%@\"\n", log: Log.WriterCommon.all, type: .debug, %%sourceString)
        os_log("destinationString:\n\"%@\"\n", log: Log.WriterCommon.all, type: .debug, %%destinationString)
        #endif
        
        let sourceStringChangedAction = EditableStoreAction.sourceStringChanged(description: change).syncAction
        let result = dispatcher!.sync(store: markdownDocumentStore!, action: sourceStringChangedAction)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("result: %@", log: Log.WriterCommon.all, type: .info, %%markdownDocumentStore?.sourceString.value)
        #endif
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            
            let errorString = "Invalid action result expecting DocumentStoreActionResult received: \(String(describing: result))."
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("%@", log: Log.WriterCommon.all, type: .error, %%errorString)
            #endif
            return false
        }
        
        let attributedStringBefore = markdownStyleStore.attributesStore.attributedString
        let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument!
//        debugPrint("attributedStringBefore: \(attributedStringBefore)")
        
        if documentStoreActionResult.containsCompleteUpdate {
        
            let styleAssemblyStore = MarkdownStyleStore(string: destinationString, focusMode: .disabled, resourceComputedStyle: markdownStyleStore.resourceComputedStyle)
            
            // apply the style
            dispatcher!.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true, selectedRange: nil).syncAction)
            markdownStyleStore = styleAssemblyStore
        }
        else {
            
            let applyStringChangeAction = StylableStoreAction.applySourceStringChange(change: change, documentResults: documentStoreActionResult.updateDocumentResults!, visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true).syncAction
            dispatcher?.sync(store: markdownStyleStore, action: applyStringChangeAction)
        }
        let attributedStringAfter = markdownStyleStore.attributesStore.attributedString
//        debugPrint("attributedStringAfter: \(attributedStringAfter)")
        
        let expectedMardownTokens = compileExpectedMarkdownTokens(source: destinationString)
        let compilationResultMarkdownTokens = markdownDocumentStore!.markdownTokens
        
        XCTAssert(compilationResultMarkdownTokens != nil, "compilationResultMarkdownTokens is nil")
        if let compilationResultMarkdownTokens = compilationResultMarkdownTokens {
            
            //////////////////////////////////////////////////////////////////
            /////////// make sure both Tokens are equals ////////////////
            //////////////////////////////////////////////////////////////////
            if !expectedMardownTokens.equals(to: compilationResultMarkdownTokens, comparePositions: true, compareChildren: true) {
                
                 #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("expectedMardownTokens: %@", log: Log.WriterCommon.all, type: .debug, %%expectedMardownTokens.toString())
                os_log("compilationResultMarkdownTokens: %@)", log: Log.WriterCommon.all, type: .debug, %%compilationResultMarkdownTokens.toString())
                 #endif
                
                XCTAssert(false, "different markdown tokens")
                return false
            }
            
            let expectedMarkdownDomDocument = createMarkdownDom(from: expectedMardownTokens)
            
            //////////////////////////////////////////////////////////////////
            ///////////////////// compare the DOMs ///////////////////////////
            //////////////////////////////////////////////////////////////////
            let compiledMarkdownDomDocument = markdownDocumentStore!.document.value as? HtmlDocument
            
            XCTAssert(compiledMarkdownDomDocument != nil, "compiledMarkdownDomDocument is nil")
            if let compiledMarkdownDomDocument = compiledMarkdownDomDocument {
                
                if !expectedMarkdownDomDocument.equals(to: compiledMarkdownDomDocument, comparePositions: true) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("compiled document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(compiledMarkdownDomDocument))
                    os_log("expected document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(expectedMarkdownDomDocument))
                    #endif
                    
                    XCTAssert(false, "different markdown dom document")
                    return false
                }
                
                
                
//                dispatcher?.sync(store: markdownStyleStore, action: StylableStoreAction.computeAttributes(phase: .maintenance, stringChange: change).syncAction)
                
                //////////////////////////////////////////////////////////////////
                ///////////////// compare the Attributes /////////////////////////
                //////////////////////////////////////////////////////////////////
                let compiledAttributes = markdownStyleStore.attributesStore.attributedString
                
                let (expectedResourceComputedStyle, styledElements) = computesElementsStyle(using: expectedMarkdownDomDocument, and: style!)
                
                XCTAssert(destinationString == compiledAttributes.string)
                
                let expectedAttributes = applyAttributes(using: expectedMarkdownDomDocument, and: expectedResourceComputedStyle, to: destinationString, stringChange: nil, styledElements: styledElements)
                
                if !areSameAttributes(expectedAttributedString: expectedAttributes, with: compiledAttributes) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("expectedAttributes:\n\"%@\"\n", log: Log.WriterCommon.all, type: .debug, %%expectedAttributes)
                    os_log("compiledAttributes:\n\"%@\"\n", log: Log.WriterCommon.all, type: .debug, %%compiledAttributes)
                    #endif
                    
                    XCTAssert(false, "different attributes")
                    
                    // find the problem source
                    let compiledResourceComputedStyle = markdownStyleStore.resourceComputedStyle
                    
                    ///////////////////////////////////////////////////////////////////////////////
                    ////////////////// StyleIdentity validation ///////////////////////////////////
                    ///////////////////////////////////////////////////////////////////////////////
                    for element in styledElements {
                        
                        let compiledElement = compiledMarkdownDomDocument.findSamePositionAndLocalnameElement(as: element)
                        
                        if compiledElement == nil {
                            
                            os_log("compiled document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(compiledMarkdownDomDocument))
                            
                            debugPrint("compiledElement is nil")
                            
                            // see why...
                            let _ = compiledMarkdownDomDocument.findSamePositionAndLocalnameElement(as: element)
                        }
                        
//                        XCTAssert(compiledElement != nil)
//                        if let compiledElement = compiledElement {
//
//                            let compiledStyleIdentity = compiledResourceComputedStyle.styleIdentities[compiledElement]
//
//                            assert(compiledStyleIdentity != nil)
//                            if let compiledStyleIdentity = compiledStyleIdentity {
//
//                                if compiledStyleIdentity != expectedStyleIdentity {
//                                    debugPrint("wrong style identity, expected: \(expectedStyleIdentity), received: \(compiledStyleIdentity)")
//                                }
//                                XCTAssert(compiledStyleIdentity == expectedStyleIdentity, "wrong style identity, expected: \(expectedStyleIdentity), received: \(compiledStyleIdentity)")
//                            }
//                            else {
//                                XCTAssert(false, "missing style identity for element: \(element.localName)")
//                            }
//                        }
//                        else {
//                            XCTAssert(false, "No corresponding element for: \(element)")
//                        }
                    }
                    
                    ///////////////////////////////////////////////////////////////////////////////
                    ////////////////// Computed style validation //////////////////////////////////
                    ///////////////////////////////////////////////////////////////////////////////
                    
                    for element in styledElements {
                        
                        let expectedComputedStyle: ComputedStyleDeclaration? = {
                            if let pseudoElement = element as? PseudoElement {
                                return expectedResourceComputedStyle.computedStyle(forPseudoElement: pseudoElement, withElement: pseudoElement.associatedElement)
                            }
                            return expectedResourceComputedStyle.computedStyle(forElement:element)
                        }()
                            
                        let compiledElement = compiledMarkdownDomDocument.findSamePositionAndLocalnameElement(as: element)
                        
                        XCTAssert(compiledElement != nil)
                        if let compiledElement = compiledElement {
                            
                            let compiledComputedStyle = compiledResourceComputedStyle.computedStyle(forElement:compiledElement)
                            
                            assert(compiledComputedStyle != nil)
                            if let compiledComputedStyle = compiledComputedStyle {
                                
                                if !compiledComputedStyle.equals(to: expectedComputedStyle) {
                                    debugPrint("wrong computed style, expected: \(expectedComputedStyle), received: \(compiledComputedStyle)")
                                }
                                XCTAssert(compiledComputedStyle.equals(to: expectedComputedStyle), "wrong computed style, expected: \(expectedComputedStyle), received: \(compiledComputedStyle)")
                            }
                            else {
                                XCTAssert(false, "missing computed style for element: \(element.localName)")
                            }
                        }
                        else {
                            XCTAssert(false, "No corresponding element for: \(element.localName)")
                        }
                    }
                    
                    return false
                }
            }
        }
        return true
    }
    
    func compileExpectedMarkdownTokens(source string: String) -> Tokens {
        
        return loadMarkdownTokens(markdownString: string)
    }
    
    func createMarkdownDom(from markdownTokens: Tokens) -> HtmlDocument {
        
        // Create the HtmlDocument that will be th head of all created elements
        let markdownDomRenderer = MarkdownDomRenderer(parentContainer: HtmlDocument.Create()!)
        return markdownDomRenderer.render(markdownTokens)
    }
    
    func computesElementsStyle(using document: Document, and style: CSSStyle) -> (ResourceComputedStyle, ContiguousArray<Element>) {
        
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: style)
        let styledElements = resourceComputedStyle.computeElementsStyles(document: document, filterContext: FilterContext())
        return (resourceComputedStyle, styledElements)
    }
    
    
    func applyAttributes(using document: Document, and resourceComputedStyle: ResourceComputedStyle, to string: String, stringChange: SourceStringChangeDescription?, styledElements: ContiguousArray<Element>) -> NSAttributedString {
  
        let dispatcher = createDispatcher()
        
        let markdownStore = MarkdownDocumentStore(identifier: UUID().uuidString, name: "test-store", parentId: "")
        
        let description = SourceStringChangeDescription(string: string, originalString: nil)
        dispatcher.sync(store: markdownStore, action: EditableStoreAction.setString(string: string).syncAction)
        let result = dispatcher.sync(store: markdownStore, action: DocumentStoreAction.compileInitialDocument(description: description).syncAction)
        
        guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
            XCTAssert(false, "result is not DocumentStoreActionResult")
            fatalError()
        }
        
        guard let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument else {
            XCTAssert(false, "lastCompiledDocument is nil")
            fatalError()
        }
        
        let resourcComputedStyle = ResourceComputedStyle(styleDefinition: self.style!)
        let styleAssemblyStore = MarkdownStyleStore(string: string, focusMode: .disabled, resourceComputedStyle: resourcComputedStyle)
        
        // apply the style
        dispatcher.sync(store: styleAssemblyStore, action: StylableStoreAction.computeInitialAttributes(visibleTopElements: nil, document: lastCompiledDocument, isFirstResponder: true, selectedRange: NSMakeRange(0, 0)).syncAction)
        
        return styleAssemblyStore.attributesStore.attributedString
    }
    
    func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationFileName: String) -> SourceStringChangeDescription? {
        
        let url = urlOfFile(named: destionationFileName)
        
        XCTAssert(url != nil)
        if let url = url {
            return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetStringUrl: url)
        }
        return nil
    }
    
    func sourceStringChangeDescription(from range: NSRange, stringReplacement: String.UTF16View.SubSequence, changeLength: Int, destionationString: String) -> SourceStringChangeDescription? {
        
        return SourceStringChangeDescription(range: range, stringReplacement: stringReplacement, changeLength: changeLength, targetString: destionationString)
    }
    
//    func compileMarkdown(from url: URL, in store: MarkdownDocumentStore, dispatcher: MarkdownDocumentDispatcher, with style: CSSStyle) -> MarkdownStyleStore? {
//        
//        let loadAction = EditableStoreActionsFactory.loadStringAction(url: url)
//        let result = dispatcher.sync(store: store, action: loadAction)
//        
//        XCTAssert(result is StylableActionResult)
//        
//        if let editableActionResult = result as? EditableActionResult {
//            
//            let loadedString = editableActionResult.loadedString
//            XCTAssert(loadedString != nil)
//            XCTAssert(loadedString! == contentOfFile(at: url))
//            
//            return compileMarkdown(fromSourceString: loadedString!, in: store, dispatcher: dispatcher, with: style)
//        }
//        return nil
//    }
    
    func areSameAttributes(expectedAttributedString: NSAttributedString, with compiledAttributedString: NSAttributedString) -> Bool {
        
        XCTAssert(compiledAttributedString.length == expectedAttributedString.length)
        
        if !expectedAttributedString.isEqual(to: compiledAttributedString) {
            
            for i in 0..<compiledAttributedString.length {
                
                let char = compiledAttributedString.string.charAt(i)!
                
                guard !UnicodeWhitespace.isUnicodeWhitespace(char) else {
                    continue
                }
                
                let compiledAttributes = compiledAttributedString.attributes(at: i, effectiveRange: nil)
                let expectedAttributes = expectedAttributedString.attributes(at: i, effectiveRange: nil)
                
                let differentAttributes = self.differentAttributes(expectedAttributes: expectedAttributes, compiledAttributes: compiledAttributes)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let rawExpected = expectedAttributedString.string.charAt(i)!
                let rawCompiled = compiledAttributedString.string.charAt(i)!
                
                let expectedString = String(utf16CodeUnits: [rawExpected], count: 1)
                let compiledString = String(utf16CodeUnits: [rawCompiled], count: 1)
                
                debugPrint("expectedString: \(expectedString)")
                debugPrint("compiledString: \(compiledString)")
                #endif
                
                let numberOfCharactersBeforeAndAfter = 50
                
                if !differentAttributes.isEmpty { //&& rawExpected != 0x20 && rawCompiled != 0x20 {
                    
//                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    let rangeStart = i > numberOfCharactersBeforeAndAfter ? i-numberOfCharactersBeforeAndAfter : 0
                    let rangeStop = i < compiledAttributedString.length-numberOfCharactersBeforeAndAfter ? i+numberOfCharactersBeforeAndAfter : compiledAttributedString.length
                    let range = NSMakeRange(rangeStart, rangeStop - rangeStart)
                    
                    os_log("string affected in index: \"%@\"", log: Log.WriterCommon.all, type: .debug, %%i)
                    os_log("string affected in expected: \"%@\"", log: Log.WriterCommon.all, type: .debug, %%expectedAttributedString.attributedSubstring(from: range).string)
                    os_log("string affected in compiled: \"%@\"", log: Log.WriterCommon.all, type: .debug, %%compiledAttributedString.attributedSubstring(from: range).string)
                    
                    for (key, compiled, expected) in differentAttributes {
                        
                        debugPrint("different attribute: \(key) at index: \(i)")
                        debugPrint("expected attributes: \(expected)")
                        debugPrint("compiled attributes: \(compiled)")
                    }
//                    #endif
                    
                    XCTAssert(false, "different attributes at index: \(i)")
                    return false
                }
            }
        }
        return true
    }
    
    private func differentAttributes(expectedAttributes: [NSAttributedString.Key: Any], compiledAttributes: [NSAttributedString.Key: Any]) -> [(attribute: NSAttributedString.Key, compiledValue: Any?, expectedValue: Any?)] {
        
        var differentAttributes = [(attribute: NSAttributedString.Key, compiledValue: Any?, expectedValue: Any?)]()
        
        var expectedWithoutParagraphAttr = expectedAttributes
        expectedWithoutParagraphAttr.removeValue(forKey: NSAttributedString.Key.paragraphStyle)
        
        for (key, expectedValue) in expectedWithoutParagraphAttr {
            
            if let compiledValue = compiledAttributes[key] {
                
                switch key {
                    
                case NSAttributedString.Key.underlineColor: fallthrough
                case NSAttributedString.Key(rawValue: §StyloAttribute.overlineColor): fallthrough
                case NSAttributedString.Key(rawValue: §StyloAttribute.strikethroughColor):
                    
                    // these attributes may not have been set
                    
                    let compiledValue = compiledValue as? PlateformColorType
                    let expectedValue = expectedValue as? PlateformColorType
                    
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                    else if compiledValue != nil && expectedValue == nil {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                        
                    else if expectedValue != nil && compiledValue == nil {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                    
                case StyloAttribute.headingTagBefore.key: fallthrough
                case StyloAttribute.headingTagAfter.key:
                    
                    let compiledValue = compiledValue as? NSNumber
                    let expectedValue = expectedValue as? NSNumber
                    
                    // these values should always be defined
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                
                case StyloAttribute.caretColor.key: fallthrough
                case NSAttributedString.Key.foregroundColor: fallthrough
                case NSAttributedString.Key.backgroundColor:
                    
                    let compiledValue = compiledValue as? PlateformColorType
                    let expectedValue = expectedValue as? PlateformColorType
                    
                    // these values should always be defined
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                    
                case NSAttributedString.Key.underlineStyle: fallthrough
                case NSAttributedString.Key.strikethroughStyle: fallthrough
                case NSAttributedString.Key(rawValue: §StyloAttribute.overlineStyle):
                    
                    let compiledValue = compiledValue as? Int
                    let expectedValue = expectedValue as? Int
                    
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                    
                case NSAttributedString.Key.font:
                    
                    let compiledValue = compiledValue as? PlateformFontType
                    let expectedValue = expectedValue as? PlateformFontType
                    
                    assert(compiledValue != nil)
                    assert(expectedValue != nil)
                    if let compiledValue = compiledValue, let expectedValue = expectedValue, compiledValue != expectedValue {
                        
                        differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                    }
                    
                case NSAttributedString.Key.paragraphStyle:
                    // we don't care about paragraph style
                    break
                    
                default:
                    assert(false)
                    differentAttributes.append((key, compiledValue: compiledValue, expectedValue: expectedValue))
                }
            }
            else {
                
                // no value for the key
                differentAttributes.append((key, compiledValue: nil, expectedValue: expectedValue))
            }
        }
        return differentAttributes
    }
    
}
