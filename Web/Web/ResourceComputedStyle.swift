//
//  ResourceComputedStyle.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

///
/// This class is responsible for keeping an updated version
/// of a style for it's document so that when another
/// the style represented by the parent StyleManager is chosen
/// this class can be used to know rapidly which style applies
/// to all the document elements accoring to this style.
///
public final class ResourceComputedStyle: CustomDebugStringConvertible {
    
    public enum AttributesType: Int {
        case text = 0
        case decoration = 1
    }
    
    /// A textual representation of this instance, suitable for debugging.
    public var debugDescription: String {
        
        #if CONCURENT_RENDERING
        lock.readLock()
        #endif
        var _debugString = "ResourceComputedStyle: "
        _debugString += "styleDefinition: \(styleDefinition.style.id)"
        _debugString += "elementStyleCache: \(elementStyleCache)"
        #if CONCURENT_RENDERING
        lock.unlock()
        #endif
        return _debugString
    }
    
    /// owner style
    public let styleDefinition: StyleDefinition
    
    /// Computed elements style cache. This is the main cache which contains
    /// computed style for each element of the document.
    let elementStyleCache: ElementStyleCache
    
    let elementsAttributesCache: ElementAttributesCache
    
    ///
    /// An element can have multiple style identities based
    /// on the pseudo-classes that my be applied to it.
    ///
    /// StyleIdentity refers in the end to a specific
    /// combination of pseudo-classes the simpler being
    /// no pseudo-classes.
    ///
    /// In this dictionary we keep each possible combination,
    /// each pseudo-classe are ordered the way they appear for
    /// this paticular item.
    ///
    /// A possible combination is referred by a proper Pseudo classes
    /// combination.
    ///
    let styleIdentitiesCache: StyleIdentitiesCache
    
    public let containSiblingSelectors: Bool
    
    #if CONCURENT_RENDERING
    let lock = ReadWriteLock()
    #endif
    
    var _paragraphStyle: [NSAttributedString.Key : Any]?
    
    public init(styleDefinition: StyleDefinition) {
        
        self.styleDefinition = styleDefinition
        self.containSiblingSelectors = styleDefinition.containFollowingSiblingSelectors || styleDefinition.containNextSiblingSelector
        
        self.elementStyleCache = ElementStyleCache()
        self.styleIdentitiesCache = StyleIdentitiesCache()
        self.elementsAttributesCache = ElementAttributesCache()
    }
    
    public func computedStyle(forPseudoElement pseudoElement: PseudoElement, withElement element: Element) -> ComputedStyleDeclaration?  {
        
        return computedStyle(forPseudoElement: pseudoElement, withElement: element, filterContext: FilterContext())
    }
    
    func computeStyle(forElement element: Element, filterContext: FilterContext, applicable: StyleApplicable?) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("computeStyle(forElement: %@, filterContext: %@, applicable: %@)", log: Log.Web.all, type: .info, %%element.localName, %%filterContext, %%applicable)
        os_log("computeStyle -> rulesComplexSelectors for element: %@", log: Log.Web.all, type: .info, %%applicable?.rulesComplexSelectors)
        os_log("computeStyle -> styleIdentity for element: %@", log: Log.Web.all, type: .info, %%styleIdentity)
        #endif
        
        let inheritingElementStyle = self.inheritingElementStyle(forElement: element, filterContext: filterContext)
        let elementStyle = ElementStyle(associatedElement: element, resourceComputedStyle: self, inheritingElementStyle: inheritingElementStyle)
        _computeStyle(elementStyle: elementStyle, applicable: applicable, filterContext: filterContext)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("computeStyle -> styleIdentity for element: %@", log: Log.Web.all, type: .info, %%styleIdentity)
        #endif
        
        var styles = self.evaluatePseudosStyle(applicable: applicable, withElement: element, associatedElementStyle: elementStyle, filterContext: filterContext, inheritingElementStyle: elementStyle) ?? [:]
        
        let styleIdentity = self.styleIdentity(for: element, filterContext: filterContext)
        styles[styleIdentity] = elementStyle
        self.elementStyleCache.updateElementStyles(with: styles)
    }
    
    func inheritingElementStyle(forElement element: Element, filterContext: FilterContext) -> ElementStyle? {
     
        guard let inheritingElement = element.inheritingElement else {
            return nil
        }
        
        return self.elementStyle(forElement: inheritingElement, filterContext: filterContext)
    }
    
    private func evaluatePseudosStyle(applicable: StyleApplicable?, withElement element: Element, associatedElementStyle: ElementStyle, filterContext: FilterContext, inheritingElementStyle: ElementStyle) -> [StyleIdentity: ElementStyle]? {
        
        if let applicable = applicable {
            
            if let pseudos = applicable.pseudos {
                
                var pseudoStyles: [StyleIdentity: ElementStyle] = [:]
                
                for pseudo in pseudos {
                    
                    guard !associatedElementStyle.evaluatedStyle.hasStyle(forPseudoElementWithName: pseudo.localName) else {
                        continue
                    }
                    
                    assert(applicable.pseudoRules[pseudo.localName] != nil)
                    let pseudoApplicable: StyleApplicable? = applicable.pseudoRules[pseudo.localName]
                    
                    assert(pseudoApplicable != nil)
                    let styleIdentity = self.pseudoElementStyleIdentity(for: pseudo, withElement: element, applicable: pseudoApplicable, filterContext: filterContext)
                    
                    let pseudoClassesOptions = filterContext.pseudoClassesOptions(forElement: element)
                    
                    let pseudoElementStyle = ElementStyle(associatedElement: pseudo, resourceComputedStyle: self, inheritingElementStyle: inheritingElementStyle)
                    _computeStyle(elementStyle: pseudoElementStyle, applicable: pseudoApplicable, filterContext: filterContext)
                    
                    pseudoStyles[styleIdentity] = pseudoElementStyle
                    associatedElementStyle.evaluatedStyle.setEvaluatedStyle(pseudoElementStyle.evaluatedStyle, for: pseudo, pseudoClassesOptions: pseudoClassesOptions)
                }
                return pseudoStyles
            }
        }
        return nil
    }
    
    private func _computeStyle(elementStyle: ElementStyle, applicable: StyleApplicable?, filterContext: FilterContext) {
        
        elementStyle.computeCascadedValues(applicable: applicable)
        elementStyle.evaluateStyle(filterContext: filterContext)
    }
    
    func treePositionIdentity(for node: Node?, withElement element: Element? = nil) -> TreePositionIdentity {
        
        return node?.treePositionIdentity(withElement: element) ?? "nil"
    }
    
    func elementStyle(forElement element: Element, filterContext: FilterContext) -> ElementStyle? {
        
        let styleIdentity = self.styleIdentity(for: element, filterContext: filterContext)
        return elementStyleCache.elementStyle(forStyleIdentity: styleIdentity)
    }
    
    func elementStyle(forStyleIdentity styleIdentity: StyleIdentity) -> ElementStyle? {
        
        return elementStyleCache.elementStyle(forStyleIdentity: styleIdentity)
    }
    
    func updateElementStyle(forStyleIdentity styleIdentity: StyleIdentity, elementStyle: ElementStyle) {
        
        self.elementStyleCache.updateElementStyle(forStyleIdentity: styleIdentity, elementStyle: elementStyle)
    }
    
    func updateElementStyleForElement(element: Element, styleIdentity: StyleIdentity, elementStyle: ElementStyle, pseudoClassesOptions: PseudoClassesOptions) {
        
        self.elementStyleCache.updateElementStyle(forStyleIdentity: styleIdentity, elementStyle: elementStyle)
    }
    
    /// Method that removes all computed style.
    public func deleteAllStyles() {
        
        self.styleIdentitiesCache.clean()
        self.elementStyleCache.clean()
        self.elementsAttributesCache.clean()
    }
    
    /// since deletedDomNodes is ContiguousArray<Node>? we shoud make sure
    /// the node is an element before delting the style for it.
    public func deleteStyleIdentity(forElement element: Element, filterContext: FilterContext) {
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Removing style for element %@ with id: %@", log: Log.Web.all, type: .info, %%element.localName, %%ObjectIdentifier(element))
        #endif
        // To put back, for now we would need to know the selection context which
        // we dont have
        // elementStyleCache.removeStyle(for: element)
        //
        
        
//        let styleIdentity = self.styleIdentity(for: element, filterContext: filterContext)
//        self.elementStyleCache.removeValue(forStyleIdentity: styleIdentity)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Equals methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func equals(_ other: Any?) -> Bool {
        
        if let other = other {
            
            if let other = other as? ResourceComputedStyle {

                if containSiblingSelectors != other.containSiblingSelectors {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: containSiblingSelectors are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if !self.elementStyleCache.equals(other.elementStyleCache) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: elementStyleCache are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                // TODO missing other 
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ResourceComputedStyle.", log: Log.Web.all, type: .debug)
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
    
}

