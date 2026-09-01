//
//  CSSDOMFontParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-24.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMFontFamilyPropertyValueParser: CSSDOMPropertyParser, PropertyValueParser {

    let validatorDelegate: CSSFontFamilyValidatorDelegate
    
    override init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement? = nil) {
        
        self.validatorDelegate = CSSFontFamilyValidatorDelegate()
        
        super.init(componentValueArray: componentValueArray, parentPropertyElement: parentPropertyElement)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: PropertyValueParser protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias PropertyValueType = CSSFontFamily
    
    /// Method used to parse the property value and append the value to the 
    /// property-value DOM element. It doesn't return anything contrary to the
    /// parsePropertyValue() -> CSSPropertyValueContainer? method since it appends the result of
    /// the parsing process to the DOM tree.
    func parsePropertyValueDom() {
        
        assert(parentPropertyElement != nil, "parentPropertyElement == nil")
        
        parseWhitespaces()
        
        let fontFamilies: [([String], CSSDOMFontFamilyNameElement?)] = parseFontFamilyProperty()
        
        var exception = Exception()
        
        // iterates over the two arrays together
        for  index in 0..<fontFamilies.count {
            
            let (fontFamilyArray, domElement) = fontFamilies[index]
            
            // Here we make sure the domElement is not nil since that's what we are
            // supposed to have added to the non-nil parentPropertyValuePseudoElement.
            assert(domElement != nil, "domElement == nil")
            
            let spaceSeparatedFontFamilyName = constructStringByJoiningArrayElements(fontFamilyArray, withSeparator: " ")
            
            if let fontFamilyValue = CSSFontFamily.valueFromKeyword(spaceSeparatedFontFamilyName) {
                
                // NW-160 : selected-value
                // we do this to associate CSSPropertyValueContainer.CSSFontFamily with each DOM elements
                // in order for the RenderingProcessor to know the value represented by this element
                // we can not take the value from the CSDeclaration since it contains only the first valid one
                // which is the only needed for the target styled document.
                // NW-160 : add the specified value to the dom element
                domElement!.propertyValue = CSSPropertyValueContainer.fontFamily(fontFamilyValue)
            }
            else {
                
                // unsupported font family keyword
                domElement!.addMessage(MessageCode.unsupportedFontFamily,
                    args: [spaceSeparatedFontFamilyName])
            }
        }
    }
    
    /// Method used to get the value property. It does not need and must not have the
    /// parentPropertyValuePseudoElement variable set, beacause it will cause unecessary 
    /// computing.
    func parsePropertyValue() -> CSSFontFamily? {
        
        // Make sure parentPropertyValuePseudoElement is nil.
        assert(parentPropertyElement == nil, "parentPropertyElement != nil")
        
        parseWhitespaces()
        
        let fontFamilies: [([String], CSSDOMFontFamilyNameElement?)] = parseFontFamilyProperty()
        
        // iterates over the two arrays together
        for  index in 0..<fontFamilies.count {

            let (fontFamilyArray, _) = fontFamilies[index]
            
            let spaceSeparatedFontFamilyName = constructStringByJoiningArrayElements(fontFamilyArray)
            
            if let fontFamilyValue = CSSFontFamily.valueFromKeyword(spaceSeparatedFontFamilyName) {
                
                // here we return the first valid value because that's the only one we
                // care about. If we do not encouter valid value we will return nil.
                return fontFamilyValue
            }
        }
        
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    fileprivate func parseFontFamilyProperty() -> [([String], CSSDOMFontFamilyNameElement?)] {
        
        var exception = Exception()
        
        var fontFamilies = [([String], CSSDOMFontFamilyNameElement?)]()
        
//        var lastTokenWasString: Bool = false
        
        while let componentValue = currentComponentValue() {
                
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                if preservedToken.isTokenId(§CSTokenId.identToken)
                    || preservedToken.isTokenId(§CSTokenId.stringToken) {
                    
                    
                    // The StringToken can not be together with another Token
                    // we must validate that.
    //                if preservedToken.isTokenId(§CSTokenId.stringToken) {
    //
    //                    lastTokenWasString = true
    //                }
    //                else {
    //
    //                    lastTokenWasString = false
    //                }
                    
                    // append the font familiy to the list
                    
                    let fontFamilyArray: [String]
                    let domElement: CSSDOMFontFamilyNameElement?
                    
                    if preservedToken.isTokenId(§CSTokenId.identToken) {
                        
                        (fontFamilyArray, domElement) = parseFontFamilyIdent()
                    }
                    else {
                        
                        (fontFamilyArray, domElement) = parseFontFamilyString()
                    }
                    
                    if let domElement = domElement {
                        
                        assert(parentPropertyElement != nil)
                        
                        // Append the child if parentPropertyValuePseudoElement is non-nil
                        parentPropertyElement?.appendChild(domElement, exception: &exception)
                        
                        if exception.isError() {
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("Exception: %@ while appending child to property value element.", log: Log.Web.all, type: .error, %%exception)
                            #endif
                        }
                    }
                    
                    if fontFamilyArray.count > 0 {
                        
                        fontFamilies.append((fontFamilyArray, domElement))
                        
                        if let _ = currentComponentValue() {
                            
                            parseWhitespaces()
                        }
                        else {
                            // if there is nothing we break here and return the font families
                            break
                        }
                    }
                }
                else if preservedToken.isTokenId(§CSTokenId.commaToken) {
                    
                    if let parentPropertyElement = parentPropertyElement {
                    
                        let commaToken = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.CommaToken, textValue: ",")
                        
                        var ex = Exception()
                        
                        assert(!(parentPropertyElement is CSSDOMTokenElement))
                        parentPropertyElement.appendChild(commaToken, exception: &ex)
                        
                        if ex.isError() {
                            assert(false, "Error adding stringToken child.")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("Error adding stringToken child.", log: Log.Web.all, type: .error)
                            #endif
                        }
                    }
                    
                    advanceComponentValueIndex()
                    parseWhitespaces()
                }
                else {
                    
                    let (stringsArray, domElement) = parseUnexpectedTokenFontFamilyName(preservedToken)
                    
                    if let domElement = domElement {
                        
                        parentPropertyElement?.appendChild(domElement, exception: &exception)
                    }
                    fontFamilies.append((stringsArray, domElement))
                }
            }
            else {
                
                let (stringsArray, domElement) = parseUnexpectedTokenFontFamilyName(componentValue)
                
                if let domElement = domElement {
                    
                    parentPropertyElement?.appendChild(domElement, exception: &exception)
                }
                fontFamilies.append((stringsArray, domElement))
            }
        }
        
        return fontFamilies
    }
    
    /// The CSSDOMPseudoElement elements returned are of element type: PseudoElementType.FontFamilyName.
    fileprivate func parseFontFamilyString() -> ([String], CSSDOMFontFamilyNameElement?) {
        
        var exception = Exception()
        var fontFamilyNameElement: CSSDOMFontFamilyNameElement?
        let currentComponent = currentComponentValue()!
            
        assert(currentComponent.isTokenId(§CSTokenId.stringToken))
        assert(currentComponent is CSPreservedTokenComponentValue, "currentComponent is not CSPreservedTokenComponentValue")
        
        let preservedToken = currentComponent as! CSPreservedTokenComponentValue
            
        let string = preservedToken.value.stringRepresentation
        let fontFamilyArray = string.explode(" ")
        let className = constructStringByJoiningArrayElements(fontFamilyArray, withSeparator: "-")
        
        if parentPropertyElement != nil {
        
            fontFamilyNameElement = CSSDOMFontFamilyNameElement(segment: currentComponent.sourceStringSegment, document: document, localName: §CSSElementType.FontFamilyName)
            
            // append the "time-new-roman" to ::font-family-name.time-new-roman
            fontFamilyNameElement?.addClassAttribute(className)
            
            let stringToken = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.StringToken, textValue: string)
            
            // append the class of the form:
            // css-token.string.time-new-roman
            stringToken.addClassAttribute(className)
            
            assert(!(fontFamilyNameElement is CSSDOMTokenElement))
            fontFamilyNameElement?.appendChild(stringToken, exception: &exception)
            
            if exception.isError() {
                assert(false, "Error adding stringToken child.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error adding stringToken child.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        advanceComponentValueIndex()
        parseWhitespaces()
        return (fontFamilyArray, fontFamilyNameElement)
    }
    
    /// The CSSDOMPseudoElement elements returned are of element type: PseudoElementType.FontFamilyName.
    fileprivate func parseFontFamilyIdent() -> ([String], CSSDOMFontFamilyNameElement?) {
        
        var fontFamilyNameElement: CSSDOMFontFamilyNameElement?
        
        
        var startIndex: Int?
        var endIndex: Int?
        
        var position: SourceStringSegment?
        
        parseWhitespaces()
        
        var fontFamilyArray = [String]()
        
        var componentValue: CSComponentValue?
        
        let currentComponent = currentComponentValue()!
            
        startIndex = currentComponent.sourceStringSegment?.startIndex
        
        componentValue = currentComponent
        
        // ident tokens array
        var identTokensArray = [CSSDOMTokenElement]()
        
        while let _componentValue = componentValue , _componentValue.isTokenId(§CSTokenId.identToken) {
            
            let preservedToken = _componentValue as! CSPreservedTokenComponentValue
                
            let tokenString = preservedToken.value.stringRepresentation.lowercased().trimmed()
            
            fontFamilyArray.append(tokenString)

            // When parsing the DOM
            if parentPropertyElement != nil {
            
                // construct the CSSDOMTokenElement and append it to the array
                let identToken = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.IdentToken, textValue: preservedToken.value.stringRepresentation)
            
                // css-token.ident-token.time (
                identToken.addClassAttribute(tokenString)
                identTokensArray.append(identToken)
            }
            
            endIndex = preservedToken.sourceStringSegment?.endIndex

            advanceComponentValueIndex()
            parseWhitespaces()
            
            componentValue = currentComponentValue()
        }
    
        if let startIndex = startIndex, let endIndex = endIndex {
        
            position = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("startIndex and/or endIndex is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        // When parsing the DOM
        if parentPropertyElement != nil {
        
            fontFamilyNameElement = CSSDOMFontFamilyNameElement(segment: position, document: document, localName: §CSSElementType.FontFamilyName)
        
            let fontFamilyNameClass = constructStringByJoiningArrayElements(fontFamilyArray, withSeparator: "-")
        
            // append the "time-new-roman" to ::font-family-name.time-new-roman
            fontFamilyNameElement!.addClassAttribute(fontFamilyNameClass)
        
            for identToken in identTokensArray {
            
                var ex = Exception()
                
                fontFamilyNameElement?.appendChild(identToken, exception: &ex)
                
                if ex.isError() {
                    
                    assert(false, "Error adding token child.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error adding token child.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
        
        return (fontFamilyArray,fontFamilyNameElement)
    }
    
    fileprivate func constructStringByJoiningArrayElements(_ stringArray: [String], withSeparator separator: String = " ") -> String {
        
        var constructedString = ""
        
        if stringArray.count > 1 {
            constructedString = stringArray.joined(separator: separator)
        }
        else if stringArray.count == 1 {
            constructedString = stringArray.first!
        }
        return constructedString
    }
    
    /// This method will parse an unexpected token whenever it happens.
    fileprivate func parseUnexpectedTokenFontFamilyName(_ componentValue: CSComponentValue) -> ([String], CSSDOMFontFamilyNameElement?) {
        
        var stringsArray = [String]()
        var fontFamilyNameElement: CSSDOMFontFamilyNameElement?
        
        // we only add a message to the first component
        var firstComponent = true
        
        // here we should handle the unexpected token case only when we are parsing
        // the DOM otherwise we should skip until the next CommaToken and try to parse
        // the next font-family property value.
        //
        // When parsing the DOM we create a CSSDOMFontFamilyNamePseudoElement but we add to it
        // all contiguous unexpected tokens, et return when we encounter the next comma, otherwise
        // it's all considered unexpected tokens.
        if parentPropertyElement != nil {
            
            var unexpectedTokensArray = [CSSDOMTokenElement]()
            
            // Calcultate the SourceStringSegment spanning over multiple tokens
            // Intialiase it to the unexpected token start and end index.
            let startIndex: Int = componentValue.sourceStringSegment!.startIndex
            var endIndex: Int = componentValue.sourceStringSegment!.endIndex
            
            fontFamilyNameElement = CSSDOMFontFamilyNameElement(segment: SourceStringSegment(startIndex: startIndex, endIndex: endIndex), document: document, localName: §CSSElementType.FontFamilyName)
            
            // Parse until we encouter a comma token or there is no more component value,
            // in which case the while loop will stop.
            while let unexpectedComponentValue = currentComponentValue() {
                
                if let unexpectedPreservedToken = unexpectedComponentValue as? CSPreservedTokenComponentValue, unexpectedPreservedToken.isTokenId(§CSTokenId.commaToken) {
                    break
                }
                else {

                    let unexpectedToken = self.handleComponentValueToDom(unexpectedComponentValue, in: fontFamilyNameElement!)
                    
                    // add the error message, to the token and keep it in the error message array,
                    // in order to add a message with all those dependencies at the CSSDOMFontFamilyNamePseudoElement
                    // level.
                    if firstComponent {
                        
                        unexpectedToken?.addMessage(MessageCode.unexpectedToken, args: [unexpectedComponentValue.cssText()])
                        firstComponent = false
                    }
                    
                    // construct the string array
                    stringsArray.append(unexpectedComponentValue.cssText())
                    
                    let sourceStringSegment = unexpectedComponentValue.sourceStringFragment as? SourceStringSegment
                    
                    assert(sourceStringSegment != nil)
                    if let sourceStringSegment = sourceStringSegment {
                    
                        // udpate the endIndex
                        endIndex = sourceStringSegment.endIndex
                    }
                }
                advanceComponentValueIndex()
                parseWhitespaces()
            }
            
            assert(fontFamilyNameElement != nil)
            fontFamilyNameElement?.addMessage(MessageCode.unsupportedFontFamily, args: nil)
        }
        else {
            
            // Just append all string token string value until the next comma, because we are parsing a value.
            // Parse until we encouter a comma token or there is no more component value,
            // in which case the while loop will stop.
            while let unexpectedComponentValue = currentComponentValue() {
                
                if let unexpectedPreservedToken = unexpectedComponentValue as? CSPreservedTokenComponentValue {
                
                    if unexpectedPreservedToken.isTokenId(§CSTokenId.commaToken) {
                        break
                    }
                    
                    // construct the string array
                    stringsArray.append(unexpectedPreservedToken.value.stringRepresentation)
                }
                else if let functionComponentValue = unexpectedComponentValue as? CSFunctionComponentValue {
                    
                    stringsArray.append(functionComponentValue.value.name)
                }
                
                advanceComponentValueIndex()
                parseWhitespaces()
            }
        }
        
        return (stringsArray, fontFamilyNameElement)
    }
    
}


