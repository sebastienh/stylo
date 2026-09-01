////
////  AttributesBlocsChangeTests.swift
////  WriterCommonTests
////
////  Created by Sebastien hamel on 2019-05-13.
////  Copyright © 2019 Textually Inc. All rights reserved.
////
//
//import XCTest
//import Common
//import Igloo
//import Markdown
//import os
//@testable import WriterCommon
//@testable import Web
//
//class AttributesBlocsChangeTests: HistoryTestExecutorTest {
//
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    func testFollowingSiblingNotColoring122() {
//
//        // { affectedRange: {3, 0}, replacementString: ->{<-}
//        let stringChange = StringChange(affectedRange: NSMakeRange(3,0), replacementString: "{")
//
//        XCTAssert(executeTest(markdown: "following-sibling-not-coloring.md", css: "following-sibling-not-coloring.css", stringChange: stringChange), "failed history test!")
//    }
//
//    override func compare(change: SourceStringChangeDescription, fromSourceString sourceString: String, to destinationString: String) -> Bool {
//
//        let oldTokens = markdownDocumentStore?.markdownTokens.clone()
//
//        let sourceStringChangedAction = EditableStoreActionsFactory.sourceStringChangedActionSync(description: change)
//        dispatcher!.sync(store: markdownDocumentStore!, action: sourceStringChangedAction)
//
//
//        let newTokens = markdownDocumentStore!.markdownTokens
//
//        let markdownDocumentReducer = MarkdownDocumentReducer(storeIdentifier: markdownDocumentStore!.identifier)
//
//        markdownDocumentReducer.computeAttributesBlocsChange(recompiledTokenRange: tokenRange, replacingTokens: newTokens, currentTokens: oldTokens)
//
//        XCTAssert(compilationResultMarkdownTokens != nil, "compilationResultMarkdownTokens is nil")
//        if let compilationResultMarkdownTokens = compilationResultMarkdownTokens {
//
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("expectedMardownTokens: %@", log: Log.WriterCommon.all, type: .debug, %%expectedMardownTokens.toString())
//            os_log("compilationResultMarkdownTokens: %@)", log: Log.WriterCommon.all, type: .debug, %%compilationResultMarkdownTokens.toString())
//            #endif
//
//            //////////////////////////////////////////////////////////////////
//            /////////// make sure both Tokens are equals ////////////////
//            //////////////////////////////////////////////////////////////////
//            if !expectedMardownTokens.equals(to: compilationResultMarkdownTokens, comparePositions: true, compareChildren: true) {
//
//                XCTAssert(false, "different markdown tokens")
//                return false
//            }
//
//            let expectedMarkdownDomDocument = createMarkdownDom(from: expectedMardownTokens)
//
//            //////////////////////////////////////////////////////////////////
//            ///////////////////// compare the DOMs ///////////////////////////
//            //////////////////////////////////////////////////////////////////
//            let compiledMarkdownDomDocument = markdownDocumentStore!.document.value as? HtmlDocument
//
//            XCTAssert(compiledMarkdownDomDocument != nil, "compiledMarkdownDomDocument is nil")
//            if let compiledMarkdownDomDocument = compiledMarkdownDomDocument {
//
//                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("compiled document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(compiledMarkdownDomDocument))
//                os_log("expected document: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createDefault().serializeHTMLFragment(expectedMarkdownDomDocument))
//                #endif
//
//                if !expectedMarkdownDomDocument.equals(to: compiledMarkdownDomDocument, comparePositions: true) {
//
//                    XCTAssert(false, "different markdown dom document")
//                    return false
//                }
//
//                //////////////////////////////////////////////////////////////////
//                ///////////////// compare the Attributes /////////////////////////
//                //////////////////////////////////////////////////////////////////
//                let compiledAttributes = markdownDocumentStore!.attributesStore.value!.permanentAttributesString
//
//                let expectedResourceComputedStyle = computesElementsStyle(using: expectedMarkdownDomDocument, and: style!)
//
//                let expectedAttributes = applyAttributes(using: expectedMarkdownDomDocument, and: expectedResourceComputedStyle, to: destinationString)
//
//                if !areSameAttributes(expectedAttributedString: expectedAttributes, with: compiledAttributes) {
//
//                    XCTAssert(false, "different attributes")
//
//                    // find the problem source
//                    let compiledResourceComputedStyle = markdownDocumentStore!.resourceComputedStyle.value!
//
//                    ///////////////////////////////////////////////////////////////////////////////
//                    ////////////////// StyleIdentity validation ///////////////////////////////////
//                    ///////////////////////////////////////////////////////////////////////////////
//                    for (element, expectedStyleIdentity) in expectedResourceComputedStyle.elementsStyleIdentities {
//
//                        let compiledElement = compiledMarkdownDomDocument.findSamePositionAndLocalnameElement(as: element)
//
//                        if compiledElement == nil {
//                            debugPrint("compiledElement is nil")
//                        }
//
//                        XCTAssert(compiledElement != nil)
//                        if let compiledElement = compiledElement {
//
//                            let compiledStyleIdentity = compiledResourceComputedStyle.elementsStyleIdentities[compiledElement]
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
//                    }
//
//                    ///////////////////////////////////////////////////////////////////////////////
//                    ////////////////// Computed style validation //////////////////////////////////
//                    ///////////////////////////////////////////////////////////////////////////////
//
//                    for (element, styleIdentity) in expectedResourceComputedStyle.elementsStyleIdentities {
//
//                        let expectedComputedStyle = expectedResourceComputedStyle.computedStyle(forElement:element)
//
//                        let compiledElement = compiledMarkdownDomDocument.findSamePositionAndLocalnameElement(as: element)
//
//                        XCTAssert(compiledElement != nil)
//                        if let compiledElement = compiledElement {
//
//                            let compiledComputedStyle = compiledResourceComputedStyle.computedStyle(forElement:compiledElement)
//
//                            assert(compiledComputedStyle != nil)
//                            if let compiledComputedStyle = compiledComputedStyle {
//
//                                if compiledComputedStyle != expectedComputedStyle {
//                                    debugPrint("wrong computed style, expected: \(expectedComputedStyle), received: \(compiledComputedStyle)")
//                                }
//                                XCTAssert(compiledComputedStyle == expectedComputedStyle, "wrong computed style, expected: \(expectedComputedStyle), received: \(compiledComputedStyle)")
//                            }
//                            else {
//                                XCTAssert(false, "missing computed style for element: \(element.localName)")
//                            }
//                        }
//                    }
//
//                    return false
//                }
//            }
//        }
//        return true
//    }
//
//}
