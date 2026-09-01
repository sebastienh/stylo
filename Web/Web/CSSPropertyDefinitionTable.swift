//
//  CSSPropertyDefinitionTable.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import CoreImage
import os

public final class CSSPropertyDefinitionTable {
    
    /// Singleton instance.
    static var shared = CSSPropertyDefinitionTable()
    
    let propertyDefinitionTable: [CSSProperty: PropertyDefinition]
    
    /// Use for custom properties. In the case of custom properties
    /// their initial value is invalid. to make sure we do not use
    /// them.
    ///
    /// [css-variables](https://drafts.csswg.org/css-variables/#guaranteed-invalid-value)
    ///
    let guaranteedInvalidValue = CSPreservedTokenComponentValue.emptyStringComponentValue
    
    fileprivate init() {
        
        self.propertyDefinitionTable = [
            /// see http://www.w3.org/TR/css3-fonts/#font-family-prop
            .fontFamily:
                CSSPropertyDefinition<CSSFontFamily>(
                    property: CSSProperty.fontFamily,
                    initial: CSSFontFamily.custom("Avenir Next"),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: true,
                    media: Media.visual),
        
            .caretColor:
                CSSPropertyDefinition<CSSColor>(
                    property: CSSProperty.caretColor,
                    // black: 0 0 0
                    initial: CSSColor.custom(CIColor(red: 0, green: 0, blue: 0)),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: true,
                    media: Media.visual),
                
            .color:
                CSSPropertyDefinition<CSSColor>(
                    property: CSSProperty.color,
                    // black: 0 0 0
                    initial: CSSColor.custom(CIColor(red: 0, green: 0, blue: 0)),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: Bool(booleanLiteral: true),
                    media: Media.visual),
            
            .backgroundColor:
                CSSPropertyDefinition<CSSColor>(
                    property: CSSProperty.backgroundColor,
                    // white: 255 255 255
                    initial: CSSColor.custom(CIColor(red: 1, green: 1, blue: 1)),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: Bool(booleanLiteral: true),
                    media: Media.visual),
            
            /// see http://www.w3.org/TR/css3-fonts/#font-size-prop
            .fontSize:
                CSSPropertyDefinition<CSSFontSize>(
                    property: CSSProperty.fontSize,
                    initial: CSSFontSize.length(CSSLength.px(UserAgent.shared.mediumFontSizePixelValue)) ,
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.fontSize,
                    inherited: true,
                    media: Media.visual
            ),
            /// see http://www.w3.org/TR/css3-fonts/#font-weight-prop
            .fontWeight:
                CSSPropertyDefinition<CSSFontWeight>(
                    property: CSSProperty.fontWeight,
                    initial: CSSFontWeight.absolute(.normal),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.fontWeight,
                    inherited: true,
                    media: Media.visual
            ),
            /// see http://www.w3.org/TR/css3-fonts/#font-style-prop
            .fontStyle:
                CSSPropertyDefinition<CSSFontStyle>(
                    property: CSSProperty.fontStyle,
                    initial: CSSFontStyle.keyword(.normal),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.fontStyle,
                    inherited: true,
                    media: Media.visual
            ),
            
            .textDecorationColor:
                CSSPropertyDefinition<CSSColor>(
                    property: CSSProperty.textDecorationColor,
                    initial: CSSColor.custom(CIColor(red: 0, green: 0, blue: 0)),
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: false,
                    media: Media.visual
            ),
            
            .textDecorationLine:
                CSSPropertyDefinition<CSSTextDecorationLine>(
                    property: CSSProperty.textDecorationLine,
                    initial: CSSTextDecorationLine.defaultValue,
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: false,
                    media: Media.visual
            ),
            
            .textDecorationStyle:
                CSSPropertyDefinition<CSSTextDecorationStyle>(
                    property: CSSProperty.textDecorationStyle,
                    initial: CSSTextDecorationStyle.solid,
                    domain: [CoreDOMElementType.All],
                    type: CSSValueType.stringListType,
                    inherited: false,
                    media: Media.visual
            ),
        ]
    }
    
    func propertyDefinitionForProperty<T>(_ property: CSSProperty) -> CSSPropertyDefinition<T>? {
        
        let propertyDefinition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<T>
        
        assert(propertyDefinition != nil, "Could not retreive property definition for property: \(property)")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Could not retreive property definition for property: %@", log: Log.Web.all, type: .error, %%property)
        #endif
        return propertyDefinition
    }
    
    public func isInheritedProperty(_ property: CSSProperty) -> Bool {
        
        if let propertyDefinition = self.propertyDefinitionTable[property] {
            
            return propertyDefinition.inherited
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Could not retreive property definition for property: %@", log: Log.Web.all, type: .error, %%property)
        #endif
        return true
    }
    
    public func initialValueForProperty(_ propertyName: String) -> CSSPropertyValueContainer {
        
        if let property = CSSProperty(rawValue: propertyName) {
            return self.initialValueForProperty(property)
        }
        
        if propertyName.isCustomPropertyName {
            return self.initialValueForCustomProperty(propertyName)
        }
        
        return CSSPropertyValueContainer.unsupported
    }
    
    public func initialValueForCustomProperty(_ propertyName: String) -> CSSPropertyValueContainer {
         
        return CSSPropertyValueContainer.resolvedCustom([self.guaranteedInvalidValue])     
    }
    
    public func initialValueForProperty(_ property: CSSProperty) -> CSSPropertyValueContainer {
        
        switch property {
            
        case .fontFamily:
            
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontFamily> {
                
                let initialValue = definition.initial   
                return CSSPropertyValueContainer.fontFamily(initialValue)
            }
            
        case .fontSize:

            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontSize> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.fontSize(initialValue)
            }
            
            
        case .color:
            
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSColor> {
            
                let initialValue = definition.initial
                return CSSPropertyValueContainer.color(initialValue)
            }
            
        case .backgroundColor:
            
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSColor> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.backgroundColor(initialValue)
            }
            
        case .caretColor:
        
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSColor> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.caretColor(initialValue)
            }
            
//        case .FontStretch:
//            
//            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontStretch> {
//                
//                let initialValue = definition.initial
//                
//                return CSSPropertyValueContainer.FontStretch(initialValue)
//            }
//            else {
//                
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Missing definition for property: \(property).", log: Log.Web.all, type: .error)
//                #endif
//            }
//            
        case .fontStyle:

            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontStyle> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.fontStyle(initialValue)
            }
            
//
//        case .FontVariant:
//
//            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontVariant> {
//                
//                let initialValue = definition.initial
//                
//                return CSSPropertyValueContainer.FontVariant(initialValue)
//            }
//            else {
//                
//                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                os_log("Missing definition for property: \(property).", log: Log.Web.all, type: .error)
//                #endif
//            }
//            
        case .fontWeight:

            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSFontWeight> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.fontWeight(initialValue)
            }
//
//        case .TextAlign:
//            fatalError("Missing implementation.")
//            
        case .textDecorationColor:
            
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSColor> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.textDecorationColor(initialValue)
            }

        case .textDecorationLine:

            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSTextDecorationLine> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.textDecorationLine(initialValue)
            }
            
        case .textDecorationStyle:
            
            if let definition = self.propertyDefinitionTable[property] as? CSSPropertyDefinition<CSSTextDecorationStyle> {
                
                let initialValue = definition.initial
                return CSSPropertyValueContainer.textDecorationStyle(initialValue)
            }
//            
//        case .TextIndent:
//            fatalError("Missing implementation.")
//            
//        case .TextTransform:
//            fatalError("Missing implementation.")
        }
        
        assert(false, "Missing definition for property: \(property).")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Missing definition for property: %@.", log: Log.Web.all, type: .error, %%property)
        #endif
        
        return CSSPropertyValueContainer.unsupported
    }
    
}
