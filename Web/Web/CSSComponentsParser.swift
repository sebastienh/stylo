//
//  ComponentsParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

class CSSComponentsParser {
    
    var currentComponentValueIndex: Int
    
    // when a select is created from the accumulated
    // list of components values this value is reset to
    // the currentComponentValueIndex + 1
    var startComponentValueIndex: Int
    
    /// Needed in subclasses
    let lastComponentPosition: SourceStringSegment?
    
    var componentValueArray: [CSComponentValue]
    
    var restOfComponentsValues: [CSComponentValue] {
        
        var restOfComponentsValues = [CSComponentValue]()
        
        for i in currentComponentValueIndex..<componentValueArray.count {
            
            restOfComponentsValues.append(componentValueArray[i])
        }
        return restOfComponentsValues
    }
    
    var componentsString: String {
        
        var string = ""
        for componentValue in componentValueArray {
            string += componentValue.cssText()
        }
        return string
    }
    
    init(componentValueArray: [CSComponentValue] ) {
        
        self.currentComponentValueIndex = 0
        self.startComponentValueIndex = 0
        
        self.componentValueArray = componentValueArray
        
        if let lastComponent = self.componentValueArray.last as? CSPreservedTokenComponentValue {
            
            self.lastComponentPosition = lastComponent.sourceStringSegment
        }
        else {
            
            lastComponentPosition = nil
        }
    }
    
    /// Function that parse the whitespaces inside an attribute
    ///
    func parseAttributeWhitespaces(from index: inout Int) {
        
        let _currentComponentValue = currentComponentValue()
        
        assert(_currentComponentValue is CSSimpleBlockComponentValue)
        if let simpleBlockComponentValue = _currentComponentValue as? CSSimpleBlockComponentValue {
            
            let simpleBlock = simpleBlockComponentValue.value
            
            if index < simpleBlock.componentValueList.count {
            
                var currentToken: CSComponentValue? = simpleBlock.componentValueList[index]
            
                while let _currentToken = currentToken, _currentToken.isTokenId(§CSTokenId.whitespaceToken) {
                
                    index += 1
                    currentToken = simpleBlockComponentValue[index]
                }
            }
        }
    }
    
    // Parse multiple whitspaces
    // @return true if there was whitespace otherwise false
    @discardableResult
    func parseWhitespaces() -> SourceStringSegment? {
        
        var whitespaceFound = false
        
        if var preservedTokenComponentValue = currentComponentValue() as? CSPreservedTokenComponentValue{
            
            let startIndex: Int = preservedTokenComponentValue.sourceStringSegment!.startIndex
            var endIndex: Int = preservedTokenComponentValue.sourceStringSegment!.endIndex
            
            while preservedTokenComponentValue.isTokenId(§CSTokenId.whitespaceToken) {
                
                advanceComponentValueIndex()
                endIndex = preservedTokenComponentValue.sourceStringSegment!.endIndex
                whitespaceFound = true
                
                if let nextComponentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
                    
                    preservedTokenComponentValue = nextComponentValue
                }
                else {
                    break;
                }
            }
            
            if whitespaceFound {
                return SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
            }
        }
        return nil
    }
    
    /// Function that parse whitspaces without advancing
    /// and return the number of whitespaces found
    func parseWhitespacesWithoutAdvancing() -> Int {
        
        var numberOfWhitespaces = 0
        
        if var preservedTokenComponentValue = currentComponentValue() as? CSPreservedTokenComponentValue{
            
            while preservedTokenComponentValue.isTokenId(§CSTokenId.whitespaceToken) {
                
                numberOfWhitespaces += 1
                
                if let nextComponentValue = componentValueLookahead(with: numberOfWhitespaces) as? CSPreservedTokenComponentValue {
                    preservedTokenComponentValue = nextComponentValue
                }
                else {
                    break
                }
            }
        }
        return numberOfWhitespaces
    }
    
    // Parse ','
    func parseComma() -> CSPreservedTokenComponentValue? {
        
        if let preservedTokenComponentValue = currentComponentValue() as? CSPreservedTokenComponentValue {
            
            if preservedTokenComponentValue.value.tokenId == §CSTokenId.commaToken {
                
                advanceComponentValueIndex()
                return preservedTokenComponentValue
            }
        }
        return nil
    }
    
    /// Method that consume the reste of the property and adding an error 
    /// for each token : we assume all the charcters following are not expected
    /// meaning that we have parsed what we needed. 
    func consumeRestOfInputValueAsUnexpectedCharacters() {
        
        advanceComponentValueIndex()
        parseWhitespaces()
        
        // verify we reached the end
        while let componentValue = currentComponentValue() {
            
            // Should be added to componentValue
            // componentValue.sourceStringSegment
            Message.CreateMessage(MessageCode.unexpectedToken,
                args: [componentValue.cssText()]).logError()
            
            advanceComponentValueIndex()
            parseWhitespaces()
        }
    }
    
    
    func stringValue(_ token: CSSToken) -> String {
        
        if let formatedString = token.formattedStringValue {
            
            return formatedString
        }
        
        return token.rawStringValue
    }
    
    func resetComponentValueIndex(toIndex index: Int) {
        
        self.currentComponentValueIndex = index
    }
    
    func advanceComponentValueIndex(_ advance: Int = 1) {
        
        self.currentComponentValueIndex += advance
        self.startComponentValueIndex = self.currentComponentValueIndex
    }
    
    func componentValueLookahead(with lookahead: Int) -> CSComponentValue? {
        
        if currentComponentValueIndex + lookahead < componentValueArray.count {
            
            return componentValueArray[currentComponentValueIndex + lookahead]
        }
        return nil
    }
    
    func currentComponentValue() -> CSComponentValue? {
        
        if currentComponentValueIndex < componentValueArray.count {
            
            return componentValueArray[currentComponentValueIndex]
        }
        
        return nil
    }
    
    @discardableResult
    func nextComponentValue() -> CSComponentValue? {
        
        if (currentComponentValueIndex + 1) < componentValueArray.count {
            
            return componentValueArray[currentComponentValueIndex + 1]
        }
        
        return nil
    }
    
    func collectComponentValues(_ componentValue: CSComponentValue, in componentsList: inout [CSComponentValue]) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("handling component value: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
        #endif
        
        if let functionComponentValue = componentValue as? CSFunctionComponentValue {
            collectFunctionComponentValues(functionComponentValue: functionComponentValue, in: &componentsList)
        }
        else if let simpleBlockComponentValue = componentValue as? CSSimpleBlockComponentValue {
            collectSimpleBlockComponentValues(simpleBlockValue: simpleBlockComponentValue, in: &componentsList)
        }
        else {
            componentsList.append(componentValue)
        }
    }
    
    private func collectSimpleBlockComponentValues(simpleBlockValue: CSSimpleBlockComponentValue, in componentsList: inout [CSComponentValue]) {
        
        componentsList.append(simpleBlockValue)
        
        let value = simpleBlockValue.value
        
        componentsList.append(CSPreservedTokenComponentValue(value: value.startToken))
        
        for componentValue in value.componentValueList {
            collectComponentValues(componentValue, in: &componentsList)
        }
        componentsList.append(CSPreservedTokenComponentValue(value: value.endToken))
    }
    
    private func collectFunctionComponentValues(functionComponentValue: CSFunctionComponentValue, in componentsList: inout [CSComponentValue]) {
        
        componentsList.append(functionComponentValue)
        
        for componentValue in functionComponentValue.value.componentValueList {
            collectComponentValues(componentValue, in: &componentsList)
        }
        if let rightParenthesisToken = functionComponentValue.value.rightParenthesisToken {
            componentsList.append(CSPreservedTokenComponentValue(value: rightParenthesisToken))
        }
    }
}
