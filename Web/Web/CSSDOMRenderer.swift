//
//  CSSDOMRenderer.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-16.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSDOMRenderer<P: ContainerNode>: CSSVisitor {
    
    var parentStack: Stack<CSSDOMNodeInfo>
    
    let parentContainer: P
    
    var cssDomDocument: CSSDOMDocument? {
        
        return parentContainer as? CSSDOMDocument
    }
    
    var beforeStyleRuleElement: CSSDOMElement?
    
    let cssDomElementFactory: CSSDOMElementConcreteFactory
    
    public convenience init() {
        
        let documentFragment = CSSDOMDocumentFragment()
        self.init(parentContainer: documentFragment as! P)
    }
    
    public convenience init(document: CSSDOMDocument) {
        
        self.init(parentContainer: document as! P)
    }
    
    public init(parentContainer: P) {
        
        self.cssDomElementFactory = CSSDOMElementConcreteFactory.shared
        parentStack = Stack<CSSDOMNodeInfo>()
        
        self.parentContainer = parentContainer
    }
    
    public func pop() {
        
        parentStack.pop()
    }
    
    public func push(_ nodeInfo: NodeInfo) {
        
        self.parentStack.push(nodeInfo as! CSSDOMNodeInfo)
    }
    
    fileprivate func top() -> CSSDOMNodeInfo? {
        
        return self.parentStack.top
    }
    
    public func renderStylesheet(_ cssStyleSheet: CSSStyleSheet) -> CSSDOMDocument? {
        
        assert(cssDomDocument != nil)
        // push the node as parent information
        push(CSSDOMNodeInfo(node: cssDomDocument!))
        cssStyleSheet.accept(self)
        return cssDomDocument!
    }
    
    public func render(stylesheetSelectorList stylesheet: CSSStyleSheet, inCssDocument document: CSSDOMDocument) -> ContiguousArray<Element>? {
        
        guard let styleRule = parentContainer as? CSSDOMElement else {
            assertionFailure("Error: styleRule is nil")
            return nil
        }

        let nodeInfo = CSSDOMNodeInfo(node: styleRule)
        parentStack.push(nodeInfo)
        
        var rootElements = ContiguousArray<Element>()
        
        // convert all CSComment in CSSDOMTokenElement
        if let comments = stylesheet.comments {
            
            let commentElements = comments.map({ (comment) -> CSSDOMTokenElement in
                return CSSDOMTokenElement(segment: comment.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.CommentToken, textValue: comment.rawStringValue)
            })
            
            document.styleSheet.insertCommentsInOrder(comments: commentElements)
            rootElements.append(contentsOf: commentElements)
        }
        
        guard let firstStyleRule = stylesheet.firstStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return nil
        }
        
        guard let selectorList = firstStyleRule.selectorList else {
            assertionFailure("Error: selectorList is nil")
            return nil
        }
        
        selectorList.accept(self)
        return rootElements
    }
    
    public func render(stylesheetDeclarations stylesheet: CSSStyleSheet, inCssDocument document: CSSDOMDocument) -> ContiguousArray<Element>? {
        
        guard let styleDeclaration = parentContainer as? CSSDOMElement else {
            assertionFailure("Error: styleRule is nil")
            return nil
        }

        let nodeInfo = CSSDOMNodeInfo(node: styleDeclaration)
        parentStack.push(nodeInfo)
        
        var rootElements = ContiguousArray<Element>()
        
        // convert all CSComment in CSSDOMTokenElement
        if let comments = stylesheet.comments {
            
            let commentElements = comments.map({ (comment) -> CSSDOMTokenElement in
                return CSSDOMTokenElement(segment: comment.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.CommentToken, textValue: comment.rawStringValue)
            })
            
            document.styleSheet.insertCommentsInOrder(comments: commentElements)
            rootElements.append(contentsOf: commentElements)
        }
        
        guard let firstStyleRule = stylesheet.firstStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return nil
        }
        
        
        guard let csStyleDeclaration = firstStyleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        
        for (_ , declaration) in csStyleDeclaration.propertyStyleDeclarations {
            declaration.accept(self)
            guard let addedCssDeclaration = styleDeclaration.lastElementChild else {
                assertionFailure("Error: addedCssDeclaration is nil")
                continue
            }
            rootElements.append(addedCssDeclaration)
        }
        
        return rootElements
    }
    
    public func renderRules(in cssStyleSheet: CSSStyleSheet) -> CSSDOMDocumentFragment? {
        
        assert(parentContainer is CSSDOMDocumentFragment)
        if let documentFragment = parentContainer as? CSSDOMDocumentFragment {

            let nodeInfo = CSSDOMNodeInfo(node: parentContainer)
            parentStack.push(nodeInfo)
            
            // convert all CSComment in CSSDOMTokenElement
            if let comments = cssStyleSheet.comments {
                
                var exception = Exception()
                
                for i in 0..<comments.count {
                    
                    let comment = comments[i]
                    
                    let domComment = CSSDOMTokenElement(segment: comment.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.CommentToken, textValue: comment.rawStringValue)
                    
                    documentFragment.append(domComment, exception: &exception)
                    exception.logIfError()
                }
            }
            
            for rule in cssStyleSheet.cssRules {
                rule.accept(self)
            }
        }
        return self.parentContainer as? CSSDOMDocumentFragment
    }
    
    func renderStyleRule(_ styleRule: CSSStyleRule, insertBefore: CSSDOMElement?, styleSheetElement: CSSDOMStyleSheetElement) {
        
        assert(insertBefore?.localName == §CSSElementType.StyleRule)
        
        push(CSSDOMNodeInfo(node: styleSheetElement))
        
        self.beforeStyleRuleElement = insertBefore
        
        styleRule.accept(self)
    }
    
    func processStyleDeclaration(_ styleDeclaration: CSSStyleDeclaration, styleRuleElement: CSSDOMElement) {
        
        assert(styleRuleElement.localName == §CSSElementType.StyleRule)
        
        push(CSSDOMNodeInfo(node: styleRuleElement))
        
        styleDeclaration.accept(self)
    }
    
    public func visit(_ node: CSSStyleSheet) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let cssDomDocument = parentNodeInfo.node as? CSSDOMDocument {
                
                // this method returns the real element
                if let stylesheetDocumentElement = cssDomElementFactory.createCssDomStyleSheet(cssDomDocument, cssStyleSheet: node ) {
                    
                    // convert all CSComment in CSSDOMTokenElement
                    if let comments = node.comments {
                        
                        var exception = Exception()
                        
                        for comment in comments {
                            let domComment = CSSDOMTokenElement(segment: comment.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.CommentToken, textValue: comment.rawStringValue)
                            
                            assert(!(stylesheetDocumentElement is CSSDOMTokenElement))
                            stylesheetDocumentElement.append(domComment, exception: &exception)
                            exception.logIfError()
                        }
                    }
                    return CSSDOMNodeInfo(node: stylesheetDocumentElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("NodeInfo is not of type : CSSDOMDocument", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("NodeInfo is not of type : CSSDOMDocument", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error : no source document parent node info on the stack!", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: WQNamePrefix) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let element = parentNodeInfo.node as? CSSDOMElement , element.localName == §CSSElementType.TypeSelector {
                
                if let wqNamePrefixElement = cssDomElementFactory.createCssDomWQNamePrefixElement(cssDomDocument, wqNamePrefix: node, parentElement: parentNodeInfo.node as! CSSDOMElement, beforeElement: (parentNodeInfo.node as! CSSDOMElement).lastChild as! CSSDOMElement) {
                    
                    return CSSDOMNodeInfo(node: wqNamePrefixElement)
                }
            }
            else if let element = parentNodeInfo.node as? CSSDOMElement , element.localName == §CSSElementType.AttributeName {
                
                if let wqNamePrefixElement = cssDomElementFactory.createCssDomWQNamePrefixElement(cssDomDocument, wqNamePrefix: node, parentElement: parentNodeInfo.node as! CSSDOMElement, beforeElement: (parentNodeInfo.node as! CSSDOMElement).lastChild as! CSSDOMElement) {
                    
                    return CSSDOMNodeInfo(node: wqNamePrefixElement)
                }
            }
        }
        else { os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error) }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: UnrecognizedAtRule) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
        
            if let parentContainerNode = parentNodeInfo.node as? ContainerNode {
                
                if let unrecognizedRuleElement = cssDomElementFactory.createCssDomUnrecognizedRuleElement(cssDomDocument, unrecognizedAtRule: node, containerNode: parentContainerNode) {
                    
                    return CSSDOMNodeInfo(node: unrecognizedRuleElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: CSSNamespaceRule) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleSheetElement = parentNodeInfo.node as? CSSDOMStyleSheetElement {
                
                let namespaceRuleElement = cssDomElementFactory.createCssDomNamespaceRuleElement(cssDomDocument, namespaceRule: node, containerNode: styleSheetElement)
                
                assert(namespaceRuleElement != nil)
                if let namespaceRuleElement = namespaceRuleElement {
                    
                    return CSSDOMNodeInfo(node: namespaceRuleElement)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else if let documentFragment = parentNodeInfo.node as? DocumentFragment {
                
                let namespaceRuleElement = cssDomElementFactory.createCssDomNamespaceRuleElement(cssDomDocument, namespaceRule: node, containerNode: documentFragment)
                
                assert(namespaceRuleElement != nil)
                if let namespaceRuleElement = namespaceRuleElement {
                    
                    return CSSDOMNodeInfo(node: namespaceRuleElement)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("styleSheetElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func postVisit(_ node: CSSNamespaceRule) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let unexpectedSuffixComponentsValues = node.unexpectedSuffixComponentsValues
        
        // of course, unexpectedSuffixComponentsValues can be nil
        if let unexpectedSuffixComponentsValues = unexpectedSuffixComponentsValues {
            
            let top = self.top()
            
            assert(top != nil)
            if let parentNodeInfo = top {
                
                let namespaceRuleElement = parentNodeInfo.node as? CSSDOMElement
                
                assert(namespaceRuleElement != nil)
                assert(namespaceRuleElement!.localName == §CSSElementType.NamespaceRule)
                if let namespaceRuleElement = namespaceRuleElement {
                    
                    cssDomElementFactory.handleComponentsList(cssDomDocument, componentValuesList: unexpectedSuffixComponentsValues, parent: namespaceRuleElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
        }
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: CSSNamespacePrefix) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let namespaceRuleElement = parentNodeInfo.node as? CSSDOMElement , namespaceRuleElement.localName == §CSSElementType.NamespaceRule {
                
                var endSemiColonElement: CSSDOMTokenElement?
                
                if let _endSemiColonElement = namespaceRuleElement.lastChild as? CSSDOMTokenElement , _endSemiColonElement.hasClassAttribute(§TokenClassType.SemicolonToken) {
                    
                    endSemiColonElement = _endSemiColonElement
                }
                
                if let namespaceRuleElement = cssDomElementFactory.createCssDomNamespacePrefixElement(cssDomDocument, namespacePrefix: node, namespaceRuleElement: namespaceRuleElement, beforeElement: endSemiColonElement) {
                    
                    return CSSDOMNodeInfo(node: namespaceRuleElement)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("styleSheetElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: CSSNamespaceURI) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let namespaceRuleElement = parentNodeInfo.node as? CSSDOMElement , namespaceRuleElement.localName == §CSSElementType.NamespaceRule {
                
                var endSemiColonElement: CSSDOMTokenElement?
                
                if let _endSemiColonElement = namespaceRuleElement.lastChild as? CSSDOMTokenElement , _endSemiColonElement.hasClassAttribute(§TokenClassType.SemicolonToken) {
                    
                    endSemiColonElement = _endSemiColonElement
                }
                
                if let namespaceRuleElement = cssDomElementFactory.createCssDomNamespaceUriElement(cssDomDocument, namespaceUri: node, namespaceRuleElement: namespaceRuleElement, beforeElement: endSemiColonElement) {
                    
                    return CSSDOMNodeInfo(node: namespaceRuleElement)
                }
                else { os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error) }
            }
            else { os_log("styleSheetElement is nil.", log: Log.Web.all, type: .error) }
        }
            else { os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error) }

        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    /// A CSSStyleRule contains a SelectorList and
    /// a style (CSSStyleDeclaration).
    public func visit(_ node: CSSStyleRule) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleSheetElement = parentNodeInfo.node as? CSSDOMStyleSheetElement {
                
                if let styleRuleElement = cssDomElementFactory.createCssDomStyleRuleElement(cssDomDocument, cssStyleRule: node, containerNode: styleSheetElement, beforeElement: beforeStyleRuleElement) {
                    
                    return CSSDOMNodeInfo(node: styleRuleElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else if let documentFragment = parentNodeInfo.node as? DocumentFragment {
                
                if let styleRuleElement = cssDomElementFactory.createCssDomStyleRuleElement(cssDomDocument, cssStyleRule: node, containerNode: documentFragment, beforeElement: beforeStyleRuleElement) {
                    
                    return CSSDOMNodeInfo(node: styleRuleElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleRuleElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("styleSheetElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: SelectorList) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        guard let parentNodeInfo = self.top() else {
            assertionFailure("Error: top is nil")
            return CSSDOMNodeInfo(node: nil, visitChildren: false)
        }
           
        guard let styleRule = parentNodeInfo.node as? CSSDOMElement else {
            assertionFailure("Error: styleRule is nil")
            return CSSDOMNodeInfo(node: nil, visitChildren: false)
        }
        
        guard styleRule.localName == §CSSElementType.StyleRule else {
            assertionFailure("Error: \(styleRule.localName) != \(§CSSElementType.StyleRule)")
            return CSSDOMNodeInfo(node: nil, visitChildren: false)
        }
        
        if let selectorListElement = cssDomElementFactory.createCssDomSelectorListElement(cssDomDocument, selectorList: node, styleRule: styleRule) {
            
            return CSSDOMNodeInfo(node: selectorListElement)
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("selectorListElement is nil.", log: Log.Web.all, type: .error)
            #endif
        }

        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: ComplexSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let selectorListElement = parentNodeInfo.node as? CSSDOMElement , selectorListElement.localName == §CSSElementType.SelectorList {
                
                if let complexSelectorElement = cssDomElementFactory.createCssDomComplexSelectorElement(cssDomDocument, complexeSelector: node, selectorListElement: selectorListElement ) {
                    
                    return CSSDOMNodeInfo(node: complexSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("complexSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("selectorListElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: InvalidComplexSelector) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            let selectorListElement = parentNodeInfo.node as? CSSDOMElement
            
            assert(selectorListElement != nil)
            if let selectorListElement = selectorListElement {
            
                assert(selectorListElement.localName == §CSSElementType.SelectorList)
                if let complexSelectorElement = cssDomElementFactory.createCssDomInvalidComplexSelectorElement(cssDomDocument, invalidComplexSelector: node, selectorListElement: selectorListElement) {
                    
                    complexSelectorElement.addMessage(MessageCode.invalidComplexSelector)
                    
                    return CSSDOMNodeInfo(node: complexSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("complexSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    
    /// We need to do a post visit to put the unexpected
    /// component values after the correct simple selectors
    public func postVisit(_ node: InvalidComplexSelector) {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let complexSelectorElement = parentNodeInfo.node as? CSSDOMElement, complexSelectorElement.localName == §CSSElementType.InvalidComplexSelector {
                
//                assert(!(complexSelectorElement is CSSDOMTokenElement))
//                var exception = Exception()
                
                cssDomElementFactory.handleComponentsList(cssDomDocument, componentValuesList: node.invalidComponentValues, parent: complexSelectorElement, addError: false)
                    
//                    let tokenElement = CSSDOMTokenElement(segment: component.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.UnexpectedToken, textValue: component.cssText())
//
//                    tokenElement.addMessages(component.allMessages)
//
//                    complexSelectorElement.append(tokenElement, exception: &exception)
//                    exception.logIfError()
                
            }
        }
    }
    
    public func visit(_ node: CompoundSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let complexSelectorElement = parentNodeInfo.node as? CSSDOMElement , complexSelectorElement.localName == §CSSElementType.ComplexSelector {
                
                if let compoundSelectorElement = cssDomElementFactory.createCssDomCompoundSelectorElement(cssDomDocument, compoundSelector: node, complexeSelectorElement: complexSelectorElement ) {
                    
                    return CSSDOMNodeInfo(node: compoundSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("complexSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: InvalidCompoundSelector) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let complexSelectorElement = parentNodeInfo.node as? CSSDOMElement , complexSelectorElement.localName == §CSSElementType.ComplexSelector {
                
                if let compoundSelectorElement = cssDomElementFactory.createCssDomInvalidCompoundSelectorElement(cssDomDocument, invalidCompoundSelector: node, complexeSelectorElement: complexSelectorElement ) {
                    
                    compoundSelectorElement.addMessage(MessageCode.invalidCompoundSelector)
                    
                    return CSSDOMNodeInfo(node: compoundSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("complexSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    /// We need to do a post visit to put the unexpected
    /// component values after the correct simple selectors
    public func postVisit(_ node: InvalidCompoundSelector) {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement, compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
        
                var exception = Exception()
                
                for component in node.invalidComponentValues {
                    
                    let tokenElement = CSSDOMTokenElement(segment: component.sourceStringSegment, document: cssDomDocument, tokenClass: TokenClassType.UnexpectedToken, textValue: component.cssText())
        
                    tokenElement.addMessages(component.allMessages)
                    
                    assert(!(compoundSelectorElement is CSSDOMTokenElement))
                    compoundSelectorElement.append(tokenElement, exception: &exception)
                    exception.logIfError()
                }
            }
        }
    }
    
    public func visit(_ node: SelectorCombinator) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let complexeSelectorElement = parentNodeInfo.node as? CSSDOMElement , complexeSelectorElement.localName == §CSSElementType.ComplexSelector {
                
                if let selectorCombinatorElement = cssDomElementFactory.createCssDomSelectorCombinatorElement(cssDomDocument, selectorCombinator: node, complexeSelectorElement: complexeSelectorElement ) {
                    
                    return CSSDOMNodeInfo(node: selectorCombinatorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("selectorCombinatorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: TypeSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement , compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let typeSelectorElement = cssDomElementFactory.createCssDomTypeSelectorElement(cssDomDocument, typeSelector: node, compoundSelectorElement: compoundSelectorElement ) {
                    
                    // could be type selector or universal sele
                    assert(typeSelectorElement.localName == §CSSElementType.TypeSelector)
                    
                    return CSSDOMNodeInfo(node: typeSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("typeSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: IdentPseudoClass) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement , compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let pseudoClassSelectorElement = cssDomElementFactory.createCssDomPseudoClassSelectorElement(cssDomDocument, pseudoClass: node, parentElement: compoundSelectorElement ) {
                    
                    pseudoClassSelectorElement.addMessages(node.allMessages)
                    assert(pseudoClassSelectorElement.localName == §CSSElementType.PseudoClassSelector)
                    return CSSDOMNodeInfo(node: pseudoClassSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("pseudoClassSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: FunctionalPseudoClass) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement , compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                // since it could be functional pseudo-class the first pseudo class selector element
                // becomes the parent of the second pseudo-class.
                // FIXME: implement this.
                if let functionalPseudoClassSelectorElement = cssDomElementFactory.createCssDomPseudoClassSelectorElement(cssDomDocument, pseudoClass: node, parentElement: compoundSelectorElement ) {
                    
                    assert(functionalPseudoClassSelectorElement.localName == §CSSElementType.FucntionalPseudoClassSelector)
                    
                    return CSSDOMNodeInfo(node: functionalPseudoClassSelectorElement)
                }
                else { os_log("functionalPseudoClassSelectorElement is nil.", log: Log.Web.all, type: .error) }
            }
            else { os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error) }
        }
        else { os_log("parentNodeInfo is nil.", log: Log.Web.all, type: .error) }
        
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: PseudoElementSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            // we don't know which pseudo-selector will be on the top of the stack
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement , compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let pseudoElementSelectorElement = cssDomElementFactory.createCssDomPseudoElementSelectorElement(cssDomDocument,  pseudoElementSelector: node, compoundSelectorElement: compoundSelectorElement ){
                    
                    assert(pseudoElementSelectorElement.localName == §CSSElementType.PseudoElementSelector)
                    
                    return CSSDOMNodeInfo(node: pseudoElementSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("pseudoElementSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                assert(false, "compoundSelectorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: ClassSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement, compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let classSelectorElement = cssDomElementFactory.createCssDomClassSelectorElement(cssDomDocument, classSelector: node, compoundSelectorElement: compoundSelectorElement ) {
                    
                    assert(classSelectorElement.localName == §CSSElementType.ClassSelector)
                    
                    return CSSDOMNodeInfo(node: classSelectorElement)
                }
                else {
                    assert(false, "classSelectorElement is nil.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("classSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                assert(false, "compoundSelectorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: IdSelector) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement
            
            assert(compoundSelectorElement != nil)
            if let compoundSelectorElement = compoundSelectorElement, compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let idSelectorElement = cssDomElementFactory.createCssDomIdSelectorElement(cssDomDocument, idSelector: node, compoundSelectorElement: compoundSelectorElement ) {
                    
                    assert(idSelectorElement.localName == §CSSElementType.IdSelector)
                    
                    return CSSDOMNodeInfo(node: idSelectorElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("idSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                assert(false, "compoundSelectorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: AttribSelector) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let compoundSelectorElement = parentNodeInfo.node as? CSSDOMElement , compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector {
                
                if let attribSelectorElement = cssDomElementFactory.createCssDomAttributeSelectorElement(cssDomDocument, attribSelector: node, compoundSelectorElement: compoundSelectorElement ) {
                    
                    assert(attribSelectorElement.localName == §CSSElementType.AttributeSelector)
                    
                    return CSSDOMNodeInfo(node: attribSelectorElement)
                }
                else {
                    assert(false, "attribSelectorElement is nil.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                assert(false, "compoundSelectorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("compoundSelectorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: AttribName) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let attributeSelectorElement = parentNodeInfo.node as? CSSDOMElement , attributeSelectorElement.localName == §CSSElementType.AttributeSelector {
                
                if let attribNameSelectorElement = cssDomElementFactory.createCssDomAttributeNameSelectorElement(cssDomDocument, attribName: node, attribSelectorElement: attributeSelectorElement ) {
                    
                    assert(attribNameSelectorElement.localName == §CSSElementType.AttributeName)
                    
                    return CSSDOMNodeInfo(node: attribNameSelectorElement)
                }
            }
            else {
                assert(false, "attribSelectorMirrorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("attribSelectorMirrorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: AttribMatch) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let attributeSelectorElement = parentNodeInfo.node as? CSSDOMElement , attributeSelectorElement.localName == §CSSElementType.AttributeSelector {
                
                if let attributeMatchSelectorElement = cssDomElementFactory.createCssDomAttributeMatchSelectorElement(cssDomDocument, attribMatch: node, attribSelectorElement: attributeSelectorElement ) {
                    
                    assert(attributeMatchSelectorElement.localName == §CSSElementType.AttributeMatch)
                    
                    return CSSDOMNodeInfo(node: attributeMatchSelectorElement)
                }
            }
            else {
                assert(false, "attribSelectorMirrorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("attribSelectorMirrorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: AttribValue) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let attributeSelectorElement = parentNodeInfo.node as? CSSDOMElement , attributeSelectorElement.localName == §CSSElementType.AttributeSelector {
                
                if let attributeValueSelectorElement = cssDomElementFactory.createCssDomAttributeValueSelectorElement(cssDomDocument, attribValue: node, attribSelectorElement: attributeSelectorElement ) {
                    
                    assert(attributeValueSelectorElement.localName == §CSSElementType.AttributeValue)
                    
                    return CSSDOMNodeInfo(node: attributeValueSelectorElement)
                }
            }
            else {
                assert(false, "attribSelectorMirrorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("attribSelectorMirrorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: AttribFlags) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let attributeSelectorElement = parentNodeInfo.node as? CSSDOMElement , attributeSelectorElement.localName == §CSSElementType.AttributeSelector {
                
                if let attributeFlagsSelectorElement = cssDomElementFactory.createCssDomAttributeFlagsSelectorElement(cssDomDocument, attribFlags: node, attribSelectorElement: attributeSelectorElement ) {
                    
                    assert(attributeFlagsSelectorElement.localName == §CSSElementType.AttributeFlags)
                    
                    return CSSDOMNodeInfo(node: attributeFlagsSelectorElement)
                }
            }
            else {
                assert(false, "attribSelectorMirrorElement is nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("attribSelectorMirrorElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "top() parentNodeInfo is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: CSSStyleDeclaration) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleRulePseudoElement = parentNodeInfo.node as? CSSDOMElement , styleRulePseudoElement.localName == §CSSElementType.StyleRule {
                
                if let styleDeclarationPseudoElement = cssDomElementFactory.createCssDomStyleDeclarationElement(cssDomDocument, styleDeclaration: node, styleRuleElement: styleRulePseudoElement ) {
                    
                    assert(styleDeclarationPseudoElement.localName == §CSSElementType.StyleDeclaration)
                    
                    return CSSDOMNodeInfo(node: styleDeclarationPseudoElement)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("styleDeclarationElement is nil.", log: Log.Web.all, type: .error)
                    #endif
                }
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("styleRulePseudoElement is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while compiling stylesheet", log: Log.Web.all, type: .error)
        #endif
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func visit(_ node: IgnoredSimpleBlock) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleDeclarationElement = parentNodeInfo.node as? CSSDOMElement, styleDeclarationElement.localName == §CSSElementType.StyleDeclaration {
                
                assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration)
                
                if let ignoredBlockElement = cssDomElementFactory.createCssDomIgnoredBlockElement(cssDomDocument, ignoredBlock: node, styleDeclarationElement: styleDeclarationElement) {

                    assert(ignoredBlockElement.localName == §CSSElementType.IgnoredSimpleBlock)

                    return CSSDOMNodeInfo(node: ignoredBlockElement)
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
        
    }
    
    public func visit(_ node: CSDeclaration) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleDeclarationElement = parentNodeInfo.node as? CSSDOMElement, styleDeclarationElement.localName == §CSSElementType.StyleDeclaration {
                
                assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration)
                
                if let declarationElement = cssDomElementFactory.createCssDomDeclarationElement(cssDomDocument, propertyDeclaration: node, styleDeclarationElement: styleDeclarationElement) {
                    
                    assert(declarationElement.localName == §CSSElementType.Declaration)

                    return CSSDOMNodeInfo(node: declarationElement)
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    public func postVisit(_ node: CSDeclaration) {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            // on top of the stack we are supposed to have a PseudoElementType.Declaration
            // we will need to extract the ::property-value-block and append before the last semi-colon
            // the ::important-declaration
            if let declarationElement = parentNodeInfo.node as? CSSDOMElement, declarationElement.localName == §CSSElementType.Declaration {
                
                // ERROR HANDLING
                if declarationElement.descendantElementsHasErrors || declarationElement.hasErrors() {
                    declarationElement.addMessage(MessageCode.invalidDeclaration, args: [node.cssText().firstLine])
                }
            }
        }
    }
    
    public func visit(_ node: InvalidDeclaration) -> NodeInfo? {
        
        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            if let styleDeclarationElement = parentNodeInfo.node as? CSSDOMElement, styleDeclarationElement.localName == §CSSElementType.StyleDeclaration {
                
                assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration)

                if let declarationElement = cssDomElementFactory.createCssDomInvalidDeclarationElement(cssDomDocument, invalidDeclaration: node, styleDeclarationElement: styleDeclarationElement) {
                    
                    assert(declarationElement.localName == §CSSElementType.InvalidDeclaration)
                    
                    return CSSDOMNodeInfo(node: declarationElement)
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    
    //                                property-value-block
    //                                         |
    //         ________________________________|______________________________________________________
    //        /                                |                           |                          \
    //       /                                 |                           |                           \
    // css-token.colon                  property-value        important-declaration        css-token.semi-colon
    //
    //
    //                               important-declaration
    //                                         |
    //                      ___________________|____________________
    //                     /                                        \
    //                    /                                          \
    //             css-token.delim-token                  css-token.ident-token
    
    public func visit(_ node: CSImportantDeclaration) -> NodeInfo? {

        #if DEBUG
        validateSourceStringSegment(node)
        #endif
        
        let top = self.top()
        
        assert(top != nil)
        if let parentNodeInfo = top {
            
            // on top of the stack we are supposed to have a PseudoElementType.Declaration
            // we will need to extract the ::property-value-block and append before the last semi-colon
            // the ::important-declaration
            if let declarationElement = parentNodeInfo.node as? CSSDOMElement, declarationElement.localName == §CSSElementType.Declaration {
                
                let propertyValueBlockElement: CSSDOMElement = declarationElement.lastChild as! CSSDOMElement
                
                assert(propertyValueBlockElement.localName == §CSSElementType.PropertyValueBlock)
                
                // Must be in front of the semi-colon
                if let lastChildElement = propertyValueBlockElement.lastChild as? CSSDOMTokenElement {
                    
                    assert(lastChildElement.tokenClass == TokenClassType.SemicolonToken)
                    
                    let importantDeclarationElement = cssDomElementFactory.createCssDomImportantDeclarationElement(cssDomDocument, propertyValueBlockElement: propertyValueBlockElement, importantDeclaration: node)!
                    
                    assert(importantDeclarationElement.localName == §CSSElementType.ImportantDeclaration)
                    
                    return CSSDOMNodeInfo(node: importantDeclarationElement)
                }
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("top() parentNodeInfo is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        assert(false, "Error while compiling stylesheet")
        return CSSDOMNodeInfo(node: nil, visitChildren: false)
    }
    
    func validateSourceStringSegment(_ node: CSSOMLanguageObject) {
        
        #if DEBUG
        let sourceStringSegment = node.sourceStringSegment
        
        // in the case of a stylesheet without rules the sourceStringSegment
        // could be nil
        if !(node is CSSStyleSheet) {
            assert(sourceStringSegment != nil)
        }
        
        if let sourceStringSegment = sourceStringSegment {
            assert(sourceStringSegment.startIndex >= 0)
            assert(sourceStringSegment.startIndex <= sourceStringSegment.endIndex)
        }
        #endif
    }
    
    
}

