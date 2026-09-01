//
//  ComplexSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#complex
// A complex selector is a sequence of one or more
// compound selectors separated by combinators.
public class ComplexSelector: BaseSelector, SelectorChainLink, CustomStringConvertible {
    
    var preparedSelectorChain: SelectorEvaluatorChain?
    
    var precedingCommaToken: Token?
    
    public internal(set) var compoundSelectorList: [CompoundSelector]
    public internal(set) var combinatorList: [SelectorCombinator]
    
    public var containsFlashPseudoClass: Bool {
        for compoundSelector in compoundSelectorList {
            if compoundSelector.containsFlashPseudoClass {
                return true
            }
        }
        return false
    }
    
    public var containsFocusPseudoClass: Bool {
        for compoundSelector in compoundSelectorList {
            if compoundSelector.containsFocusPseudoClass {
                return true
            }
        }
        return false
    }
    
    public var containsFadePseudoClass: Bool {
        for compoundSelector in compoundSelectorList {
            if compoundSelector.containsFadePseudoClass {
                return true
            }
        }
        return false
    }
    
    public var containsEmphemeralPseudoClasses: Bool {
        for compoundSelector in compoundSelectorList {
            if compoundSelector.containsEmphemeralPseudoClasses {
                return true
            }
        }
        return false
    }
    
    private var _rightmostSelectorType: RightmostSelectorType?
    
    var rightmostSelectorType: RightmostSelectorType {
        
        if _rightmostSelectorType == nil {
            
            if let lastCompoundSelector = compoundSelectorList.last {
                
                if let lastSimpleSelector = lastCompoundSelector.simpleSelectorSequence.last {
                    
                    _rightmostSelectorType = lastSimpleSelector.selectorType
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("lastSimpleSelector is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("lastCompoundSelector is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        return _rightmostSelectorType!
    }
    
    /// see http://dev.w3.org/csswg/selectors-4/#specificity
    private var _specificity: SelectorSpecificity?
    
    /// Return the selector specificity as calculated according
    /// to CSS Selector module specification.
    /// see http://dev.w3.org/csswg/selectors-4/#specificity
    public var selectorSpecificity: SelectorSpecificity {
        
        if _specificity == nil {
            let complexSelectorSpecificity = SelectorSpecificity()
            for compoundSelector in compoundSelectorList {
                let compoundSelectorSpecificity = SelectorSpecificity()
                compoundSelector.calculateSpecificity(compoundSelectorSpecificity)
                complexSelectorSpecificity.add(compoundSelectorSpecificity)
            }
            self._specificity = complexSelectorSpecificity
        }
        return _specificity!
    }
    
    lazy var emptyContextSelectorEvaluatorChain: SelectorEvaluatorChain = {
        
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: nil, scopingMethod: nil)

        // construct the SelectorEvaluatorChain
        self.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        return selectorEvaluatorChain
    }()
    
    init(sourceStringSegment: SourceStringSegment?, parent: SelectorList?) {
        
        self.compoundSelectorList = [CompoundSelector]()
        self.combinatorList = [SelectorCombinator]()
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parent
    }
    
    // sometime we dont have access to the position but we need to create 
    // a ComplexSelector anyway, this is the way to do it
    convenience init() {
        
        self.init(sourceStringSegment: nil, parent: nil)
    }
    
    /// 
    func exclusivelyContainsEmphemeralPseudoClasses(_ pseudoClassesOptions: PseudoClassesOptions) -> Bool {
        
        #if DEBUG
        guard self.containsEmphemeralPseudoClasses else {
            assertionFailure("Error: we should call this method if we already know it does not contain ephemeral pseudo classes")
            return true
        }
        #endif
        
        for compoundSelector in compoundSelectorList {
            if !compoundSelector.exclusivelyContainsEmphemeralPseudoClasses(pseudoClassesOptions) {
                return false
            }
        }
        return true
    }
    
    func clone(_ parent: SelectorList? = nil) -> ComplexSelector {
        
        let complexSelectorClone = ComplexSelector(sourceStringSegment: nil, parent: parent)
        
        var previousSelectorCombinator: SelectorCombinator? = nil
        
        for compoundSelector in compoundSelectorList {
            
            let compoundSelectorClone = compoundSelector.clone(complexSelectorClone)
            
            complexSelectorClone.addCompoundSelector(compoundSelectorClone)
            
            if let _previousSelectorCombinator = previousSelectorCombinator {
                
                _previousSelectorCombinator.rightCompoundSelector = compoundSelectorClone
                previousSelectorCombinator = nil
            }
            
            if let combinator = compoundSelector.combinator {
                
                let combinatorClone = combinator.clone(complexSelectorClone)
                complexSelectorClone.addCombinator(combinatorClone)
                
                combinatorClone.leftCompoundSelector = compoundSelectorClone
                
                compoundSelectorClone.combinator = combinatorClone
                
                previousSelectorCombinator = combinatorClone
            }
        }
        return complexSelectorClone
    }
    
    func addCompoundSelector(_ compoundSelector: CompoundSelector) {
        
        // if there is already a compound select in the list
        // it means we also have a combinator
        if let lastCompoundSelector = compoundSelectorList.last {
            
            if let lastCombinator = combinatorList.last {
                
                lastCombinator.leftCompoundSelector = lastCompoundSelector
                lastCombinator.rightCompoundSelector = compoundSelector
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Adding two compound selector but there is no combinator, the selector parser should have validated this.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        compoundSelectorList.append(compoundSelector)
    }
    
    func addCombinator(_ combinator: SelectorCombinator) {
        
        if let lastCompoundSelector = compoundSelectorList.last {
         
            lastCompoundSelector.combinator = combinator
            combinatorList.append(combinator)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Adding a combinator but there is no compound selector defined yet, the selector parser should have validated this.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    func deleteCombinator(_ combinator: SelectorCombinator) {
     
        var indexToDelete: Int?
        
        for (index, existingCombinator) in combinatorList.enumerated() {
            
            if combinator == existingCombinator {
                
                indexToDelete = index
                break
            }
        }
        
        assert(indexToDelete != nil, "indexToDelete can not be nil.")
        if let indexToDelete = indexToDelete {
            
            combinator.leftCompoundSelector?.combinator = nil
        }
    }
    
    ///
    /// [serialize a selector](https://drafts.csswg.org/cssom/#serialize-a-selector)
    ///
    override public var selectorText: String {
        
        var selectorTextValue: String = ""
        
        // > If there is only one simple selector in the compound selectors which is a universal selector,
        // > append the result of serializing the universal selector to s.
        if compoundSelectorList.count == 1, let firstCompoundSelector = compoundSelectorList.first, firstCompoundSelector.simpleSelectorSequence.count == 1, let firstSimpleSelector = firstCompoundSelector.simpleSelectorSequence.first as? TypeSelector , firstSimpleSelector.universal {
            
            selectorTextValue += firstSimpleSelector.serialize()
        }
        else {
            
            
        }

        if let firstCompoundSelector = compoundSelectorList.first {
    
             selectorTextValue += firstCompoundSelector.selectorText
        }    
        return selectorTextValue
    }

    public override var selectorTextWithPositions: String {
        
        var selectorTextValue: String = ""
        
        // > If there is only one simple selector in the compound selectors which is a universal selector,
        // > append the result of serializing the universal selector to s.
        if compoundSelectorList.count == 1, let firstCompoundSelector = compoundSelectorList.first, firstCompoundSelector.simpleSelectorSequence.count == 1, let firstSimpleSelector = firstCompoundSelector.simpleSelectorSequence.first as? TypeSelector , firstSimpleSelector.universal {
            
            selectorTextValue += firstSimpleSelector.selectorTextWithPositions
        }
        else {
            
            
        }

        if let firstCompoundSelector = compoundSelectorList.first {
    
             selectorTextValue += firstCompoundSelector.selectorTextWithPositions
        }
        return selectorTextValue
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("before move sourceStringFragment: %@, sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
        #endif

        self.sourceStringFragment?.move(count)

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("after move sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif
        
        for i in 0..<compoundSelectorList.count {
            
            compoundSelectorList[i].move(count)
        }
        
        for i in 0..<combinatorList.count {
            
            combinatorList[i].move(count)
        }
        
        precedingCommaToken?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
       
        if let other = other {
            
            if let other = other as? ComplexSelector {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.compoundSelectorList.count != other.compoundSelectorList.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: compoundSelectorList.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for (index, compoundSelector) in self.compoundSelectorList.enumerated() {
                    
                    let otherCompoundSelector = other.compoundSelectorList[index]
                    
                    if !compoundSelector.equals(to: otherCompoundSelector) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: compoundSelector element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                for (index, selectorCombinator) in self.combinatorList.enumerated() {
                    
                    let otherSelectorCombinator = other.combinatorList[index]
                    
                    if !selectorCombinator.equals(to: otherSelectorCombinator) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: selector combinator element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ComplexSelector.", log: Log.Web.all, type: .debug)
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
    
    public func serializeWithPositions() {
        
        
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
    
    typealias ChildNodeType = ComplexSelectorChild
    
    func childIndexForChild(_ child: ComplexSelectorChild) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override public func deleteAllChildren() {
        
        self.compoundSelectorList.removeAll(keepingCapacity: true)
        self.combinatorList.removeAll(keepingCapacity: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        if let nodeInfo = visitor.visit(self) , nodeInfo.visitChildren {
            
            visitor.push(nodeInfo)
            
            for selector in self {
                
                selector.accept(visitor)
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
            
            for selector in self {
                
                selector.accept(visitor)
            }
            
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectorChainLink protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func reverseEvaluatorChain(withFilterContext filterContext: FilterContext, scopingRootFilter: ((SelectorSelection) -> Bool)? = nil, stylesheet: CSSStyleSheet?, scopingMethod: ScopingMethod? = nil) -> SelectorEvaluatorChain {
    
        // create the SelectorEvaluatorChain if necessary
        if let preparedSelectorChain = self.preparedSelectorChain {
            return preparedSelectorChain
        }
        
        var selectorEvaluatorChain = SelectorEvaluatorChain(scopingRootFilter: scopingRootFilter, scopingMethod: scopingMethod)
    
        // construct the SelectorEvaluatorChain
        self.constructReverseEvaluatorChain(&selectorEvaluatorChain)
        self.preparedSelectorChain = selectorEvaluatorChain
        return selectorEvaluatorChain
    }
    
    public func constructReverseEvaluatorChain(_ selectorEvaluatorChain: inout SelectorEvaluatorChain) {
    
        // this iterates through all selectors (compound and combinator selectors)
        // in the context object. starting from the final selector.
        for selector in self.reversed() {
            
            // construct the SelectorEvaluatorChain
            (selector as! SelectorChainLink).constructReverseEvaluatorChain(&selectorEvaluatorChain)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CustomStringConvertible protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var description: String {
        
        return serialize()
    }
    
}
