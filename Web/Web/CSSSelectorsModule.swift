//
//  CSSParser.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-21.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// This class is the main interface to CSS Module. It is defined as a singleton and is
/// reintrant in the sens that there is no state kept in the class.
/// 
/// This class implements the genericly defined interfaces in the [CSS Selectors] 
/// (http://dev.w3.org/csswg/selectors ) standard.
///
///
///
/// Singletong class
public final class CSSSelectorsModule : CSSModule {
    
    typealias Module = CSSSelectorsModule
    
    /// Singleton instance.
    public static var shared = CSSSelectorsModule()
    
    fileprivate init() {
        
    }
    
    /// Parse a selector from a string source. It returns either a complex selector list, or failure.
    /// see http://dev.w3.org/csswg/selectors/#parse-a-selector
    public func parse(_ selector: NSString) -> SelectorList? {
        
        let reader = CSSReader(sourceString: selector)
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0)
        
        let styleSheet = parser.parseStyleSheet()

        let qualifiedRules = styleSheet.cssRules
        
        if qualifiedRules.count == 1 {
            
            if let qualifiedRule = qualifiedRules[0] as? CSQualifiedRule {
                
                let selectorParser = CSSSelectorParser(componentValueArray: qualifiedRule.prelude)
                
                // The parent value is not passed here since we don't want to deviate 
                // from the interface defined by w3c.
                if let selectorList = selectorParser.parseSelector() {
                    
                    return selectorList
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("There's been an error while parsing selector string.", log: Log.Web.all, type: .error)
                    #endif
                    return nil
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("CssRules array should contin only CSQualifiedRule.", log: Log.Web.all, type: .error)
                #endif
                return nil
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Number of QualifiedRule should be 1.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    func createSimpleSelector(from selectorString: String) -> SimpleSelector? {
        
        guard let selectorList = CSSSelectorsModule.shared.parse(selectorString as NSString) else {
            assertionFailure("Error: selectorList is nil with \(selectorString)")
            return nil
        }
        
        assert(!selectorList.selectorArray.isEmpty)
        assert(selectorList.selectorArray.count == 1)
        guard let complexSelector = selectorList.selectorArray.last else {
            assertionFailure("Error: last complexSelector is nil")
            return nil
        }
        
        assert(!complexSelector.compoundSelectorList.isEmpty)
        assert(complexSelector.compoundSelectorList.count == 1)
        guard let compoundSelector = complexSelector.compoundSelectorList.last else {
            assertionFailure("Error: last compoundSelector is nil")
            return nil
        }
        
        assert(!compoundSelector.simpleSelectorSequence.isEmpty)
        assert(compoundSelector.simpleSelectorSequence.count == 1)
        guard let simpleSelector = compoundSelector.simpleSelectorSequence.last else {
            assertionFailure("Error: last simpleSelector is nil")
            return nil
        }
        
        return simpleSelector
    }
    
    /// Parse a relative selector from a string source, against :scope elements refs. 
    /// It returns either a complex selector list, or failure.
    /// see http://dev.w3.org/csswg/selectors/#parse-relative-selector
    func parseRelativeSelector(_ selector: DOMString, refs: [Element]) -> SelectorList? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("parseRelativeSelector(..) missing subclass implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }

    /// Match a selector against a tree
    /// see http://dev.w3.org/csswg/selectors/#match-against-tree
    func matchSelector<S: ScopingElement>(_ selector: DOMString, against rootElements: ContiguousArray<Element>, scopingMethod: ScopingMethod = ScopingMethod.unscoped, scopingRoot: S? = nil, scopeElements: ContiguousArray<S>? = nil, allowedPseudoElements: [DOMString]? = nil) -> [Element: [ComplexSelector]]? {
        
        // A scoping method and scoping root. If not specified, the selector defaults to being unscoped.
        // Note : done using the default value Unscoped for scopingMethod parameter.
        if scopingMethod != ScopingMethod.unscoped && scopingRoot == nil {
            
            assert(false, "scopingRoot must be specified when selector is scoped.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("scopingRoot must be specified when selector is scoped.", log: Log.Web.all, type: .error)
            #endif
            return nil
        }
        
        var _scopeElements = ContiguousArray<S>()
        
        // A set of :scope elements, which will match the :scope pseudo-class. 
        // If not specified, then if the selector is a scoped selector, 
        // the set of :scope elements default to the scoping root; 
        // otherwise, it defaults to the root elements.
        if scopeElements == nil {
            
            if scopingMethod != ScopingMethod.unscoped {
                
                if let scopingRoot = scopingRoot {
                    
                    _scopeElements.append(scopingRoot)
                }
                else {
                    
                    assert(false, "scopingRoot must be specified when selector is scoped.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("scopingRoot must be specified when selector is scoped.", log: Log.Web.all, type: .error)
                    #endif
                    return nil
                }
            }
            // otherwise, it defaults to the root elements.
            else {
                
                for element in rootElements {
                
                    let s = element as! S
                    
                    _scopeElements.append(s)
                }
            }
        }
        
        return evaluate(selector, against: rootElements, scopingMethod: scopingMethod, scopingRoot: scopingRoot, scopeElements: _scopeElements, allowedPseudoElements: allowedPseudoElements, stylesheet: nil, filterContext: FilterContext())
        
    }
    
    /// Match a selector against a DOM element
    /// see http://dev.w3.org/csswg/selectors/#match-a-selector-against-an-element
    func match<S: ScopingElement>(_ selectorList: SelectorList, against element: Element, scopeElements: ContiguousArray<S>) -> Bool {

        // 1. Let root element be the "root ancestor" of element: the element found 
        // by traversing parent links from element until an element without a parent is encountered.
        let rootElement = element.document.rootDocumentElement
            
        // 2. Evaluate a selector with selector and root element,
        // and any optional arguments passed to this algorithm. 
        // Let matched elements be the result.
        if let filteredElements = reverseDirectionSelectorListEvaluator(selectorList, against: [rootElement], scopingMethod: nil, scopingRoot: nil, scopeElements: scopeElements, allowedPseudoElements: nil, stylesheet: nil, filterContext: FilterContext()) {
            
            // 3. If element is in matched elements, return success.
            // Otherwise, return failure
            if filteredElements[element] != nil{
                return true
            }
        }
        return false
    }
 
    
    
    public func evaluate(_ selector: DOMString, against rootElements: ContiguousArray<Element>, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Element: [ComplexSelector]]? {
        
        return evaluate(selector, against: rootElements, scopeElements: rootElements, stylesheet: stylesheet, filterContext: filterContext)
    }
    
    /// Evaluate a selector against a set of elements.
    /// APIs using this algorithm must provide a selector, and one or more root elements 
    /// indicating the trees that will be searched by the selector. 
    ///
    /// They may optionally provide:
    ///     - a scoping method and scoping root. If not specified, the selector defaults to being unscoped.
    ///     - a set of :scope elements, for resolving the :scope pseudo-class against. 
    ///       If not specified, the set defaults to being empty.
    ///
    /// def :   The root of the scoping subtree is called the scoping root,
    ///         and may be either a true element (the scoping element) or
    ///         a virtual one (such as a DocumentFragment).
    /// see http://dev.w3.org/csswg/selectors/#scoping-root
    ///
    /// see http://dev.w3.org/csswg/selectors/#evaluate-a-selector
    public func evaluate<S: ScopingElement>(_ selector: DOMString, against rootElements: ContiguousArray<Element>, scopingMethod: ScopingMethod? = nil, scopingRoot: S? = nil, scopeElements: ContiguousArray<S> = ContiguousArray<S>(), allowedPseudoElements: [DOMString]? = nil, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Element: [ComplexSelector]]? {
        
        let selectorList = parse(selector as NSString )
    
        if let selectorList = selectorList {
            
            if selectorList.hasErrors() {
                return nil
            }
            
            return reverseDirectionSelectorListEvaluator(selectorList, against: rootElements, scopingMethod: scopingMethod, scopingRoot: scopingRoot, scopeElements: scopeElements, allowedPseudoElements: allowedPseudoElements, stylesheet: stylesheet, filterContext: filterContext)
        }
        return nil
    }
    
    public func reverseDirectionSelectorListEvaluator<S: ScopingElement>(_ selector: SelectorList, against rootElements: ContiguousArray<Element>, scopingMethod: ScopingMethod? = nil, scopingRoot: S? = nil, scopeElements: ContiguousArray<S> = ContiguousArray<S>(), allowedPseudoElements: [DOMString]? = nil, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Element: [ComplexSelector]]? {
        
        // If the selector is a relative selector, the set of :scope elements must not be empty.
        // TODO: Verify if this error could be a user error or a programmer error since
        // it could change the way we handle it.
        if !validateRelativeSelector(selector, scopeElements: scopeElements, scopingMethod: scopingMethod) {
            
            // FIXME: not handled at the moment since the validation always
            // returns true
        }
        
        let elements: [Element: [ComplexSelector]]?
        
        if let scopingRoot = scopingRoot, let scopingMethod = scopingMethod {
            
            switch scopingMethod {
                
            case .scopeRoot:
                
                elements = selector.reverseEvaluate(rootElements, scopingMethod: scopingMethod, scopingRootFilter: makeScopingRootFilter(scopingRoot), stylesheet: stylesheet, filterContext: filterContext)
                
            default:
                
                let initialSelectorMatchList = self.createInitialSelectorMatchList(rootElements)
                
                elements = selector.reverseEvaluate(initialSelectorMatchList, scopingMethod: scopingMethod, scopingRootFilter: makeScopingRootFilter(scopingRoot), stylesheet: stylesheet, filterContext: filterContext)
            }
        }
        else {
            
            let initialSelectorMatchList = createInitialSelectorMatchList(rootElements)
            elements = selector.reverseEvaluate(initialSelectorMatchList, scopingMethod: scopingMethod, stylesheet: stylesheet, filterContext: filterContext)
        }
        
        return elements
    }
    
    public func reverseElementsDirectionSelectorListEvaluator(_ selector: SelectorList, against sourceElements: ContiguousArray<Element>, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Element: [ComplexSelector]]? {
        
        return selector.reverseEvaluate(sourceElements, scopingMethod: nil, stylesheet: stylesheet, filterContext: filterContext)
    }
    
    /// Create the filter that bound the scopingRoot to the 
    /// filter method.
    func makeScopingRootFilter<S: ScopingElement>(_ scopingRoot: S) -> ((SelectorSelection) -> Bool) {
        
        if let scopingRoot = scopingRoot as? DocumentFragment {
            func filter(_ selection: SelectorSelection) -> Bool {
                return false
            }
            return filter
        }
        else if let scopingRoot = scopingRoot as? Element {
         
            func filter(_ selection: SelectorSelection) -> Bool {
                
                if selection.elementToEvaluate != scopingRoot {
                    
                    if !selection.elementToEvaluate.isDescendant(of: scopingRoot) {
                            
                        return false
                    }
                    else {
                        
                        return false
                    }
                }
                
                return true
            }
            
            return filter
        }
        else {
            
            fatalError("ScopingElement must either be of type Element or DocumentFragment.")
        }
    }
    
    // If the selector is scope-contained, the selector match list is immediately filtered
    // to contain only elements that are either the scoping root or descendants of the scoping root.

    
    /// The selector match list is initially populated with the root elements provided to the algorithm,
    /// and all elements reachable from them by traversing any number of child lists.
    /// see http://dev.w3.org/csswg/selectors/#selector-matchr-list
    public func createInitialSelectorMatchList(_ rootElements: ContiguousArray<Element>) -> ContiguousArray<Element> {
        
        var selectorMatchList = ContiguousArray<Element>()
        
        for element in rootElements {
            
            assert(element.document != nil)
            
            let filter = AllElementNodeFilter()
            
            let collection = HTMLCollection(root: element, filter: filter, inclusive: true)
            
            #if DEBUG
            var elementsSet = Set<Element>()
            for descendant in element.descendants() {
                
                if let element = descendant as? Element {
                    elementsSet.insert(element)
                }
            }
            
            let elementSetCount = elementsSet.count+1
            let collectionLength = collection.length
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("elementSetCount: %d", log: Log.Web.all, type: .debug, elementSetCount)
            os_log("collectionLength: %d", log: Log.Web.all, type: .debug, collectionLength)
            #endif
            
            assert(collectionLength == elementSetCount, "Two different lengths: \(collectionLength) and \(elementSetCount)")
            #endif
            
            for collectionElement in collection {

                assert(collectionElement.document != nil)
                    
                selectorMatchList.append(collectionElement as! Element)
            }
            
        }
        
        return selectorMatchList
    }
    
    // If the selector is a relative selector, the set of :scope elements must not be empty.
    func validateRelativeSelector<S: ScopingElement>(_ selector: SelectorList, scopeElements: ContiguousArray<S>, scopingMethod: ScopingMethod?) -> Bool {
        
        
//        if selector.isRelative() {
//        
//            // Note: Note that if the selector is scoped, the scoping root is automatically
//            // taken as the :scope element, so it doesn’t have to be provided explicitly 
//            // unless a different result is desired.
//            if let scopingMethod = scopingMethod {
//                
//                //
//                if scopingMethod != ScopingMethod.Unscoped {
//                    
//                }
//                //
//                return true
//            }
//        }
        
        return true
    }
    
}



