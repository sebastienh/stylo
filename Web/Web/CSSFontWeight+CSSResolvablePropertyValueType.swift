//
//  CSSFontWeight+CSSResolvablePropertyValueType.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-01-15.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSFontWeight : CSSResovalblePropertyValueType {
    
    typealias ResovablePropertyValueType = CSSFontWeight
    
    func resolveComputedValueFromSpecifiedValue(_ specifiedValue: ResovablePropertyValueType, container: CSSPropertyValueContainer, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        switch specifiedValue {
            
        case .relative(let relativeValue):
            
            switch relativeValue {
            case .bolder:
                
                return bolderWeight(specifiedValue, elementStyle: elementStyle, filterContext: filterContext)
            case .lighter:
                return lighterWeight(specifiedValue, elementStyle: elementStyle, filterContext: filterContext)
            }
            
        case .absolute(let absoluteValue):
            
            switch absoluteValue{
            case .bold:
                return CSSPropertyValueContainer.fontWeight(CSSFontWeight.numeric(.bold))
            case .normal:
                return CSSPropertyValueContainer.fontWeight(CSSFontWeight.numeric(.normal))
            }
            
        case .numeric(_):
            
            return container
            
        case .defaulted(_):

            assert(false, "Specified value should not be of kind defaulted")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error: specified value should not be of kind defaulted", log: Log.Web.all, type: .error)
            #endif
            return CSSPropertyValueContainer.fontWeight(
                CSSFontWeight.numeric(.normal)
            )
        }
    }
    
    /// https://drafts.csswg.org/css-fonts-3/#font-weight-prop
    fileprivate func bolderWeight(_ fontWeight: CSSFontWeight, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let inheritedAbsoluteFontWeightValue = elementStyle.inheritedValue(.fontWeight, filterContext: filterContext)
        
        let fontWeightNumericValue = inheritedAbsoluteFontWeightValue.fontWeightNumericValue()
        
        switch fontWeightNumericValue {
            
            //  Inherited Value        Bolder      Lighter
            //  100                    400         100
            //  200                    400         100
            //  300                    400         100
            //  400                    700         100
            //  500                    700         100
            //  600                    900         400
            //  700                    900         400
            //  800                    900         700
            //  900                    900         700
            
        case .thin:
            return CSSPropertyValueContainer.fontWeight(.numeric(.normal))
        case .extraLight:
            return CSSPropertyValueContainer.fontWeight(.numeric(.normal))
        case .light:
            return CSSPropertyValueContainer.fontWeight(.numeric(.normal))
        case .normal:
            return CSSPropertyValueContainer.fontWeight(.numeric(.bold))
        case .medium:
            return CSSPropertyValueContainer.fontWeight(.numeric(.bold))
        case .semiBold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.black))
        case .bold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.black))
        case .extraBold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.black))
        case .black:
            return CSSPropertyValueContainer.fontWeight(.numeric(.black))
        }
    }
    
    /// https://drafts.csswg.org/css-fonts-3/#font-weight-prop
    fileprivate func lighterWeight(_ fontWeight: CSSFontWeight, elementStyle: ElementStyle, filterContext: FilterContext) -> CSSPropertyValueContainer {
        
        let inheritedAbsoluteFontWeightValue = elementStyle.inheritedValue(.fontWeight, filterContext: filterContext)
        
        let fontWeightNumericValue = inheritedAbsoluteFontWeightValue.fontWeightNumericValue()
        
        switch fontWeightNumericValue {
            
            //  Inherited Value        Bolder      Lighter
            //  100                    400         100
            //  200                    400         100
            //  300                    400         100
            //  400                    700         100
            //  500                    700         100
            //  600                    900         400
            //  700                    900         400
            //  800                    900         700
            //  900                    900         700
            
        case .thin:
            return CSSPropertyValueContainer.fontWeight(.numeric(.thin))
        case .extraLight:
            return CSSPropertyValueContainer.fontWeight(.numeric(.thin))
        case .light:
            return CSSPropertyValueContainer.fontWeight(.numeric(.thin))
        case .normal:
            return CSSPropertyValueContainer.fontWeight(.numeric(.thin))
        case .medium:
            return CSSPropertyValueContainer.fontWeight(.numeric(.thin))
        case .semiBold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.normal))
        case .bold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.normal))
        case .extraBold:
            return CSSPropertyValueContainer.fontWeight(.numeric(.bold))
        case .black:
            return CSSPropertyValueContainer.fontWeight(.numeric(.bold))
        }
    }
}
