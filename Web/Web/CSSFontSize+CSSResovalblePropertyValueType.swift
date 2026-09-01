//
//  CSSFontSize+CSSResovalblePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSFontSize : CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSFontSize
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: ResovablePropertyValueType, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        switch specifiedValue {
            
        case .length(let lengthValue):
            
            return lengthValue.resolveComputedValueFromSpecifiedValue(lengthValue, container: container, elementStyle: elementStyle, filterContext: filterContext)
            
        case .defaulted(_):
            
            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            // returning medium in this case...
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        UserAgent.shared.mediumFontSizePixelValue
                )))
            
        case .larger:
            return largerFontSize(specifiedValue, elementStyle: elementStyle, filterContext: filterContext)
            
        case .percentage(let value):
            return computedPercentageValue(value, elementStyle: elementStyle, filterContext: filterContext)
            
        case .smaller:
            return smallerFontSize(specifiedValue, elementStyle: elementStyle, filterContext: filterContext)
            
        case .xxSmall:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .xSmall:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .small:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .medium:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .large:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .xLarge:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
            
        case .xxLarge:
            return CSSPropertyValueContainer.fontSize(
                CSSFontSize.length(
                    CSSLength.px(
                        specifiedValue.pixelValueFromKeyword()
                )))
        }
    }
    
    fileprivate func largerFontSize(_ fontSize: CSSFontSize, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let inheritedKeyword = computeFontSizeKeywordFromInheritedPixelValue(elementStyle, filterContext: filterContext)
        
        switch inheritedKeyword {
            
        case .xxSmall:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xSmall.pixelValueFromKeyword())
            
        case .xSmall:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.small.pixelValueFromKeyword())
            
        case .small:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.medium.pixelValueFromKeyword())
            
        case .medium:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.large.pixelValueFromKeyword())
            
        case .large:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xLarge.pixelValueFromKeyword())
            
        case .xLarge:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xxLarge.pixelValueFromKeyword())
            
        case .xxLarge:
            
            let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
            let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
            
            // we know we are around 200% bigger than medium so to reach
            // the next level we need to get to 300% so 200*1.5.
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(pixelFontSize*1.5)
            
        case .length(let value):
            
            switch value {
                
            default:
                
                let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
                let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
                
                // we know we are around 200% bigger than medium so to reach
                // the next level we need to get to 300% so 200*1.5.
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(pixelFontSize*1.5)
            }
            
        default:
            
            assert(false, "Unexpected value.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: unexpected font size value", log: Log.Web.all, type: .error)
            #endif
            // returning medium default value
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.medium.pixelValueFromKeyword())
        }
        
    }
    
    fileprivate func smallerFontSize(_ fontSize: CSSFontSize, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let inheritedKeyword = computeFontSizeKeywordFromInheritedPixelValue(elementStyle, filterContext: filterContext)
        
        switch inheritedKeyword {
            
        case .xxSmall:
            
            let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
            let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
            
            // if pixel size is 9px return this value : it can not be smaller...
            
            let computedFontSize = pixelFontSize*0.85
            
            // if calculated font-size is smaller than minimum user agent font-size
            if computedFontSize < 0 {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xxSmall.pixelValueFromKeyword())
            }
            else {
                
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(computedFontSize)
            }
            
        case .xSmall:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xxSmall.pixelValueFromKeyword())
            
        case .small:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xSmall.pixelValueFromKeyword())
            
        case .medium:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.small.pixelValueFromKeyword())
            
        case .large:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.medium.pixelValueFromKeyword())
            
        case .xLarge:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.large.pixelValueFromKeyword())
            
        case .xxLarge:
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xLarge.pixelValueFromKeyword())
            
        case .length(let lengthValue):
            
            switch lengthValue {
                
            default:
                
                let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
                let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
                
                // we know we are around 200% bigger than medium so to reach
                // the next level we need to get to 300% so 200*1.5.
                return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(pixelFontSize*0.66)
            }
            
        default:
            assert(false, "Unexpected value.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: unexpected font size value", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.medium.pixelValueFromKeyword())
        }
    }
    
    fileprivate func computedPercentageValue(_ value: CGFloat, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
        let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
        
        let computedFontSize = (value/100)*pixelFontSize
        
        if computedFontSize <= 0 {
            
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(CSSFontSize.xxSmall.pixelValueFromKeyword())
        }
        else {
            
            return CSSPropertyValueContainer.fontSizePropertyValueFromPixelValue(computedFontSize)
        }
    }
    
    fileprivate func computeFontSizeKeywordFromInheritedPixelValue(_ elementStyle: ElementStyle, filterContext: FilterContext) -> CSSFontSize {
        
        let inheritedAbsoluteFontSizeValue = elementStyle.inheritedValue(.fontSize, filterContext: filterContext)
        
        let pixelFontSize = inheritedAbsoluteFontSizeValue.pixelFontSizeValue()
        
        let ratio = pixelFontSize/UserAgent.shared.mediumFontSizePixelValue * 100
        
        switch ratio {
            
        // 60% - 3:5
        case 0...68:
            return CSSFontSize.xxSmall
            
        // 75% - 3:4
        case 69...82:
            return CSSFontSize.xSmall
            
        // 89% - 8:9
        case 83...95:
            return CSSFontSize.small
            
        // 100% - 1:1
        case 96...110:
            return CSSFontSize.medium
            
        // 120% - 6:5
        case 111...135:
            return CSSFontSize.large
            
        // 150% - 3:2
        case 136...175:
            return CSSFontSize.xLarge
            
        // 200% - 2:1
        case 176...250:
            return CSSFontSize.xxLarge
            
        // 300% - 3:1
        default:
            return CSSFontSize.length(CSSLength.px(pixelFontSize))
        }
    }
    
    
}
