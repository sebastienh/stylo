//
//  CSSColorParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import CoreImage
import os

final class CSSColorParser: CSSComponentsParser {
    
    let delegate: CSSColorParserDelegate
    
    override init(componentValueArray: [CSComponentValue] ) {
        
        self.delegate = CSSColorParserDelegate()
        
        super.init(componentValueArray: componentValueArray)
    }

    func parseToValue() -> CSSColor? {
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
            
                if preservedToken.isTokenId(§CSTokenId.whitespaceToken) {
                    
                    // nothing to do we just jump to the next component
                }
                // it is a keyword color
                else if preservedToken.isTokenId(§CSTokenId.identToken) {
                
                    return parseColorKeyword()
                }
                else if preservedToken.isTokenId(§CSTokenId.hashToken) {
                
                    if let color = parseColorHash() {
                    
//                        #if ALPHA_COLOR_ENABLED
                        return CSSColor.custom(color)
//                        #else
//                        let colorWithoutAlpha = CIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1)
//                        return CSSColor.custom(colorWithoutAlpha)
//                        #endif
                    }
                }
            }
            else if componentValue is CSFunctionComponentValue {
            
                if let color = parseColorFunction() {
                
//                    #if ALPHA_COLOR_ENABLED
                    return CSSColor.custom(color)
//                    #else
//                    let colorWithoutAlpha = CIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1)
//                    return CSSColor.custom(colorWithoutAlpha)
//                    #endif
                }
            }
            else {
                
                // we log the error 
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("CSSColorParser expect CSPreservedTokenComponentValue or CSFunctionComponentValue.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        return nil
    }
    
    fileprivate func parseColorKeyword() -> CSSColor? {
        
        if let componentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
            
            if componentValue.isTokenId(§CSTokenId.identToken) {
                
                let keyword: String = componentValue.value.stringRepresentation
                
                if let color = CSSColor.valueFromKeyword(keyword.lowercased()) {
                    
                    return color
                }
                else {
                    
                    // unknown color
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    Message.CreateMessage(MessageCode.unknownColor,
                                          args: [keyword]).logError()
                    #endif
                    return nil
                }
            }
            else {
                
                assert(false, "Component is not ident token id.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Component is not ident token id.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        return nil
    }

    fileprivate func parseColorFunction() -> CIColor? {
        
        if let componentValue = currentComponentValue() as? CSFunctionComponentValue {
            
            if let functionType = componentValue.functionType {
            
                switch functionType {
                    
                case .HSL:
                    
                    return parseHSLColorFunction()
                    
                case .HSLA:
                    
                    return parseHSLAColorFunction()
                    
                case .RGB:
                    
                    return parseRGBColorFunction()
                    
                case .RGBA:
                    
                    return parseRGBAColorFunction()
                    
                default:
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    Message.CreateMessage(MessageCode.unsupportedColorFunction, args: [componentValue.value.name]).logError()
                    #endif
                    return nil
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                Message.CreateMessage(MessageCode.unsupportedFunction, args: [componentValue.value.name]).logError()
                #endif
                return nil
            }
        }
        return nil
    }
    
    func parseHSLColorFunction() -> CIColor? {
        
        if let function = currentComponentValue() as? CSFunctionComponentValue {
            
            if let colorComponents = colorComponentsFromFunction(function, expectedNumberOfArguments:3,
                colorModel: ColorModel.hsl) {
            
                return ColorUtils.convertHSLAToCIColor(colorComponents[0], s: colorComponents[1], l: colorComponents[2], a: 1)
            }
        }
        return nil
    }
    
    func parseHSLAColorFunction() -> CIColor? {
        
        if let function = currentComponentValue() as? CSFunctionComponentValue {
            
            if let colorComponents = colorComponentsFromFunction(function, expectedNumberOfArguments: 4,
                colorModel: ColorModel.hsl), colorComponents.count == 4 {
             
                return ColorUtils.convertHSLAToCIColor(colorComponents[0], s: colorComponents[1], l: colorComponents[2], a: colorComponents[3])
            }
        }
        return nil
    }
    
    func parseRGBColorFunction() -> CIColor? {

        if let function = currentComponentValue() as? CSFunctionComponentValue {
            
            if let colorComponents = colorComponentsFromFunction(function, expectedNumberOfArguments: 3,
                colorModel: ColorModel.rgb) {
             
                return CIColor(red: colorComponents[0],
                    green: colorComponents[1],
                    blue: colorComponents[2],
                    alpha:1)
            }
        }
        return nil
    }
    
    func parseRGBAColorFunction() -> CIColor? {
        
        if let function = currentComponentValue() as? CSFunctionComponentValue {
            
            if let colorComponents = colorComponentsFromFunction(function, expectedNumberOfArguments: 4,
                colorModel: ColorModel.rgb) {
                
                return CIColor(red: colorComponents[0],
                    green: colorComponents[1],
                    blue: colorComponents[2],
                    alpha:colorComponents[3])
            }
        }
        return nil
    }
    
    fileprivate func parseColorHash() -> CIColor? {
    
        if let componentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
        
            if componentValue.isTokenId(§CSTokenId.hashToken) {
                
                var red:   CGFloat = 0.0
                var green: CGFloat = 0.0
                var blue:  CGFloat = 0.0
                var alpha: CGFloat = 1.0
                
                let hex = componentValue.value.stringRepresentation
                
                var hexValue: CUnsignedLongLong = 0
                
                let scanner = Scanner(string: hex)
                
                if scanner.scanHexInt64(&hexValue) {
                    
                    switch (hex.count) {
                        
                    case 3:
                        red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                        green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                        blue  = CGFloat(hexValue & 0x00F)              / 15.0

                    case 4:
                        red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                        green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                        blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                        alpha = CGFloat(hexValue & 0x000F)             / 15.0

                    case 6:
                        red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                        green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                        blue  = CGFloat(hexValue & 0x0000FF)           / 255.0

                    case 8:
                        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                        blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                        alpha = CGFloat(hexValue & 0x000000FF)         / 255.0

                    default:
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        Message.CreateMessage(MessageCode.invalidHexColorValue,
                            args: [hex]).logError()
                        #endif
                        return nil
                    }
                } else {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    Message.CreateMessage(MessageCode.invalidHexColorValue,
                        args: [hex]).logError()
                    #endif
                    return nil
                }
                
                return CIColor(red:red, green:green, blue:blue, alpha:alpha)
            }
            else {
                
                assert(false, "Component is not ident token id.")
            }
        }
        return nil
    }
    
    func colorComponentsFromFunction(_ function: CSFunctionComponentValue, expectedNumberOfArguments: Int, colorModel: ColorModel) -> [CGFloat]? {
        
        var colorComponents = [CGFloat]()
        
        var parsedArguments: Int = 0
        
        var lastPreservedToken: CSPreservedTokenComponentValue?
        
        for componentValue in function.value.componentValueList {
                
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                lastPreservedToken = preservedToken
                
                if preservedToken.isTokenId(§CSTokenId.numberToken) ||
                    preservedToken.isTokenId(§CSTokenId.percentageToken) {
                    
                    parsedArguments += 1
                    
                    if parsedArguments > expectedNumberOfArguments {
                    
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        Message.CreateMessage(MessageCode.tooManyArgumentsPassedToFunction).logError()
                        #endif
                        return nil
                    }
                    
                    if let numberToken = preservedToken.value as? NumberToken {
                        
                        let number = numberToken.number
                        let value: CGFloat
                        
                        switch number.numberType {
                            
                        case .integer:
                            
                            value = CGFloat(number.value)
                            
                        case .real:
                            
                            value = CGFloat(number.value)
                            
                        case .nil:
                            
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("number is nil.", log: Log.Web.all, type: .error)
                            #endif
                            value = 0
                        }
                        
                        if parsedArguments < 4 {
                         
                            var finalNumber: CGFloat = 0
                            
                            switch colorModel {
                                
                            case .rgb:
                                
                                let result = delegate.validateRGBColorComponentsRange(numberToken, color: value)
                                
                                switch result {
                                    
                                case .tooHigh:
                                    
                                    if numberToken.tokenId == §CSTokenId.numberToken {
                                        
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongRGBColorRange).logError()
                                        #endif
                                        finalNumber = convertRGBComponentToAcceptableValue(value)
                                    }
                                    else if numberToken.tokenId == §CSTokenId.percentageToken {
                                        Message.CreateMessage(MessageCode.wrongPercentageColorRange).logError()
                                        finalNumber = convertPercentageToAcceptableValue(value)
                                    }
                                case .tooLow:
                                    
                                    if numberToken.tokenId == §CSTokenId.numberToken {
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongRGBColorRange).logError()
                                        #endif
                                        finalNumber = convertRGBComponentToAcceptableValue(value)
                                    }
                                    else if numberToken.tokenId == §CSTokenId.percentageToken {
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongPercentageColorRange).logError()
                                        #endif
                                        finalNumber = convertPercentageToAcceptableValue(value)
                                    }
                                case .ok:
                                    
                                    if numberToken.tokenId == §CSTokenId.numberToken {
                                        
                                        finalNumber = convertRGBComponentToAcceptableValue(value)
                                    }
                                    else if numberToken.tokenId == §CSTokenId.percentageToken {
                                        
                                        finalNumber = convertPercentageToAcceptableValue(value)
                                    }
                                }
                                
                                // Here we must convert the color to it's 0 to 1 representation.
                                colorComponents.append(finalNumber)
                                
                            case .hsl:
                                
                                // HUE
                                if parsedArguments == 1 {
                                    
                                    let result = delegate.validateHSLHueComponentTypeIsNumber(numberToken)
                                    
                                    if !result {
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongValueTypePercentageForHSLHueComponent).logError()
                                        #endif
                                    }
                                    
                                    colorComponents.append(convertHUEToAcceptableValue(value))
                                }
                                
                                // SATURATION OR LIGHTNESS
                                else if parsedArguments == 2 || parsedArguments == 3 {
                                
                                    let result = delegate.validatePercentageValue(value)
                                    
                                    switch result {
                                        
                                    case .tooHigh:
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongPercentageColorRange).logError()
                                        #endif
                                        finalNumber = convertPercentageToAcceptableValue(value)
                                        
                                    case .tooLow:
                                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                        Message.CreateMessage(MessageCode.wrongPercentageColorRange).logError()
                                        #endif
                                        finalNumber = convertPercentageToAcceptableValue(value)
                                        
                                    case .ok:
                                        finalNumber = value
                                    }
                                    
                                    colorComponents.append(finalNumber)
                                }
                            }
                        }
                        else if parsedArguments == 4 && expectedNumberOfArguments == 4 {
                            
                            let result = delegate.validateAlphaComponentRange(numberToken, alpha: value)
                            
                            switch result {
                            case .ok:
                                colorComponents.append(value)
                            case .tooHigh:
                                colorComponents.append(1)
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                Message.CreateMessage(MessageCode.wrongAlphaRange).logError()
                                #endif
                            case .tooLow:
                                colorComponents.append(0)
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                Message.CreateMessage(MessageCode.wrongAlphaRange).logError()
                                #endif
                            }
                        }
                    }
                }
            }
        }
        
        if parsedArguments < expectedNumberOfArguments {
            
            if lastPreservedToken != nil {
                
                // not enough arguments
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                Message.CreateMessage(MessageCode.notEnoughArgumentsPassedToFunction).logError()
                #endif
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                Message.CreateMessage(MessageCode.noArgumentsPassedToFunction).logError()
                #endif
            }
            return nil
        }
        return colorComponents
    }
    
    func convertHUEToAcceptableValue(_ number: CGFloat) -> CGFloat {
        
        return (((number.truncatingRemainder(dividingBy: 360)) + 360).truncatingRemainder(dividingBy: 360))/360
    }
    
    func convertPercentageToAcceptableValue(_ number: CGFloat) -> CGFloat {
        
        if number > 100 {
            return 1
        }
        else if number < 0 {
            return 0
        }
        return convertPercentageToFloatValue(number)
    }
    
    func convertRGBComponentToAcceptableValue(_ number: CGFloat) -> CGFloat {
        
        if number > 255 {
            return convertRGBToFloatValue(255)
        }
        else if number < 0 {
            return 0
        }
        return convertRGBToFloatValue(number)
    }
    
    func convertRGBToFloatValue(_ number: CGFloat) -> CGFloat {
     
        if number == 0 {
            return 0
        }
        else {
            return number/255
        }
    }
    
    func convertPercentageToFloatValue(_ number: CGFloat) -> CGFloat {
     
        if number == 0 {
            return 0
        }
        else {
            return number/100
        }
    }
}
