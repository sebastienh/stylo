//
//  ElementStyle+Cascade.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension ElementStyle {
    
    /// For each element supported property and all applicable style declaration
    /// this method will compute the cascaded value and assign it to private _cascadedStyle
    /// property.
    ///
    /// def: All longhand properties that are supported CSS properties, in lexicographical order,
    /// that have a cascaded value for the context object, with the value being the cascaded value computed
    /// for the context object using the style rules associated with the context object’s associated document.
    ///
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-cascadedstyle
    func computeCascadedValues(applicable: StyleApplicable?) {
        
        assert(associatedElement != nil)
        if let associatedElement = associatedElement {
            
            let elementSupportedProperties: Set<CSSProperty> = supportedProperties(for: associatedElement)
            
            // initialize a None property value for each supported properties
            for property in elementSupportedProperties {
                cascadedStyle.setCSSPropertyValueContainer(§property, value: CSSPropertyValueContainer.none, cascadingPhase: .none)
            }
            
            // compute the applicable declared cascading values
            let supportedPropertiesDeclarations: [String : [CascadedDeclaration]] = collectSupportedPropertyDeclarations(supportedProperties: elementSupportedProperties, applicable: applicable)
            
            // initialize a None property value for each supported properties
            for (name, _) in supportedPropertiesDeclarations {
                
                // this can happen if we returned custom values from
                // the supportedPropertiesDeclarations
                if cascadedStyle.propertyValues[name] == nil {
                    cascadedStyle.setCSSPropertyValueContainer(name, value: CSSPropertyValueContainer.none, cascadingPhase: .none)
                }
            }
            
            for (property, declarations) in supportedPropertiesDeclarations {
                
                if let cascadedDeclaration = computeCascadedValue(declarations) {
                    
                    let value = cascadedDeclaration.declaration.value!
                    cascadedStyle.setCSSPropertyValueContainer(property, value: value, cascadingPhase: .cascaded)
                    cascadedStyle.setPropertyOrigin(property, origin: cascadedDeclaration.styleRule.parentStyleSheet!.origin)
                }
                else {
                    
                    #if DEBUG
                    assert(cascadedStyle.getCSSPropertyValueContainer(property) != nil, "Property value should not be nil.")
                    #endif
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("The property is already initialized.", log: Log.Web.all, type: .error)
                    #endif
                    // There has been no cascaded value computed, we add a nil declaration
                    // in this case to record that we found nothing by adding a nil value
                    // to the property declaration.
                    //                cascadedStyle.setCSSPropertyValueContainer(property, value: CSSPropertyValueContainer.None)
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// Method that return the supported properties for the element.
    /// Temporary properties does not support layout influencing properties
    /// like font-size.
    ///
    private func supportedProperties(for element: Element) -> Set<CSSProperty> {
        
        return element.supportedProperties
    }
    
    /// Compute the cascaded value
    /// see http://dev.w3.org/csswg/css-cascade/#cascaded
    private func computeCascadedValue(_ declarations: [CascadedDeclaration]) -> CascadedDeclaration? {
        
        if declarations.count == 0 {
            return nil
        }
        else if declarations.count == 1 {
            return declarations.first
        }
        else {
            return deriveCascadedValueFromDeclarations(declarations)
        }
    }
    
    private func deriveCascadedValueFromDeclarations(_ declarations: [CascadedDeclaration]) -> CascadedDeclaration? {
        
        let highestPrecedenceDeclarations = keepHighestPrecedenceDeclarations(declarations)
        
        if highestPrecedenceDeclarations.count == 1 {
            
            assignUserAgentDefaultDeclaration(highestPrecedenceDeclarations)
            assignUserDefaultDeclaration(highestPrecedenceDeclarations)
            return highestPrecedenceDeclarations.first!
        }
        else {
            
            let scopedValues = deriveScopedValues(highestPrecedenceDeclarations)
            
            if scopedValues.count == 1 {
                return scopedValues.first!
            }
            else {
                
                let specificityValues = deriveSpecificityValues(scopedValues)
                
                if specificityValues.count == 1 {
                    return specificityValues.first!
                }
                else {
                    return deriveOrderOfAppearanceValues(specificityValues)
                }
            }
        }
    }
    
    private func deriveOrderOfAppearanceValues(_ declarations: [CascadedDeclaration]) -> CascadedDeclaration? {
        
        //        var highestOrderDeclarationAndRule: (CSDeclaration, CSSStyleRule)
        
        
        // The last declaration has highest precedence in our case.
        // We should try to keep it that way, but if we manage to support
        // the import eventually the "order" may be the way to go.
        // TODO:
        let orderSortedCascadedDeclarations = declarations.sorted {(first: CascadedDeclaration, second: CascadedDeclaration) -> Bool in
            
            // sort in reverse order : lower to higher
            return  first.order < second.order
        }
        
        return orderSortedCascadedDeclarations.last
        
        //        if let declarationAndRule = declarations.first {
        //
        //            highestOrderDeclarationAndRule = declarationAndRule
        //
        //            for (declaration, styleRule) in declarations {
        //
        //                if declaration.order > highestOrderDeclarationAndRule.0.order {
        //
        //                    highestOrderDeclarationAndRule = (declaration, styleRule)
        //                }
        //                else if declaration.order == highestOrderDeclarationAndRule.0.order {
        //
        ////                    assert(highestOrderDeclarationAndRule.0 == declaration)
        //                }
        //            }
        //        }
        //        else {
        //
        //            debugPrint("first is nil: we should investigate the reason why it is happening, that's why we leave the fatal error, otherwise, easy fix, remove it and return nil.")
        //            fatalError("FIXME!!!")
        //
        //            return nil
        //        }
        //
        //        return highestOrderDeclarationAndRule
    }
    
    private func deriveSpecificityValues(_ declarations: [CascadedDeclaration]) -> [CascadedDeclaration] {
        
        let sortedCascadedDeclarations = declarations.sorted {(first: CascadedDeclaration, second: CascadedDeclaration) -> Bool in
            
            // sort in reverse order : higher to lower
            return second.maxSpecificity < first.maxSpecificity
        }
        
        var highestSpecifictyDeclarations = [CascadedDeclaration]()
        
        assert(sortedCascadedDeclarations.first != nil)
        if let firstSortedCascadedDeclarations = sortedCascadedDeclarations.first {
                
            let highestSpecificity = firstSortedCascadedDeclarations.maxSpecificity
            
            for cascadedDeclaration in sortedCascadedDeclarations {
                
                if cascadedDeclaration.maxSpecificity == highestSpecificity {
                    highestSpecifictyDeclarations.append(cascadedDeclaration)
                }
                else if cascadedDeclaration.maxSpecificity > highestSpecificity {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    assert(false, "order is wrong")
                    os_log("revise specificty sorting code.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("first is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return highestSpecifictyDeclarations
    }
    
    
    private func deriveScopedValues(_ declarations: [CascadedDeclaration]) -> [CascadedDeclaration] {
        
        // TODO: missing implementation
        // since we do not support yet scoped
        return declarations
    }
    
    ///
    private func keepHighestPrecedenceDeclarations(_ declarations: [CascadedDeclaration]) -> [CascadedDeclaration] {
        
        // assign precendence to all declarations.
        var declarationsPrecedences: [(cascadedDeclaration: CascadedDeclaration, precedence: CSSDeclarationPrecedence)] = assignDeclarationPrecedences(declarations)
        
        // sort the precendence in reverse order: the highest first
        declarationsPrecedences.sort { (first: (CascadedDeclaration, CSSDeclarationPrecedence), second: (CascadedDeclaration, CSSDeclarationPrecedence)) -> Bool in
            
            let (_, firstPrecedence) = first
            let (_, secondPrecedence) = second
            
            // sort in reverse order
            // see https://developer.apple.com/library/ios/documentation/General/Reference/SwiftStandardLibraryReference/Array.html
            if secondPrecedence < firstPrecedence {
                return true
            }
            return false
        }
        
        // keep the winners.
        var highestPrecedenceDeclarations = [CascadedDeclaration]()
        
        // Assign the highest precence to the first declaration
        let highestPrecedence = declarationsPrecedences.first?.precedence
        
        // filter the declarations that share the same precedence
        // as the highestPrecedence
        assert(highestPrecedence != nil)
        if let highestPrecedence = highestPrecedence {
            
            for (cascadedDeclaration, precedence) in declarationsPrecedences {
                
                if precedence == highestPrecedence {
                    
                    highestPrecedenceDeclarations.append(cascadedDeclaration)
                }
            }
        }
        
        // if we have declarations, we should also have highestPrecedenceDeclarations
        assert(declarations.isEmpty == highestPrecedenceDeclarations.isEmpty)
        return highestPrecedenceDeclarations
    }
    
    /// [see](https://drafts.csswg.org/css-cascade/#cascading)
    private func assignDeclarationPrecedences(_ declarations: [CascadedDeclaration]) -> [(CascadedDeclaration, CSSDeclarationPrecedence)] {
        
        var declarationsPrecedences = [(CascadedDeclaration, CSSDeclarationPrecedence)]()
        
        for cascadedDeclaration in declarations {
            
            let origin = cascadedDeclaration.styleRule.parentStyleSheet!.origin
            let important = cascadedDeclaration.declaration.importantFlag
            
            var precedence: CSSDeclarationPrecedence?
            
            // Transition declarations [CSS3-TRANSITIONS]
            // TODO: we need to handle this case when we will support transitions
            
            // Important user agent declarations
            if important && origin == CSSOrigin.userAgent {
                
                precedence = CSSDeclarationPrecedence.importantUserAgentDeclaration
            }
                // Important user declarations
            else if important && origin == CSSOrigin.user {
                
                precedence = CSSDeclarationPrecedence.importantUserDeclaration
            }
                // Important override declarations [DOM-LEVEL-2-STYLE]
                // TODO: do we need to include support for override declarations???
                
                // Important author declarations
            else if important && origin == CSSOrigin.author {
                
                precedence = CSSDeclarationPrecedence.importantAuthorDeclaration
            }
            
            // Animation declarations [CSS3-ANIMATIONS]
            // TODO: we need to handle this case when we will support animations
            
            // Normal override declarations [DOM-LEVEL-2-STYLE]
            // TODO: do we need to include support for override declarations???
            
            // Normal author declarations
            if !important && origin == CSSOrigin.author {
                
                precedence = CSSDeclarationPrecedence.normalAuthorDeclaration
            }
            
            // Normal user declarations
            if !important && origin == CSSOrigin.user {
                
                precedence = CSSDeclarationPrecedence.normalUserDeclaration
            }
            
            // Normal user agent declarations
            if !important && origin == CSSOrigin.userAgent {
                
                precedence = CSSDeclarationPrecedence.normalUserAgentDeclaration
            }
            declarationsPrecedences.append((cascadedDeclaration, precedence!))
        }
        
        return declarationsPrecedences
    }
    
    private func assignUserAgentDefaultDeclaration(_ originValues: [CascadedDeclaration]) {
        
        for cascadedDeclaration in originValues {
            
            let styleRule = cascadedDeclaration.styleRule
            let declaration = cascadedDeclaration.declaration
            
            if styleRule.parentStyleSheet!.origin == CSSOrigin.userAgent {
                
                if let value = declaration.value {
                    
                    userAgentLevelStyle.setCSSPropertyValueContainer(declaration.propertyName, value: value, cascadingPhase: .cascaded)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("value is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
    }
    
    private func assignUserDefaultDeclaration(_ originValues: [CascadedDeclaration]) {
        
        for cascadedDeclaration in originValues {
            
            let styleRule = cascadedDeclaration.styleRule
            let declaration = cascadedDeclaration.declaration
            
            if styleRule.parentStyleSheet!.origin == CSSOrigin.user {
                
                if let value = declaration.value {
                    
                    userAgentLevelStyle.setCSSPropertyValueContainer(declaration.propertyName, value: value, cascadingPhase: .cascaded)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("value is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
    }
    
    /// Here we compute all the supported property declarations and their corresponding
    /// declared style rule that comes from the applicable style rules.
    private func collectSupportedPropertyDeclarations(supportedProperties: Set<CSSProperty>, applicable: StyleApplicable?) -> [String : [CascadedDeclaration]] {
        
        var supportedPropertiesStyleDeclarations = [String : [CascadedDeclaration]]()
        
        guard let applicable = applicable else {
            return supportedPropertiesStyleDeclarations
        }
        
        // construct style declaration with all the instances of declaration of this
        // property in all applicable style rules for this element
        for (index, styleRule) in applicable.rules.enumerated() {
            
            // style could be nil if we only have a selector
            if let style = styleRule.style {
                
                for (key, _) in style.properties {

                    // any custom property is supported...
                    if self.isPropertySupportedOrCustom(key: key, supportedProperties: supportedProperties) {
                        
                        guard let declaration = style[key] else {
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("declaration is nil for : %@", log: Log.Web.all, type: .info, %%(§supportedProperty))
                            #endif
                            continue
                        }
                        
                        guard !declaration.hasErrors() else {
                            assertionFailure("Error: declaration errors: \(declaration.allMessages)")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("declaration has errors: %@", log: Log.Web.all, type: .info, %%declaration)
                            #endif
                            continue
                        }
                        
                        insertCascadedDeclaration(fromDeclaration: declaration, styleRule: styleRule, in: &supportedPropertiesStyleDeclarations, applicable: applicable, atIndex: index, forPropertyName: key)
                    }
                }
            }
        }
        
        return supportedPropertiesStyleDeclarations
    }
    
    private func isPropertySupportedOrCustom(key: String, supportedProperties: Set<CSSProperty>) -> Bool {
        
        if key.starts(with: "--") {
            return true
        }
        else if let property = CSSProperty(rawValue: key), supportedProperties.contains(property) {
            return true
        }
        return false
    }
    
    private func insertCascadedDeclaration(fromDeclaration declaration: CSDeclaration, styleRule: CSSStyleRule, in supportedPropertiesStyleDeclarations: inout [String : [CascadedDeclaration]], applicable: StyleApplicable, atIndex index: Int, forPropertyName propertyName: String) {
        
        // A property does not necessarly has a value since it could
        // be not supported or just not written yet...
        if let value = declaration.value {
            
            switch value {
            case .error:
                break
                
            default:
                
                let rulesComplexSelectors = applicable.rulesComplexSelectors
                let complexSelectors = rulesComplexSelectors[index]
                
                let cascadedDeclaration = CascadedDeclaration(declaration: declaration, styleRule: styleRule, complexSelectors: complexSelectors, order: index)
                
                if supportedPropertiesStyleDeclarations[propertyName] != nil {
                    supportedPropertiesStyleDeclarations[propertyName]!.append(cascadedDeclaration)
                }
                else {
                    supportedPropertiesStyleDeclarations[propertyName] = [cascadedDeclaration]
                }
            }
        }
    }
}
