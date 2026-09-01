//
//  ApplicableRulesTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-08-25.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon
@testable import Web
import Common
import Igloo


class ApplicableRulesTests: MarkdownRendererTests {
    
    
    
    func testPseudoClassDescendantsApplicableRulesWhenApplicable() {
        
        let markdownTestContext = self.createInitialContext(markdownFilename: "highlight-md-test-strong-inside-highlight.md", stylesheetsName: [
            "highlight-common.css",
            "highlight-colors-selectors.css",
            "highlight-source-dark.css"
        ])
        
        let resourceComputedStyle = markdownTestContext.markdownStyleStore.resourceComputedStyle
        
        let styledDocument = markdownTestContext.markdownDocumentStore.document.value!
        
        let strongElement = styledDocument.getElementsByTagName("strong").elements.first!
        
        XCTAssert(strongElement.localName == "strong")
        
        let expectedStyleRulesCount = 3
        
        let selectorList = CSSSelectorsModule.shared.parse(".hesiod" as NSString)
        
        var filterContext = FilterContext(highlightSelectors: selectorList)
        
        let pElement = styledDocument.getElementsByTagName("p").elements.first!
        
        filterContext.updatePseudoClassesOptions(forElement: pElement, with: .highlight)
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: strongElement), filterContext: filterContext)
        
        let styleApplicable = applicableStyleRules[strongElement]!
        
        XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        
    }
    
    func testHighlightedDescendantApplicableRules() {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.test}\n" +
                "p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
              body {
                  color: black;
              }

              p:fade {
                  color: purple;
              }

              strong {
                  color: green;
              }

              strong::tag {
                  color: blue;
              }

              attr-bloc::tag {
                  color: orange;
              }

              body:highlight {
                  color: red;
              }

              body :highlight p,
              body p:highlight {
                  color: orange;
              }

              body :highlight strong::tag {
                  color: yellow;
              }

              body :highlight strong {
                  color: pink;
              }

              body :highlight attr-bloc::tag {
                  color: blue;
              }

           """
        
        let markdownTestContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let resourceComputedStyle = markdownTestContext.markdownStyleStore.resourceComputedStyle
        
        let styledDocument = markdownTestContext.markdownDocumentStore.document.value!
        
        let selectorList = CSSSelectorsModule.shared.parse(".test" as NSString)
        
        var filterContext = FilterContext(highlightSelectors: selectorList)
        
        let pElement = styledDocument.getElementsByTagName("p").elements.first!
        
        filterContext.updatePseudoClassesOptions(forElement: pElement, with: .highlight)
        
        let strongElement = styledDocument.getElementsByTagName("strong").elements.first!
        
        XCTAssert(strongElement.localName == "strong")
        
        let expectedStyleRulesCount = 2
        
        
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: strongElement), filterContext: filterContext)
        
        let styleApplicable = applicableStyleRules[strongElement]!
        
        XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        
    }
    
    
    func testHighlightedApplicableRules() {
        
        let markdownString: String = {
            
            var value: String = "\n" +
                "\n" +
                "{.test}\n" +
                "p **n**. 1 2 3. 1 2 3. " +
            "\n"
            
            for _ in 0..<100 {
                value += "\n\n"
                value += "p"
            }
            return value
        }()
        
        let styleString = """
              body {
                  color: black;
              }

              p:fade {
                  color: purple;
              }

              strong {
                  color: green;
              }

              strong::tag {
                  color: blue;
              }

              attr-bloc::tag {
                  color: orange;
              }

              body:highlight {
                  color: red;
              }

              body :highlight p,
              body p:highlight {
                  color: orange;
              }

              body :highlight strong::tag {
                  color: yellow;
              }

              body :highlight strong {
                  color: pink;
              }

              body :highlight attr-bloc::tag {
                  color: blue;
              }

           """
        
        let markdownTestContext = self.createInitialContext(markdownString: markdownString, styleString: styleString)
        
        let resourceComputedStyle = markdownTestContext.markdownStyleStore.resourceComputedStyle
        
        let styledDocument = markdownTestContext.markdownDocumentStore.document.value!
        
        let pElement = styledDocument.getElementsByTagName("p").elements.first!
        
        XCTAssert(pElement.localName == "p")
        
        let expectedStyleRulesCount = 1
        
        let selectorList = CSSSelectorsModule.shared.parse(".test" as NSString)
        
        var filterContext = FilterContext(highlightSelectors: selectorList)
        filterContext.updatePseudoClassesOptions(forElement: pElement, with: .highlight)
        
        
        let applicableStyleRules = resourceComputedStyle.computeElementsAplicableRules(for: ContiguousArray<Element>(arrayLiteral: pElement), filterContext: filterContext)
        
        let styleApplicable = applicableStyleRules[pElement]!
        
        XCTAssert(styleApplicable.rules.count == expectedStyleRulesCount, "expected: \(expectedStyleRulesCount), received: \(applicableStyleRules.count)")
        
    }
    
    
    
}
