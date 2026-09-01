//
//  CSSParser.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-26.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSParser: RecursiveDescentParser {
    
    final fileprivate var topLevelFlag: Bool
    
    fileprivate var sourceString: NSString {
        
        return self.tokenReader.stringReader.sourceString
    }
    
    public convenience init(sourceString: NSString) {
        
        let reader = CSSReader(sourceString: sourceString )
        
        self.init(reader: reader, currentInputTokenIndex: 0 )
    }
    
    convenience init(sourceString: NSString, sourceStringSegment: SourceStringSegment) {
        
        let reader = CSSReader(sourceString: sourceString )
        
        let index = sourceStringSegment.startIndex
        
        self.init(reader: reader, currentInputTokenIndex: index )
    }
    
    init(reader: CSSReader, currentInputTokenIndex: Int ) {
        self.topLevelFlag = true
        
        super.init(reader: reader, currentInputTokenIndex: currentInputTokenIndex)
    }
    
    // http://dev.w3.org/csswg/css-syntax/#parse-stylesheet
    public final func parseStyleSheet() -> CSStyleSheet {
        
        return parseStyleSheet(rulesStopIndex: nil, selectorStopIndex: nil, declarationStopIndex: nil).stylesheet
    }
    
    // http://dev.w3.org/csswg/css-syntax/#parse-stylesheet
    public final func parseStyleSheet(rulesStopIndex: Int?, selectorStopIndex: Int?, declarationStopIndex: DeclarationStopIndex?) -> (stylesheet: CSStyleSheet, rulesStoppedIndex: Int?, selectorStoppedIndex: Int?, declarationStoppedIndex: Int?) {
        
        let (rules, rulesStoppedIndex, selectorStoppedIndex, declarationStoppedIndex) = consumeAListOfRules(rulesStopIndex: rulesStopIndex, selectorStopIndex: selectorStopIndex, declarationStopIndex: declarationStopIndex)
        let region = regionFromAListOfRules(rules)
        
        #if DEBUG
        validateSourceStringSegment(sourceStringSegment: region)
        #endif
        let cssSyntaxStyleSheet = CSStyleSheet(sourceStringSegment: region, rules: rules, comments: (tokenReader.stringReader as! CSSReader).comments)
        
        // stoppedIndex could be nil if we didn't stop the parsing.
        return (cssSyntaxStyleSheet, rulesStoppedIndex, selectorStoppedIndex, declarationStoppedIndex)
    }
    
    /// Function that consume a list of rule.
    ///
    /// The stopIndex parameter is used to stop the parsing before
    /// the end of the rules if possible, meaning that the rules
    /// we parse are right curly bracket terminated.
    ///
    /// [Consume a list of rules](http://dev.w3.org/csswg/css-syntax/#consume-list-of-rules)
    public func consumeAListOfRules(rulesStopIndex: Int? = nil, selectorStopIndex: Int?, declarationStopIndex: DeclarationStopIndex?) -> (rules: [CSRule], rulesStoppedIndex: Int?, selectorStoppedIndex: Int?, declarationStoppedIndex: Int?) {
        
        var cssRuleList = [CSRule]()
        var token: Token = currentInputToken()
        var _rulesStoppedIndex: Int?
        var _selectorStoppedIndex: Int?
        var _declarationStoppedIndex: Int?
        
        while token.tokenId != §CSTokenId.cssEof {
            
            if token.tokenId != §CSTokenId.whitespaceToken {
                
                if let (rule, selectorStoppedIndex, declarationStoppedIndex) = consumeNextRule(from: token, selectorStopIndex: selectorStopIndex, declarationStopIndex: declarationStopIndex) {
                    if let rule = rule {
                        cssRuleList.append(rule)
                    }
                    if selectorStoppedIndex != nil {
                        _selectorStoppedIndex = selectorStoppedIndex
                        break
                    }
                    if declarationStoppedIndex != nil {
                        _declarationStoppedIndex = declarationStoppedIndex
                        break
                    }
                }
            }
            token = consumeNextInputToken()
            
            // if we reached the stop index point, we should stop parsing.
            // we are at the start of the next rule because we consume a rule
            // at each loop we go through
            if let rulesStopIndex = rulesStopIndex, let startStringIndex = token.startStringIndex, startStringIndex == rulesStopIndex {
                _rulesStoppedIndex = startStringIndex
                break
            }
        }
        return (cssRuleList, _rulesStoppedIndex, _selectorStoppedIndex, _declarationStoppedIndex)
    }
    
    fileprivate func consumeNextRule(from token: Token, selectorStopIndex: Int?, declarationStopIndex: DeclarationStopIndex?) -> (CSRule?, selectorStoppedIndex: Int?, declarationStoppedIndex: Int?)? {
        
        if token.tokenId == §CSTokenId.cdcToken
            || token.tokenId == §CSTokenId.cdoToken {
            
            if !topLevelFlag {
                
                reconsumeCurrentInputToken()
                let (rule, selectorStoppedIndex, declarationStoppedIndex) = consumeAQualifiedRule(selectorStopIndex: selectorStopIndex, declarationStopIndex: declarationStopIndex)
                if let rule = rule {
                    #if DEBUG
                    validateSourceStringSegment(sourceStringSegment: rule.sourceStringSegment)
                    #endif
                    return (rule, selectorStoppedIndex, declarationStoppedIndex)
                }
            }
        }
        else if token.tokenId == §CSTokenId.atKeywordToken {
            
            reconsumeCurrentInputToken()
            if let rule = consumeAnAtRule() {
                #if DEBUG
                validateSourceStringSegment(sourceStringSegment: rule.sourceStringSegment)
                #endif
                return (rule, nil, nil)
            }
        }
        else {
            
            reconsumeCurrentInputToken()
            let (rule, selectorStoppedIndex, declarationStoppedIndex) = consumeAQualifiedRule(selectorStopIndex: selectorStopIndex, declarationStopIndex: declarationStopIndex)
            if let rule = rule {
                #if DEBUG
                validateSourceStringSegment(sourceStringSegment: rule.sourceStringSegment)
                #endif
                return (rule, selectorStoppedIndex, declarationStoppedIndex)
            }
        }
        return nil
    }
    
    //http://dev.w3.org/csswg/css-syntax/#consume-a-qualified-rule
    fileprivate func consumeAQualifiedRule(selectorStopIndex: Int?, declarationStopIndex: DeclarationStopIndex?) -> (CSQualifiedRule?, selectorStoppedIndex: Int?, declarationStoppedIndex: Int?) {
        
        var block: CSSimpleBlock?
        var declarationStoppedIndex: Int?
        var componentValues = [CSComponentValue]()
        var token = currentInputToken()
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("token: %@", log: Log.Web.all, type: .debug, %%token.rawStringValue)
        #endif
        
        while token.tokenId != §CSTokenId.cssEof {
            
            if token.tokenId == §CSTokenId.leftCurlyBraceToken {
                
                // if leftCurlyBraceStopIndex is not nil, it means
                // if we reached the stop index point, we should stop parsing.
                // we wich to stop after the selector list (prelude).
                if let selectorStopIndex = selectorStopIndex, let startStringIndex = token.startStringIndex, startStringIndex == selectorStopIndex {
//                       stoppedIndex = startStringIndex
                    
                    let sourceStringSegment = regionFromPreludeAndBlock(componentValues, block: block)
                    
                    #if DEBUG
                    validateSourceStringSegment(sourceStringSegment: sourceStringSegment)
                    #endif
                    
                    let qualifiedRule = CSQualifiedRule(sourceStringSegment: sourceStringSegment, prelude: componentValues, block: block)
                
                    return (qualifiedRule, selectorStopIndex, nil)
                }
                   
                guard let (block, declarationStoppedIndex) = consumeASimpleBlock(declarationStopIndex: declarationStopIndex) else {
                    
                    let sourceStringSegment = token.sourceStringSegment
                    return (CSQualifiedRule(sourceStringSegment: sourceStringSegment, prelude: componentValues, block: nil), nil, nil)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                for componentValue in componentValues {
                    os_log("componentValue: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
                }
                #endif
                
                let region = regionFromPreludeAndBlock(componentValues, block: block)
                if let region = region {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Computed region: %@ for block: %@", log: Log.Web.all, type: .debug, %%String(describing: region), %%block!.cssText())
                    validateSourceStringSegment(sourceStringSegment: region)
                    #endif
                    return (CSQualifiedRule(sourceStringSegment: region, prelude: componentValues, block: block), nil, declarationStoppedIndex)
                }
                else {
                    let sourceStringSegment = token.sourceStringSegment
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Computed region: %@ for block: %@", log: Log.Web.all, type: .debug, %%String(describing: sourceStringSegment), %%block!.cssText())
                    validateSourceStringSegment(sourceStringSegment: sourceStringSegment)
                    #endif
                    return (CSQualifiedRule(sourceStringSegment: sourceStringSegment, prelude: componentValues, block: block), nil, declarationStoppedIndex)
                }
            }
                // special case where we may have a @rule following
                // this unterminated qualified rule.
            else if token.tokenId == §CSTokenId.atKeywordToken {
                reconsumeCurrentInputToken()
                break
            }
            else {
                
                reconsumeCurrentInputToken()
                let componentValue = consumeAComponentValue()
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("consume token: %@", log: Log.Web.all, type: .debug, %%componentValue.cssText())
                #endif
                componentValues.append(componentValue)
            }
            token = consumeNextInputToken()
        }
        
        let region = regionFromPreludeAndBlock(componentValues, block: block)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Computed region: %@ for block: %@", log: Log.Web.all, type: .debug, %%String(describing: region), %%String(describing: block?.cssText()))
        validateSourceStringSegment(sourceStringSegment: region)
        #endif
        
        return (CSQualifiedRule(sourceStringSegment: region, prelude: componentValues, block: block), nil, nil)
    }
    
    /// [consume an at-rule](http://dev.w3.org/csswg/css-syntax/#consume-at-rule)
    fileprivate func consumeAnAtRule() -> CSAtRule? {
        
        let token = currentInputToken()
        
        if let name = token.formattedStringValue {
            
            var blocks = [CSSimpleBlock]()
            var componentValues = [CSComponentValue]()
            var token = consumeNextInputToken()
            
            while token.tokenId != §CSTokenId.cssEof
                && token.tokenId != §CSTokenId.semicolonToken {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                    os_log("handling component: %@", log: Log.Web.all, type: .info, %%token.rawStringValue)
                    #endif
                    
                    if token.tokenId == §CSTokenId.leftCurlyBraceToken {
                        
                        if let (_block, _) = consumeASimpleBlock(declarationStopIndex: nil), let block = _block {
                            blocks.append(block)
                        }
                    }
                    else {
                        
                        reconsumeCurrentInputToken()
                        let componentValue = consumeAComponentValue()
                        componentValues.append(componentValue)
                    }
                    
                    token = consumeNextInputToken()
            }
            
            let sourceStringSegment = regionFromPreludeAndBlock(componentValues, block: blocks.last)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("Computed region: %@ for block: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment), %%String(describing: blocks.last?.cssText()))
            #endif
            
            #if DEBUG
            validateSourceStringSegment(sourceStringSegment: sourceStringSegment)
            #endif
            let atRule = CSAtRule(name: name, sourceStringSegment: sourceStringSegment, prelude: componentValues, blocks: blocks)
            
            if token.tokenId == §CSTokenId.semicolonToken {
                atRule.endSemiColon = token
            }
            
            return atRule
        }
        else {
            NSException(
                name: NSExceptionName(rawValue: "Invalid token value!"),
                reason: "Expected token formatted string value was nil : \(token)!",
                userInfo: nil).raise()
        }
        
        return nil
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-simple-block
    fileprivate func consumeASimpleBlock(declarationStopIndex: DeclarationStopIndex?) -> (CSSimpleBlock?, declarationStoppedIndex: Int?)? {
        
        let startingToken = currentInputToken()
        var _declarationStoppedIndex: Int?
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("startingToken: %@", log: Log.Web.all, type: .info, %%startingToken.rawStringValue)
        #endif
        
        if let mirrorVariantTokenId: Int = mirrorVariantTokenId(startingToken) {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("mirrorVariantTokenId: %@", log: Log.Web.all, type: .info, %%mirrorVariantTokenId)
            #endif
            
            var componentValueList = [CSComponentValue]()
            var token = consumeNextInputToken(resetReconsume: true)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("token: %@", log: Log.Web.all, type: .info, %%token.rawStringValue)
            os_log("token id: %d", log: Log.Web.all, type: .info, token.tokenId)
            #endif
            
            if token.tokenId != mirrorVariantTokenId && token.tokenId != §CSTokenId.cssEof {
                
                while token.tokenId != §CSTokenId.cssEof
                    && token.tokenId != mirrorVariantTokenId {
                        
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("consume token: %@", log: Log.Web.all, type: .info, %%token.rawStringValue)
                    #endif
                    
                    reconsumeCurrentInputToken()
                    let componentValue = consumeAComponentValue()
                    componentValueList.append(componentValue)
                    
                    if let declarationStopIndex = declarationStopIndex, declarationStopIndex.isEndOfDeclaration && token.tokenId == §CSTokenId.semicolonToken {
                        if token.startStringIndex == declarationStopIndex.index {
                            _declarationStoppedIndex = declarationStopIndex.index
                            break
                        }
                    }
                    
                    token = consumeNextInputToken()
                }
                
                if token.tokenId == mirrorVariantTokenId {
                    if let declarationStopIndex = declarationStopIndex, declarationStopIndex.isEndOfStyleDeclarationBloc {
                        if token.endStringIndex == declarationStopIndex.index {
                            _declarationStoppedIndex = declarationStopIndex.index
                        }
                    }
                }
            }

            return (
                CSSimpleBlock(startToken: startingToken, endToken: token, componentValueList: componentValueList),
                _declarationStoppedIndex
            )
        }
        
        return nil
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-function
    fileprivate func consumeAFunction() -> CSFunction {
        
        let token = currentInputToken()
        #if DEBUG
        validateSourceStringSegment(sourceStringSegment: token.sourceStringSegment)
        #endif
        let function = CSFunction(name: token.stringRepresentation, sourceStringSegment: token.sourceStringSegment!)
        
        // Repeatedly consume the next input token:
        var nextToken = consumeNextInputToken()
        
        while nextToken.tokenId != §CSTokenId.cssEof
            && nextToken.tokenId != §CSTokenId.rightParenthesisToken {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("consume token: %@", log: Log.Web.all, type: .info, %%nextToken.rawStringValue)
                #endif
                
                self.reconsumeCurrentInputToken()
                let componentValue = self.consumeAComponentValue()
                function.addComponent(componentValue)
                nextToken = consumeNextInputToken()
                
                // in case we see a right curly braquet, it means
                // we reached the end of the current rule
                if nextToken.tokenId == §CSTokenId.rightCurlyBraceToken {
                    reconsumeCurrentInputToken()
                    break
                }
        }
        if nextToken.tokenId == §CSTokenId.rightParenthesisToken {
            
            function.rightParenthesisToken = nextToken
        }
        function.sourceStringSegment = token.sourceStringSegment!
        return function
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-component-value
    fileprivate func consumeAComponentValue() -> CSComponentValue {
        
        let token: Token = consumeNextInputToken()
        
        if token.tokenId == §CSTokenId.leftCurlyBraceToken
            || token.tokenId == §CSTokenId.leftParenthesisToken
            || token.tokenId == §CSTokenId.leftSquareBracketToken {
            
            if let (_simpleBlock, _) = consumeASimpleBlock(declarationStopIndex: nil), let simpleBlock = _simpleBlock {
                
                return CSSimpleBlockComponentValue(value: simpleBlock)
            }
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//            os_log("simpleBlock is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        else if token.tokenId == §CSTokenId.functionToken {
            
            let function = consumeAFunction()
            return CSFunctionComponentValue(value: function)
        }
        return CSPreservedTokenComponentValue(value: token)
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-list-of-declarations
    // In our case we already know the list of tokens since it has already
    // been consumed from the css reader and returned to the csparser
    // componentValueList parameter could be empty, at this point of the parsing
    // we are inside a simple block, the starting delimiter and closing delimiter has
    // been recognized.
    final class func consumeAListOfDeclarations(_ componentValueList: [CSComponentValue], cssStyleDeclaration: CSSStyleDeclaration?, declarationStopIndex: DeclarationStopIndex?) -> (CSDeclarationList, declarationStoppedIndex: Int?) {
        
        let declarationList = CSDeclarationList()
        var declarationStoppedIndex: Int?
        
        var componentValueIndex = 0
        
        // if the list is empty it will return nothing.
        while componentValueIndex < componentValueList.count {
            
            let componentValue = componentValueList[componentValueIndex]
            
            if let preservedTokenComponentValue = componentValue as? CSPreservedTokenComponentValue {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("handling component value: %@", log: Log.Web.all, type: .info, %%preservedTokenComponentValue.cssText())
                #endif
                
                // if token equal <whitespace-token> or <EOF-token> or nothing.
                // we allow the <semicolon-token> since it will just be an empty declaration
                // else ...
                if !preservedTokenComponentValue.isTokenId(§CSTokenId.whitespaceToken)
                    && !preservedTokenComponentValue.isTokenId(§CSTokenId.cssEof){
                    
                    var (declarationComponentValueList, endSemiColonToken) = CSParser.collectComponentsUntilEnd(in: componentValueList, from: &componentValueIndex, cssStyleDeclaration: cssStyleDeclaration)
                    
                    // <ident-token>
                    if preservedTokenComponentValue.isTokenId(§CSTokenId.identToken) {
                        
                        // there
                        let declaration = CSParser.consumeADeclaration(&declarationComponentValueList, cssStyleDeclaration: cssStyleDeclaration)
                        
                        if let declaration = declaration {
                            
                            declaration.endSemiColonToken = endSemiColonToken
                            
                            if endSemiColonToken == nil {
                                declaration.messageHandler.addMessage(MessageCode.missingEndSemiColon)
                                assert(declaration.hasErrors())
                            }
                            
                            #if DEBUG
                            assert(declaration.sourceStringSegment != nil)
                            declaration.sourceStringSegment?.validate()
                            #endif
                            declarationList.addDeclaration(declaration)
                            
                            if let declarationStopIndex = declarationStopIndex, declarationStopIndex.isEndOfDeclaration &&   declarationStopIndex.index == endSemiColonToken?.startStringIndex {
                                declarationStoppedIndex = declarationStopIndex.index
                                break
                            }
                        }
                    }
                    // <at-keyword-token>
                    // anything else
                    else {
                        
                        let invalidDeclaration = CSParser.consumeAnInvalidDeclaration(declarationComponentValueList, endSemiColonToken: endSemiColonToken)
                        
                        declarationList.addDeclaration(invalidDeclaration)
                    }
                }
            }
                // it is not a preserved token component value
            else if let simpleBlock = componentValue as? CSSimpleBlockComponentValue {
                
                cssStyleDeclaration?.addIgnoredBlockComponent(simpleBlockComponent: simpleBlock)
            }
            else {
                
                let (declarationComponentValueList, endSemiColonToken) = CSParser.collectComponentsUntilEnd(in: componentValueList, from: &componentValueIndex, cssStyleDeclaration: cssStyleDeclaration)
                
                let invalidDeclaration = CSParser.consumeAnInvalidDeclaration(declarationComponentValueList, endSemiColonToken: endSemiColonToken)
                
                declarationList.addDeclaration(invalidDeclaration)
            }
            
            componentValueIndex += 1
        }
        
        return (declarationList, declarationStoppedIndex)
    }
    
    class func collectComponentsUntilEnd(in componentValueList: [CSComponentValue], from index: inout Int, cssStyleDeclaration: CSSStyleDeclaration?) -> ([CSComponentValue], Token?) {
        
        var declarationComponentValueList = [CSComponentValue]()
        
        var endSemiColonToken: Token?
        
        // this is a declaration that we must parse
        while index < componentValueList.count {
            
            let tokenComponentValue = componentValueList[index]
            
            if let preservedToken = tokenComponentValue as? CSPreservedTokenComponentValue {
                
                // we should handle the possible error case here :
                //  1. We reach the the EOF
                //  2.
                if preservedToken.isTokenId(§CSTokenId.cssEof) || preservedToken.isTokenId(§CSTokenId.semicolonToken){
                    
                    // keep the end token to set it in the declaration
                    if preservedToken.isTokenId(§CSTokenId.semicolonToken) {
                        endSemiColonToken = preservedToken.value
                    }
                    break
                }
                else {
                
                    declarationComponentValueList.append(tokenComponentValue)
                }
            }
            else if let simpleBlock = tokenComponentValue as? CSSimpleBlockComponentValue {
                
                cssStyleDeclaration?.addIgnoredBlockComponent(simpleBlockComponent: simpleBlock)
            }
            else if let function = tokenComponentValue as? CSFunctionComponentValue {
                
                declarationComponentValueList.append(function)
            }
            
            // prepare the new preseved token component value
            // by before we need to check if we reached the end of the compoenents
            
            index += 1
        }
        return (declarationComponentValueList, endSemiColonToken)
    }
    
    
    class func consumeAnInvalidDeclaration(_ declarationComponentValueList: [CSComponentValue], endSemiColonToken: Token?) -> InvalidDeclaration {
        
        let invalidDeclaration = InvalidDeclaration(preservedDeclarationCompleteComponentValueList: declarationComponentValueList, endSemiColonToken: endSemiColonToken)
        
        return invalidDeclaration
    }
    
    // http://dev.w3.org/csswg/css-syntax/#consume-a-declaration
    class func consumeADeclaration(_ declarationComponentValueList: inout [CSComponentValue], cssStyleDeclaration: CSSStyleDeclaration?) -> CSDeclaration? {
        
        var declarationComponentIndex: Int = 0
        
        for declarationComponent in declarationComponentValueList {
            if declarationComponent.isTokenId(§CSTokenId.whitespaceToken) {
                declarationComponentIndex += 1
            }
            else {
                break
            }
        }
        
        if declarationComponentIndex < declarationComponentValueList.count {
            
            // this token is supposed to be the first non-whitespace token
            let declarationNameToken =  declarationComponentValueList[declarationComponentIndex]
            declarationComponentIndex += 1
            
            let preservedToken = declarationNameToken as! CSPreservedTokenComponentValue
            let propertyName = preservedToken.value.stringRepresentation
            
            // just temporary name that will need to be replaced
            let declaration = CSDeclaration(sourceStringSegment: preservedToken.sourceStringSegment!, propertyName: propertyName, propertyNamePreservedTokenComponentValue: preservedToken, preservedDeclarationCompleteComponentValueList: declarationComponentValueList)
            
            declaration.propertyNamePreservedTokenComponentValue = preservedToken
            
            if declarationComponentIndex < declarationComponentValueList.count {
                
                var declarationComponent = declarationComponentValueList[declarationComponentIndex]
                
                // skip all whitespaces after the property name
                while declarationComponent.isTokenId(§CSTokenId.whitespaceToken) {
                    
                    declarationComponentIndex += 1
                    
                    if declarationComponentIndex < declarationComponentValueList.count {
                        
                        declarationComponent = declarationComponentValueList[declarationComponentIndex]
                    }
                    else {
                        
                        break
                    }
                }
            }
            // we expect to find a colon token between the property name and the property value
            // we have already found the property name
            if declarationComponentIndex < declarationComponentValueList.count {
                
                let token = declarationComponentValueList[declarationComponentIndex]
                
                declarationComponentIndex += 1
                
                if let colonToken = token as? CSPreservedTokenComponentValue, colonToken.isTokenId(§CSTokenId.colonToken) {
                    
                    declaration.colonToken = colonToken.value
                    
                    if declarationComponentIndex <= declarationComponentValueList.count - 1 {
                        
                        for _ in declarationComponentIndex...(declarationComponentValueList.count - 1) {
                            
                            let componentValue = declarationComponentValueList[declarationComponentIndex]
                            
                            declaration.propertyValueComponentValueList.append(componentValue)
                            declarationComponentIndex += 1
                        }
                        
                        // set the important flag value
                        setImportantFlag(declaration )
                    }
                    
                    declaration.updatePosition()
                    
                    #if DEBUG
                    assert(declaration.sourceStringSegment != nil)
                    declaration.sourceStringSegment?.validate()
                    #endif
                    return declaration
                }
                else {
                    
                    if var valueHolder = token as? CSPreservedTokenComponentValue {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("expectedColonError valueHolder sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: valueHolder.sourceStringSegment))
                        #endif
                        valueHolder.messageHandler.addMessage(MessageCode.expectedColonError)
                        
                        #if DEBUG
                        assert(declaration.sourceStringSegment != nil)
                        declaration.sourceStringSegment?.validate()
                        #endif
                        return declaration
                    }
                    else if let valueHolder = token as? CSSimpleBlockComponentValue {
                        
                        cssStyleDeclaration?.addIgnoredBlockComponent(simpleBlockComponent: valueHolder)
                    }
                }
            }
            // this declaration almost contains nothing, but since there is
            // something we return it.
            return declaration
        }
        
        return nil
    }
    
    class func setImportantFlag(_ declaration: CSDeclaration) {
        
        var important:Bool = false
        var importantIndex: Int = 0
        
        var importantFlagPreservedTokenArray = [CSPreservedTokenComponentValue]()
        
        let reversedPropertyValueComponentValueList = Array(declaration.propertyValueComponentValueList.reversed())
        
        for i in 0..<reversedPropertyValueComponentValueList.count {
            
            let componentValue = reversedPropertyValueComponentValueList[i]
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Handling token with text value: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
            #endif
            
            let preservedToken = componentValue as? CSPreservedTokenComponentValue
            
            if var preservedToken = preservedToken {
                
                // append token to important flag preserved token array
                importantFlagPreservedTokenArray.append(preservedToken)
                
                if preservedToken.value.rawStringValue.lowercased() == "important" {
                    
                    if i+1 < reversedPropertyValueComponentValueList.count {
                        
                        let nextComponentValue = reversedPropertyValueComponentValueList[i+1]
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Handling token with text value: %@", log: Log.Web.all, type: .info, %%nextComponentValue.cssText())
                        #endif
                        
                        let nextPreservedToken = nextComponentValue as? CSPreservedTokenComponentValue
                        
                        if let nextPreservedToken = nextPreservedToken {
                            
                            // append token to important flag preserved token array
                            importantFlagPreservedTokenArray.append(nextPreservedToken)
                            
                            if nextPreservedToken.value.rawStringValue.lowercased() == "!" {
                                
                                importantIndex += 1
                                important = true
                                break
                            }
                            else {
                                
                                // we are missing a "!" before the important keyword
                                preservedToken.addMessage(.missingExclamationBeforeImportant)
                            }
                        }
                    }
                }
            }
            else {
                // if it's anything else than a preserved token we let this value be handled
                // by the value parser
                break
            }
            importantIndex += 1
        }
        
        if important {
            
            declaration.importantFlag = true
            declaration.importantDeclaration = CSImportantDeclaration(
                preservedTokenComponentValueArray: Array(importantFlagPreservedTokenArray.reversed()), parent: declaration)
            
            for _ in 0...importantIndex {
                declaration.propertyValueComponentValueList.removeLast()
            }
        }
    }
    
    fileprivate func mirrorVariantTokenId(_ startingToken: Token) -> Int? {
        
        switch(startingToken.tokenId) {
            
        case §CSTokenId.leftParenthesisToken:
            
            return §CSTokenId.rightParenthesisToken
            
        case §CSTokenId.leftSquareBracketToken:
            
            return §CSTokenId.rightSquareBracketToken
            
        case §CSTokenId.leftCurlyBraceToken:
            
            return §CSTokenId.rightCurlyBraceToken
        default:
            return nil
        }
    }
    
    fileprivate func regionFromPreludeAndBlock(_ prelude: [CSComponentValue], block: CSSimpleBlock?) -> SourceStringSegment? {
        
        if let preludeFirst = prelude.first {
            
            if let simpleBlock = block {
                
                return SourceStringSegment(startIndex: preludeFirst.sourceStringSegment!.startIndex, endIndex: simpleBlock.sourceStringSegment!.endIndex)
            }
            else if let preludeLast = prelude.last {
                
                return SourceStringSegment(startIndex: preludeFirst.sourceStringSegment!.startIndex, endIndex: preludeLast.sourceStringSegment!.endIndex)
            }
        }
        else if let simpleBlock = block {
            
            if simpleBlock.endToken.tokenId != §CSTokenId.cssEof {
                return SourceStringSegment(startIndex: simpleBlock.startToken.sourceStringSegment!.startIndex, endIndex: simpleBlock.endToken.sourceStringSegment!.endIndex)
            }
            else {
                return SourceStringSegment(startIndex: simpleBlock.startToken.sourceStringSegment!.startIndex, endIndex: self.sourceString.length)
            }
        }
        
        return nil
    }
    
    fileprivate func regionFromAListOfRules(_ rules: [CSRule]) -> SourceStringSegment? {
        
        if let firstRuleSegment = rules.first?.sourceStringSegment {
            
            if let lastRuleSegment = rules.last!.sourceStringSegment {
                
                return SourceStringSegment(startIndex: firstRuleSegment.startIndex, endIndex: lastRuleSegment.endIndex)
            }
        }
        
        return SourceStringSegment(startIndex: 0, endIndex: sourceString.length)
    }
    
    
    fileprivate func validateSourceStringSegment(sourceStringSegment: SourceStringSegment?) {
        #if DEBUG
        assert(sourceStringSegment != nil)
        sourceStringSegment?.validate()
        let range = sourceStringSegment!.range

        assert(range != nil)
        if let range = range {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//            os_log("self.sourceString.length: %d", log: Log.Web.all, type: .debug, self.sourceString.length)
//            os_log("range.location: %d", log: Log.Web.all, type: .debug, range.location)
            #endif
            
            // range.location <= self.sourceString.length because the sourceString could be empty 
            assert(range.location >= 0 && range.location <= self.sourceString.length)
            if range.location < 0 {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("range.location: %d", log: Log.Web.all, type: .debug, range.location)
                #endif
                assert(false)
            }
            if range.location + range.length > self.sourceString.length {
//                os_log("range.location + range.length: %d", log: Log.Web.all, type: .debug, range.location + range.length)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("length: %d", log: Log.Web.all, type: .debug, self.sourceString.length)
                #endif
                assert(false)
            }
        }
        #endif
    }
    
}


