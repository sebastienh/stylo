//
//  StyleApplicable.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-17.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

/// This object keeps everything that is necessary to evaluate
/// the style of an element.
class StyleApplicable {
    
    /// For each rule which match, we keep the list of complex selectors
    /// that were selecting the element. This is used later when
    /// evaluating the selectors specificity for a rule, since
    /// selector list do not have specificity we need to keep
    /// the complex selectors to know the specificity.
    var rulesComplexSelectors: [[ComplexSelector]] {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._rulesComplexSelectors
    }
    
    /// We need this second array to keep the order
    var rules: [CSSStyleRule] {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._rules
    }
    
    var pseudos: [PseudoElement]? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._pseudos
    }
    
    var pseudoRules: [String: StyleApplicable] {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._pseudoRules
    }
    
    /// We need to use all the rules applicable to an element (or
    /// its pseudo elements to define a style identity with following
    /// sibling selectors. 
    var allRules: [CSSStyleRule] {
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        return self._rules + self._pseudoRules.flatMap({ (arg) -> [CSSStyleRule] in
            arg.value.allRules
        })
    }
    
    #if CONCURENT_RENDERING
    private let lock: ReadWriteLock
    #endif
    
    private var _pseudos: [PseudoElement]?
    
    private var _pseudoRules: [String: StyleApplicable]
    
    private var _rules: [CSSStyleRule]
    
    private var _rulesComplexSelectors: [[ComplexSelector]]
    
    init() {
        
        self._rules = [CSSStyleRule]()
        self._rulesComplexSelectors = [[ComplexSelector]]()
        self._pseudoRules = [String: StyleApplicable]()
        #if CONCURENT_RENDERING
        self.lock = ReadWriteLock()
        #endif
    }
    
    /// This method merges together this StyleApplicable with
    /// the other StyleApplicable. This operation has to be done
    /// before the style evaluation.
    func merge(with other: StyleApplicable) {
        
        self.addRules(rules: other.rules, rulesComplexSelectors: other.rulesComplexSelectors)
        self.addPseudos(other.pseudos)
        
        if let otherPseudos = other.pseudos {
            
            for otherPseudo in otherPseudos {
                
                let pseudoApplicable = other.pseudoRules[otherPseudo.localName]
                
                assert(pseudoApplicable != nil)
                if let pseudoApplicable = pseudoApplicable {
                
                    let rules = self._pseudoRules[otherPseudo.localName]
                    
                    // we don't have this pseudo here
                    if rules == nil {
                        
                        self._pseudoRules[otherPseudo.localName] = pseudoApplicable
                    }
                    else {
                        
                        // we need to merge
                        self._pseudoRules[otherPseudo.localName]!.merge(with: pseudoApplicable)
                    }
                }
            }
        }
    }
    
    private func addPseudos(_ pseudos: [PseudoElement]) {
        
        for pseudo in pseudos {
            addPseudo(pseudo)
        }
    }
    
    func addPseudo(_ pseudo: PseudoElement) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        if pseudos == nil {
            self._pseudos = [PseudoElement]()
        }
        
        if currentPseudo(for: pseudo.localName) == nil {
            self._pseudos!.append(pseudo)
            self._pseudoRules[pseudo.localName] = StyleApplicable()
        }
    }
    
    func addPseudoRule(_ pseudo: PseudoElement, rule: CSSStyleRule, complexSelectors: [ComplexSelector]) {
        
        assert(self.pseudoRules[pseudo.localName] != nil)
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        self._pseudoRules[pseudo.localName]!.addRule(rule, complexSelectors: complexSelectors)
    }
    
    func addPseudoRules(_ pseudo: PseudoElement, rules: [CSSStyleRule], rulesComplexSelectors: [[ComplexSelector]]) {
        
        assert(self.pseudoRules[pseudo.localName] != nil)
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        self._pseudoRules[pseudo.localName]!.addRules(rules: rules, rulesComplexSelectors: rulesComplexSelectors)
    }
    
    func addPseudos(_ pseudos: [PseudoElement]?) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        if self._pseudos == nil {
            self._pseudos = [PseudoElement]()
        }
        
        if let pseudos = pseudos {
            self._pseudos!.append(contentsOf: pseudos)
        }
    }
    
    func addRule(_ rule: CSSStyleRule, complexSelectors: [ComplexSelector]) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        assert(self.rules.count == self.rulesComplexSelectors.count)
        _rulesComplexSelectors.append(complexSelectors)
        _rules.append(rule)
        assert(self.rules.count == self.rulesComplexSelectors.count)
    }
    
    private func addRules(rules: [CSSStyleRule], rulesComplexSelectors: [[ComplexSelector]]) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        defer {
            lock.unlock()
        }
        #endif
        assert(self.rules.count == self.rulesComplexSelectors.count)
        assert(rules.count == rulesComplexSelectors.count)

        for rulesComplexSelectorsArray in rulesComplexSelectors {
            
            // all style rules are supposed to have a different key
            // and since we process applicable rules on a stylesheet basis
            // a style rule found in one stylesheet is not supposed to be found
            // in another stylesheet... Remember that we process the stylesheets
            // from the user-agent, to the authors, going up to the user.
            self._rulesComplexSelectors.append(rulesComplexSelectorsArray)
        }
    
        for rule in rules {
            self._rules.append(rule)
        }
        assert(self.rules.count == self.rulesComplexSelectors.count)
    }
    
    private func currentPseudo(for localName: String) -> PseudoElement? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        defer {
            lock.unlock()
        }
        #endif
        if let pseudos = _pseudos {
            for pseudo in pseudos {
                if pseudo.localName == localName {
                    return pseudo
                }
            }
        }
        return nil
    }
}
