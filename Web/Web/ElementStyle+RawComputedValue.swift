//
//  ElementStyle+RawComputedValue.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension ElementStyle {
    
    /// Compute the raw computed style.
    ///
    /// def: All longhand properties that are supported CSS properties, in lexicographical order,
    /// with the value being the computed value computed for the context object using the style rules
    /// associated with the context object’s associated document.
    ///
    /// see http://dev.w3.org/csswg/cssom/#dom-getstyleutils-rawcomputedstyle
    func computeRawComputedStyle(filterContext: FilterContext) {
        
        // the first two properties that should be computed are font-family
        // and font-size since all lengths values'ch', 'em'
        // and 'ex' (also 'rem') are depending on those.
        ensureFontFamilyValueIsComputed(filterContext: filterContext)
        ensureFontSizeValueIsComputed(filterContext: filterContext)
        
        for (propertyName, specifiedPropertyValue) in specifiedValues.propertyValues {
            
            let cascadingPhaseOrigin = specifiedValues.propertyCascadingPhaseOrigin(forPropertyWithName: propertyName)
            
            assert(cascadingPhaseOrigin != nil)
            if let cascadingPhaseOrigin = cascadingPhaseOrigin {
            
                computeRawValue(propertyName, specifiedPropertyValue: specifiedPropertyValue, cascadingPhaseOrigin: cascadingPhaseOrigin, filterContext: filterContext)
            }
        }
    }
    
    
    func computeRawValue(_ propertyName: DOMString, specifiedPropertyValue: CSSPropertyValueContainer, cascadingPhaseOrigin: CascadingPhaseOrigin, filterContext: FilterContext) {
        
        if let property = CSSProperty(rawValue: propertyName) {
            
            // some properties may already have been computed
            // font-family and font-size are two examples of this.
            if rawComputedStyle.getCSSPropertyValueContainer(propertyName) == nil {
                
                let computedValue = resolveSpecifiedValue(property, specifiedValue: specifiedPropertyValue, filterContext: filterContext)
                
                assert(computedValue != nil)
                if let computedValue = computedValue {
                    rawComputedStyle.setCSSPropertyValueContainer(propertyName, value: computedValue, cascadingPhase: cascadingPhaseOrigin)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("computedValue is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
                // validate that the value is really not relative
            else {
                // validation code
                #if DEBUG
                    if let computedValue = rawComputedStyle.getCSSPropertyValueContainer(propertyName) {
                        
                        assert(!computedValue.isRelative(), "computed value should be absolute.")
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("computedValue is nil.", log: Log.Web.all, type: .error)
                        #endif
                    }
                #endif
                // end validation code
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unsupported property : %S", log: Log.Web.all, type: .error, %%propertyName)
            #endif
        }
        
    }
    
    func rawComputedValueForProperty(_ propertyName: DOMString) -> CSSPropertyValueContainer? {
        
        if let rawValue = rawComputedStyle.getCSSPropertyValueContainer(propertyName) {   
            return rawValue
        }
        return nil
    }
    
    /// The first available font, used in the definition of font-relative lengths such as ‘ex’ and ‘ch’,
    /// is defined to be the first available font that would match any character given font families in the
    /// ‘font-family’ list (or a user agent's default font if none are available).
    ///
    /// see http://www.w3.org/TR/css-fonts-3/#first-available-font
    func firstAvailableFontFamily() -> CSSPropertyValueContainer {
        
        // computation of the font-family property keeps
        // the first available font-family
        if let computedFontFamily = rawComputedStyle.getCSSPropertyValueContainer(§CSSProperty.fontFamily) {
            return computedFontFamily
        }
        
        return CSSPropertyValueContainer.fontFamilyPropertyValueFromCSSFontFamily(
            UserAgent.shared.defaultFontFamily)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// see http://dev.w3.org/csswg/css-cascade-4/#computed-value
    private func resolveSpecifiedValue(_ property: CSSProperty, specifiedValue: CSSPropertyValueContainer, filterContext: FilterContext) -> CSSPropertyValueContainer? {
        
        switch specifiedValue {
            
        case .customValue(_):
            fatalError("missing implementation")
        case .resolvedCustom(_):
            fatalError("missing implementation")
            
        case .fontFamily(let fontFamily):
            return fontFamily.resolveComputedValueFromSpecifiedValue(fontFamily, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .fontSize(let fontSize):
            
            return fontSize.resolveComputedValueFromSpecifiedValue(fontSize, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .fontStyle(let fontStyle):
            
            return fontStyle.resolveComputedValueFromSpecifiedValue(fontStyle, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .fontWeight(let fontWeight):
            
            return fontWeight.resolveComputedValueFromSpecifiedValue(fontWeight, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .caretColor(let color):
            return color.resolveComputedValueFromSpecifiedValue(color, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .color(let color):
            return color.resolveComputedValueFromSpecifiedValue(color, container: specifiedValue, elementStyle: self, filterContext: filterContext)
        case .backgroundColor(let color):
            
            return color.resolveComputedValueFromSpecifiedValue(color, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .textDecorationColor(let color):
            
            return color.resolveComputedValueFromSpecifiedValue(color, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .textDecorationLine(let value):
            
            return value.resolveComputedValueFromSpecifiedValue(value, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .textDecorationStyle(let value):
            
            return value.resolveComputedValueFromSpecifiedValue(value, container: specifiedValue, elementStyle: self, filterContext: filterContext)
            
        case .error:
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error should not be a relative value.", log: Log.Web.all, type: .error)
            #endif
            
        case .none:
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("None should not be a relative value.", log: Log.Web.all, type: .error)
            #endif
            
        case .unsupported:
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error should not be a relative value.", log: Log.Web.all, type: .error)
            #endif

        }
        assert(false, "Missing implementation for \(specifiedValue).")
        return nil
    }
    
    fileprivate func ensureFontFamilyValueIsComputed(filterContext: FilterContext) {
        
        if let specifiedFontSizeValue = specifiedValues.getCSSPropertyValueContainer(§CSSProperty.fontFamily) {
            
            let cascadingPhaseOrigin = specifiedValues.propertyCascadingPhaseOrigin(forPropertyWithName: §CSSProperty.fontFamily)
            
            assert(cascadingPhaseOrigin != nil)
            if let cascadingPhaseOrigin = cascadingPhaseOrigin {
            
                computeRawValue(§CSSProperty.fontFamily, specifiedPropertyValue: specifiedFontSizeValue, cascadingPhaseOrigin: cascadingPhaseOrigin, filterContext: filterContext)
            }
        }
        else {
            // FIXME: font-size handling
        }
    }
    
    fileprivate func ensureFontSizeValueIsComputed(filterContext: FilterContext) {
        
        if let specifiedFontSizeValue = specifiedValues.getCSSPropertyValueContainer(§CSSProperty.fontSize) {
            
            let cascadingPhaseOrigin = specifiedValues.propertyCascadingPhaseOrigin(forPropertyWithName: §CSSProperty.fontSize)
            
            assert(cascadingPhaseOrigin != nil)
            if let cascadingPhaseOrigin = cascadingPhaseOrigin {
            
                computeRawValue(§CSSProperty.fontSize, specifiedPropertyValue: specifiedFontSizeValue, cascadingPhaseOrigin: cascadingPhaseOrigin, filterContext: filterContext)
            }
        }
        else {
            
            // FIXME: handle font-size property
        }
    }
    
}
