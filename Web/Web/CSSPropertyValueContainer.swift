//
//  CSSPropertyValueContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-16.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public enum CSSPropertyValueContainer: Equatable, CSSPropertyValueAssociatedValueProtocol {
    
    case customValue(CSDeclaration)
    case resolvedCustom([ComponentValue])
    
    /// Color Module
    case caretColor(CSSColor)
    case color(CSSColor)
    case backgroundColor(CSSColor)
    
    /// Font Module
    /// see http://www.w3.org/TR/css3-fonts/
    //    case Font = "font"

    case fontFamily(CSSFontFamily)
    
    case fontSize(CSSFontSize)
    
    case fontWeight(CSSFontWeight)
    
    case fontStyle(CSSFontStyle)
//    case FontStretch(CSSFontStretch)
//    case FontVariant(CSSFontVariant)

    
    /// Text Decoration Module
    //    case TextDecoration = "text-decoration" short property not supported
    case textDecorationLine(CSSTextDecorationLine)
    case textDecorationColor(CSSColor)
    case textDecorationStyle(CSSTextDecorationStyle)
    
    /// Text Module
//    case TextIndent // TODO
//    case TextTransform // TODO
//    case TextAlign // TODO
    
    case error
    case unsupported
    case none
    
    var resolvedComponentsValues: [CSComponentValue]? {
        
        switch self {
        case .resolvedCustom(let components):
            return components.compactMap { (componentValue) -> CSComponentValue? in
                return componentValue as? CSComponentValue
            }
        case .customValue: fallthrough
        case .caretColor: fallthrough
        case .color: fallthrough
        case .backgroundColor(_): fallthrough
        case .fontFamily(_): fallthrough
        case .fontSize(_): fallthrough
        case .fontWeight(_): fallthrough
        case .fontStyle(_): fallthrough
        case .textDecorationLine(_): fallthrough
        case .textDecorationColor(_): fallthrough
        case .textDecorationStyle(_): fallthrough
        case .error: fallthrough
        case .unsupported: fallthrough
        
        case .none:
            return nil
        }
    }
    
    public var customValueDeclaration: CSDeclaration? {
        switch self {

        case .customValue(let declaration):
            return declaration
        case .caretColor: fallthrough
        case .color: fallthrough
        case .backgroundColor(_): fallthrough
        case .fontFamily(_): fallthrough
        case .fontSize(_): fallthrough
        case .fontWeight(_): fallthrough
        case .fontStyle(_): fallthrough
        case .textDecorationLine(_): fallthrough
        case .textDecorationColor(_): fallthrough
        case .textDecorationStyle(_): fallthrough
        case .error: fallthrough
        case .unsupported: fallthrough
        case .resolvedCustom: fallthrough
        case .none:
            return nil
        }
    }
    
    public var isUnresolvedCustomValueProperty: Bool {
        switch self {
        case .customValue:
            return true
        case .resolvedCustom: fallthrough
        case .caretColor: fallthrough
        case .color: fallthrough
        case .backgroundColor(_): fallthrough
        case .fontFamily(_): fallthrough
        case .fontSize(_): fallthrough
        case .fontWeight(_): fallthrough
        case .fontStyle(_): fallthrough
        case .textDecorationLine(_): fallthrough
        case .textDecorationColor(_): fallthrough
        case .textDecorationStyle(_): fallthrough
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none:
            return false
        }
    }
    
    public var isResolvedComponentValuesCustomProperty: Bool {
        switch self {
        case .resolvedCustom:
            return true
        case .customValue: fallthrough
        case .caretColor: fallthrough
        case .color: fallthrough
        case .backgroundColor(_): fallthrough
        case .fontFamily(_): fallthrough
        case .fontSize(_): fallthrough
        case .fontWeight(_): fallthrough
        case .fontStyle(_): fallthrough
        case .textDecorationLine(_): fallthrough
        case .textDecorationColor(_): fallthrough
        case .textDecorationStyle(_): fallthrough
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none:
            return false
        }
    }
    
    
    
    public func isRelative() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isRelative()
            
        case .fontSize(let fontSize):
            return fontSize.isRelative()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isRelative()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isRelative()
            
        case .caretColor(let color):
            return color.isRelative()
            
        case .color(let color):
            return color.isRelative()
            
        case .backgroundColor(let color):
            return color.isRelative()
            
        case .textDecorationColor(let color):
            return color.isRelative()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isRelative()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isRelative()
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    public func isExplicitlyDefaulting() -> Bool {
        
        return isInherit() || isUnset() || isDefault() || isInitial() || isSelectedValue()
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit
    public func isInherit() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isInherit()
            
        case .fontSize(let fontSize):
            return fontSize.isInherit()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isInherit()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isInherit()
            
        case .caretColor(let color):
            return color.isInherit()
            
        case .color(let color):
            return color.isInherit()
            
        case .backgroundColor(let color):
            return color.isInherit()
            
        case .textDecorationColor(let color):
            return color.isInherit()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isInherit()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isInherit()
            
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#initial
    public func isInitial() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isInitial()
            
        case .fontSize(let fontSize):
            return fontSize.isInitial()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isInitial()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isInitial()
            
        case .caretColor(let color):
            return color.isInitial()
            
        case .color(let color):
            return color.isInitial()
            
        case .backgroundColor(let color):
            return color.isInitial()
            
        case .textDecorationColor(let color):
            return color.isInitial()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isInitial()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isInitial()
            
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#inherit-initial
    public func isUnset() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isUnset()
            
        case .fontSize(let fontSize):
            return fontSize.isUnset()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isUnset()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isUnset()
            
        case .caretColor(let color):
            return color.isUnset()
        
        case .color(let color):
            return color.isUnset()
            
        case .backgroundColor(let color):
            return color.isUnset()
            
        case .textDecorationColor(let color):
            return color.isUnset()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isUnset()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isUnset()
            
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    public func isDefault() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isDefault()
            
        case .fontSize(let fontSize):
            return fontSize.isDefault()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isDefault()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isDefault()
        
        case .caretColor(let color):
            return color.isDefault()
            
        case .color(let color):
            return color.isDefault()
            
        case .backgroundColor(let color):
            return color.isDefault()
            
        case .textDecorationColor(let color):
            return color.isDefault()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isDefault()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isDefault()
            
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    /// see http://dev.w3.org/csswg/css-cascade/#default
    public func isSelectedValue() -> Bool {
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.isSelectedValue()
            
        case .fontSize(let fontSize):
            return fontSize.isSelectedValue()
            
        case .fontWeight(let fontWeight):
            return fontWeight.isSelectedValue()
            
        case .fontStyle(let fontStyle):
            return fontStyle.isSelectedValue()
            
        case .caretColor(let color):
            return color.isSelectedValue()
        
        case .color(let color):
            return color.isSelectedValue()
            
        case .backgroundColor(let color):
            return color.isSelectedValue()
            
        case .textDecorationColor(let color):
            return color.isSelectedValue()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.isSelectedValue()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.isSelectedValue()
            
        case .error: fallthrough
        case .unsupported: fallthrough
        case .none: fallthrough
        case .resolvedCustom: fallthrough
        case .customValue:
            return false
        }
    }
    
    
    public func defaultingType() -> DefaultingType {
        
        assert(isExplicitlyDefaulting(), "is not explicitly defaulting.")
        
        switch self {
            
        case .fontFamily(let fontFamily):
            return fontFamily.defaultingType()
            
        case .fontSize(let fontSize):
            return fontSize.defaultingType()
            
        case .fontWeight(let fontWeight):
            return fontWeight.defaultingType()
            
        case .fontStyle(let fontStyle):
            return fontStyle.defaultingType()
            
        case .caretColor(let color):
            return color.defaultingType()
            
        case .color(let color):
            return color.defaultingType()
            
        case .backgroundColor(let color):
            return color.defaultingType()
            
        case .textDecorationColor(let color):
            return color.defaultingType()
            
        case .textDecorationLine(let textDecorationLineValue):
            return textDecorationLineValue.defaultingType()
            
        case .textDecorationStyle(let textDecorationStyleValue):
            return textDecorationStyleValue.defaultingType()
            
        case .resolvedCustom: fallthrough
        case .customValue:
            
            assert(false, "Custom can not be defaulted.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Custom can not be defaulted.", log: Log.Web.all, type: .error)
            #endif
            return .Default
            
        case .error:
            
            assert(false, "Error can not be defaulted.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error can not be defaulted.", log: Log.Web.all, type: .error)
            #endif
            return .Default
            
        case .unsupported:
            
            assert(false, "Unsupported can not be defaulted.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Unsupported can not be defaulted.", log: Log.Web.all, type: .error)
            #endif
            return .Default
            
        case .none:
            
            assert(false, "None can not be defaulted.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("None can not be defaulted.", log: Log.Web.all, type: .error)
            #endif
            return .Default
        }
    }
}

public func ==(lhs: CSSPropertyValueContainer, rhs: CSSPropertyValueContainer) -> Bool {
    
    switch(lhs, rhs) {

    case (.caretColor(let color), .caretColor(let otherColor)):
        
        if color != otherColor {
            return false
        }
        return true
        
    case (.color(let color), .color(let otherColor)):
        
        if color != otherColor {
            return false
        }
        return true
        
    case (.backgroundColor(let color), .backgroundColor(let otherColor)):
        
        if color != otherColor {
            return false
        }
        return true
        
    case (.fontFamily(let fontFamily), .fontFamily(let otherFontFamily)):
        
        if fontFamily != otherFontFamily {
            return false
        }
        return true
        
    case (.fontSize(let fontSize), .fontSize(let otherFontSize)):
        
        if fontSize != otherFontSize {
            return false
        }
        return true
        
    case (.fontWeight(let fontWeight), .fontWeight(let otherFontWeight)):
        
        if fontWeight != otherFontWeight {
            return false
        }
        return true
        
    case (.fontStyle(let fontStyle), .fontStyle(let otherFontStyle)):
        
        if fontStyle != otherFontStyle {
            return false
        }
        return true
//
//    case (.FontStretch(let lhsValue), .FontStretch(let rhsValue)):
//        return true
//        
//    case (.FontVariant(let lhsValue), .FontVariant(let rhsValue)):
//        return true
//        
    case (.textDecorationLine(let textDecorationLine), .textDecorationLine(let otherTextDecorationLine)):
        
        if textDecorationLine != otherTextDecorationLine {
            return false
        }
        return true
        
    case (.textDecorationColor(let color), .textDecorationColor(let otherColor)):
        
        if color != otherColor {
            return false
        }
        return true

    case (.textDecorationStyle(let textDecorationStyle), .textDecorationStyle(let otherTextDecorationStyle)):
        
        if textDecorationStyle != otherTextDecorationStyle {
            return false
        }
        return true

//    case (.TextIndent, .TextIndent):
//        return true
//        
//    case (.TextTransform, .TextTransform):
//        return true
//        
//    case (.TextAlign, .TextAlign):
//        return true
        
    case (.error, .error):
        return true
        
    case (.unsupported, .unsupported):
        return true
        
    case (.none, .none):
        return true
        
    case (.customValue(let declaration1), .customValue(let declaration2)):
        
        if !declaration1.equals(to: declaration2, comparePositions: true, compareValue: false) {
            return false
        }
        return true
        
    default:
        return false
    }
}
