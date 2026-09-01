//
//  CSSLength+CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

extension CSSLength : CSSResovalblePropertyValueType {
    
    #if os(OSX)
    typealias PlateformFontType = NSFont
    #else
    typealias PlateformFontType = UIFont
    #endif
    
    typealias ResovablePropertyValueType = CSSLength
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: CSSLength, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        // font-relative lengths
        switch specifiedValue {
            
            /// Equal to the used advance measure of the "0" (ZERO, U+0030) glyph found in the font
            /// used to render it.
            ///
            /// ‘ch’ width of the "0" (ZERO, U+0030) glyph in the element's font
            ///
        /// see http://www.w3.org/TR/2013/CR-css3-values-20130730/#ch-unit
        case .ch(let value):
            
            return computedChValue(value, propertyValueContainer: container, elementStyle: elementStyle, filterContext: filterContext)
            
            /// Equal to the computed value of the ‘font-size’ property of the element on which it is used.
            /// 'em' font size of the element
        /// see http://www.w3.org/TR/2013/CR-css3-values-20130730/#em-unit
        case .em(let value):
            
            return computedEmValue(value, propertyValueContainer: container, elementStyle: elementStyle, filterContext: filterContext)
            
        case .ex(let value):
            
            return computedExValue(value, propertyValueContainer: container, elementStyle: elementStyle, filterContext: filterContext)
            
        case .rem(let value):
            
            return computedRemValue(value, propertyValueContainer: container, elementStyle: elementStyle)
            
        /// ‘vh’ 1% viewport's height
        case .vh(let value):
            
            return computedVhValue(value, propertyValueContainer: container)
            
        /// ‘vmax’ 1% of viewport's larger dimension
        case .vmax(let value):
            
            return computedVmaxValue(value, propertyValueContainer: container)
            
        /// ‘vmin’ 1% of viewport's smaller dimension
        case .vmin(let value):
            
            return computedVminValue(value, propertyValueContainer: container)
            
        /// ‘vw’ 1% of viewport's width
        case .vw(let value):
            
            return computedVwValue(value, propertyValueContainer: container)
            
        /// ‘cm’    centimeters
        case .centimeters(let value):
            return computedCmValue(value, propertyValueContainer: container)
            
        /// ‘mm’    millimeters
        case .mm(let value):
            return computedMmValue(value, propertyValueContainer: container)
            
        /// ‘in’    inches; 1in is equal to 2.54cm
        case .in(let value):
            return computedInValue(value, propertyValueContainer: container)
            
        /// ‘px’    pixels; 1px is equal to 1/96th of 1in
        case .px(let value):
            return computedPxValue(value, propertyValueContainer: container)
            
        /// ‘pt’    points; 1pt is equal to 1/72nd of 1in
        case .pt(let value):
            return computedPtValue(value, propertyValueContainer: container)
            
        /// ‘pc’    picas; 1pc is equal to 12pt
        case .pc(let value):
            return computedPcValue(value, propertyValueContainer: container)
            
        /// q    quarter-millimeters    1q = 1/40th of 1cm
        case .q(let value):
            return computedQValue(value, propertyValueContainer: container)
        }
    }
    
    /// "the computed value of the ‘font-size’ property of the element
    /// on which it is used."
    /// see http://dev.w3.org/csswg/css-values-3/#em
    func computedEmValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let rawComputedFontSizeValue: CSSPropertyValueContainer?
        
        switch propertyValueContainer {
            
        case .fontSize(_):
            
            // if we want to calculate absolute value for the font-size
            // property itself we should refer to the inherited value
            rawComputedFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
            
        default:
            
            rawComputedFontSizeValue = elementStyle.rawComputedValueForProperty(§CSSProperty.fontSize)
        }
        
        if let rawComputedFontSizeValue = rawComputedFontSizeValue {
            
            let fontSizePixelValue = rawComputedFontSizeValue.pixelFontSizeValue()
            
            let computedFontSize = fontSizePixelValue*value
            
            if computedFontSize < 0 {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(0)
            }
            else {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(computedFontSize)
            }
        }
        
        assert(false, "We should not be here.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("error: reveived invalid value in computedEmValue(...)", log: Log.Web.all, type: .error)
        #endif
        return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(0)
    }
    
    /// Equal to the used x-height of the first available font.
    /// see http://dev.w3.org/csswg/css-values-3/#ex
    func computedExValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let usedFontSize: CSSPropertyValueContainer?
        
        switch propertyValueContainer {
            
        case .fontSize(_):
            
            usedFontSize = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
            
        default:
            
            usedFontSize = elementStyle.rawComputedValueForProperty(§CSSProperty.fontSize)
        }
        
        // the method firstAvailableFont makes sure that font-family
        // property has been computed.
        let fontFamily = elementStyle.firstAvailableFontFamily()
        
        if let usedFontSize = usedFontSize {
            
            if let font = PlateformFontType(name: fontFamily.fontFamilyStringValue(), size: usedFontSize.pixelFontSizeValue()){
                
                let xHeightValue = font.xHeight*value
                
                if xHeightValue < 0 {
                    
                    return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(0)
                }
                else {
                    
                    return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(xHeightValue)
                }
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("usedFontSize is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        // In the cases where it is impossible or impractical to determine the x-height,
        // a value of 0.5em must be assumed.
        return computedEmValue(0.5, propertyValueContainer: propertyValueContainer, elementStyle: elementStyle, filterContext: filterContext)
    }
    
    /// Equal to the computed value of font-size on the root element. When specified on the font-size property
    /// of the root element, the rem units refer to the property’s initial value.
    ///
    /// see http://dev.w3.org/csswg/css-values-3/#rem
    func computedRemValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer, elementStyle: ElementStyle) -> CSSPropertyValueContainer {
        
        var rawComputedFontSizeValue: CSSPropertyValueContainer? = nil
        
        if let root = elementStyle.associatedElement!.document.documentElement {
            
            let rawComputedStyle = elementStyle.resourceComputedStyle.rawComputedStyleForElement(root)
            rawComputedFontSizeValue = rawComputedStyle.getCSSPropertyValueContainer(§CSSProperty.fontSize)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("associatedElement.document.documentElement returns nil.", log: Log.Web.all, type: .error)
            #endif
            let propertyDefinitionTable = CSSPropertyDefinitionTable.shared
            rawComputedFontSizeValue = propertyDefinitionTable.initialValueForProperty(CSSProperty.fontSize)
        }
                
        if let rawComputedFontSizeValue = rawComputedFontSizeValue {
            
            let fontSizePixelValue = rawComputedFontSizeValue.pixelFontSizeValue()
            
            let computedFontSize = fontSizePixelValue*value
            
            if computedFontSize < 0 {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(0)
            }
            else {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(computedFontSize)
            }
        }
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error: returning default font size value becaue rawComputedFontSizeValue.", log: Log.Web.all, type: .error)
        #endif
        return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(0)
    }
    
    /// Equal to the used advance measure of the "0" (ZERO, U+0030) glyph found in the font used to render it.
    ///
    /// see http://dev.w3.org/csswg/css-values-3/#ch
    func computedChValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let usedFontSize: CSSPropertyValueContainer?
        
        switch propertyValueContainer {
        case .fontSize(_):
            usedFontSize = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
        default:
            usedFontSize = elementStyle.rawComputedValueForProperty(§CSSProperty.fontSize)
        }
        
        let usedFontFamily = elementStyle.rawComputedValueForProperty(§CSSProperty.fontFamily)
        
        if let usedFontSize = usedFontSize, let usedFontFamily = usedFontFamily {
            
            if let font = PlateformFontType(name: usedFontFamily.fontFamilyStringValue(), size: usedFontSize.pixelFontSizeValue()) {
                
                #if os(OSX)
                    let advancement = font.advancement(forGlyph: 0x0030)
                    
                    // based on the interpretation that advance measure in CSS means
                    // the horizontal advance and not the vertical advance.
                    let advancementValue = advancement.width*value
                    
                #else
                    // FIXME: need a way to find this value
                    let advancementValue = font.ascender
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Warning: Got the wrong advancement value.", log: Log.Web.all, type: .fault)
                #endif 
                #endif
                
                if advancementValue < 0 {
                    return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(0)
                }
                else {
                    
                    return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(advancementValue)
                }
                
            }
        }
        
        return computedEmValue(value, propertyValueContainer: propertyValueContainer, elementStyle: elementStyle, filterContext: filterContext)
    }
    
    /// Mark: Viewport-percentage lengths: the vw, vh, vmin, vmax units
    /// see http://dev.w3.org/csswg/css-values-3/#viewport_percentage-lengths
    
    /// Equal to 1% of the height of the initial containing block.
    /// In my case, it is defined by UserAgent and it should
    /// be the screen size.
    /// see http://dev.w3.org/csswg/css-values-3/#vh
    func computedVhValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let viewportHeight = UserAgent.shared.viewportHeight!
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Computed viewport height %@", log: Log.Web.all, type: .info, %%viewportHeight)
        #endif
        
        let vh = viewportHeight*0.01
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(vh*value)
    }
    
    /// Equal to 1% of the width of the initial containing block.
    /// see http://dev.w3.org/csswg/css-values-3/#vw
    func computedVwValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let viewportWidth = UserAgent.shared.viewportWidth!
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Computed viewport width %@", log: Log.Web.all, type: .info, %%viewportWidth)
        #endif
        
        let vw = viewportWidth*0.01
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED 
        os_log("Computed value %@", log: Log.Web.all, type: .info, %%vw)
        #endif
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(vw*value)
    }
    
    /// Equal to the larger of vw or vh.
    /// see http://dev.w3.org/csswg/css-values-3/#vmax
    func computedVmaxValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let vh = computedVhValue(value, propertyValueContainer: propertyValueContainer)
        let vw = computedVwValue(value, propertyValueContainer: propertyValueContainer)
        
        let vhPixelLengthValue = vh.pixelLengthValue()
        let vwPixelLengthValue = vw.pixelLengthValue()
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(max(vhPixelLengthValue,vwPixelLengthValue))
    }
    
    /// Equal to the smaller of vw or vh.
    /// see http://dev.w3.org/csswg/css-values-3/#vmin
    func computedVminValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let vh = computedVhValue(value, propertyValueContainer: propertyValueContainer)
        let vw = computedVwValue(value, propertyValueContainer: propertyValueContainer)
        
        let vhPixelLengthValue = vh.pixelLengthValue()
        let vwPixelLengthValue = vw.pixelLengthValue()
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(min(vhPixelLengthValue,vwPixelLengthValue))
    }
    
    /// Mark: Absolute lengths: the cm, mm, q, in, pt, pc, px units
    /// see http://dev.w3.org/csswg/css-values-3/#absolute-lengths
    
    /// ‘cm’    centimeters
    func computedCmValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromCm(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    ///
    /// ‘mm’    millimeters
    func computedMmValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromMm(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    /// The input value is in inches.
    /// ‘in’    inches; 1in is equal to 2.54cm
    func computedInValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromIn(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    /// ‘px’    pixels; 1px is equal to 1/96th of 1in
    func computedPxValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        // Even if the value if the form we want already we want to validate negative values
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(propertyValueContainer.pixelLengthValue())
    }
    
    /// ‘pt’    points; 1pt is equal to 1/72nd of 1in
    func computedPtValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromPt(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    /// ‘pc’    picas; 1pc is equal to 12pt
    func computedPcValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromPc(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    /// 'q' quarter-millimeters; 1q = 1/40th of 1cm
    func computedQValue(_ value: CGFloat, propertyValueContainer: CSSPropertyValueContainer) -> CSSPropertyValueContainer {
        
        let pixelLengthValue = computePixelLengthValueFromQ(value)
        
        return propertyValueContainer.pixelLengthPropertyValueFromPixelValue(pixelLengthValue)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// quarter-millimeters
    /// 1q = 1/40th of 1cm
    fileprivate func computePixelLengthValueFromQ(_ qValue: CGFloat) -> CGFloat {
        
        return computePixelLengthValueFromCm(qValue/40)
    }
    
    /// ‘pt’    points; 1pt is equal to 1/72nd of 1in
    /// 1pt = 1/72th of 1in
    fileprivate func computePixelLengthValueFromPt(_ ptValue: CGFloat) -> CGFloat {
        
        return computePixelLengthValueFromIn(ptValue/72)
    }
    
    /// ‘pc’    picas; 1pc is equal to 12pt
    /// 1pc = 1/6th of 1in
    fileprivate func computePixelLengthValueFromPc(_ pcValue: CGFloat) -> CGFloat {
        
        return computePixelLengthValueFromIn(pcValue/6)
    }
    
    /// ‘in’    inches; 1in is equal to 2.54cm
    /// 1in = 2.54cm = 96px
    fileprivate func computePixelLengthValueFromIn(_ inValue: CGFloat) -> CGFloat {
        
        return computePixelLengthValueFromCm(inValue*2.54)
    }
    
    /// ‘cm’    centimeters
    /// 1cm = 96px/2.54
    fileprivate func computePixelLengthValueFromCm(_ cmValue: CGFloat) -> CGFloat {
        
        return cmValue*96/2.54
    }
    
    /// ‘mm’    millimeters
    /// 1mm = 1/10th of 1cm
    fileprivate func computePixelLengthValueFromMm(_ mmValue: CGFloat) -> CGFloat {
        
        return computePixelLengthValueFromCm(mmValue/10)
    }
    
    
    
}
