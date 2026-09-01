//
//  EphemeralPseudoClassesRendererTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

@testable import WriterCommon
import Web
import Common
import Igloo

class EphemeralPseudoClassesRendererTests: MarkdownRendererTests {
    
    
    func testRenderingContextWithEphemeralPseudoClasses() throws {
        
        var markdownString = "\n# 12\n"
        markdownString += "\n"
        markdownString += "p1"
        markdownString += "\n"
        markdownString += "## 2\n"
        markdownString += "\n"
        markdownString += "p2\n"
        markdownString += "\n"
        
        let styleString = """
            body {
                color: blue;
            }

            :flash {
                color: red;
            }

            h1::tag:flash {
                color: pink;
            }

            h1::first-letter:flash {
                color: green;
            }

        """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        let applyFlashResult = markdownContext.applyFlash(in: NSMakeRange(1, 4))
        
        XCTAssert(applyFlashResult != nil)
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = applyFlashResult?.attributes else {
            XCTAssert(false)
            return
        }

        let attr = NSTextStorage(string: markdownString)
        attr.applyAttributes(attributes)
        
        //        1: #
        WriterCommonTests.validateColor(in: attr, index: 1, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        3: 1
        WriterCommonTests.validateColor(in: attr, index: 3, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: 2
        WriterCommonTests.validateColor(in: attr, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    
    func testRenderingContextWithEphemeralPseudoClassesWithInheritedValue() throws {
        
        var markdownString = "\n# 12\n"
        markdownString += "\n"
        markdownString += "p1"
        markdownString += "\n"
        markdownString += "## 2\n"
        markdownString += "\n"
        markdownString += "p2\n"
        markdownString += "\n"
        
        let styleString = """
            body {
                color: blue;
            }

            h1:flash {
                color: red;
            }

            h1::tag:flash {
                color: pink;
            }

            h1::first-letter:flash {
                color: green;
            }

        """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        let applyFlashResult = markdownContext.applyFlash(in: NSMakeRange(1, 4))
        
        XCTAssert(applyFlashResult != nil)
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = applyFlashResult?.attributes else {
            XCTAssert(false)
            return
        }

        let attr = NSTextStorage(string: markdownString)
        attr.applyAttributes(attributes)
        
        
        //        1: #
        WriterCommonTests.validateColor(in: attr, index: 1, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        3: 1
        WriterCommonTests.validateColor(in: attr, index: 3, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: 2
        WriterCommonTests.validateColor(in: attr, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
    
    func testRenderingContextWithEphemeralPseudoClassesConflictingWithAnotherOne() throws {
        
        var markdownString = "\n# 12\n"
        markdownString += "\n"
        markdownString += "p1"
        markdownString += "\n"
        markdownString += "## 2\n"
        markdownString += "\n"
        markdownString += "p2\n"
        markdownString += "\n"
        
        let styleString = """
                body {
                    color: blue;
                }

                :flash {
                    color: red;
                }

                h1::tag {
                    color: red;
                }

                h1::tag:flash {
                    color: pink;
                }

                h1::first-letter:flash {
                    color: green;
                }

            """
        
        let indexedCharacters = markdownString.indexedCharacters
        
        let indexedCharactersString = indexedCharacters.map { (arg) -> String in
            return "\(arg.key): \(arg.value)\n"
        }
        for indexedCharacterString in indexedCharactersString {
            print("\(indexedCharacterString)")
        }
        
        let markdownContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        let applyFlashResult = markdownContext.applyFlash(in: NSMakeRange(1, 4))
        
        XCTAssert(applyFlashResult != nil)
        
        guard let attributes: [RenderingProcessingResult.AttributeAction: [AttributesRange]] = applyFlashResult?.attributes else {
            XCTAssert(false)
            return
        }

        let attr = NSTextStorage(string: markdownString)
        attr.applyAttributes(attributes)
        
        //        1: #
        WriterCommonTests.validateColor(in: attr, index: 1, color: pink) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
                
        //        3: 1
        WriterCommonTests.validateColor(in: attr, index: 3, color: green) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
        
        //        4: 2
        WriterCommonTests.validateColor(in: attr, index: 4, color: red) { (e, r, i) in
            XCTAssert(false, "Expected: \(e), received: \(r) at index: \(i)")
        }
    }
}
