//
//  ResourceComputedStyle+StyleResolver.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

fileprivate let elementsSubsequenceLength = 20

extension ResourceComputedStyle {
    
    public func computedStyle(forElement element: Element) -> ComputedStyleDeclaration?  {
        
        assert(!(element is PseudoElement))
        return elementStyle(forElement: element, filterContext: FilterContext())?.rawComputedStyle
    }
    
    /// Method that compute the style for the document root elements and all the descendants
    /// of the roots elements passed as a parameter and the roots elements themselves.
    @discardableResult
    public func computeElementsStyles(forRootElements elements: ContiguousArray<Element>, document: Document, filterContext: FilterContext, forceStyleComputation: Bool = false) -> ContiguousArray<Element> {
        
        evaluateStyleForRootsElementsIfNecessary(document: document, filterContext: filterContext)
        
        var _elements = self.elementWithoutStyles(from: elements, filterContext: filterContext, forceStyleComputation: forceStyleComputation)
        
        // this is an early exit based on the fact that we have already computed the style
        // for root elements and that we have computed the style for the requested elements
        // this early exit is only valid in the case of a Markdown document
        
        if _elements.isEmpty, !(document is CSSDOMDocument) {
            
            // just return an empty array
            return ContiguousArray<Element>()
        }
        else {
            
            _elements = elements
        }
        
        _elements = populateElements(forRootElements: _elements, document: document, forceStyleComputation: forceStyleComputation, filterContext: filterContext)
        
        // code validation: here we should always have elements
        assert(!_elements.isEmpty )
        
        // here all the elements we want to compute style for should
        // have not been computed before, meaning they should have no
        // style associated, see NW-734
        if !_elements.isEmpty {
            
            return evaluateStyleIfNeeded(for: _elements, filterContext: filterContext)
        }
        
        return ContiguousArray<Element>()
    }
    
    
    
    
    
    
    
    @discardableResult
    public func computeElementsStyles(document: Document, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        let _elements = populateElements(document: document, forceStyleComputation: false, filterContext: filterContext)
        
        if _elements.isEmpty {
            
            // just return an empty array
            return ContiguousArray<Element>()
        }
        return self.evaluateStyleIfNeeded(for: _elements, filterContext: filterContext)
    }
    
    private func elementWithoutStyles(from elements: ContiguousArray<Element>, filterContext: FilterContext, forceStyleComputation: Bool = false) -> ContiguousArray<Element> {
        
        // make sure we only compute elements that have not already been computed
        
        if forceStyleComputation {
            return elements
        }
        else {
            let array = elements.map { (element) -> (Element, StyleIdentity) in
                return (element, self.styleIdentity(for: element, filterContext: filterContext))
            }.filter { (elementStyleIdentity) -> Bool in
                if self.elementStyle(forStyleIdentity: elementStyleIdentity.1) == nil {
                    return true
                }
                return false
            }.map { (elementStyleIdentity) -> Element in
                return elementStyleIdentity.0
            }
            return ContiguousArray<Element>(array)
        }
    }
    
    @discardableResult
    func evaluateStyleIfNeeded(for elements: ContiguousArray<Element>, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        var computedStyleElements = ContiguousArray<Element>()
        
        // two options here: we may have following or next sibling selectors, or not.
        if self.containSiblingSelectors {
            
            let elementsApplicableRules: [Element: StyleApplicable] = self.computeElementsAplicableRules(for: elements, filterContext: filterContext)
            
            for matchedElement in elements {
                
                // applicableRules could be nil since it's possible to have no rules
                // specifically pointing at it.
                let applicable = elementsApplicableRules[matchedElement]
                let styleIdentity = self.styleIdentity(for: matchedElement, filterContext: filterContext, rules: applicable?.allRules, computeRules: false)
                
                // it's already there
                if let elementStyle = self.elementStyle(forStyleIdentity: styleIdentity) {
                    
                    // we update for inheriting purpose because style is there but the element has changed
                    let elementStyle = ElementStyle(associatedElement: matchedElement, evaluatedStyle: elementStyle.evaluatedStyle, resourceComputedStyle: self, inheritingElementStyle: elementStyle.inheritingElementStyle)
                    self.updateElementStyle(forStyleIdentity: styleIdentity, elementStyle: elementStyle)
                }
                else {
                    computeStyle(forElement: matchedElement, filterContext: filterContext, applicable: applicable)
                }
                computedStyleElements.append(matchedElement)
            }
        }
        else {
            
            for idx in stride(from: elements.indices.lowerBound, to: elements.indices.upperBound, by: elementsSubsequenceLength) {
                
                let subsequence = elements[idx..<min(idx.advanced(by: elementsSubsequenceLength), elements.count)]
                
                let needStyleEvaluationElements = self.elementsNeedingStyleEvaluation(fromSubsequence: subsequence, computedStyleElements: &computedStyleElements, filterContext: filterContext)
                
                guard !needStyleEvaluationElements.isEmpty else {
                    continue
                }
                
                self.evaluateStyle(for: needStyleEvaluationElements, computedStyleElements: &computedStyleElements, filterContext: filterContext)
            }
        }
        return computedStyleElements
    }
    
    private func evaluateStyle(for elements: ContiguousArray<Element>, computedStyleElements: inout ContiguousArray<Element>, filterContext: FilterContext) {
        
        let elementsApplicableRules: [Element: StyleApplicable] = computeElementsAplicableRules(for: elements, filterContext: filterContext)
        
        for element in elements {
            
            let applicable = elementsApplicableRules[element]
            self.computeStyle(forElement: element, filterContext: filterContext, applicable: applicable)
            computedStyleElements.append(element)
        }
    }
    
    private func elementsNeedingStyleEvaluation(fromSubsequence subsequence: ArraySlice<Element>, computedStyleElements: inout ContiguousArray<Element>, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        var needStyleEvaluationElements = ContiguousArray<Element>()
        
        var processedStyleIdentities = Set<StyleIdentity>()
        
        // the first pass is to remove elements for which we don't
        // need to compute style
        for matchedElement in subsequence {
            
            let styleIdentity = self.styleIdentity(for: matchedElement, filterContext: filterContext, computeRules: false)
            
            if let elementStyle = self.elementStyle(forStyleIdentity: styleIdentity) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Element with name %@ has already a style.", log: Log.Web.all, type: .info, matchedElement.localName, %%ObjectIdentifier(matchedElement))
                #endif
                
                // we update for inheriting purpose because style is there but the element has changed
                let elementStyle = ElementStyle(associatedElement: matchedElement, evaluatedStyle: elementStyle.evaluatedStyle, resourceComputedStyle: self, inheritingElementStyle: elementStyle.inheritingElementStyle)
                self.updateElementStyle(forStyleIdentity: styleIdentity, elementStyle: elementStyle)
                
                // add the computed element
                computedStyleElements.append(matchedElement)
            }
            else {
                
                if !processedStyleIdentities.contains(styleIdentity) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Element with name %@ and style identity %@ has no style.", log: Log.Web.all, type: .info, matchedElement.localName, %%treePositionStyleIdentity.identity)
                    #endif
                    
                    needStyleEvaluationElements.append(matchedElement)
                }
            }
            processedStyleIdentities.insert(styleIdentity)
        }
        return needStyleEvaluationElements
    }
    
    
    private func evaluateStyleForRootsElementsIfNecessary(document: Document, filterContext: FilterContext) {
        
        for element in document.styleRoots {
            
            if self.computedStyle(forElement:element) == nil {
                
                let applicable = elementAplicables(for: element, filterContext: filterContext)
                computeStyle(forElement: element, filterContext: filterContext, applicable: applicable)
            }
        }
    }
    
    private func populateElements(forRootElements elements: ContiguousArray<Element>? = nil, document: Document, forceStyleComputation: Bool, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        var combinedElements: ContiguousArray<Element>
        
        if let elements = elements {
            combinedElements = elements
        }
        else {
            combinedElements = [document.rootDocumentElement]
        }
        
        // add empty entries for added elements
        for element in combinedElements {
            
            // when forcing recomputation we only need to remove
            // the style identity for an element and the style identity
            // will cimply be recomputed and the if the style has already
            // been computed it will be applied to the element as it
            // normally should in the normal mecanism.
            if forceStyleComputation {
                self.deleteStyleIdentity(forElement: element, filterContext: filterContext)
            }
            
            // create empty entries for all present elements
            for nodeToCastAsElement in element.descendantElements {
                
                guard let descendantElement = nodeToCastAsElement as? Element else {
                    assertionFailure("Error: nodeToCastAsElement is not Element")
                    continue
                }
                
                if forceStyleComputation {
                    self.deleteStyleIdentity(forElement: descendantElement, filterContext: filterContext)
                }
                combinedElements.append(descendantElement)
            }
        }
        return combinedElements
    }
    
    /// Method that computes the elements applicable rules for all elements
    func elementAplicables(for element: Element, filterContext: FilterContext) -> StyleApplicable {
        
        let applicable = StyleApplicable()
        
        ///////////////////
        // user agent style
        ///////////////////
        if let userAgentStyleSheet = styleDefinition.userAgentStyleSheet {
            
            let userAgentApplicable: StyleApplicable = elementApplicableStyleRules(userAgentStyleSheet, filterContext: filterContext, for: element)
            applicable.merge(with: userAgentApplicable)
        }
        ///////////////
        // author style
        ///////////////
        for authorStyleSheet in styleDefinition.authorStyleSheets {
            
            let authorStyleSheetApplicable: StyleApplicable =  elementApplicableStyleRules(authorStyleSheet, filterContext: filterContext, for: element)
            applicable.merge(with: authorStyleSheetApplicable)
        }
        
        //////////////////////
        // document user style
        //////////////////////
        
        if let userStyleSheet = styleDefinition.userStyleSheet {
            
            let userStyleSheetApplicable: StyleApplicable = elementApplicableStyleRules(userStyleSheet, filterContext: filterContext, for: element)
            applicable.merge(with: userStyleSheetApplicable)
        }
        return applicable
    }
    
    /// Method that computes the elements applicable rules for all elements
    ///
    /// This method is optionally passed a ephemeral pseudo classes set.
    /// We dont care about the order here the only thing we care is
    /// they must be all there!
    func computeElementsAplicableRules(for elements: ContiguousArray<Element>, filterContext: FilterContext) -> [Element: StyleApplicable] {
        
        var elementsApplicableRules = [Element: StyleApplicable]()
        
        var stylesheets: [CSSStyleSheet] = []
        
        ///////////////////
        // user agent style
        ///////////////////
        if let userAgentStyleSheet = styleDefinition.userAgentStyleSheet {
            stylesheets.append(userAgentStyleSheet)
        }
        
        ///////////////
        // author style
        ///////////////
        for authorStyleSheet in styleDefinition.authorStyleSheets {
            stylesheets.append(authorStyleSheet)
        }
        
        //////////////////////
        // document user style
        //////////////////////
        
        if let userStyleSheet = styleDefinition.userStyleSheet {
            stylesheets.append(userStyleSheet)
        }
        
        let lock = NSLock()
        
        var applicables: [Int: [Element: StyleApplicable]] = [:]
        
        DispatchQueue.concurrentPerform(iterations: stylesheets.count) { (index) in
            
            let styleSheet = stylesheets[index]
            
            let elementsApplicableRules = self.elementsApplicableStyleRules(styleSheet, filterContext: filterContext, elements: elements)
            
            lock.withCriticalSection {
                applicables[index] = elementsApplicableRules
            }
        }
        
        applicables.sorted { (first, second) -> Bool in
            return first.key < second.key
        }.forEach { (arg) in
            
            let applicableRules = arg.value
            for (element, styleApplicable) in applicableRules {
                
                if elementsApplicableRules[element] == nil {
                    elementsApplicableRules[element] = StyleApplicable()
                }
                elementsApplicableRules[element]!.merge(with: styleApplicable)
            }
        }
        
        return elementsApplicableRules
    }
    
    /// Method that returns all the applicable rules for all elements, that means the rules that
    /// each element is selected by the selector.
    func elementsApplicableStyleRules(_ styleSheet: CSSStyleSheet, document: Document, filterContext: FilterContext) -> [Element: StyleApplicable] {
        
        return rootElementsApplicableStyleRules(styleSheet, filterContext: filterContext, rootElements: [document.rootDocumentElement])
    }
    
    /// Method that returns all the applicable rules and pseudo elements
    /// for all elements passed in parameter.
    ///
    /// Note: This is not the final applicable rules that derive from cascading it's only
    /// the directly applicable rules.
    ///
    func elementsApplicableStyleRules(_ styleSheet: CSSStyleSheet, filterContext: FilterContext, elements: ContiguousArray<Element>) -> [Element: StyleApplicable] {
        
        let selectorModule = CSSSelectorsModule.shared
        var elementsApplicableStyleRules = [Element: StyleApplicable]()
        var elementsComplexSelectors = [Int: (CSSStyleRule, [Element: [ComplexSelector]]?)]()
        
        let rules = styleSheet.cssRules
        
        let lock = NSLock()
        
        DispatchQueue.concurrentPerform(iterations: rules.length) { (index) in
            
            let rule = rules[index]
            
            if let styleRule = rule as? CSSStyleRule {
                
                // it's possible to have a selector list value
                // to nil while editing a document.
                if let selectorList = styleRule.selectorList {
                    
                    // here I return multiple time the same element
                    if let _elementsComplexSelectors = selectorModule.reverseElementsDirectionSelectorListEvaluator(
                        selectorList,
                        against: elements, stylesheet: styleSheet, filterContext: filterContext), !_elementsComplexSelectors.isEmpty {
                        
                        lock.withCriticalSection {
                            elementsComplexSelectors[index] = (styleRule, _elementsComplexSelectors)
                        }
                    }
                }
            }
        }
        
        let sortedEvaluatedRules = elementsComplexSelectors.sorted { (first, second) -> Bool in
            return first.key < second.key
        }
        
        for _evaluatedRules in sortedEvaluatedRules {
            
            let (styleRule, _elementsSelectors) = _evaluatedRules.value
            
            guard let elementsSelectors = _elementsSelectors else {
                continue
            }
            
            for (elem, complexSelectors) in elementsSelectors {
                
                if let pseudoElement = elem as? PseudoElement {
                    
                    let key = pseudoElement.associatedElement
                    
                    if elementsApplicableStyleRules[key] == nil {
                        elementsApplicableStyleRules.updateValue(StyleApplicable(), forKey: key)
                    }
                    
                    elementsApplicableStyleRules[key]!.addPseudo(pseudoElement)
                    elementsApplicableStyleRules[key]!.addPseudoRule(pseudoElement, rule: styleRule, complexSelectors: complexSelectors)
                }
                else {
                    
                    if elementsApplicableStyleRules[elem] == nil {
                        elementsApplicableStyleRules.updateValue(StyleApplicable(), forKey: elem)
                    }
                    
                    // we know it's there we just tested for it.
                    elementsApplicableStyleRules[elem]!.addRule(styleRule, complexSelectors: complexSelectors)
                }
            }
        }
        
        #if DEBUG
        for (_, applicable) in elementsApplicableStyleRules {
            
            validateStyleApplicablePseudos(applicable)
        }
        #endif
        
        return elementsApplicableStyleRules
    }
    
    /// Method that returns all the applicable rules and pseudo elements
    /// for all elements passed in parameter.
    ///
    /// Note: This is not the final applicable rules that derive from cascading it's only
    /// the directly applicable rules.
    ///
    private func rootElementsApplicableStyleRules(_ styleSheet: CSSStyleSheet, filterContext: FilterContext, rootElements: ContiguousArray<Element>) -> [Element: StyleApplicable] {
        
        let selectorModule = CSSSelectorsModule.shared
        var elementsApplicableStyleRules = [Element: StyleApplicable]()
        let rules = styleSheet.cssRules
        
        for rule in rules {
            
            if let styleRule = rule as? CSSStyleRule {
                
                // it's possible to have a selector list value
                // to nil while editing a document.
                if let selectorList = styleRule.selectorList, let rootElement = rootElements.first {
                    
                    // here I return multiple time the same element
                    if let elementsComplexSelectors = selectorModule.reverseDirectionSelectorListEvaluator(
                        selectorList,
                        against: rootElements,
                        scopingMethod: ScopingMethod.unscoped,
                        scopingRoot: rootElement, stylesheet: styleSheet, filterContext: filterContext), !elementsComplexSelectors.isEmpty {
                        
                        for (elem, complexSelectors) in elementsComplexSelectors {
                            
                            if let pseudoElement = elem as? PseudoElement {
                                
                                let key = pseudoElement.associatedElement
                                
                                if elementsApplicableStyleRules[key] == nil {
                                    elementsApplicableStyleRules.updateValue(StyleApplicable(), forKey: key)
                                }
                                
                                elementsApplicableStyleRules[key]!.addPseudo(pseudoElement)
                                elementsApplicableStyleRules[key]!.addPseudoRule(pseudoElement, rule: styleRule, complexSelectors: complexSelectors)
                            }
                            else {
                                
                                if elementsApplicableStyleRules[elem] == nil {
                                    elementsApplicableStyleRules.updateValue(StyleApplicable(), forKey: elem)
                                }
                                
                                // we know it's there we just tested for it.
                                elementsApplicableStyleRules[elem]!.addRule(styleRule, complexSelectors: complexSelectors)
                            }
                        }
                    }
                }
            }
        }
        
        #if DEBUG
        for (_, applicable) in elementsApplicableStyleRules {
            
            validateStyleApplicablePseudos(applicable)
        }
        #endif
        
        return elementsApplicableStyleRules
    }
    
    /// Method that returns all the applicable rules for all elements passed in parameter,
    ///
    func elementApplicableStyleRules(_ styleSheet: CSSStyleSheet, filterContext: FilterContext, for element: Element) -> StyleApplicable {
        
        let selectorModule = CSSSelectorsModule.shared
        let rules = styleSheet.cssRules
        let styleApplicable = StyleApplicable()
        
        for rule in rules {
            
            guard let styleRule = rule as? CSSStyleRule else {
                continue
            }
            
            // it's possible to have a selector list value
            // to nil while editing a document.
            guard let selectorList = styleRule.selectorList else {
                continue
            }
            
            guard let elementsComplexSelectors = selectorModule.reverseDirectionSelectorListEvaluator(
                selectorList,
                against: [element],
                scopingMethod: ScopingMethod.scopeRoot,
                scopingRoot: element, stylesheet: styleSheet, filterContext: filterContext), !elementsComplexSelectors.isEmpty else {
                    continue
            }
            
            for (elem, complexSelectors) in elementsComplexSelectors {
                
                if let pseudoElement = elem as? PseudoElement {
                    
                    styleApplicable.addPseudo(pseudoElement)
                    styleApplicable.addPseudoRule(pseudoElement, rule: styleRule, complexSelectors: complexSelectors)
                }
                else {
                    
                    assert(elem === element)
                    styleApplicable.addRule(styleRule, complexSelectors: complexSelectors)
                }
            }
        }
        #if DEBUG
        validateStyleApplicablePseudos(styleApplicable)
        #endif
        
        return styleApplicable
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func validateStyleApplicablePseudos(_ styleApplicable: StyleApplicable) {
        
        if let pseudos = styleApplicable.pseudos {
            
            for pseudo in pseudos {
                
                assert(styleApplicable.pseudoRules[pseudo.localName] != nil)
            }
        }
    }
    
}

