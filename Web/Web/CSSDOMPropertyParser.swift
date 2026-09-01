//
//  CSSDOMPropertyParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-11.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

class CSSDOMPropertyParser: CSSDOMComponentsParser {
    
    weak var parentPropertyElement: CSSDOMElement?
    
    /// If there is an error here we should crash because 
    /// it's a coding error.
    var parentStyleSheetElement: CSSDOMStyleSheetElement? {
        
        return (document?.documentElement as! CSSDOMStyleSheetElement)
    }
    
    init(componentValueArray: [CSComponentValue], parentPropertyElement: CSSDOMElement?) {
        
        self.parentPropertyElement = parentPropertyElement
        
        let cssDomDocument = parentPropertyElement?.document as? CSSDOMDocument

        super.init(componentValueArray: componentValueArray, document: cssDomDocument)
    }
    
    
    func addChildPseudoElementToPseudoElement(_ child: CSSDOMElement, parentElement: CSSDOMElement) -> CSSDOMElement? {
        
        var exception = Exception()
        
        parentElement.appendChild(child, exception: &exception)
        
        if exception.isError() {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("exception: %@ while appending child to parent element.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return nil
        }
        
        return child
    }
    
    @discardableResult
    func addChildElementToPropertyValueElement(_ child: CSSDOMElement) -> CSSDOMElement? {
        
        assert(parentPropertyElement != nil, "parentPropertyElement == nil")
        return addChildPseudoElementToPseudoElement(child, parentElement: parentPropertyElement!)
    }
    
    func createNumberElement(_ position: SourceStringSegment?, number: Number, document: CSSDOMDocument) -> CSSDOMElement {
        
        let type: CSSElementType
        
        switch number.numberType {
            
        case .real:
            
            type = CSSElementType.RealNumber
            
        case .integer:
            
            type = CSSElementType.IntegerNumber
            
        case .nil:
            
            type = CSSElementType.Error
        }
        
        return CSSDOMElement(segment: position, document: document, localName: §type)
    }
    
    func functionSourceStringSegmentFromCSFunctionToken(_ token: CSFunction) -> SourceStringSegment {
        
        let startIndex = token.sourceStringSegment!.startIndex
        
        let endIndex = token.endIndex
        
        // the final segment starts from the function name startIndex to the componenents
        return SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
    }
    
    /// This method parse the rest of the property definition and appends the tokens 
    /// to the propety-value DOM element.
    /// It should never be called when we are not parsing a DOM => propertyValuePseudoElement == nil and
    /// document == nil.
    func consumeNextComponentsAsUnknownDomElements() {
        
        let parentPropertyElement = self.parentPropertyElement
        
        assert(parentPropertyElement != nil)
        if let parentPropertyElement = parentPropertyElement {
            
            advanceComponentValueIndex()
            parseWhitespaces()
            
            var componentValue = currentComponentValue()
            
            while componentValue != nil {
                
                handleComponentValueToDom(componentValue!, in: parentPropertyElement, messageCode: MessageCode.unexpectedToken)
                advanceComponentValueIndex()
                componentValue = currentComponentValue()
            }
        }
    }
    
    /// This method parse the rest of the property definition and appends the tokens
    /// to the propety-value DOM element.
    /// It should never be called when we are not parsing a DOM => propertyValuePseudoElement == nil and
    /// document == nil.
    func consumeComponentsAsUnknownDomElements() {

        let parentPropertyElement = self.parentPropertyElement

        assert(parentPropertyElement != nil)
        if let parentPropertyElement = parentPropertyElement {

            parseWhitespaces()

            var componentValue = currentComponentValue()

            while componentValue != nil {

                handleComponentValueToDom(componentValue!, in: parentPropertyElement, messageCode: MessageCode.unexpectedToken)
                advanceComponentValueIndex()
                componentValue = currentComponentValue()
            }
        }
    }
    
    @discardableResult
    func handleComponentValueToDom(_ componentValue: CSComponentValue, in parent: CSSDOMElement, messageCode: MessageCode? = nil) -> CSSDOMElement? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handling component value: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
        #endif
        
        if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
            
            return parsePreservedTokenToDom(preservedToken: preservedToken, parent: parent, messageCode: messageCode)
        }
        else if let functionComponentValue = componentValue as? CSFunctionComponentValue {
            
            return parseFunctionValueToDom(componentValue: functionComponentValue, parent: parent, messageCode: messageCode)
        }
        else if let simpleBlockComponentValue = componentValue as? CSSimpleBlockComponentValue {
            
            return parseSimpleBlockValueToDom(simlpeBlockValue: simpleBlockComponentValue, parent: parent, messageCode: messageCode)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Property parsing for this kind of component value not implemented : %@", log: Log.Web.all, type: .error, %%componentValue)
            #endif
            assert(false)
            return parseComponentValueToDom(componentValue: componentValue, parent: parent)
        }
    }
    
    private func parseComponentValueToDom(componentValue: CSComponentValue, parent: CSSDOMElement, messageCode: MessageCode? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        
        assert(!(parent is CSSDOMTokenElement))
        let cssTokenElement = CSSDOMTokenElement(segment: componentValue.sourceStringSegment, document: document, tokenClass: TokenClassType.None, textValue: "")
        
        cssTokenElement.addMessages(componentValue.allMessages)
        if let messageCode = messageCode {
            cssTokenElement.addMessage(messageCode, args: [componentValue.cssText()])
        }
        
        assert(!(parent is CSSDOMTokenElement))
        parent.append(cssTokenElement, exception: &exception)
        exception.logIfError()
        return cssTokenElement 
    }
    
    private func parsePreservedTokenToDom(preservedToken: CSPreservedTokenComponentValue, parent: CSSDOMElement, messageCode: MessageCode? = nil) -> CSSDOMElement? {
        
        if preservedToken.value.tokenId != §CSTokenId.whitespaceToken {
            
            var exception = Exception()
            let tokenString = preservedToken.value.stringRepresentation
            let tokenClass: TokenClassType = preservedToken.associatedTokenClass()
            let cssTokenElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment, document: document, tokenClass: tokenClass, textValue: tokenString)
            
            cssTokenElement.addMessages(preservedToken.allMessages)
            if let messageCode = messageCode {
                cssTokenElement.addMessage(messageCode, args: [preservedToken.cssText()])
            }
            
            assert(!(parent is CSSDOMTokenElement))
            parent.append(cssTokenElement, exception: &exception)
            exception.logIfError()
            return cssTokenElement
        }
        return nil
    }
    
    private func parseSimpleBlockValueToDom(simlpeBlockValue: CSSimpleBlockComponentValue, parent: CSSDOMElement, messageCode: MessageCode? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let simpleBlockTokenElement = CSSDOMElement(segment: simlpeBlockValue.sourceStringSegment!, document: document, localName: §CSSElementType.StyleDeclarationBlock)
        simpleBlockTokenElement.addMessages(simlpeBlockValue.allMessages)
        if let messageCode = messageCode {
            simpleBlockTokenElement.addMessage(messageCode, args: [simlpeBlockValue.cssText()])
        }
        
        assert(!(parent is CSSDOMTokenElement))
        parent.append(simpleBlockTokenElement, exception: &exception)
        
        let value = simlpeBlockValue.value
        let startToken = value.startToken
        
        let startTokenElement = CSSDOMTokenElement(segment: startToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.LeftCurlyBraceToken, textValue: startToken.rawStringValue)
        startTokenElement.addMessages(startToken.allMessages)
        
        if let messageCode = messageCode {
            startTokenElement.addMessage(messageCode, args: [startToken.rawStringValue])
        }
        assert(!(simpleBlockTokenElement is CSSDOMTokenElement))
        simpleBlockTokenElement.append(startTokenElement, exception: &exception)
        exception.logIfError()
        
        for componentValue in value.componentValueList {
            
            handleComponentValueToDom(componentValue, in: parent, messageCode: messageCode)
        }
        
        let endToken = value.endToken
        
        let endTokenElement = CSSDOMTokenElement(segment: endToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.RightCurlyBraceToken, textValue: endToken.rawStringValue)
        endTokenElement.addMessages(endToken.allMessages)
        if let messageCode = messageCode {
            endTokenElement.addMessage(messageCode, args: [endToken.rawStringValue])
        }
        assert(!(simpleBlockTokenElement is CSSDOMTokenElement))
        simpleBlockTokenElement.append(endTokenElement, exception: &exception)
        exception.logIfError()
        return simpleBlockTokenElement
    }
    
    private func parseFunctionValueToDom(componentValue: CSFunctionComponentValue, parent: CSSDOMElement, messageCode: MessageCode? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        let functionSourceStringSegment = functionSourceStringSegmentFromCSFunctionToken(componentValue.value)
        let functionElement = CSSDOMElement(segment: functionSourceStringSegment, document: document, localName: §CSSElementType.Function)
        
        // add the function name to the function element
        functionElement.addClassAttribute(componentValue.value.name)
        
        assert(!(parent is CSSDOMTokenElement))
        parent.appendChild(functionElement, exception: &exception)
        exception.logIfError()
        
        let functionStartElement = CSSDOMElement(segment: componentValue.sourceStringSegment, document: document, localName: §CSSElementType.FunctionStart)
        
        assert(!(functionElement is CSSDOMTokenElement))
        functionElement.appendChild(functionStartElement, exception: &exception)
        exception.logIfError()
        
        let functionToken = CSSDOMTokenElement(segment: componentValue.sourceStringSegment!, document: document, tokenClass: TokenClassType.FunctionToken, textValue: componentValue.value.name)
        
        functionToken.addClassAttribute(componentValue.value.name)
        
        assert(!(functionStartElement is CSSDOMTokenElement))
        functionStartElement.appendChild(functionToken, exception: &exception)
        exception.logIfError()
        
        for componentValue in componentValue.value.componentValueList {
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                if preservedToken.isTokenId(§CSTokenId.commaToken) {
                    
                    let commaTokenElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.CommaToken, textValue: preservedToken.value.stringRepresentation)
                    
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(commaTokenElement, exception: &exception)
                }
                else if preservedToken.isTokenId(§CSTokenId.whitespaceToken) {
                    
                    // nothing to do we just jump to the next component
                }
                else {
                    
                    let functionParameterElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: document, tokenClass: preservedToken.associatedTokenClass(), textValue: preservedToken.cssText())
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(functionParameterElement, exception: &exception)
                    exception.logIfError()
                }
            }
        }
        
        // handle the right parenthesis token which has a specific property
        // because we don't want to alter the parding algorythm logic by appending it
        // to the componentValueList
        if let rightParenthesisToken = componentValue.value.rightParenthesisToken {
            
            let rightParenthesisTokenElement = CSSDOMTokenElement(segment: rightParenthesisToken.sourceStringSegment!, document: document, tokenClass: TokenClassType.RightParenthesisToken, textValue: rightParenthesisToken.stringRepresentation)
            
            assert(!(functionElement is CSSDOMTokenElement))
            functionElement.appendChild(rightParenthesisTokenElement, exception: &exception)
        }
        return functionElement
    }
    
    private func isValidPropertyNameComponent(_ componentValue: CSComponentValue) -> Bool {
        
        if let preservedTokenComponentValue = componentValue as? CSPreservedTokenComponentValue{
            if preservedTokenComponentValue.isTokenId(§CSTokenId.identToken) {
                return true
            }
        }
        return false
    }
    
}
