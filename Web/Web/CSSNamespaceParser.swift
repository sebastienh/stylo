//
//  CSSNamespaceParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-01-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSNamespaceParser: CSSComponentsParser {
    
    static let NamespaceRuleName = "@namespace"
    
    var namespaceSourceStringSegment: SourceStringSegment?
    
    var atKeywordToken: Token?
    
    ///
    /// We pass a list of component value from the prelude of the
    /// CSAtRule
    ///
    /// namespace
    ///     : NAMESPACE_SYM S* [namespace_prefix S*]? [STRING|URI] S* ';' S*
    ///     ;
    ///
    /// [Syntax](https://www.w3.org/TR/css-namespaces-3/#syntax)
    ///
    func parseNamespaceAtRule(_ node: CSAtRule) -> CSSNamespaceRule? {
        
        let namespacePrefix = parseNamespacePrefix()
        
        let namespaceURI = parseNamespaceURI()
        
        return parseNamespaceRule(node: node, namespacePrefix: namespacePrefix, namespaceURI: namespaceURI)
    }

    ///
    ///
    ///
    private func parseNamespaceRule(node: CSAtRule, namespacePrefix: CSSNamespacePrefix?, namespaceURI: CSSNamespaceURI?) -> CSSNamespaceRule? {
        
        let namespace = CSSNamespaceRule(cssNamespaceURI: namespaceURI, cssNamespacePrefix: namespacePrefix, cssText: node.cssText())
        
        if namespaceURI == nil {
            namespace.messageHandler.addMessage(MessageCode.missingNamespaceUri)
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        let startIndex = self.componentValueArray.first!.sourceStringSegment!.endIndex
        let endIndex = self.componentValueArray.first!.sourceStringSegment!.endIndex
        os_log("startIndex: %@, endIndex: %@", log: Log.Web.all, type: .info, %%String(describing: startIndex), %%String(describing: endIndex))
        let endSemiColonEndIndex = namespace.endSemiColon?.sourceStringSegment?.endIndex
        os_log("endSemiColon endIndex: %@", log: Log.Web.all, type: .info, %%String(describing: endSemiColonEndIndex))
        #endif
        
        //
        namespace.sourceStringSegment = SourceStringSegment(startIndex: self.componentValueArray.first!.sourceStringSegment!.startIndex, endIndex: self.componentValueArray.last!.sourceStringSegment!.endIndex)
        
        namespace.atKeywordToken = self.atKeywordToken
        
        // we should handle any left component which will in fat resolve
        // in an invalid namespace rule, this should be done for the
        // left prelude components and the any blocks associated with the
        // CSAtRule.
        
        // handle the prelude
        namespace.unexpectedSuffixComponentsValues = self.restOfComponentsValues
        
        // handle the unexpected blocks
        var blocksComponents = [CSComponentValue]()
        
        if let blocks = node.blocks {
            for block in blocks {
                let simpleBlock = CSSimpleBlockComponentValue(value: block)
                blocksComponents.append(simpleBlock)
            }
        }
        if namespace.unexpectedSuffixComponentsValues != nil {
            namespace.unexpectedSuffixComponentsValues?.append(contentsOf: blocksComponents)
        }
        else {
            namespace.unexpectedSuffixComponentsValues = blocksComponents
        }
        
        return namespace
    }
    
    ///
    /// namespace_prefix
    ///     : IDENT
    ///     ;
    ///
    private func parseNamespacePrefix() -> CSSNamespacePrefix? {
        
        // validate we are in front of the @namespace keyword
        if let token = currentComponentValue() as? CSPreservedTokenComponentValue, token.isTokenId(§CSTokenId.atKeywordToken) && token.rawStringValue == CSSNamespaceParser.NamespaceRuleName {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component value: %@", log: Log.Web.all, type: .info, %%token.cssText())
            #endif
            
            self.namespaceSourceStringSegment = token.sourceStringSegment
            
            self.atKeywordToken = token.value
            
            advanceComponentValueIndex()
            parseWhitespaces()
            
            if let prefixToken = currentComponentValue() as? CSPreservedTokenComponentValue, prefixToken.isTokenId(§CSTokenId.identToken) {
                
                advanceComponentValueIndex()
                parseWhitespaces()
                
                return CSSNamespacePrefix(sourceStringSegment: prefixToken.sourceStringSegment!, tokenValue: prefixToken.value)
            }
        }
        
        return nil
    }
    
    ///
    /// S* [STRING|URI] S* 
    ///
    private func parseNamespaceURI() -> CSSNamespaceURI? {
    
        parseWhitespaces()
        
        if let token = currentComponentValue() as? CSPreservedTokenComponentValue, token.isTokenId(§CSTokenId.identToken) || token.isTokenId(§CSTokenId.stringToken) {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component value: %@", log: Log.Web.all, type: .info, %%token.cssText())
            #endif
            
            let namespaceURI = CSSNamespaceURI(sourceStringSegment: nil, uriValue: NamespaceURIValue.none)
            
            if token.isTokenId(§CSTokenId.identToken) {
                
                namespaceURI.uriValue = NamespaceURIValue.stringValue(token.stringRepresentation)
            }
            else {
                
                namespaceURI.uriValue = NamespaceURIValue.uriValue(token.stringRepresentation)
            }
            
            namespaceURI.sourceStringSegment = token.sourceStringSegment!
            namespaceURI.tokenValue = token.value
            advanceComponentValueIndex()
            parseWhitespaces()
            
            return namespaceURI
        }
        
        return nil
    }
//    
//    ///
//    /// S* ';' S*
//    ///
//    private func parseEndSemiColon() -> CSToken? {
//        
//        parseWhitespaces()
//        
//        let token = currentComponentValue()
//        
//        if let preservedToken = currentComponentValue() as? CSPreservedTokenComponentValue where preservedToken.isTokenId(§CSTokenId.SemicolonToken) {
//            
//            advanceComponentValueIndex()
//            parseWhitespaces()
//            
//            return preservedToken.value
//        }
//        
//        return nil
//    }
    
}
