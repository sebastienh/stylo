


//
//  SelectorList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

///
/// > A comma-separated list of selectors represents the union of all elements 
/// > selected by each of the individual selectors in the selector list.
///
// http://dev.w3.org/csswg/selectors4/#grouping
public final class SelectorList: BaseSelector, Serializable, CustomStringConvertible {
    
    var selectorArray: [ComplexSelector]
    
    /// The rightmost selector type is used as a way to increase 
    /// selector perfromance. The array contains all the rightmost 
    /// selector type for each complexe selector contained in the 
    /// SelectorList.
    internal var rightmostSelectorTypeArray: [RightmostSelectorType] {
        
        var selectorTypeArray = [RightmostSelectorType]()
        
        for selector in selectorArray {
            
            selectorTypeArray.append(selector.rightmostSelectorType)
        }
        
        return selectorTypeArray
    }
    
    var count: Int {
        
        return selectorArray.count
    }
    
    var isEmpty: Bool {
        
        return selectorArray.isEmpty
    }
    
    public subscript(index: Int) -> ComplexSelector? {
        get {
            if index < selectorArray.count {
                return selectorArray[index]
            }
            return nil
        }
        set {
            assert(index < selectorArray.count)
            assert(newValue != nil)
            if let newValue = newValue, index < selectorArray.count {
                selectorArray[index] = newValue
            }
        }
    }
    
    public static let empty = SelectorList(parent: nil)
    
    public var associatedDomNodes: ContiguousArray<Node>? {
        
        guard let correspondingCssDomElement = correspondingCssDomElement else {
            assertionFailure("Error: correspondingCssDomElement is nil")
            return nil
        }
            
        var nodes = ContiguousArray<Node>()
        nodes.append(correspondingCssDomElement)
        return nodes
    }
    
    init(parent: CSSRule?) {
        
        self.selectorArray = [ComplexSelector]()
        
        // temporary value should be replaced at the end of the parsing
        super.init(sourceStringSegment: nil)
        
        self.parent = parent
    }

//    /// This method filters the complex selectors that satisfies the
//    /// ephemeral pseudo classes options parameter. Filtering is done
//    /// by following these rules:
//    ///
//    /// 1. if options is empty we return only the complex selectors
//    /// with no ephemeral pseudo classes.
//    ///
//    /// 2. if options is not empty, we return the complex selectors
//    /// without ephemeral pseudo classes and the complex selectors
//    /// that that defines all the ephemeral pseudo classes but no more.
//    ///
//    func filtered(withPseudoClassesOptions pseudoClassesOptions: PseudoClassesOptions) -> SelectorList? {
//        
//        let filtered = SelectorList(parent: self.parent as? CSSRule)
//        
//        if pseudoClassesOptions.isEmpty {
//            for selector in self.selectorArray {
//                if !selector.containsEmphemeralPseudoClasses {
//                    filtered.appendComplexSelector(selector)
//                }
//            }
//        }
//        else {
//            for selector in self.selectorArray {
//                
//                if !selector.containsEmphemeralPseudoClasses {
//                    filtered.appendComplexSelector(selector)
//                }
//                else {
//                    if selector.exclusivelyContainsEmphemeralPseudoClasses(pseudoClassesOptions.ephemerals) {
//                        filtered.appendComplexSelector(selector)
//                    }
//                }
//            }
//        }
//        return filtered
//    }
    
    /// Method that returns the first type selector 
    /// with the specified name.
    func firstTypeSelector(withName name: String) -> TypeSelector? {
        
        let firstTypeSelectorVisitor = FirstTypeSelectorVisitor(typeName: name)
        firstTypeSelectorVisitor.process(self)
        return firstTypeSelectorVisitor.typeSelector
    }
    
    func appendComplexSelector(_ complexSelector: ComplexSelector) {
        
        self.selectorArray.append(complexSelector);
    }
    
    func filterHighlightedSelection(_ selection: SelectorSelection, stylesheet: CSSStyleSheet?) -> SelectorSelection? {

        for evaluableSelector in selectorArray {

            let selectorEvaluatorChain = evaluableSelector.emptyContextSelectorEvaluatorChain

            // get the evaluated selector selections
            // Regarding pseudo-elements, in here we have all the pseudo-elements
            // for all available selections, meaning that each element which
            // resolved to be associated with a pseudo-element is associated with
            // one.
            let filteredSelections = selectorEvaluatorChain.reverseEvaluate(selections: [selection], stylesheet: stylesheet, filterContext: FilterContext())
            
            if !filteredSelections.isEmpty {
                assert(filteredSelections.count == 1)
                return filteredSelections.first!
            }
        }
        
        return nil
    }
    
    func reverseEvaluate(_ selectorMatchList: ContiguousArray<Element>, scopingMethod: ScopingMethod? = nil, scopingRootFilter: ((SelectorSelection) -> Bool)? = nil, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Web.Element: [ComplexSelector]] {
        
        let initialSelection: [SelectorSelection] = selectorMatchList.map { (element) -> SelectorSelection in
            return SelectorSelection(elementToEvaluate: element)
        }
        
        return reverseEvaluate(initialSelection: initialSelection, scopingMethod: scopingMethod, scopingRootFilter: scopingRootFilter, stylesheet: stylesheet, filterContext: filterContext)
    }
    
    /// We call this method when we know in advance the evalutation context of a complex selector
    /// to avoid recomputing the dame selector chain every time we evaluate it.
    public func prepareSelectorChains() {
        
        for evaluableSelector in self.selectorArray {
            
            // create the SelectorEvaluatorChain
            var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)
            
            // construct the SelectorEvaluatorChain
            evaluableSelector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        
            // keep the selector chain for futher use
            evaluableSelector.preparedSelectorChain = selectorEvaluatorChain
        }
    }
    
    /// This method evaluate which elements match a selector
    /// list and return for each matached element the
    /// complex selectors that allowed to select them
    func reverseEvaluate(initialSelection: [SelectorSelection], scopingMethod: ScopingMethod? = nil, scopingRootFilter: ((SelectorSelection) -> Bool)? = nil, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> [Web.Element: [ComplexSelector]] {
        
        let lock = NSLock()
        
        var combinedSelectorsElements = [Web.Element: [ComplexSelector]]()
        
        DispatchQueue.concurrentPerform(iterations: self.selectorArray.count) { (index) in
            
            let evaluableSelector = self.selectorArray[index]
            let elements = evaluateComplexSelector(complexSelector: evaluableSelector, initialSelection: initialSelection, scopingMethod: scopingMethod, scopingRootFilter: scopingRootFilter, stylesheet: stylesheet, filterContext: filterContext)
            
            // combine them with the ones already found
            lock.withCriticalSection {
                for element in elements {
                    if combinedSelectorsElements[element] == nil {
                        combinedSelectorsElements[element] = [ComplexSelector]()
                    }
                
                    assert(combinedSelectorsElements[element] != nil)
                    combinedSelectorsElements[element]?.append(evaluableSelector)
                }
            }
        }
        
        return combinedSelectorsElements
    }
    
    private func evaluateComplexSelector(complexSelector: ComplexSelector, initialSelection: [SelectorSelection], scopingMethod: ScopingMethod? = nil, scopingRootFilter: ((SelectorSelection) -> Bool)? = nil, stylesheet: CSSStyleSheet?, filterContext: FilterContext) -> ContiguousArray<Element> {
        
        // create the SelectorEvaluatorChain if necessary
        let selectorEvaluatorChain: SelectorEvaluatorChain = complexSelector.reverseEvaluatorChain(withFilterContext: filterContext, scopingRootFilter: scopingRootFilter, stylesheet: stylesheet, scopingMethod: scopingMethod)
            
        // get the evaluated selector selections
        // Regarding pseudo-elements, in here we have all the pseudo-elements
        // for all available selections, meaning that each element which
        // resolved to be associated with a pseudo-element is associated with
        // one.
        let selections = selectorEvaluatorChain.reverseEvaluate(selections: initialSelection, stylesheet: stylesheet, filterContext: filterContext)
        
        var elements = ContiguousArray<Element>()
        
        for selection in selections {
            
            // if it's a pseudo selector we should add the pseudo
            // in the result.
            if selection.pseudoElementSelectorsTypes?.isEmpty == false {
            
                guard let pseudos = selection.pseudoElementSelectorsTypes else {
                    assertionFailure("Error: selection.pseudos is nil")
                    continue
                }
                
                if let pseudoSelectorType = self.lastPseudoElementSelectorType(from: pseudos) {
                    
                    if let support = selection.matchedElement?.supportsPseudo(with: pseudoSelectorType.rawValue), support {
                                            
                        let pseudoElement = selection.matchedElement!.pseudo(pseudoSelectorType.rawValue)!
                                            
                        // debugPrint("Adding pseudo element \(pseudoElement.localName), for element \(selection.matchedElement!.localName)")
                        // those elements should be resolved at rendering time. When we have access to
                        // string to render.
                        elements.append(pseudoElement)
                        
                        // TODO: see NW-446 for more information on what to do. Basically we should
                                            // warn the user in a way.
                        //                    else {
                        //
                        //                        #if DEBUG
                        //                            // it's possible for a region to not be defined e.g. <code> can be
                        //                            // created using indented code and also fenced code. In one case there is
                        //                            // opening-tag (fenced code) and the other the is no tag at all (indented code).
                        //                            // For the moment we throw a fatal error for any element type which does not define
                        //                            // the pseudo-element type for which we requesting styling, it's a debug facility.
                        //                            if selection.matchedElement!.localName != "code" /* not mandatory */
                        //                                && pseudoType != PseudoElementType.LinkLabel /* not mandatory */
                        //                                && pseudoType != PseudoElementType.LinkTitle /* not mandatory */
                        //                                && pseudoType != PseudoElementType.LinkDestination /* not mandatory */ {
                        //
                        //                                fatalError("No region defined in the element for the pseudo element type: \(§pseudoType)")
                        //                            }
                        //                        #else
                        //                            // FIXME: we should add an error somewhere
                        //                            debugPrint("not region defined in the element for the pseudo element type: \(§pseudoType)")
                        //                        #endif
                        //                    }
                    }
                }
            }
            else {
                
                /// It's possible that the matchedElement is nil since the complex selector
                /// could be empty..
                if let matchedElement = selection.matchedElement {
                    elements.append(matchedElement)
                }
            }
        }
        return elements
    }
    
    // SUPPORT FOR MULTIPLE PSEUDO ELEMENTS IS NOT NECESSARY OR EVEN STANDARD
    // make sure the host element defines the region of the pseudo element
    private func lastPseudoElementSelectorType(from pseudos: [PseudoSelectorType]) -> PseudoSelectorType? {
        
        guard let lastPseudoElement = pseudos.last else {
            return nil
        }
        
        guard lastPseudoElement.isPseudoElementSelector else {
            return nil
        }
        
        guard pseudos.count > 1 else {
            return lastPseudoElement
        }
        
        // ensure we dont have pseudo element after the first one
        for i in 0..<pseudos.count-1 {
            let pseudo = pseudos[i]
            if pseudo.isPseudoElementSelector {
                return nil
            }
        }
        return lastPseudoElement
    }
    
    private var _selectorText: String?
    
    ///
    /// > To serialize a comma-separated list concatenate all items of the list 
    /// > in list order while separating them by ", ", i.e., COMMA (U+002C) followed by a single SPACE (U+0020).
    ///
    /// [serialize a comma-separated list](https://drafts.csswg.org/cssom/#serialize-a-comma-separated-list)
    ///
    override public var selectorText: String {
        
        if _selectorText == nil {
        
            var selectorTextValue: String = ""
            if let firstSelector = selectorArray.first {
                selectorTextValue += firstSelector.selectorText
            }
            
            if selectorArray.count > 1 {
                for selectorIndex in 1..<selectorArray.count {
                    selectorTextValue += ", " + selectorArray[selectorIndex].selectorText
                }
            }
            _selectorText = selectorTextValue
        }
        return _selectorText!
    }
    
    func clone(_ parent: CSSRule?) -> SelectorList {
        
        let selectorListClone = SelectorList(parent: parent)
        
        for complexSelector in selectorArray {
            
            selectorListClone.appendComplexSelector(complexSelector.clone(selectorListClone))
        }
        return selectorListClone
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("before move selector list sourceStringFragment: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
        #endif
        
        self.sourceStringFragment?.move(count)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("after move selector list sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif
        
        for i in 0..<selectorArray.count {
            
            selectorArray[i].move(count)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {

        if let other = other {
        
            if let other = other as? SelectorList {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.selectorArray.count != other.selectorArray.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: selectorArray.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for (index, complexSelector) in self.selectorArray.enumerated() {
                    
                    let otherComplexSelector = other.selectorArray[index]
                    
                    if !complexSelector.equals(to: otherComplexSelector, comparePositions: comparePositions) {
                     
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: complexSelector are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not SelectorList.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Serializable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func serialize() -> String {
        
        return selectorText
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        return parent!.minimalCompilationUnit
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ChildNodeType = ComplexSelector
    
    func childIndexForChild(_ child: ComplexSelector) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override public func deleteAllChildren() {
        
        selectorArray.removeAll(keepingCapacity: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            for complexSelector in selectorArray {
                complexSelector.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
        
            visitor.push(nodeInfo)
            
            for complexSelector in selectorArray {
                complexSelector.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CustomStringConvertible protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var description: String {
        
        var _description = ""
        
        for (index, selector) in selectorArray.enumerated() {
            if index != selectorArray.count - 1 {
                _description += ", "
            }
            _description += selector.description
        }
        return _description
    }
    
    public override var selectorTextWithPositions: String {
        
        var _description = ""
        
        for (index, selector) in selectorArray.enumerated() {
            if index != selectorArray.count - 1 {
                _description += ", "
            }
            _description += selector.selectorTextWithPositions
        }
        return _description
    }
    
}





















