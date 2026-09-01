//
//  StyleDefinition.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

public enum ContainsSiblingSelectorResult {
    
    case none
    case next
    case following
    case both
}

/// StyleDefinition protocol defines what can be used by all the cascading
/// code and everything that needs to access a style.
public protocol StyleDefinition: HtmlStyleQueryable {
    
    /// This variable is used is order to know if we can just
    /// calculate render style for the modified elements or
    /// we need to recompute everything. The presence of next sibling
    /// or following siblings selector makes it effectively impossible
    /// to know which element styles will be modified.
    var containFollowingSiblingSelectors: Bool { get }
    
    /// This dynamic property returns all the following siblings
    /// top element CompoundSelectorm.
    var followingSiblingSelectorsTopCompoundSelectors: [CompoundSelector] { get }
    
    /// This variable is used to to know if there is any next sibling
    /// selector defined in the style.
    var containNextSiblingSelector: Bool { get }
    
    /// Return the top elements compound selector of nextsibling selectors.
    var nextSiblingSelectorTopCompoundSelectors: [CompoundSelector] { get }
    
    var style: CSSStyle { get }
    
    var styleAssemblyIdentifier: StyleAssemblyIdentifier { get }
    
    var styleString: String { get set }
    
    var userAgentStyleSheet: CSSStyleSheet? { get }
    
    /// The list of author style sheets
    var authorStyleSheets: [CSSStyleSheet] { get }
    
    var userStyleSheet: CSSStyleSheet? { get }
    
    /// This property keeps information regarding a style if this
    /// style is temporary or not. A temporary style is used to apply
    /// temporary attributes to a document.
    var temporary: Bool { get }
    
    func replaceAllColorsWith(_ color: CIColor)
    
    func serialize() -> String
    
    func areAttributesImpliedInSiblingSelector(attributesMap: [String: Set<String>]) -> ContainsSiblingSelectorResult
}

extension StyleDefinition {
    
    /// Default implementation.
    public var containFollowingSiblingSelectors: Bool {
        
        if let containFollowingSiblingSelectors = userAgentStyleSheet?.containFollowingSiblingSelectors, containFollowingSiblingSelectors {
            return true
        }
        for styleSheet in authorStyleSheets {
            if styleSheet.containFollowingSiblingSelectors {
                return true
            }
        }
        return false
    }
    
    /// This dynamic property returns all the following siblings
    /// top element CompoundSelectorm.
    public var followingSiblingSelectorsTopCompoundSelectors: [CompoundSelector] {
        
        var _followingSiblingSelectorsTopCompoundSelectors = [CompoundSelector]()
        
        if let userAgentStyleSheet = userAgentStyleSheet {
            
            _followingSiblingSelectorsTopCompoundSelectors.append(contentsOf: userAgentStyleSheet.followingSiblingSelectorsTopCompoundSelectors)
        }
        
        for styleSheet in authorStyleSheets {
            _followingSiblingSelectorsTopCompoundSelectors.append(contentsOf: styleSheet.followingSiblingSelectorsTopCompoundSelectors)
        }
        return _followingSiblingSelectorsTopCompoundSelectors
    }
    
    /// This variable is used to to know if there is any next sibling
    /// selector defined in the style.
    public var containNextSiblingSelector: Bool {
        
        if let containNextSiblingSelector = userAgentStyleSheet?.containNextSiblingSelectors, containNextSiblingSelector {
            return true
        }
        for styleSheet in authorStyleSheets {
            if styleSheet.containNextSiblingSelectors {
                return true
            }
        }
        return false
    }
    
    /// Return the top elements compound selector of nextsibling selectors.
    public var nextSiblingSelectorTopCompoundSelectors: [CompoundSelector] {
        
        var _nextSiblingSelectorTopCompoundSelectors = [CompoundSelector]()
        
        if let userAgentStyleSheet = userAgentStyleSheet, let userAgentNextSiblingSelectorTopCompoundSelectors = userAgentStyleSheet.nextSiblingSelectorTopCompoundSelectors {
            
            _nextSiblingSelectorTopCompoundSelectors.append(contentsOf: userAgentNextSiblingSelectorTopCompoundSelectors)
        }
        
        for styleSheet in authorStyleSheets {
            
            if let styleSheetNextSiblingSelectorTopCompoundSelectors = styleSheet.nextSiblingSelectorTopCompoundSelectors {
                _nextSiblingSelectorTopCompoundSelectors.append(contentsOf: styleSheetNextSiblingSelectorTopCompoundSelectors)
            }
        }
        return _nextSiblingSelectorTopCompoundSelectors
    }
    
    public func areAttributesImpliedInSiblingSelector(attributesMap: [String: Set<String>]) -> ContainsSiblingSelectorResult {
        
        var impliedInFollowingSiblingSelector = false
        var impliedInNextSiblingSelector = false
        
        if areAttributesImpliedInFollowingSiblingSelector(attributesMap: attributesMap) {
            impliedInFollowingSiblingSelector = true
        }
        if areAttributesImpliedInNextSiblingSelector(attributesMap: attributesMap) {
            impliedInNextSiblingSelector = true
        }
        
        if impliedInFollowingSiblingSelector && impliedInNextSiblingSelector {
            return .both
        }
        else if impliedInFollowingSiblingSelector {
            return .following
        }
        else if impliedInNextSiblingSelector {
            return .next
        }
        return .none
    }
    
    private func areAttributesImpliedInFollowingSiblingSelector(attributesMap: [String: Set<String>]) -> Bool {
        
        for compoundSelector in followingSiblingSelectorsTopCompoundSelectors {
        
            if simpleSelectorSequence(compoundSelector.simpleSelectorSequence, containsOneOf: attributesMap) {
                return true
            }
        }
        return false
    }
    
    private func areAttributesImpliedInNextSiblingSelector(attributesMap: [String: Set<String>]) -> Bool {
        
        for compoundSelector in nextSiblingSelectorTopCompoundSelectors {
            
            if simpleSelectorSequence(compoundSelector.simpleSelectorSequence, containsOneOf: attributesMap) {
                return true
            }
        }
        return false
    }
    
    private func simpleSelectorSequence(_ simpleSelectorSequence: [SimpleSelector], containsOneOf attributes: [String: Set<String>]) -> Bool {
        
        for simpleSelector in simpleSelectorSequence {
            
            for (attribute, values) in attributes {
                
                switch attribute{
                    
                case "id":
                    
                    assert(values.count == 1)
                    if let idSelector = simpleSelector as? IdSelector {
                        let value = values.first
                        
                        assert(value != nil)
                        if let value = value {
                            if idSelector.hashString == value {
                                return true
                            }
                        }
                    }
                    
                case "class":
                    
                    if let classSelector = simpleSelector as? ClassSelector {
                        
                        if values.contains(classSelector.className) {
                            return true
                        }
                    }
                    
                default:
                    
                    if let attributeSelector = simpleSelector as? AttribSelector {
                        
                        if let attribName = attributeSelector.attribName {
                         
                            let ident = attribName.ident
                            
                            assert(ident != nil)
                            if let ident = ident {
                                if values.contains(ident.identString) {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    /// This function replaces all colors in the style with the
    /// specified color.
    public func replaceAllColorsWith(_ color: CIColor) {
        
        if let userAgentStyleSheet = userAgentStyleSheet {
            userAgentStyleSheet.replaceAllColorsWith(color)
        }
        
        for authorStyleSheet in authorStyleSheets {
            authorStyleSheet.replaceAllColorsWith(color)
        }
    }
    
    /// This function returns a String resulting from the serialisation
    /// of all author css style sheets included in this Style.
    ///
    /// There seems to be no need of synchronizing this operation since
    /// we take a copy of the string.
    public func serialize() -> String {
        
        var result: String = ""
        
        if let userAgentStyleSheet = userAgentStyleSheet {
            
            result += "\n/* user-agent stylesheet */\n"
            result += userAgentStyleSheet.sourceString
        }
        
        for authorStyleSheet in authorStyleSheets {
            
            result += "/* author stylesheet */\n"
            result += authorStyleSheet.sourceString
        }
        
        if let userStyleSheet = userStyleSheet {
            
            result += "/* user stylesheet */\n"
            result += userStyleSheet.sourceString
        }
        
        return result
    }
    
    public var bodyBackgroundColor: PlateformColorType? {
        
        return backgroundColor(for: "body")
    }
    
    public var h1Color: PlateformColorType? {
        
        return color(for: "h1")
    }
    
    public var h2Color: PlateformColorType? {
        
        return color(for: "h2")
    }
    
    private func caretColor(for elementName: String) -> PlateformColorType? {
        
        return colorPropertyValue(for: elementName, property: CSSProperty.caretColor)
    }
    
    private func backgroundColor(for elementName: String) -> PlateformColorType? {
        
        return colorPropertyValue(for: elementName, property: CSSProperty.backgroundColor)
    }
    
    private func color(for elementName: String) -> PlateformColorType? {
        
        return colorPropertyValue(for: elementName, property: CSSProperty.color)
    }
    
    private func colorPropertyValue(for elementName: String, property: CSSProperty) -> PlateformColorType? {
        
        assert(property == .backgroundColor || property == .color)
        
        let (htmlDocument, element) = documentWithElement(named: elementName)
        let resourceComputedStyle = ResourceComputedStyle(styleDefinition: self)
        resourceComputedStyle.computeElementsStyles(document: htmlDocument, filterContext: FilterContext())
        
        if let elementStyle = resourceComputedStyle.computedStyle(forElement:element) {
            if let value = elementStyle.getCSSPropertyValueContainer(§property) {
                return value.colorValue()
            }
        }
        return nil
    }
    
    private func documentWithElement(named elementName: String) -> (HtmlDocument, HTMLElement) {
        
        let htmlDocument = HtmlDocument.Create()
        let bodyElement = htmlDocument!.body!
        var targetElement: HTMLElement
        
        if elementName != "body" {
            
            targetElement = HTMLElement(document: htmlDocument, localName: elementName)

            var exception = Exception()
            bodyElement.appendChild(targetElement, exception: &exception)
        }
        else {
            targetElement = bodyElement
        }
        return (htmlDocument!, targetElement)
    }
}
