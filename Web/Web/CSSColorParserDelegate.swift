//
//  CSSColorParser+Validator.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-19.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

final class CSSColorParserDelegate : Validator {
    
    init() {
         
    }
    
    func validateAlphaComponentRange(_ numberToken: NumberToken, alpha: CGFloat) -> InsideRangeValidationResult {
        
        if alpha < 0 || alpha > 1 {
            
            if alpha < 0 {
                
                return InsideRangeValidationResult.tooLow
            }
            else {
                
                return InsideRangeValidationResult.tooHigh
            }
        }
        return InsideRangeValidationResult.ok
        
    }
    
    func validateHSLHueComponentRange(_ color: CGFloat) -> InsideRangeValidationResult {
        
        // validate color
        if color < 0 || color > 360 {
            
            if color < 0 {
                
                return InsideRangeValidationResult.tooLow
            }
            else {
                
                return InsideRangeValidationResult.tooHigh
            }
        }
        return InsideRangeValidationResult.ok
    }
    
    func validateHSLHueComponentTypeIsNumber(_ numberToken: NumberToken) -> Bool {
    
        if numberToken.tokenId == §CSTokenId.percentageToken {
        
            return false 
        }
        return true
    }
    
    func validateRGBAComponents(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> Bool {
        
        if validateDecimalColorValueRange(red) != InsideRangeValidationResult.ok {
            
            return false
        }
        if validateDecimalColorValueRange(green) != InsideRangeValidationResult.ok {
            
            return false
        }
        if validateDecimalColorValueRange(blue) != InsideRangeValidationResult.ok {
            
            return false
        }
        if validateDecimalColorValueRange(alpha) != InsideRangeValidationResult.ok {
            
            return false
        }
        return true
    }
    
    func validateRGBColorComponentsRange(_ numberToken: NumberToken, color: CGFloat) -> InsideRangeValidationResult {
        
        if numberToken.tokenId == §CSTokenId.numberToken {
        
            // validate color
            if color < 0 || color > 255 {
                
                if color < 0 {
                    
                    return InsideRangeValidationResult.tooLow
                }
                else {
                    
                    return InsideRangeValidationResult.tooHigh
                }
            }
        }
        else if numberToken.tokenId == §CSTokenId.percentageToken {
            
            return validatePercentageValue(color)
        }
        return InsideRangeValidationResult.ok
    }
    
    func validatePercentageValue(_ value: CGFloat) -> InsideRangeValidationResult {
        
        if value < 0 || value > 100 {
            
            if value < 0 {
                
                return InsideRangeValidationResult.tooLow
            }
            else {
                
                return InsideRangeValidationResult.tooHigh
            }
        }
        return InsideRangeValidationResult.ok
    }
    
    func validateDecimalColorValueRange(_ value: CGFloat) -> InsideRangeValidationResult {
        
        if value < 0 || value > 1 {
            
            if value < 0 {
                
                return InsideRangeValidationResult.tooLow
            }
            else {
                
                return InsideRangeValidationResult.tooHigh
            }
        }
        return InsideRangeValidationResult.ok
    }
    
}
