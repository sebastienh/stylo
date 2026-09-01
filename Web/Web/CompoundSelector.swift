//
//  CompoundSelector.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/#compound
// A compound selector is a sequence of simple selectors that
// are not separated by a combinator. If it contains a type
// selector or universal selector, that selector comes first in
// the sequence. Only one type selector or universal selector
// is allowed in the sequence.
public class CompoundSelector: BaseSelector, SelectorChainLink, ComplexSelectorChild {
    
    var simpleSelectorSequence: [SimpleSelector]
    
    // link to the next compound selector
    weak var combinator: SelectorCombinator?
    
    var rightmostSelectorType: RightmostSelectorType? {

        return self.simpleSelectorSequence.last?.selectorType
    }
    
    public var containsFlashPseudoClass: Bool {
        for simpleSelector in simpleSelectorSequence {
            if let pseudoClassSelector = simpleSelector as? IdentPseudoClass, pseudoClassSelector.name == §PseudoSelectorType.flash {
                return true
            }
        }
        return false
    }

    public var containsFocusPseudoClass: Bool {
        for simpleSelector in simpleSelectorSequence {
            if let pseudoClassSelector = simpleSelector as? IdentPseudoClass, pseudoClassSelector.name == §PseudoSelectorType.focus {
                return true
            }
        }
        return false
    }
    
    public var containsFadePseudoClass: Bool {
        for simpleSelector in simpleSelectorSequence {
            if let pseudoClassSelector = simpleSelector as? IdentPseudoClass, pseudoClassSelector.name == §PseudoSelectorType.fade {
                return true
            }
        }
        return false
    }
    
    public var pseudoClassesOptions: PseudoClassesOptions {
        
        var pseudoClassesOptions: PseudoClassesOptions = []
        for simpleSelector in simpleSelectorSequence {
            if let ephemeralPseudoClass = simpleSelector.ephemeralPseudoClass {
                pseudoClassesOptions.insert(ephemeralPseudoClass)
            }
        }
        return pseudoClassesOptions
    }
    
    public var containsEmphemeralPseudoClasses: Bool {
        for simpleSelector in simpleSelectorSequence {
            if let pseudoClassSelector = simpleSelector as? IdentPseudoClass, pseudoClassSelector.isEphemeral {
                return true
            }
        }
        return false
    }
    
    init(sourceStringSegment: SourceStringSegment?, parent: ComplexSelector?) {
        
        self.simpleSelectorSequence = [SimpleSelector]()
        super.init(sourceStringSegment: sourceStringSegment)
        
        self.parent = parent
    }
    
    public subscript(index: Int) -> SimpleSelector {
        
        return simpleSelectorSequence[index]
    }
    
    // sometime we dont have access to the position but we need to create
    // a CompoundSelector anyway, this is the way to do it
    convenience init() {
        
        self.init(sourceStringSegment: nil, parent: nil)
    }
 
    func exclusivelyContainsEmphemeralPseudoClasses(_ pseudoClassesOptions: PseudoClassesOptions) -> Bool {
        if self.containsEmphemeralPseudoClasses {
            return self.pseudoClassesOptions == pseudoClassesOptions
        }
        return true
    }
    
    func clone(_ parent: ComplexSelector) -> CompoundSelector {
        
        let compoundSelectorClone = CompoundSelector(sourceStringSegment: nil, parent: parent)
        
        for simpleSelector in simpleSelectorSequence {
            
            compoundSelectorClone.insertSelector(simpleSelector.clone(compoundSelectorClone))
        }
        
        return compoundSelectorClone
    }
    
    // Method to insert a simple selector in the simple
    // selector sequence of this compound selector
    @discardableResult
    func insertSelector(_ selector: SimpleSelector) -> Bool {
        
        // If it contains a type selector or universal selector, 
        // that selector comes first in the sequence.
        if simpleSelectorSequence.count != 0 {
            
            if let _ = selector as? TypeSelector {
                // TODO : error handling mecanisme
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("TypeSelector only allowed in first position of sequence", log: Log.Web.all, type: .error)
                #endif
                return false
            }
        }
        
        simpleSelectorSequence.append(selector)
        return true
    }
    
    func deleteSelector(_ selector: SimpleSelector) {
        
        if simpleSelectorSequence.count != 0 {
         
            var indexToDelete: Int?
            
            for (index, existingSimpleSelector) in simpleSelectorSequence.enumerated() {
                
                if selector == existingSimpleSelector {
                    
                    indexToDelete = index
                    break
                }
            }
            
            if let indexToDelete = indexToDelete {
                
                simpleSelectorSequence.remove(at: indexToDelete)
            }
            
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Selector protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func calculateSpecificity(_ selectorSpecificity: SelectorSpecificity) {
        
        for simpleSelector in simpleSelectorSequence {
            
            simpleSelector.calculateSpecificity(selectorSpecificity)
        }
    }
    
    override public var selectorText: String {
    
        var selectorTextValue: String = ""
        
        for simpleSelector in simpleSelectorSequence {
            selectorTextValue += simpleSelector.selectorText
        }
        
        if let selectorCombinator = combinator {
            selectorTextValue += selectorCombinator.selectorText
        }
        
        return selectorTextValue
    }
    
    public override var selectorTextWithPositions: String {
        
        var selectorTextValue: String = ""
        
        for simpleSelector in simpleSelectorSequence {
            selectorTextValue += simpleSelector.selectorTextWithPositions
        }
        
        if let selectorCombinator = combinator {
            selectorTextValue += selectorCombinator.selectorTextWithPositions
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
        
        for i in 0..<simpleSelectorSequence.count {
            
            simpleSelectorSequence[i].move(count)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? CompoundSelector {
            
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.simpleSelectorSequence.count != other.simpleSelectorSequence.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: simpleSelectorSequence.count  are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                for (index, simpleSelector) in self.simpleSelectorSequence.enumerated() {
                    
                    let otherSimpleSelector = other.simpleSelectorSequence[index]
                    
                    if !simpleSelector.equals(to: otherSimpleSelector, comparePositions: comparePositions) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: simpleSelector element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if let combinator = self.combinator {
                    
                    if let otherCombinator = other.combinator {
                        
                        if !combinator.equals(to: otherCombinator, comparePositions: comparePositions) {
                            
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: combinator are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other combinator is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else {
                    
                    if other.combinator != nil {
                     
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other combinator is not nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CompoundSelector.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: Compilable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var minimalCompilationUnit: CSSOMLanguageObject {
        
        return parent!.minimalCompilationUnit
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CommonTreeOperable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ChildNodeType = SimpleSelector
    
    func childIndexForChild(_ child: SimpleSelector) -> Int? {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("childIndexForChild(...) missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return nil
    }
    
    override public func deleteAllChildren() {
        
        self.simpleSelectorSequence.removeAll(keepingCapacity: true)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSSelectorListVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func accept(_ visitor: CSSSelectorListVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
            
            visitor.push(nodeInfo)
            
            for selector in simpleSelectorSequence {
                
                selector.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public func accept(_ visitor: CSSVisitor) {
        
        if let nodeInfo = visitor.visit(self) {
        
            visitor.push(nodeInfo)
            
            for selector in simpleSelectorSequence {
                
                selector.accept(visitor)
            }
            visitor.pop()
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: SelectorChainLink protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func constructReverseEvaluatorChain(_ selectorEvaluatorChain: inout SelectorEvaluatorChain) {
    
        // this iterates through all selectors (compound and combinator selectors)
        // in the context object in reverse order.
        for selector in simpleSelectorSequence.reversed() {
            
            if let selector = selector as? EvaluableSelector {
                
                // construct the SelectorEvaluatorChain
                selector.constructReverseEvaluatorChain(&selectorEvaluatorChain)
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func ==(lhs: CompoundSelector, rhs: CompoundSelector) -> Bool {
    
    if lhs.simpleSelectorSequence.count != rhs.simpleSelectorSequence.count {
        
        return false
    }
    
    for (index, lshSimpleSelector) in lhs.simpleSelectorSequence.enumerated() {
     
        let rhsSimpleSelector = rhs.simpleSelectorSequence[index]
            
        if lshSimpleSelector != rhsSimpleSelector {
                
            return false
        }
    }
    
    return true
}




