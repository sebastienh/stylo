//
//  SelectorSelectionTests.swift
//  WebTests
//
//  Created by Sebastien Hamel on 2020-07-17.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Web

class SelectorSelectionTests: CssTests {
    
    func testPseudoElement() {
        
        let sourceString = """
             h1::tag {
                 color: blue;
             }
         """
        
        let document = buildBasicHtmlDocument()
        
        let matchList = CSSSelectorsModule.shared.createInitialSelectorMatchList([document.rootDocumentElement])
        
        let stylesheet = CSSOMModule.shared.parseStyleSheet(sourceString as NSString, origin: .author)!
        
        let selectorList: SelectorList = stylesheet.firstStyleRule!.selectorList!
        
        let intialSelectorSelection: [SelectorSelection] = matchList.map { (element) -> SelectorSelection in
            return SelectorSelection(elementToEvaluate: element)
        }
        
        let filterContext = FilterContext()
        
        // create the SelectorEvaluatorChain
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)
        
        let evaluableSelector = selectorList.selectorArray.first!
        
        // construct the SelectorEvaluatorChain
        evaluableSelector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        
        // get the evaluated selector selections
        // Regarding pseudo-elements, in here we have all the pseudo-elements
        // for all available selections, meaning that each element which
        // resolved to be associated with a pseudo-element is associated with
        // one.
        let selections = selectorEvaluatorChain.reverseEvaluate(selections: intialSelectorSelection, stylesheet: stylesheet, filterContext: filterContext)
        
        XCTAssert(selections.count == 1)
        let selection = selections.first!
        let pseudos = selection.pseudoElementSelectorsTypes!
        
        XCTAssert(pseudos.count == 1)
        XCTAssert(pseudos[0].rawValue == "tag")
        
        for selection in selections {
            debugPrint("selection: \(selection)")
        }
        
        XCTAssert(!selections.isEmpty)
    }
    
    func testPseudoClass() {
        
        let sourceString = """
            h1:focus {
                color: blue;
            }
        """
        
        let document = buildBasicHtmlDocument()
        
        let matchList = CSSSelectorsModule.shared.createInitialSelectorMatchList([document.rootDocumentElement])
        
        let stylesheet = CSSOMModule.shared.parseStyleSheet(sourceString as NSString, origin: .author)!
        
        let selectorList: SelectorList = stylesheet.firstStyleRule!.selectorList!
        
        let intialSelectorSelection: [SelectorSelection] = matchList.map { (element) -> SelectorSelection in
            return SelectorSelection(elementToEvaluate: element)
        }
        
        var filterContext = FilterContext()
        
        let h1 = document.getElementsByTagName("h1").elements.first as! HTMLHeadingElement
        
        filterContext.updatePseudoClassesOptions(forElement: h1, with: [.focus])
        
        // create the SelectorEvaluatorChain
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)
        
        let evaluableSelector = selectorList.selectorArray.first!
        
        // construct the SelectorEvaluatorChain
        evaluableSelector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        
        // get the evaluated selector selections
        // Regarding pseudo-elements, in here we have all the pseudo-elements
        // for all available selections, meaning that each element which
        // resolved to be associated with a pseudo-element is associated with
        // one.
        let selections = selectorEvaluatorChain.reverseEvaluate(selections: intialSelectorSelection, stylesheet: stylesheet, filterContext: filterContext)
        
        XCTAssert(selections.count == 1)
        let selection = selections.first!
        let pseudos = selection.pseudoElementSelectorsTypes!
        
        XCTAssert(pseudos.isEmpty)
        
        for selection in selections {
            debugPrint("selection: \(selection)")
        }
        
        XCTAssert(!selections.isEmpty)
    }
    
    func testDifferentPseudoClasses() {
        
        let sourceString = """
            h1:focus:highlight {
                color: blue;
            }
        """
        
        let document = buildBasicHtmlDocument()
        
        let matchList = CSSSelectorsModule.shared.createInitialSelectorMatchList([document.rootDocumentElement])
        
        let stylesheet = CSSOMModule.shared.parseStyleSheet(sourceString as NSString, origin: .author)!
        
        let selectorList: SelectorList = stylesheet.firstStyleRule!.selectorList!
        
        let intialSelectorSelection: [SelectorSelection] = matchList.map { (element) -> SelectorSelection in
            return SelectorSelection(elementToEvaluate: element)
        }
        
        let highlightSelectors = CSSSelectorsModule.shared.parse("*")
        
        var filterContext = FilterContext(highlightSelectors: highlightSelectors)
        
        let h1 = document.getElementsByTagName("h1").elements.first as! HTMLHeadingElement
        
        filterContext.updatePseudoClassesOptions(forElement: h1, with: [.focus, .highlight])
        
        // create the SelectorEvaluatorChain
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)
        
        let evaluableSelector = selectorList.selectorArray.first!
        
        // construct the SelectorEvaluatorChain
        evaluableSelector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        
        // get the evaluated selector selections
        // Regarding pseudo-elements, in here we have all the pseudo-elements
        // for all available selections, meaning that each element which
        // resolved to be associated with a pseudo-element is associated with
        // one.
        let selections = selectorEvaluatorChain.reverseEvaluate(selections: intialSelectorSelection, stylesheet: stylesheet, filterContext: filterContext)
        
        XCTAssert(selections.count == 1)
        let selection = selections.first!
        let pseudos = selection.pseudoElementSelectorsTypes!
        
        XCTAssert(pseudos.isEmpty)
        
        
        for selection in selections {
            debugPrint("selection: \(selection)")
        }
        
        XCTAssert(!selections.isEmpty)
    }
    
    func testMutliplePseudoClass() {
        
        let sourceString = """
            h1:focus:focus {
                color: blue;
            }
        """
        
        let document = buildBasicHtmlDocument()
        
        let matchList = CSSSelectorsModule.shared.createInitialSelectorMatchList([document.rootDocumentElement])
        
        let stylesheet = CSSOMModule.shared.parseStyleSheet(sourceString as NSString, origin: .author)!
        
        let selectorList: SelectorList = stylesheet.firstStyleRule!.selectorList!
        
        let intialSelectorSelection: [SelectorSelection] = matchList.map { (element) -> SelectorSelection in
            return SelectorSelection(elementToEvaluate: element)
        }
        
        var filterContext = FilterContext()
        
        let h1 = document.getElementsByTagName("h1").elements.first as! HTMLHeadingElement
        
        filterContext.updatePseudoClassesOptions(forElement: h1, with: [.focus])
        
        // create the SelectorEvaluatorChain
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)
        
        let evaluableSelector = selectorList.selectorArray.first!
        
        // construct the SelectorEvaluatorChain
        evaluableSelector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        
        // get the evaluated selector selections
        // Regarding pseudo-elements, in here we have all the pseudo-elements
        // for all available selections, meaning that each element which
        // resolved to be associated with a pseudo-element is associated with
        // one.
        let selections = selectorEvaluatorChain.reverseEvaluate(selections: intialSelectorSelection, stylesheet: stylesheet, filterContext: filterContext)
        
        XCTAssert(selections.count == 1)
        let selection = selections.first!
        let pseudos = selection.pseudoElementSelectorsTypes!
        
        XCTAssert(pseudos.isEmpty)

        for selection in selections {
            debugPrint("selection: \(selection)")
        }
        
        XCTAssert(!selections.isEmpty)
    }
    
    func buildBasicHtmlDocument() -> HtmlDocument {
        
        let htmlDocument: HtmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument.body {
            
            var exception = Exception()
            
            // h1
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            body.append(h1, exception: &exception)
            
            // p
            let p1 = HTMLParagraphElement(document: htmlDocument)
            body.append(p1, exception: &exception)
            
            // h2
            let h2 = HTMLHeadingElement(document: htmlDocument, localName: "h2")
            
            body.append(h2, exception: &exception)
            
            // p
            let p2 = HTMLParagraphElement(document: htmlDocument)
            body.append(p2, exception: &exception)
        }
        
        return htmlDocument
    }
}
