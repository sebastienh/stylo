//
//  ResourceComputedStyle+ComputedStyle.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-22.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension ResourceComputedStyle: ComputedStyle {
    
    public var paragraphStyle: [NSAttributedString.Key : Any]? {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        let value = self._paragraphStyle
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif 
        return value
    }
    
    public func updateParagraphStyle(withAttributes attributes: [NSAttributedString.Key : Any]) {
        
        #if CONCURENT_RENDERING
        lock.writeLock()
        #endif
        self._paragraphStyle = attributes
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
    }
    
    public func attributes(for element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]? {
        
        assert(!(element is PseudoElement))
        let styleIdentity: StyleIdentity = self.styleIdentity(for: element, filterContext: filterContext)
        return elementsAttributesCache.elementAttributes(forStyleIdentity: styleIdentity)
    }
    
    public func pseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> [[NSAttributedString.Key: Any]]? {
        
        let styleIdentity: StyleIdentity = {
            
            if self.containSiblingSelectors {
                let elements = ContiguousArray<Element>(arrayLiteral: element)
                let elementsApplicableRules: [Element: StyleApplicable] = computeElementsAplicableRules(for: elements, filterContext: filterContext)
                let applicable = elementsApplicableRules[element]
                let pseudoApplicable: StyleApplicable? = applicable?.pseudoRules[pseudoElement.localName]
                return self.pseudoElementStyleIdentity(for: pseudoElement, withElement: element, applicable: pseudoApplicable, filterContext: filterContext)
            }
            else {
                return self.pseudoElementStyleIdentity(for: pseudoElement, withElement: element, applicable: nil, filterContext: filterContext)
            }
        }()
        
        return elementsAttributesCache.elementAttributes(forStyleIdentity: styleIdentity)
    }
    
    /// A dictionary of all pseudo-elements associated with and element
    public func pseudoElements(for element: Element, filterContext: FilterContext) -> [PseudoElement]? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("elementStyleForElement for element %@ with id: %@", log: Log.Web.all, type: .info, %%element.localName, %%elementStyleCache.nonEphemeralStyle(forElement: element))
        os_log("evaluatedStyle for element %@ with id: %@", log: Log.Web.all, type: .info, %%element.localName, %%elementStyleCache.nonEphemeralStyle(forElement: element)?.evaluatedStyle)
        os_log("pseudoElements for element %@ with id: %@", log: Log.Web.all, type: .info, %%element.localName, %%elementStyleCache.nonEphemeralStyle(forElement: element)?.evaluatedStyle.pseudoElements)
        #endif

        let styleIdentity = self.styleIdentity(for: element, filterContext: filterContext)

        guard let elementStyle = elementStyleCache.elementStyle(forStyleIdentity: styleIdentity) else {
            //                assertionFailure("Error: elementStyle is nil")
            return nil
        }

        return elementStyle.evaluatedStyle.pseudoElements
    }
    
    /// This method will compute the ephemeral style for an element. An ephemeral
    /// style might
    ///
    public func evaluateEphemeralStyle(for element: Element, filterContext: FilterContext) {
    
        let elements = ContiguousArray<Element>(element.inclusiveAncestorsElements)
        evaluateStyleIfNeeded(for: elements, filterContext: filterContext)
    }
    
    public func computedStyle(forElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration?  {
    
        assert(!(element is PseudoElement))
        return elementStyle(forElement: element, filterContext: filterContext)?.rawComputedStyle
    }
    
    public func computedStyle(forPseudoElement pseudoElement: PseudoElement, withElement element: Element, filterContext: FilterContext) -> ComputedStyleDeclaration? {
    
        let styleIdentity = self.styleIdentity(for: element, filterContext: filterContext)
        let pseudoClassesOptions = filterContext.pseudoClassesOptions(forElement: element)

        guard let elementStyle = elementStyleCache.elementStyle(forStyleIdentity: styleIdentity)?.evaluatedStyle else {
            assertionFailure("Error: elementStyle is nil")
            return nil
        }

        guard let pseudoElementStyle = elementStyle.pseudoElementStyle(withName: pseudoElement.localName, pseudoClassesOptions: pseudoClassesOptions) else {
            assertionFailure("Error: pseudoElementsStyle is nil")
            return nil
        }

        return pseudoElementStyle
    }
    
    public func updateAttributes(for element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext) {
        
        assert(!(element is PseudoElement))
        let styleIdentity: StyleIdentity = self.styleIdentity(for: element, filterContext: filterContext)

        if elementsAttributesCache.elementAttributes(forStyleIdentity: styleIdentity) == nil {

            var attributes = Array<[NSAttributedString.Key: Any]>(repeating: [NSAttributedString.Key: Any](), count: 2)
            attributes[§AttributesType.text] = textAttributes
            if let decorationAttributes = decorationAttributes {
                attributes[§AttributesType.decoration] = decorationAttributes
            }

            elementsAttributesCache.setAttributes(attributes, forStyleIdentity: styleIdentity)
        }
    }
    
    public func updatePseudoAttributes(for pseudoElement: PseudoElement, withElement element: Element, with textAttributes: [NSAttributedString.Key: Any], andDecorationAttributes decorationAttributes: [NSAttributedString.Key: Any]?, filterContext: FilterContext) {
        
        let styleIdentity: StyleIdentity = {
            if self.containSiblingSelectors {
                let elements = ContiguousArray<Element>(arrayLiteral: element)
                let elementsApplicableRules: [Element: StyleApplicable] = computeElementsAplicableRules(for: elements, filterContext: filterContext)
                let applicable = elementsApplicableRules[element]
                let pseudoApplicable: StyleApplicable? = applicable?.pseudoRules[pseudoElement.localName]
                return self.pseudoElementStyleIdentity(for: pseudoElement, withElement: element, applicable: pseudoApplicable, filterContext: filterContext)
            }
            else {
                return self.pseudoElementStyleIdentity(for: pseudoElement, withElement: element, applicable: nil, filterContext: filterContext)
            }
        }()

        if elementsAttributesCache.elementAttributes(forStyleIdentity: styleIdentity) == nil {

            var attributes = Array<[NSAttributedString.Key: Any]>(repeating: [NSAttributedString.Key: Any](), count: 2)
            attributes[§AttributesType.text] = textAttributes
            if let decorationAttributes = decorationAttributes {
                attributes[§AttributesType.decoration] = decorationAttributes
            }

            elementsAttributesCache.setAttributes(attributes, forStyleIdentity: styleIdentity)
        }
    }
    
}
