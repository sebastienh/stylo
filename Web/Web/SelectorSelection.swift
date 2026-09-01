//
//  SelectorSelection.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-06.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

struct SelectorSelection: CustomStringConvertible, Hashable {
    
    var description: String {
        
        var string = """
        SelectorSelection:
            elementToEvaluate: \(elementToEvaluate.localName)
            matchedElement: \(matchedElement?.localName ?? "nil")
        """

        if let pseudos = self.pseudoElementSelectorsTypes {
            for pseudo in pseudos {
                string += "\(pseudo.rawValue)\n"
            }
        }
        return string
    }
    
    ///
    /// Contains the element that should be evaluated by this selector.
    ///
    let elementToEvaluate: Element
    
    ///
    /// matchedElement could be nil, it indicates the selector to fill it with the current element and
    /// if it is a pseudo selector, set the proper pseudo element type.
    ///
    let matchedElement: Element?
    
    ///
    /// filled by pseudo element selector if the pseudo element selector is 
    /// called with no matched element.
    
    /// This is the list of pseudos elements that are
    /// associated with this selection.
    ///
    /// Note: remember that this value is kept to
    /// filter which elements are affected by a style declaration.
    /// Not keeping a pseudo-class here does not mean it will not be
    /// used...
    ///
    let pseudoElementSelectorsTypes: [PseudoSelectorType]?
    
    init(elementToEvaluate: Element, matchedElement: Element? = nil, pseudo: PseudoSelectorType? = nil) {
        
        self.elementToEvaluate = elementToEvaluate
        self.matchedElement = matchedElement
        
        if let pseudo = pseudo {
            self.pseudoElementSelectorsTypes = [pseudo]
        }
        else {
            self.pseudoElementSelectorsTypes = nil
        }
    }

    private init(elementToEvaluate: Element, matchedElement: Element? = nil, pseudos: [PseudoSelectorType]?) {
        
        self.elementToEvaluate = elementToEvaluate
        self.matchedElement = matchedElement
        self.pseudoElementSelectorsTypes = pseudos
    }
    
    static func ==(lhs: SelectorSelection, rhs: SelectorSelection) -> Bool {
        
        if lhs.elementToEvaluate !== rhs.elementToEvaluate {
            return false
        }
        if let matchedElement = lhs.matchedElement {
            if let _matchedElement = rhs.matchedElement {
                if matchedElement !== _matchedElement {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            if rhs.matchedElement != nil {
                return false
            }
        }
        
        if let pseudoElementSelectors = lhs.pseudoElementSelectorsTypes {
            if let _pseudoElementSelectors = rhs.pseudoElementSelectorsTypes {
                if pseudoElementSelectors != _pseudoElementSelectors {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            if rhs.matchedElement != nil {
                return false
            }
        }

        return true
    }
    
    /// Erase pseudo element could be set to true when a filteringPseudo is applied. Since this kind
    /// of pseudo is evaluated in line, we don't need to keep it beacause it will never be "created"
    /// This case happens after evaluation of ::before and ::after pseudo elements.
    func create(fromNewElementToEvaluate elementToEvaluate: Element, pseudo: PseudoSelectorType? = nil, erasePseudoElement: Bool = false) -> SelectorSelection {
        
        if let matchedElement = matchedElement {
            
            /// If there is already a match, meaning it's not the last selector, we just copy the match.
            /// The match could contain a pseudo element type or not, but at this point we can't assert anything.
            if erasePseudoElement {
                
                return SelectorSelection(elementToEvaluate: elementToEvaluate, matchedElement: matchedElement, pseudo: nil)
            }
            else {
                
                let pseudos = self.updatedPseudos(withPseudo: pseudo)
                return SelectorSelection(elementToEvaluate: elementToEvaluate, matchedElement: matchedElement, pseudos: pseudos)
            }
        }
        else if let pseudo = pseudo {
            
            // we are in the case were there is no match yet, and we have encountered as the first selector to evaluate
            // (again it's in reverse order) a pseudo selector. In this case we set the pseudo element type.
            assert(matchedElement == nil)
            
            let pseudos = self.updatedPseudos(withPseudo: pseudo)
            return SelectorSelection(elementToEvaluate: elementToEvaluate, matchedElement: elementToEvaluate, pseudos:  pseudos)
        }
        else {
            
            assert(matchedElement == nil)
            return SelectorSelection(elementToEvaluate: elementToEvaluate, matchedElement: elementToEvaluate, pseudos: self.pseudoElementSelectorsTypes)
        }
    }
    
    private func updatedPseudos(withPseudo pseudo: PseudoSelectorType?) -> [PseudoSelectorType] {
        
        guard pseudo?.isPseudoElementSelector == true else {
            return self.pseudoElementSelectorsTypes ?? []
        }
        
        var pseudos: [PseudoSelectorType] = []
        if let _pseudos = self.pseudoElementSelectorsTypes {
            pseudos = _pseudos
        }
        if let pseudo = pseudo {
            pseudos.append(pseudo)
        }
        return pseudos
    }
    
}
