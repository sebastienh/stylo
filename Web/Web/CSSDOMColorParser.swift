///
//  CSSColorDOMParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMColorParser: CSSDOMPropertyParser {
    
    let delegate: CSSColorParserDelegate
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement) {
        
        self.delegate = CSSColorParserDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    func parseColorValueToDOM() {
        
        assert(parentPropertyElement != nil, "parentPropertyElement == nil")
        
        parseWhitespaces()
        
        if let componentValue = currentComponentValue() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("componentValue sourceStringSegment: %@", log: Log.Web.all, type: .info, %%componentValue.sourceStringSegment)
            #endif
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("color parser, handling component value: %@ ", log: Log.Web.all, type: .info, %%preservedToken.cssText())
                #endif
                
                // it is a keyword color
                if preservedToken.value.tokenId == §CSTokenId.identToken {
                    
                    parseColorKeywordToDOM()
                }
                else if preservedToken.isTokenId(§CSTokenId.hashToken) {
                    
                    parseColorHashToDOM()
                }
                // we may have only a hash value
                else if preservedToken.isTokenId(§CSTokenId.delimToken) {
                    
                    if preservedToken.value.rawStringValue == "#" {
                        
                        parseHashDelimTokenToDOM()
                    }
                    else {
                        consumeComponentsAsUnknownDomElements()
                        return
                    }
                }
                else {
                    
                    consumeComponentsAsUnknownDomElements()
                    return
                }
            }
            else if let _ = componentValue as? CSFunctionComponentValue {
                
                parseFunctionToDOM()
            }
            else {
                
                consumeNextComponentsAsUnknownDomElements()
                return
            }
            
//            assert(parentPropertyElement!.firstChild != nil, "parentPropertyValueElement!.firstChild == nil")
//            assert((parentPropertyElement!.firstChild! as! Element).localName == §CSSElementType.ColorValue, "parentPropertyValueElement!.firstChild!.nodeName != §PseudoElementType.ColorValue")
            
            let colorValueElement = parentPropertyElement?.firstChild // ! as! CSSDOMColorValueElement
            
            if let colorValueElement = colorValueElement as? CSSDOMColorValueElement, !colorValueElement.hasErrors() {

                let colorParser = CSSColorParser(componentValueArray: self.componentValueArray)
            
                if let color = colorParser.parseToValue() {
                    
                    // NW-160 : selected-value
                    // we do this to associate CSSPropertyValueContainer.CSSFontFamily with each DOM elements
                    // in order for the RenderingProcessor to know the value represented by this element
                    // we can not take the value from the CSDeclaration since it contains only the first valid one
                    // which is the only needed for the target styled document.
                    // NW-160 : add the specified value to the dom element
                    colorValueElement.propertyValue = CSSPropertyValueContainer.color(color)
                }
            }
        }
        
        consumeNextComponentsAsUnknownDomElements()
    }
    
    
    //              color: rgb(124, 89, 12) would give:
    //
    //                                                                                         ::color-value
    //                                                                                              |
    //                                                                                              |
    //                                                                                        ::function.rgb
    //                                                                                              |
    //           ___________________________________________________________________________________|_______________________________________________________________
    //          /   				|                           |                  |                |                   |                   |                     	\
    //         /   					|							|				   |				|                   |                   |					     \
    //  ::function-start	    ::function-param   		css-token.coma    ::function-param  css-token.coma     ::function-param  	css-token.left-parenthesis
    //        |                                                 |                                   |										|
    //        |                                                 |									|										|
    // css-token.function-token.rgb                     css-token.number 					 css-token.number 						css-token.number
    //
    fileprivate func parseFunctionToDOM() {
        
        var exception = Exception()
        
        if let componentValue = currentComponentValue() as? CSFunctionComponentValue {
            
            let function = currentComponentValue() as! CSFunctionComponentValue
            let functionSourceStringSegment = functionSourceStringSegmentFromCSFunctionToken(componentValue.value)
            let colorValueElement = CSSDOMColorValueElement(segment: functionSourceStringSegment, document: document, localName: §CSSElementType.ColorValue)
            
            parentPropertyElement!.appendChild(colorValueElement, exception: &exception)
            
            let functionElement = CSSDOMElement(segment: functionSourceStringSegment, document: document, localName: §CSSElementType.Function)
            
            // add the function name to the function element
            functionElement.addClassAttribute(componentValue.value.name)
            
            colorValueElement.appendChild(functionElement, exception: &exception)
            exception.logIfError()
            
            let functionStartElement = CSSDOMElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.FunctionStart)
            
            functionElement.appendChild(functionStartElement, exception: &exception)
            exception.logIfError()
            
            let functionToken = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: TokenClassType.FunctionToken, textValue: componentValue.value.name)
            
            functionToken.addClassAttribute(componentValue.value.name)
            
            assert(!(functionStartElement is CSSDOMTokenElement))
            functionStartElement.appendChild(functionToken, exception: &exception)
            exception.logIfError()
            
            if let functionType = componentValue.functionType {
                
                switch functionType {
                    
                case .HSL:
                    
                    colorComponentsFromFunction(function, expectedNumberOfArguments:3,
                        colorModel: ColorModel.hsl, functionElement: functionElement)
                    
                case .HSLA:
                    
                    colorComponentsFromFunction(function, expectedNumberOfArguments:4,
                        colorModel: ColorModel.hsl, functionElement: functionElement)
                    
                case .RGB:
                    
                    colorComponentsFromFunction(function, expectedNumberOfArguments:3,
                        colorModel: ColorModel.rgb, functionElement: functionElement)
                    
                case .RGBA:
                    
                    colorComponentsFromFunction(function, expectedNumberOfArguments:4,
                        colorModel: ColorModel.rgb, functionElement: functionElement)
                    
                // right now it will never be executed but as soon as we support 
                // other functions this warning will disappear.
                default:
                    
                    // MessageCode.UnsupportedColorFunction
                    functionStartElement.addMessage(MessageCode.unsupportedColorFunction, args: [componentValue.value.name])
                }
                
//                // handle the errors we found
//                if functionElement.hasErrors() {
//                    
//                    colorValueElement.addMessage(MessageCode.InvalidColor, args: nil, fromMessages: functionElement.allErrors)
//                }
            }
            else {
                
                // MessageCode.UnsupportedFunction
                functionStartElement.addMessage(MessageCode.unsupportedFunction, args: [componentValue.value.name])
                
                // we should continue to parse the rest of the function parameters, 
                // rule #1: always give the more information we can to the user.
                colorComponentsFromFunction(function, expectedNumberOfArguments: nil,
                    colorModel: ColorModel.rgb, functionElement: functionElement)
            }
        }
    }
    
    func colorComponentsFromFunction(_ function: CSFunctionComponentValue, expectedNumberOfArguments: Int?, colorModel: ColorModel?, functionElement: CSSDOMElement) {
        
        var exception = Exception()
        
        var parsedArguments: Int = 0
        
        for componentValue in function.value.componentValueList {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                if preservedToken.value.tokenId == §CSTokenId.numberToken ||
                    preservedToken.value.tokenId == §CSTokenId.percentageToken {
                        
                    let functionParameterElement = CSSDOMElement(segment: preservedToken.sourceStringSegment!, document: document, localName: §CSSElementType.FunctionParameter)
                    
                    functionElement.appendChild(functionParameterElement, exception: &exception)
                    
                    var errorMessage: Message?
                    
                    exception.logIfError()
                    
                    parsedArguments += 1
                    
                    if let expectedNumberOfArguments = expectedNumberOfArguments {

                        if parsedArguments > expectedNumberOfArguments {
                        
                            // too many arguments
                        
                            // MessageCode.UnexpectedParameter
                            let unexpectedParameter = functionParameterElement.addMessage(MessageCode.unexpectedParameter)
                        
                            // If we hve already detected to much parameters, simply add the parameter as a cause
                            // of the TooManyArgumentsPassedToFunction message added to the function.
                            if var message = functionElement.messageWithCode(MessageCode.tooManyArgumentsPassedToFunction) {
                                
                                message.addMessageDependency(unexpectedParameter)
                            }
                            else {
                                // MessageCode.TooManyArgumentsPassedToFunction
                                functionElement.addMessage(MessageCode.tooManyArgumentsPassedToFunction, args: nil, fromMessage: unexpectedParameter)
                            }
                        }
                    }
                    
                    if let numberToken = preservedToken.value as? NumberToken {
                        
                        let numberTokenElement = CSSDOMTokenElement(segment: numberToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.NumberToken, textValue: numberToken.stringRepresentation)
                        
                        assert(!(functionParameterElement is CSSDOMTokenElement))
                        functionParameterElement.appendChild(numberTokenElement, exception: &exception)
                        
                        let number = numberToken.number
                        
                        let value: CGFloat
                        
                        switch number.numberType {
                            
                        case .integer:
                            
                            value = CGFloat(number.value)
                            
                        case .real:
                            
                            value = CGFloat(number.value)
                            
                        case .nil:
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("number is Nil.", log: Log.Web.all, type: .error)
                            #endif
                            value = 0
                        }
                        
                        if let colorModel = colorModel {
                        
                            if parsedArguments < 4 {
                                
                                switch colorModel {
                                    
                                case .rgb:
                                    
                                    let result = delegate.validateRGBColorComponentsRange(numberToken, color: value)
                                    
                                    switch result {
                                        
                                    case .tooHigh:
                                        
                                        if numberToken.tokenId == §CSTokenId.numberToken {
                                            
                                            // MessageCode.WrongRGBColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongRGBColorRange)
                                        }
                                        else if numberToken.tokenId == §CSTokenId.percentageToken {
                                            
                                            // MessageCode.WrongPercentageColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongPercentageColorRange)
                                        }
                                    case .tooLow:
                                        
                                        if numberToken.tokenId == §CSTokenId.numberToken {
                                            
                                            // MessageCode.WrongRGBColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongRGBColorRange)
                                        }
                                        else if numberToken.tokenId == §CSTokenId.percentageToken {
                                            
                                            // MessageCode.WrongPercentageColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongPercentageColorRange)
                                        }
                                    case .ok:
                                        
                                        // nothing to do
                                        break
                                    }
                                    
                                    
                                case .hsl:
                                    
                                    // HUE
                                    if parsedArguments == 1 {
                                        
                                        let valid = delegate.validateHSLHueComponentTypeIsNumber(numberToken)
                                        
                                        if !valid {
                                            
                                            // MessageCode.WrongValueTypePercentageForHSLHueComponent,
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongValueTypePercentageForHSLHueComponent)
                                        }
                                        
                                        let hueRangeValid = delegate.validateHSLHueComponentRange(value)
                                        
                                        switch hueRangeValid {
                                            
                                        case .tooHigh: fallthrough
                                        case .tooLow:
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongHueComponentRange)
                                        case .ok:
                                            break
                                        }
                                    }
                                    // SATURATION OR LIGHTNESS
                                    else if parsedArguments == 2 || parsedArguments == 3 {
                                        
                                        let result = delegate.validatePercentageValue(value)
                                        
                                        switch result {
                                            
                                        case .tooHigh:
                                            
                                            // MessageCode.WrongPercentageColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongPercentageColorRange)
                                            
                                        case .tooLow:
                                            
                                            // MessageCode.WrongPercentageColorRange
                                            errorMessage = numberTokenElement.addMessage(MessageCode.wrongPercentageColorRange)
                                        case .ok:
                                            break
                                        }
                                    }
                                }
                            }
                            else if colorModel == .rgb, parsedArguments == 4 && expectedNumberOfArguments == 4 {
                                
                                let result = delegate.validateAlphaComponentRange(numberToken, alpha: value)
                                
                                switch result {
                                case .ok:
                                    break
                                    
                                case .tooHigh:
                                    // MessageCode.WrongAlphaRange
                                    errorMessage = numberTokenElement.addMessage(MessageCode.wrongAlphaRange)
                                    
                                case .tooLow:
                                    //MessageCode.WrongAlphaRange
                                    errorMessage = numberTokenElement.addMessage(MessageCode.wrongAlphaRange)
                                }
                                
                                #if ALPHA_COLOR_ENABLED
                                #else
//                                if value < 1.0 {
//                                    functionElement.addMessage(MessageCode.unsupportedColorAlpha)
//                                }
                                #endif

                            }
                        }
                    }
                }
                else if preservedToken.isTokenId(§CSTokenId.commaToken) {
                    
                    let commaTokenElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.CommaToken, textValue: preservedToken.value.stringRepresentation)
                    
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(commaTokenElement, exception: &exception)
                }
                else if preservedToken.isTokenId(§CSTokenId.whitespaceToken) {
                    
                    // nothing to do we just jump to the next component
                }
                else {
                    
                    // this an invalid argument but still an argument...
                    // to prevent adding notEnoughArgumentsPassedToFunction error
                    // when in fact the argument is just wrong. 
                    parsedArguments += 1
                    
                    let csTokenId = CSTokenId(rawValue: preservedToken.value.tokenId)!
                    
                    let unexpectedTokenElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.tokenClassFromTokenId(csTokenId), textValue: preservedToken.value.stringRepresentation)
                    
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(unexpectedTokenElement, exception: &exception)
                    
                    // if it's not a number nor a comma and we should handle the UnexpectedToken error.
                    
                    unexpectedTokenElement.addMessage(MessageCode.invalidArgument, args: [preservedToken.cssText()])
                }
            }
        }
        
        // handle the right parenthesis token which has a specific property 
        // because we don't want to alter the parding algorythm logic by appending it 
        // to the componentValueList
        if let rightParenthesisToken = function.value.rightParenthesisToken {
            
            let rightParenthesisTokenElement = CSSDOMTokenElement(segment: rightParenthesisToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.RightParenthesisToken, textValue: rightParenthesisToken.stringRepresentation)
            
            assert(!(functionElement is CSSDOMTokenElement))
            functionElement.appendChild(rightParenthesisTokenElement, exception: &exception)
        }
        
        if let expectedNumberOfArguments = expectedNumberOfArguments {
            
            if parsedArguments < expectedNumberOfArguments {
            
                // MessageCode.NotEnoughArgumentsPassedToFunction,
                functionElement.addMessage(MessageCode.notEnoughArgumentsPassedToFunction)
            }
        }
    }
    
    fileprivate func parseHashDelimTokenToDOM() {
        
        var exception = Exception()
        
        assert(currentComponentValue() is CSPreservedTokenComponentValue, "componentValue is not CSPreservedTokenComponentValue")
        
        if let componentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
            
            if componentValue.isTokenId(§CSTokenId.delimToken) {
                
                let colorValueElement = CSSDOMColorValueElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.ColorValue)
                
                parentPropertyElement!.appendChild(colorValueElement, exception: &exception)
                
                let hashValueElement = CSSDOMElement(segment: componentValue.sourceStringSegment!, document: document, localName: §CSSElementType.ColorHash)
                
                colorValueElement.appendChild(hashValueElement, exception: &exception)
                
                let delimTokenElement = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: TokenClassType.DelimToken, textValue: componentValue.value.stringRepresentation)
                
                assert(!(colorValueElement is CSSDOMTokenElement))
                colorValueElement.appendChild(delimTokenElement, exception: &exception)
                
                // parse all the unexpected tokens
                var currentComponentValue = nextComponentValue()
                
                while let _currentComponentValue = currentComponentValue as? CSPreservedTokenComponentValue {
                    
                    let unexpectedTokenElement = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: _currentComponentValue.associatedTokenClass(), textValue: _currentComponentValue.value.stringRepresentation)
                    
                    // add the message
                    unexpectedTokenElement.addMessage(MessageCode.invalidHexColorValue, args: [_currentComponentValue.cssText()])
                    
                    assert(!(colorValueElement is CSSDOMTokenElement))
                    colorValueElement.appendChild(unexpectedTokenElement, exception: &exception)
                    
                    advanceComponentValueIndex()
                    currentComponentValue = nextComponentValue()
                }
             }
        }
    }
    
    
    //                          color-value
    //                                |
    //                                |
    //                          color-hash
    //                                |
    //                                |
    //                      css-token.hash-token
    //
    fileprivate func parseColorHashToDOM() {
        
        var exception = Exception()
        
        assert(currentComponentValue() is CSPreservedTokenComponentValue, "componentValue is not CSPreservedTokenComponentValue")
        
        if let componentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
            
            if componentValue.isTokenId(§CSTokenId.hashToken) {
            
                let colorValueElement = CSSDOMColorValueElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.ColorValue)
            
                parentPropertyElement!.appendChild(colorValueElement, exception: &exception)
                
                let hashValueElement = CSSDOMElement(segment: componentValue.sourceStringSegment!, document: document, localName: §CSSElementType.ColorHash)
                
                colorValueElement.appendChild(hashValueElement, exception: &exception)
                
                let hashTokenElement = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: TokenClassType.HashToken, textValue: componentValue.value.stringRepresentation)
                
                assert(!(hashValueElement is CSSDOMTokenElement))
                hashValueElement.appendChild(hashTokenElement, exception: &exception)
                
                var scannedHex: Bool = false
                
                var red:   CGFloat = 0.0
                var green: CGFloat = 0.0
                var blue:  CGFloat = 0.0
                var alpha: CGFloat = 1.0
                
                let hex = componentValue.value.stringRepresentation
                
                var hexValue: CUnsignedLongLong = 0
                
                let scanner = Scanner(string: hex)
                
                if scanner.scanHexInt64(&hexValue) {
                    
                    switch hex.count {
                        
                    case 3:
                        red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                        green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                        blue  = CGFloat(hexValue & 0x00F)              / 15.0
                        scannedHex = true
                        
                    case 4:
                        red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                        green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                        blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                        alpha = CGFloat(hexValue & 0x000F)             / 15.0
                        scannedHex = true
                        
                    case 6:
                        red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                        green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                        blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                        scannedHex = true
                        
                    case 8:
                        red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                        green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                        blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                        alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                        scannedHex = true
                        
                    default:
                        
                        hashValueElement.addMessage(MessageCode.invalidHexColorValue, args:[hex])
                    }
                    
                    if scannedHex {
                        
                        if !delegate.validateRGBAComponents(red, green: green, blue: blue, alpha: alpha) {
                            hashValueElement.addMessage(MessageCode.invalidHexColorValue, args:[hex])
                        }
                    }
                    
                } else {
                    
                    hashValueElement.addMessage(MessageCode.invalidHexColorValue, args:[hex])
                }
            }
        }
    }
    
    
    //                         ::color-value
    //                                |
    //                                |
    //                         ::color-keyword
    //                                |
    //                                |
    //                    css-token.ident-token.blue
    //
    fileprivate func parseColorKeywordToDOM() {
        
        var exception = Exception()
        
        assert(currentComponentValue() is CSPreservedTokenComponentValue, "componentValue is not CSPreservedTokenComponentValue")
        
        if let componentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
            
            assert(componentValue.isTokenId(§CSTokenId.identToken), "componentValue.isTokenId(§CSTokenId.IdentToken) is not true.")
            
            if componentValue.isTokenId(§CSTokenId.identToken) {
                    
                let colorValueElement = CSSDOMColorValueElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.ColorValue)
                    
                parentPropertyElement!.appendChild(colorValueElement, exception: &exception)
                
                let keyword: String = componentValue.value.stringRepresentation
                
                let colorKeywordElement = CSSDOMElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.ColorKeyword)
                
                colorValueElement.appendChild(colorKeywordElement, exception: &exception)
                
                let identTokenElement = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: TokenClassType.IdentToken, textValue: componentValue.value.stringRepresentation)
                
                assert(!(colorKeywordElement is CSSDOMTokenElement))
                colorKeywordElement.appendChild(identTokenElement, exception: &exception)
                
                let color = ColorKeyword(rawValue: keyword.lowercased())
                
                if color == nil {
                    
                    let unknownColorKeywordMessage = Message.CreateMessage(MessageCode.unknownColor, args: [keyword.lowercased()])
                    
                    colorValueElement.addMessage(unknownColorKeywordMessage)
                }
            }
        }
    }
    
}
