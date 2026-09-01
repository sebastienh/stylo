//
//  ResourceComputedStyle+Identities.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension ResourceComputedStyle {
    
    func pseudoElementStyleIdentity(for pseudoElement: PseudoElement, withElement element: Element, applicable: StyleApplicable?, filterContext: FilterContext) -> StyleIdentity {
  
        #if CONCURENT_RENDERING
        lock.writeLock()
        #endif
        let treePseudoClassesIdentity = pseudoElement.treePseudoClassesIdentity(withElement: element, filterContext: filterContext)
        let treePositionIdentity = self.treePositionIdentity(for: pseudoElement, withElement: element)
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif

        if let styleIdentity = self.styleIdentitiesCache.styleIdentity(forTreePositionIdentity: treePositionIdentity, treePseudoClassesIdentity: treePseudoClassesIdentity) {
            return styleIdentity
        }

        let associatedElementStyleIdentity = self.styleIdentity(for: element, filterContext: filterContext, computeRules: false)
        let styleIdentity = StyleIdentity(node: pseudoElement, applicableRules: applicable?.rules, associatedElementStyleIdentity: associatedElementStyleIdentity, withElement: element)
        self.styleIdentitiesCache.addStyleIdentity(styleIdentity, toTreePositionIdentity: treePositionIdentity, for: treePseudoClassesIdentity)
        return styleIdentity
    }
    
    func styleIdentity(for element: Element, filterContext: FilterContext, rules: [CSSStyleRule]? = nil, computeRules: Bool = true) -> StyleIdentity {
        
        if self.containSiblingSelectors {

            let rules: [CSSStyleRule]? = {
                if let rules = rules {
                    return rules
                }
                else if computeRules {
                    let elements = ContiguousArray<Element>(arrayLiteral: element)
                    let elementApplicableRules: [Element: StyleApplicable] = self.computeElementsAplicableRules(for: elements, filterContext: filterContext)
                    guard let styleApplicable = elementApplicableRules[element] else {
                        return nil
                    }
                    return styleApplicable.allRules
                }
                return nil
            }()

            return self._siblingIdentity(for: element, rules: rules, filterContext: filterContext)
        }
        else {

            #if CONCURENT_RENDERING
            lock.writeLock()
            #endif
            let treePseudoClassesIdentity = element.treePseudoClassesIdentity(withFilterContext: filterContext)
            let treePositionIdentity = self.treePositionIdentity(for: element)
            #if CONCURENT_RENDERING
            lock.unlock()
            #endif

            if let styleIdentity = self.styleIdentitiesCache.styleIdentity(forTreePositionIdentity: treePositionIdentity, treePseudoClassesIdentity: treePseudoClassesIdentity) {
                return styleIdentity
            }

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("treePseudoClassesIdentity: %@", log: Log.Web.all, type: .debug, %%treePseudoClassesIdentity)
            os_log("treePositionIdentity: %@", log: Log.Web.all, type: .debug, %%treePositionIdentity)
            #endif
            
            let styleIdentity = StyleIdentity(treePseudoClassesIdentity: treePseudoClassesIdentity, treePositionIdentity: treePositionIdentity)
            self.styleIdentitiesCache.addStyleIdentity(styleIdentity, toTreePositionIdentity: treePositionIdentity, for: treePseudoClassesIdentity)
            return styleIdentity
        }
        
    }
    
    private func _siblingIdentity(for element: Element, rules: [CSSStyleRule]?, filterContext: FilterContext) -> StyleIdentity {
        
        assert(!(element is PseudoElement))
        let parentElement = element.parentElement
        
        if let parentElement = parentElement {
            
            let parentStyleIdentity = self.styleIdentity(for: parentElement, filterContext: filterContext, computeRules: true)
            
            // this is the backup but this is highly prone to errors
            return StyleIdentity(node: element, applicableRules: rules, parentStyleIdentity: parentStyleIdentity)
        }
        
        return StyleIdentity(node: element, applicableRules: rules, parentStyleIdentity: nil)
    }
    
}
