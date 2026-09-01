//
//  CSSOMCreatorVisitor.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

/// This visitor is implemented in order to adapt easily to any change in the CSS specification
/// There is no absolut need for the moment for this kind of complexity but it may be needed 
/// in the futur.
public final class CSSOMCreatorVisitor: CSVisitor {

    var parentStack: Stack<CSSOMNodeInfo>

    let cssStyleSheet: CSSStyleSheet
    
    var computePropertyValues: Bool

    let declarationStopIndex: DeclarationStopIndex?
    
    public private(set) var declarationStoppedIndex: Int?
    
    public convenience init(origin: CSSOrigin, computePropertyValues: Bool, declarationStopIndex: DeclarationStopIndex? = nil) {
        
        self.init(computePropertyValues: computePropertyValues, origin: origin, declarationStopIndex: declarationStopIndex)
    }
    
    public init(computePropertyValues: Bool = false, origin: CSSOrigin, declarationStopIndex: DeclarationStopIndex? = nil) {
        
        self.cssStyleSheet = CSSStyleSheet(origin: origin)
        parentStack = Stack<CSSOMNodeInfo>()
        self.computePropertyValues = computePropertyValues
        self.declarationStopIndex = declarationStopIndex
    }
    
    public func pop() {
        
        _ = parentStack.pop()
    }
    
    public func push(_ nodeInfo: NodeInfo) {
        
        parentStack.push(nodeInfo as! CSSOMNodeInfo)
    }
    
    func top() -> CSSOMNodeInfo? {
        
        return self.parentStack.top
    }
    
    public func process(_ node: CSStyleSheet) -> CSSStyleSheet {
        
        node.accept(self)
        return self.cssStyleSheet
    }
    
    // http://dev.w3.org/csswg/cssom/#the-cssstylesheet-interface
    public func visit(_ node: CSStyleSheet) -> NodeInfo {
        
        self.cssStyleSheet.comments = node.comments
        return createParentNode(cssStyleSheet)
    }
    
    public func visit(_ node: CSAtRule) -> NodeInfo {
    
        if let preludeFirstComponentValue = node.prelude.first as? CSPreservedTokenComponentValue {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("preludeFirstComponentValue.value.rawStringValue: %@", log: Log.Web.all, type: .info, %%preludeFirstComponentValue.value.rawStringValue)
            #endif
            
            if preludeFirstComponentValue.value.rawStringValue == CSSNamespaceParser.NamespaceRuleName {
                
                return handleNamespaceRule(node)
            }
            else {
                return handleUnrecognizedAtRule(node)
            }
        }
        
        return CSSOMNodeInfo(nil, visitChildren: false)
    }
    
    // http://dev.w3.org/csswg/cssom/#cssrule
    // http://dev.w3.org/csswg/cssom/#cssstylerule
    public func visit(_ node: CSQualifiedRule) -> NodeInfo {
        
        let cssStyleRule = CSSStyleRule(cssText: node.cssText(), styleSheet: cssStyleSheet)
        
        cssStyleRule.sourceStringSegment = node.sourceStringSegment
        
        if let cssOMNodeInfo = top() {
            
            // parent node is a CSSStyleSheet
            // there should always
                
            _ = self.cssStyleSheet.insertRule(cssStyleRule)
            
            // parent node is a CSSRule
            if let parentCssRule = cssOMNodeInfo.cssomNode as? CSSRule {
                
                cssStyleRule.parentRule = parentCssRule
            }
        }
        // take care of the selector text
        
        let selectorParser = CSSSelectorParser(componentValueArray: node.prelude )
        
        if let selectorList = selectorParser.parseSelector(cssStyleRule) {
        
            cssStyleRule.selectorList = selectorList
        }
    
        return createParentNode(cssStyleRule)
    }
    
    public func visit(_ node: CSSimpleBlock) -> NodeInfo {

        
        // if there is something on the top of the stack
        if let cssOMNodeInfo = top() {
            
            let parentNode = cssOMNodeInfo.cssomNode
            
            // if the parent node is a CSSStyleRule, here we need
            // to create a CSSStyleDeclaration
            if let styleRule = parentNode as? CSSStyleRule {
                
                if let declarationStopIndex = declarationStopIndex, declarationStopIndex.isEndOfStyleDeclarationBloc &&   declarationStopIndex.index == node.endStringIndex {
                    self.declarationStoppedIndex = declarationStopIndex.index
                }
                
                // http://dev.w3.org/csswg/cssom/#css-declaration-blocks
                let cssStyleDeclaration = CSSStyleDeclaration(sourceStringSegment: node.sourceStringSegment!)
                
                assert(node.startToken.tokenId == §CSTokenId.leftCurlyBraceToken, "node.startToken.tokenId != §CSTokenId.LeftCurlyBraceToken")
                cssStyleDeclaration.leftCurlyBrace = node.startToken
                
                // The end token could be the end of file. So we don't necessarly 
                // populate it.
                if node.endToken.tokenId == §CSTokenId.rightCurlyBraceToken {
                
                    cssStyleDeclaration.rightCurlyBrace = node.endToken
                }
                
                cssStyleDeclaration.parentRule = styleRule
                
                styleRule.style = cssStyleDeclaration
                
                // here we should parse a list of declarations contained 
                // inside the simple block
                // see http://dev.w3.org/csswg/css-syntax/#consume-a-list-of-declarations
                let (cssDeclarationList, _declarationStoppedIndex) = CSParser.consumeAListOfDeclarations(node.componentValueList, cssStyleDeclaration: cssStyleDeclaration, declarationStopIndex: declarationStopIndex) //, cssStyleDeclaration: cssStyleDeclaration, computePropertyValues: computePropertyValues
                
                if let declarationStopIndex = declarationStopIndex, declarationStopIndex.isEndOfDeclaration {
                    self.declarationStoppedIndex = _declarationStoppedIndex
                }
                
                for declaration in cssDeclarationList {

                    if let declaration = declaration as? CSDeclaration {
                    
                        // Keep the components returned by the reader in the style declaration object.
                        cssStyleDeclaration.appendPropertyDeclaration(declaration.propertyName,
                            declaration: declaration)
                    }
                    else if let invalidDeclaration = declaration as? InvalidDeclaration {
                     
                        cssStyleDeclaration.addInvalidPropertyDeclaration(invalidDeclaration)
                    }
                }
                
                cssStyleDeclaration.updateDeclarationsData(computePropertyValues: computePropertyValues)
                return createParentNode(cssStyleDeclaration)
            }
        }
        // what to do if there is nothing on the top of the stack
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top of the stack is empty.", log: Log.Web.all, type: .error)
            #endif
        }
        return createNilParentNode()
    }
    
    func createParentNode(_ cssNode: CSSOMLanguageObject) -> CSSOMNodeInfo {
        
        return CSSOMNodeInfo(cssNode)
    }
    
    func createNilParentNode() -> NodeInfo {
        
        return CSSOMNilNodeInfo()
    }
    
    func parseCSSDeclarationBlock(_ cssDeclarationList : [CSDeclaration]) {
        
        // TODO 
        // see parse a CSS declaration block
        // in http://dev.w3.org/csswg/cssom 6.6 CSS Declaration Blocks
        // in fact it is not really needed for the moment,
        // we will see later. 
        
    }
    
    private func handleUnrecognizedAtRule(_ node: CSAtRule) -> NodeInfo {
        
        if let cssOMNodeInfo = top() {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("node sourceStringSegment: %@", log: Log.Web.all, type: .info, %%node.sourceStringSegment!)
            #endif
            
            var componentValues = node.prelude
            
            if let blocks = node.blocks {
                for block in blocks {
                    let simpleBlock = CSSimpleBlockComponentValue(value: block)
                    componentValues.append(simpleBlock)
                }
            }
            
            var unrecognizedRule = UnrecognizedAtRule(sourceStringSegment: node.sourceStringSegment, endSemiColon: node.endSemiColon, componentValuesList: componentValues, cssText: node.cssText())
            
            unrecognizedRule.addMessage(.unsupportedOrInvalidAtRule)
            
            switch cssOMNodeInfo.cssomNode {
                
            case let styleSheet as CSSStyleSheet:
                
                unrecognizedRule.parentStyleSheet = styleSheet
                
            case let rule as CSSRule:
                
                unrecognizedRule.parentRule = rule
                
            default:
                
                assert(false, "Unhandled dom node in handleUnrecognizedAtRule(...)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Unhandled dom node in handleUnrecognizedAtRule(...)", log: Log.Web.all, type: .error)
                #endif
            }
            
            self.cssStyleSheet.insertRule(unrecognizedRule)
            return createParentNode(unrecognizedRule)
        }
        return CSSOMNodeInfo(nil, visitChildren: false)
    }
    
    private func handleNamespaceRule(_ node: CSAtRule) -> NodeInfo {
        
        if let cssOMNodeInfo = top() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("node sourceStringSegment: %@", log: Log.Web.all, type: .info, %%node.sourceStringSegment!)
            #endif
            
            let namespaceParser = CSSNamespaceParser(componentValueArray: node.prelude )
            
            if let namespaceRule = namespaceParser.parseNamespaceAtRule(node) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("namespaceRule sourceStringSegment: %@", log: Log.Web.all, type: .info, %%namespaceRule.sourceStringSegment!)
                #endif
                
                switch cssOMNodeInfo.cssomNode {
                    
                case let styleSheet as CSSStyleSheet:
                    
                    namespaceRule.parentStyleSheet = styleSheet
                    
                case let rule as CSSRule:
                    
                    namespaceRule.parentRule = rule
                    
                default:
                    
                    assert(false, "Unexpected cssOmNode: \(cssOMNodeInfo.cssomNode)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Unexpected cssOmNode: %@", log: Log.Web.all, type: .error, %%cssOMNodeInfo.cssomNode)
                    #endif
                }
                
                namespaceRule.endSemiColon = node.endSemiColon
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("namespaceRule sourceStringSegment: %@", log: Log.Web.all, type: .info, %%namespaceRule.sourceStringSegment!)
                #endif
                
                // if there is already a default namespace
                if self.cssStyleSheet.defaultNamespace != nil && namespaceRule.isDefault {
                    
                    namespaceRule.messageHandler.addMessage(MessageCode.tooManyDefaultNamespaceDeclarations)
                }
                self.cssStyleSheet.insertRule(namespaceRule)
                return createParentNode(namespaceRule)
            }
        }
        assert(false)
        return CSSOMNodeInfo(nil, visitChildren: false)
    }

}
