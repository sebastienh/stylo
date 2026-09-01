//
//  MarkdownDomRenderer.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-20.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

/// The MarkdownDomRenderer which actually
/// create a DOM with all Markdown specific elements along with
/// real HTML elements, the namespace should be used to style both
/// in the same document.
/// see http://www.w3schools.com/xml/xml_namespaces.asp for a
/// complete description of the namespace feature.
///
///
/// <f:table xmlns:f="http://www.w3schools.com/furniture">
///    <f:name>African Coffee Table</f:name>
///    <f:width>80</f:width>
///    <f:length>120</f:length>
/// </f:table>
///
///
/// The invalids elements are removed from the DOM at the
/// MarkdownHtmlSerialisationOperation phase.
public final class MarkdownDomRenderer<P: ContainerNode>: Renderer {
    
    public typealias ReturnType = P
    
    let parentContainer: P
    
    var options: Options!
    
    /// This property keeps the current parent we should add
    /// chlidren to.
    var currentParentElementStack: Stack<ContainerNode>
    
    var blockTokenStack: Stack<Token>
    
    var hiddenTokensStack: Stack<Token>
    
    var indexesStack: Stack<Int>
    
    var previousToken: Token?
    
    var rootElement: ContainerNode!
    
    var rootChildCounter: Int
    
    var bodySourceStringFragment: SourceStringSegment
    
    var document: Document? {
        if let _document = parentContainer as? Document {
            return _document
        }
        return nil
    }
    
    var htmlDocument: HtmlDocument? {
        if let _document = parentContainer as? HtmlDocument {
            return _document
        }
        return nil
    }
    
    private var levelAttributesBlocs: [Int: [AttributesBloc]]
    
    /// At the end of the rendering, this variable contains all
    /// attributes blocks for all renderer tokens.
    
    public var nodesAttributes: [Node: [String: Set<String>]]
    
    /// This is used because all inline closing tokens have a level
    /// of 0, no matter how deep they are
    private var closeLevelIncreaseFactor = 1
    
    required public init(parentContainer: P, rootChildCounterStart: Int = 0) {
        
        self.parentContainer = parentContainer
        self.currentParentElementStack = Stack<ContainerNode>()
        self.hiddenTokensStack = Stack<Token>()
        self.rootChildCounter = rootChildCounterStart
        self.bodySourceStringFragment = SourceStringSegment(startIndex: 0, endIndex: 0)
        self.levelAttributesBlocs = [Int: [AttributesBloc]]()
        self.blockTokenStack = Stack<Token>()
        self.indexesStack = Stack<Int>()
        self.nodesAttributes = [:]
    }
    
    @discardableResult
    public func render(_ tokens: Tokens, options: Options? = nil, env: Env? = nil) -> ReturnType {
        
        if let options = options {
            self.options = options
        }
        else {
            self.options = Presets.GetDefaultPresets().options
        }
        
        if let htmlDocument = document as? HtmlDocument {
        
            /// The markdown text element becomes the document element of the
            /// MarkdownDomDocument which will be the root of all elements.
            currentParentElementStack.push(htmlDocument.body!)
            rootElement = htmlDocument.body!
        }
        else {
            currentParentElementStack.push(parentContainer)
            rootElement = document
        }
        
        renderTokens(tokens, options: self.options, env: env)
        
        // we need to know what to to when it will
        // be document fragment
        if let rootElement = rootElement as? HTMLBodyElement {
            rootElement.sourceStringFragment = bodySourceStringFragment
        }
        
        return parentContainer
    }
    
    func renderTokens(_ tokens: Tokens, options: Options? = nil, env: Env? = nil) {
        
        self.indexesStack.push(-1)
        
        for (index, token) in tokens.enumerated() {
            
            self.indexesStack.top = index
            
            if token.type == .inline {
                renderInline(token.children, options: options, env: env)
            }
            else {
                renderToken(tokens, index: index, options: options, env: env)
            }
        }
    }
    
    func needToAddLineFeed(_ tokens: Tokens, index: Int, token: Token) -> Bool {
    
        var needLf = false
        
        // Check if we need to add a newline after this tag
        if token.block {
            
            needLf = true
            
            if token.nesting == .opening {
                
                if !tokens.isLast(token) {
                    
                    let nextToken = tokens[index + 1]!
                    
                    if nextToken.type == .inline || nextToken.hidden {
                        // Block-level tag containing an inline tag.
                        needLf = false;
                        
                    } else if (nextToken.nesting == .closing && nextToken.tag == token.tag) {
                        // Opening tag + closing tag of the same type. E.g. `<li></li>`.
                        //
                        needLf = false
                    }
                }
            }
        }
        return needLf
    }
    
    ///
    func renderInline(_ tokens: Tokens, options: Options? = nil, env: Env? = nil) {
        
        closeLevelIncreaseFactor += 1
        self.indexesStack.push(-1)
        
        for (index, _) in tokens.enumerated() {
            
            self.indexesStack.top = index
            renderToken(tokens, index: index, options: options, env: env)
        }
        closeLevelIncreaseFactor -= 1
    }

    ///
    func renderInlineAsText(_ tokens: Tokens, options: Options? = nil, env: Env? = nil) -> String {
        
        var result = ""
        
        for (_, token) in tokens.enumerated() {
            
            if token.type == .text {
                
                result += token.content
            }
            else if token.type == .image {
                
                result += renderInlineAsText(token.children, options: options, env: env)
            }
        }
        
        return result
    }
    
    ///
    func renderInlineAsRegion(_ tokens: Tokens, options: Options? = nil, env: Env? = nil) -> SourceStringRegion {
        
        var result = SourceStringRegion()
        self.indexesStack.push(-1)
        
        for (index, token) in tokens.enumerated() {
            
            self.indexesStack.top = index
            
            if token.type == .text {
                
                if let sourceStringSegment = token.sourceFragment(for: .All)! as? SourceStringSegment {
                
                    result.addSourceStringSegment(sourceStringSegment)
                }
                else if let sourceStringRegion = token.sourceFragment(for: .All)! as? SourceStringRegion {
                 
                    for segment in sourceStringRegion.sourceStringSegments {
                    
                        result.addSourceStringSegment(segment)
                    }
                }
            }
            else if token.type == .image {
                
                result = result + renderInlineAsRegion(token.children, options: options, env: env)
            }
        }
        
        return result
    }
    
    private func collectAttributes(for token: Token) -> [(String, String?)]? {
        
        if token.block {
            return getAttributesAndClearThem(for: token.level)
        }
        else {
            // because the close is one level lower in this case
            // and this is the same for self closing tokens.
            return getAttributesAndClearThem(for: token.level+closeLevelIncreaseFactor)
        }
    }
    
//    private func collectAttributes(for token: Token) -> [(String, String)]? {
//
//        // because the close is one level lower in this case
//        // and this is the same for self closing tokens.
//        let level = token.block ? token.level : token.level+1
//
//        guard let attributesMap = self.getAttributesMap(for: level) else {
//            clearAttributesBlocs(for: level)
//            return nil
//        }
//
//        clearAttributesBlocs(for: level)
//        self.tokensAttributes[token] = attributesMap
//        return getAttributesString(fromAttributesMap: attributesMap)
//    }
    
    ///
    func renderToken(_ tokens: Tokens, index: Int, options: Options? = nil, env: Env? = nil) {
        
        var exception = Exception()
        let token = tokens[index]!
        
        // Update the end index of body.
        // Since all the closing tags does not have sourcestringfragment defined 
        // we need to make sure it is defined first.
        if let endStringIndex = token.endStringIndex {
            bodySourceStringFragment.endIndex = endStringIndex
        }
        
        if (token.block && token.nesting != .closing && index > 0 && tokens[index - 1]!.hidden) {

            // since there is no text node generated for this one we create one
            let text = Text(document: document, data: "\n")
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(text, exception: &exception)
            token.addAssociatedDomNode(text)
        }
        
        var appendNewLineAfterClosingTag = false
        
        if token.block && token.nesting != .opening && !token.hidden {
            
            // to add a line feed after the closing tag, we must 
            // add a text element directly after the current element 
            // in the topElement
            appendNewLineAfterClosingTag = true
        }
        
        var appendNewLineAfterOpeningTag = false
        
        if token.block {
        
            appendNewLineAfterOpeningTag = true
        
            // Check if we need to add a newline after this tag
            if token.nesting == .opening {
                
                if !tokens.isLast(token) {
                    
                    let nextToken = tokens[index + 1]!
                    
                    if nextToken.type == .inline || nextToken.hidden {
                        // Block-level tag containing an inline tag.
                        //
                        appendNewLineAfterOpeningTag = false;
                        
                    } else if (nextToken.nesting == .closing && nextToken.tag == token.tag) {
                        // Opening tag + closing tag of the same type. E.g. `<li></li>`.
                        //
                        appendNewLineAfterOpeningTag = false
                    }
                }
            }
        }
        
        if token.block && token.nesting == .opening && token.type != .attrBlocOpen && token.type != .attrClassesOpen {
            
            self.blockTokenStack.push(token)
        }
        
        // this is all the attributes blocs before
        if token.block && token.nesting == .opening && (token.type == .attrBlocOpen || token.type == .attrClassesOpen) {
            
            var attrBelowToken = false
            if index > 0 {
                if let tokenAbove = tokens[index-1], tokenAbove.type.acceptAttributes && tokenAbove.isTokenLineBelow(token) {
                    attrBelowToken = true
                    token.isLineBelowToken = true
                }
            }
            
            // if token is a line below then the line above must be empty
            // otherwise if the token is not a line below then we continue...
            if (attrBelowToken && token.emptyLineAbove) || !attrBelowToken {
            
                // this is the basic case where we need to add the bloc
                // to the current level
                assert(token.attrsBlocs != nil)
                if let attrsBlocs = token.attrsBlocs {
                
                    // in the case where the previous open was a container block
                    // we must apply the attributes to this bloc, and add these
                    // to the level corresponding to the container bloc
                    if let previousOpenBloc = self.blockTokenStack.top, previousOpenBloc.type == .containerOpen {

                        addAttributesBlocs(attrsBlocs, for: previousOpenBloc.level)
                    }
                    else {

                        addAttributesBlocs(attrsBlocs, for: token.level)
                    }
                }
            }
        }

        // handle the attributes blocs inline when they apply to the enclosing bloc
        if !token.block && token.nesting == .opening && token.type == .attrBlocOpen {
            
            // an inline token can not be below another token,
            // we make sure of that here.......
//            #if DEBUG
//            var attrBelowToken = false
//            if index > 0 {
//                if let tokenAbove = tokens[index-1], tokenAbove.isTokenLineBelow(token) {
//                    attrBelowToken = true
//                    token.isLineBelowToken = true
//                }
//            }
//            assert(!attrBelowToken, "programming error: an inline token can not be below another token")
//            #endif
            
            let previousToken = tokens.nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(index)
            
            if let previousToken = previousToken {
                
                // if the previous token is of type attributes bloc
                // we must add the attributes to the block that
                // will end
                if previousToken.type == .attrBlocOpen || previousToken.type == .text {
                
                    assert(token.attrsBlocs != nil)
                    if let attrsBlocs = token.attrsBlocs {
                        
                        assert(blockTokenStack.top != nil)
                        if let level = blockTokenStack.top?.level {
                        
                            addAttributesBlocs(attrsBlocs, for: level)
                        }
                    }
                }
            }
            else {
                
                assert(token.attrsBlocs != nil)
                if let attrsBlocs = token.attrsBlocs {
                    
                    assert(blockTokenStack.top != nil)
                    if let level = blockTokenStack.top?.level {
                        
                        addAttributesBlocs(attrsBlocs, for: level)
                    }
                }
            }
        }
        
        // handle the attributes inline in the case were they apply
        // to inline elements
        // note: codeInline are selfClosing
        if token.type.acceptInlineAttributes {
            
            // if the next bloc is an attributes bloc we should add it
            // to the attributes for this token
            let nextToken = tokens.nextAttributesBlocSibling(index)
                
            if let nextToken = nextToken {
             
                assert(nextToken.attrsBlocs != nil)
                if let attrsBlocs = nextToken.attrsBlocs {
                    
                    if token.nesting == .opening {
                        assert(self.levelAttributesBlocs[token.level+closeLevelIncreaseFactor-1] == nil)
                        addAttributesBlocs(attrsBlocs, for: token.level+closeLevelIncreaseFactor-1)
                    }
                    else if token.nesting == .selfClosing {
                        assert(self.levelAttributesBlocs[token.level+closeLevelIncreaseFactor] == nil)
                        addAttributesBlocs(attrsBlocs, for: token.level+closeLevelIncreaseFactor)
                    }
                }
            }
        }
        
        // handle the terminator bloc attributes
        // reference handle itself the attributes collection
        if token.block && token.type.acceptAttributes {

            // get the next token on the same level
            let nextStartAttributesBlocToken = tokens.sameLevelAttributesBlocAfter(index)
            
            // if this attributes block is on a the line below this token
            if let nextStartAttributesBlocToken = nextStartAttributesBlocToken {
                
                if token.isTokenLineBelow(nextStartAttributesBlocToken) && !nextStartAttributesBlocToken.emptyLineAbove {
                    
                    nextStartAttributesBlocToken.isLineBelowToken = true
                    
                    assert(nextStartAttributesBlocToken.attrsBlocs != nil)
                    if let attrsBlocs = nextStartAttributesBlocToken.attrsBlocs {
                        addAttributesBlocs(attrsBlocs, for: token.level)
                    }
                }
            }
        }
        
        var attrs: [(String, String?)]? = nil
        
        // handle the attributes
        // we let reference and fence collect their own attributes since
        // they might define inline attributes
        if token.type.acceptAttributes
            && token.type != .reference
            && token.type != .fence {
            attrs = collectAttributes(for: token)
        }
        
        if token.block
            && token.nesting == .closing
            && token.type != .attrBlocClose
            && token.type != .attrClassesClose {
            self.blockTokenStack.pop()
        }
        
        switch token.type {
            
        case .span:
            
            let allFragment = token.sourceFragment(for: .All)
            
            assert(allFragment != nil)
            if let allFragment = allFragment {
                
                let span = HTMLSpanElement(document: document)
                apply(attrs, to: span, except: nil)
                
                span.sourceStringFragment = allFragment
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(span, exception: &exception)
                
                token.addAssociatedDomNode(span)
                
                if let contentFragment = token.sourceFragment(for: .Content) {
                    
                    let text = Text(sourceStringFragment: contentFragment, document: document, data: token.content)
                    span.appendChild(text, exception: &exception)
                    exception.logIfError()
                    token.addAssociatedDomNode(text)
                }
                setPseudoFragment(in: span, from: token, for: .Content)
                setPseudoFragment(in: span, from: token, for: .Tag)
                setNotTextPseudoFragment(in: span, from: token, from: [.Tag])
            }
        case .attrClassesOpen: fallthrough
        case .attrBlocOpen:
            
            assert(token.sourceFragment(for: .All) != nil)
            let attrsBloc = Web.MarkdownElement(fragment: token.sourceFragment(for: .All), document: document, localName: token.tag)
            attrsBloc.isTopLevel = token.level == 0
            
            if token.sourceFragment(for: .Tag) != nil {
                setPseudoFragment(in: attrsBloc, from: token, for: .Tag)
                setNotTextPseudoFragment(in: attrsBloc, from: token, from: [.Tag])
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(attrsBloc, exception: &exception)
            token.addAssociatedDomNode(attrsBloc)
            currentParentElementStack.push(attrsBloc)
            
        case .attrClassesClose: fallthrough
        case .attrBlocClose:
            
            currentParentElementStack.pop()
            
        case .elementNameAttr: fallthrough
        case .classNameAttr: fallthrough
        case .classAttr: fallthrough
        case .idAttr:
            
            assert(token.sourceFragment(for: .All) != nil)
            let attr = Web.MarkdownElement(fragment: token.sourceFragment(for: .All), document: document, localName: token.tag)
            attr.isTopLevel = false
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(attr, exception: &exception)
            token.addAssociatedDomNode(attr)
            
            let text = Text(sourceStringFragment: token.sourceStringFragment, document: document, data: token.content)
            attr.appendChild(text, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(text)
            
            setPseudoFragment(in: attr, from: token, for: .Tag)
            setPseudoFragment(in: attr, from: token, for: .AttributeValue)
            setNotTextPseudoFragment(in: attr, from: token, from: [.Tag])
            
        case .keyValueAttr:
            
            assert(token.sourceFragment(for: .All) != nil)
            let attr = Web.MarkdownElement(fragment: token.sourceFragment(for: .All), document: document, localName: token.tag)
            attr.isTopLevel = false
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(attr, exception: &exception)
            token.addAssociatedDomNode(attr)
            setPseudoFragment(in: attr, from: token, for: .AttributeName)
            setPseudoFragment(in: attr, from: token, for: .AttributeValue)
            setPseudoFragment(in: attr, from: token, for: .Tag)
            setNotTextPseudoFragment(in: attr, from: token, from: [.Tag])
            
            let text = Text(sourceStringFragment: token.sourceStringFragment, document: document, data: token.content)
            attr.appendChild(text, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(text)
            
            
        case .containerOpen:
            
            let attrsContainerBloc = HTMLElement(document: document, localName: token.tag)
            assert(token.sourceFragment(for: .All) != nil)
            attrsContainerBloc.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: attrsContainerBloc, from: token, for: .Tag)
            setNotTextPseudoFragment(in: attrsContainerBloc, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(attrsContainerBloc, exception: &exception)
            token.addAssociatedDomNode(attrsContainerBloc)
            currentParentElementStack.push(attrsContainerBloc)
            
        case .containerClose:
            
            let container = currentParentElementStack.pop()
            apply(attrs, to: container, except: nil)
            
        /// blockquote handling
        case .blockquoteOpen:
            
            let blockQuote = HTMLQuoteElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                blockQuote.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            blockQuote.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: blockQuote, from: token, for: .Tag)
            setNotTextPseudoFragment(in: blockQuote, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(blockQuote, exception: &exception)
            token.addAssociatedDomNode(blockQuote)
            currentParentElementStack.push(blockQuote)
            
        case .blockquoteClose:
            
            let blockElement = currentParentElementStack.pop()
            apply(attrs, to: blockElement, except: nil)
            
            if appendNewLineAfterClosingTag {
            
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .bulletListOpen:
            
            let ulListElement = HTMLUListElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                ulListElement.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            ulListElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(ulListElement, exception: &exception)
            token.addAssociatedDomNode(ulListElement)
            currentParentElementStack.push(ulListElement)
            
        /// bullet list handling
        case .bulletListClose:
            
            let bulletListClose = currentParentElementStack.pop()
            apply(attrs, to: bulletListClose, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .codeBlock: /// code block handling (indented code block) SelfClosing
            
            let pre = HTMLPreElement(document: document)
            pre.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(pre, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(pre)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
            let code = HTMLCodeElement(document: document, isInline: false)
            apply(attrs, to: code, except: nil)
            assert(token.sourceFragment(for: .All) != nil)
            code.sourceStringFragment = token.sourceFragment(for: .All)
            token.addAssociatedDomNode(code)
            pre.appendChild(code, exception: &exception)
            exception.logIfError()
            
            // since there is no text node generated for this one we create one
            let text = Text(sourceStringFragment: token.sourceStringFragment, document: document, data: token.content)
            code.appendChild(text, exception: &exception)
            exception.logIfError()
            
            // for the spec it does not matter if we add a trailing line feed or not
            // but we want to be as conform to CommonMark as possible.
            if !token.content.endsWith("\n") {
            
                // since there is no text node generated for this one we create one
                let newLineText = Text(document: document, data: "\n")
                code.appendChild(newLineText, exception: &exception)
                exception.logIfError()
            }
            else if token.content.endsWith("\n\n") {
                
                text.data = text.data.slice(0, end: text.data.length - 1)!
            }
            
        case .codeInline: /// code block handling
            
            let code = HTMLCodeElement(document: document, isInline: true)
            apply(attrs, to: code, except: nil)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(code, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(code)
            
            // To put back, not implemented yet
            assert(token.sourceFragment(for: .All) != nil)
            code.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: code, from: token, for: .Tag)
            setPseudoFragment(in: code, from: token, for: .Content)
            setNotTextPseudoFragment(in: code, from: token, from: [.Tag])
            
            let text = Text(sourceStringFragment: code.sourceStringFragment, document: document, data: token.content)
            code.appendChild(text, exception: &exception)
            exception.logIfError()

            
        /// emphasis
        case .emClose:
            
            let em = currentParentElementStack.pop()
            apply(attrs, to: em, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .emOpen:
            
            let emOpen = HTMLElement(document: document, localName: "em")
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                emOpen.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(emOpen, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(emOpen)
            
            assert(token.sourceFragment(for: .All) != nil)
            emOpen.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: emOpen, from: token, for: .Tag)
//            setPseudoFragment(in: emOpen, from: token, for: .OpeningTag)
//            setPseudoFragment(in: emOpen, from: token, for: .ClosingTag)
            setNotTextPseudoFragment(in: emOpen, from: token, from: [.Tag])
            currentParentElementStack.push(emOpen)
            
        case .entity:
            
            // nothing to to
            debugPrint("Not rendering entity tokens...")
            
        case .fence:
            
            let pre = HTMLPreElement(document: document)
            pre.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(pre, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(pre)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
            let code = HTMLCodeElement(document: document, isInline: false)
            
            if token.info?.length > 0 {
                code.addClassAttribute("\(options!.langPrefix)\(token.info!.unescapeAll())")
            }
            
            if token.children.length != 0 {
                
                currentParentElementStack.push(code)
                blockTokenStack.push(token)
                // we should have one text child
                renderTokens(token.children, options: options, env: env)
                blockTokenStack.pop()
                currentParentElementStack.pop()
            }
            attrs = collectAttributes(for: token)
            apply(attrs, to: code, except: nil)
            
            assert(token.sourceFragment(for: .All) != nil)
            code.sourceStringFragment = token.sourceFragment(for: .All)
            token.addAssociatedDomNode(code)
            setPseudoFragment(in: code, from: token, for: .Tag)
//            setPseudoFragment(in: code, from: token, for: .OpeningTag)
//            if token.sourceFragment(for: .ClosingTag) != nil {
//                setPseudoFragment(in: code, from: token, for: .ClosingTag)
//            }
            // the .CodeFenceParams is optional
            if token.sourceFragment(for: .Params) != nil {
                setPseudoFragment(in: code, from: token, for: .Params)
            }
            setNotTextPseudoFragment(in: code, from: token, from: [.Tag, .Params])
            
            pre.appendChild(code, exception: &exception)
            exception.logIfError()
            let text = Text(sourceStringFragment: code.sourceStringFragment, document: document, data: token.content)
            code.appendChild(text, exception: &exception)
            exception.logIfError()
            
            // for the spec it does not matter if we add a trailing line feed or not
            // but we want to be as conform to CommonMark as possible.
            if !token.content.endsWith("\n") && !token.content.isEmpty {
                
                // since there is no text node generated for this one we create one
                let newLineText = Text(document: document, data: "\n")
                code.appendChild(newLineText, exception: &exception)
                exception.logIfError()
            }
            
        case .hardbreak:
            
            let br = HTMLBRElement(document: document)
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(br, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(br)

            // since there is no text node generated for this one we create one
            let text = Text(document: document, data: "\n")
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(text, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(text)
            
        case .headingClose:
            
            let heading = currentParentElementStack.pop()
            apply(attrs, to: heading, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .headingOpen:
            
            let headingElement = HTMLHeadingElement(document: document, localName: token.tag)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                headingElement.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            headingElement.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: headingElement, from: token, for: .Tag)
            setNotTextPseudoFragment(in: headingElement, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(headingElement, exception: &exception)
            token.addAssociatedDomNode(headingElement)
            currentParentElementStack.push(headingElement)
            
        case .hr: // self closing
            
            let hrElement = HTMLHRElement(document: document)
            apply(attrs, to: hrElement, except: nil)
            
            assert(token.sourceFragment(for: .All) != nil)
            hrElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(hrElement, exception: &exception)
            token.addAssociatedDomNode(hrElement)
            
            // In case of Hr. element the Markdown parser will not create
            // a Text element for the markup ("----").
            // For the rendering to consider this part of the text
            // we need to add our own Text element.
            let text = Text(document: htmlDocument, data: token.content)
            text.sourceStringFragment = token.sourceFragment(for: .All)
            hrElement.appendChild(text, exception: &exception)
            exception.logIfError()
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .htmlBlock: // Self closing html-block element
            
            assert(token.sourceFragment(for: .All) != nil)
            let fragment = token.sourceFragment(for: .All)
            let markdownElement = Web.MarkdownElement(fragment: fragment, document: htmlDocument, localName: §MarkdownElementType.HtmlBlock)
            markdownElement.isTopLevel = true
            apply(attrs, to: markdownElement, except: nil)
            
            let text = PreservedText(document: htmlDocument, data: token.content)
            text.sourceStringFragment = fragment
            markdownElement.appendChild(text, exception: &exception)
            exception.logIfError()
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(markdownElement, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(markdownElement)
            
        case .htmlInline:
            
            assert(token.sourceFragment(for: .All) != nil)
            let fragment = token.sourceFragment(for: .All)
            let text = PreservedText(document: htmlDocument, data: token.content)
            text.sourceStringFragment = fragment
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(text, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(text)
            
        case .image:
            
            let image = HTMLImageElement(document: document)
            
            if var attrs = token.attrs {
            
                if let srcAttributeIndex = token.attrIndex("src") {
                    
                    (_, image.src) = attrs[srcAttributeIndex]
                    
                    // NW-1486: enable this code to support local image file
    //                if let range = image.src.range(of: Constants.Html.fileUrlScheme){
    //
    //                    let src = image.src.replacingCharacters(in: range, with: Constants.Html.styloUrlScheme)
    //
    //                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
    //                    os_log("Image src: %@", log: Log.Markdown.all, type: .info, %%src)
    //                    #endif
    //                    image.setAttribute("src", value: src, exception: &exception)
    //                }
    //                else {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
                        os_log("Image src: %@", log: Log.Markdown.all, type: .info, %%image.src)
                        #endif
                        image.setAttribute("src", value: image.src, exception: &exception)
    //                }
                    
                    attrs.remove(at: srcAttributeIndex)
                }
                
                let altText = renderInlineAsText(token.children)
                image.setAttribute("alt", value: altText, exception: &exception)
                
                // image.altRegion = renderInlineAsRegion(token.children)
                
                if let titleAttributeIndex = token.attrIndex("title") {
                    
                    let (_, title) = token.attrs![titleAttributeIndex]
                    image.setAttribute("title", value: title, exception: &exception)
                }
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            image.sourceStringFragment = token.sourceFragment(for: .All)
            if token.sourceFragment(for: .Text) != nil {
                setPseudoFragment(in: image, from: token, for: .Text)
            }
            setPseudoFragment(in: image, from: token, for: .Tag)
            if token.sourceFragment(for: .Title) != nil {
                setPseudoFragment(in: image, from: token, for: .Title)
            }
            if token.sourceFragment(for: .Destination) != nil {
                setPseudoFragment(in: image, from: token, for: .Destination)
            }
            if token.sourceFragment(for: .Label) != nil {
                setPseudoFragment(in: image, from: token, for: .Label)
            }
            setNotTextPseudoFragment(in: image, from: token, from: [.Tag, .Destination, .Title])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(image, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(image)
            
            currentParentElementStack.push(image)
            
            if token.children.length != 0 {
            
                // we should have one text child
                renderTokens(token.children, options: options, env: env)
            }
            currentParentElementStack.pop()
            if let attrsBlocs = token.attrsBlocs {
                addAttributesBlocs(attrsBlocs, for: token.level)
            }
            apply(attrs, to: image, except: Set<String>(arrayLiteral: "src", "alt", "title"))
            
        case .inline:
            
            // nothing to do with inline so far.
            break
            
        case .linkClose:
            
            let link = currentParentElementStack.pop()
            apply(attrs, to: link, except: Set<String>(arrayLiteral: "href", "title"))
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .linkOpen:
            
            let link = HTMLAnchorElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                link.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            if let hrefAttributeIndex = token.attrIndex("href") {
            
                (_, link.href) = token.attrs![hrefAttributeIndex]
                link.setAttribute("href", value: link.href, exception: &exception)
            }
            
            if let titleAttributeIndex = token.attrIndex("title") {
            
                let (_, title) = token.attrs![titleAttributeIndex]
                link.setAttribute("title", value: title, exception: &exception)
            }
            
            // link.text = token.conten
            
            assert(token.sourceFragment(for: .All) != nil)
            link.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: link, from: token, for: .Tag)
            if token.sourceFragment(for: .Text) != nil {
                setPseudoFragment(in: link, from: token, for: .Text)
            }
            if token.sourceFragment(for: .Destination) != nil {
                setPseudoFragment(in: link, from: token, for: .Destination)
            }
            
            // link title is optional
            if token.sourceFragment(for: .Title) != nil {
                setPseudoFragment(in: link, from: token, for: .Title)
            }
            
            // link lable is optional
            if token.sourceFragment(for: .Label) != nil {
                setPseudoFragment(in: link, from: token, for: .Label)
            }
            setNotTextPseudoFragment(in: link, from: token, from: [.Tag, .Destination, .Title])
            
            if let attrsBlocs = token.attrsBlocs {
                
                addAttributesBlocs(attrsBlocs, for: token.level)
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(link, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(link)
            currentParentElementStack.push(link)
            
        case .listItemClose:
            
            let item = currentParentElementStack.pop()
            apply(attrs, to: item, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .listItemOpen:
            
            let listItemElement = HTMLLIElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                listItemElement.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            listItemElement.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: listItemElement, from: token, for: .Tag)
            setNotTextPseudoFragment(in: listItemElement, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(listItemElement, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(listItemElement)
            currentParentElementStack.push(listItemElement)
            
        case .orderedListClose:
            
            let list = currentParentElementStack.pop()
            apply(attrs, to: list, except: Set<String>(arrayLiteral: "start"))
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                exception.logIfError()
                token.addAssociatedDomNode(text)
            }
            
        case .orderedListOpen:
            
            let olListElement = HTMLOListElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                olListElement.appendChild(text, exception: &exception)
                exception.logIfError()
            }
            
            if let startAttrIndex = token.attrIndex("start") {
                
                let (_, startString) = token.attrs![startAttrIndex]
                olListElement.start = Int(startString)
                olListElement.setAttribute("start", value: startString, exception: &exception)
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            olListElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(olListElement, exception: &exception)
            exception.logIfError()
            token.addAssociatedDomNode(olListElement)
            currentParentElementStack.push(olListElement)
            
        case .paragraphOpen:
            
            if token.hidden {
                
                // we just push this token on the top of the hiddenElementsStack
                hiddenTokensStack.push(token)
            }
            else {
                
                let paragraphElement = HTMLParagraphElement(document: document)
                
                if appendNewLineAfterOpeningTag {
                    
                    // since there is no text node generated for this one we create one
                    let text = Text(document: document, data: "\n")
                    paragraphElement.appendChild(text, exception: &exception)
                }
                
                assert(token.sourceFragment(for: .All) != nil)
                paragraphElement.sourceStringFragment = token.sourceFragment(for: .All)
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(paragraphElement, exception: &exception)
                token.addAssociatedDomNode(paragraphElement)
                currentParentElementStack.push(paragraphElement)
            }
            
        case .paragraphClose:
            
            if hasHiddenParent(token) {
                
                // if we are hidden we apply the attributes to the current
                // parent. Without poping.
                let parent = currentParentElementStack.top
                apply(attrs, to: parent, except: nil)
                hiddenTokensStack.pop()
            }
            else {
                
                let paragraph = currentParentElementStack.pop()
                apply(attrs, to: paragraph, except: nil)
                
                if appendNewLineAfterClosingTag {
                    
                    // since there is no text node generated for this one we create one
                    let text = Text(document: document, data: "\n")
                    currentParentElementStack.top?.appendChild(text, exception: &exception)
                    exception.logIfError()
                    token.addAssociatedDomNode(text)
                }
            }
            
        case .reference:
            
            let reference = MarkdownElement(fragment: nil, document: htmlDocument, localName: §MarkdownElementType.Reference)
            
            assert(token.sourceFragment(for: .All) != nil)
            reference.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: reference, from: token, for: .Tag)
            setPseudoFragment(in: reference, from: token, for: .Label)
            setPseudoFragment(in: reference, from: token, for: .Destination)
            setPseudoFragment(in: reference, from: token, for: .Title)
            setNotTextPseudoFragment(in: reference, from: token, from: [.Tag, .Label])
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(reference, exception: &exception)
            token.addAssociatedDomNode(reference)
            
            
            if token.children.length != 0 {
                
                currentParentElementStack.push(reference)
                blockTokenStack.push(token)
                // we should have one text child
                renderTokens(token.children, options: options, env: env)
                blockTokenStack.pop()
                currentParentElementStack.pop()
            }
            attrs = collectAttributes(for: token)
            apply(attrs, to: reference, except: nil)
            
        case .softbreak:
            
            if options!.breaks {
                
                
                let br = HTMLBRElement(document: document)
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(br, exception: &exception)
                token.addAssociatedDomNode(br)
                
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            else {
                
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .strikethroughClose:
            
            let strikethrough = currentParentElementStack.pop()
            apply(attrs, to: strikethrough, except: nil)
            
        case .strikethroughOpen:
            
            let strikethrougElement = HTMLElement(document: document, localName: "s")
            
            assert(token.sourceFragment(for: .All) != nil)
            strikethrougElement.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: strikethrougElement, from: token, for: .Tag)
//            setPseudoFragment(in: strikethrougElement, from: token, for: .OpeningTag)
//            setPseudoFragment(in: strikethrougElement, from: token, for: .ClosingTag)
            setNotTextPseudoFragment(in: strikethrougElement, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(strikethrougElement, exception: &exception)
            token.addAssociatedDomNode(strikethrougElement)
            currentParentElementStack.push(strikethrougElement)
            
        case .strongClose:
            
            let strong = currentParentElementStack.pop()
            #if DEBUG
            let element = strong as! Element
            assert(element.localName == "strong")
            #endif
            apply(attrs, to: strong, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .strongOpen:
            
            let strongElement = HTMLElement(document: document, localName: "strong")
            assert(token.sourceFragment(for: .All) != nil)
            strongElement.sourceStringFragment = token.sourceFragment(for: .All)
//            setPseudoFragment(in: strongElement, from: token, for: .OpeningTag)
//            setPseudoFragment(in: strongElement, from: token, for: .ClosingTag)
            setPseudoFragment(in: strongElement, from: token, for: .Tag)
            setNotTextPseudoFragment(in: strongElement, from: token, from: [.Tag])
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(strongElement, exception: &exception)
            token.addAssociatedDomNode(strongElement)
            currentParentElementStack.push(strongElement)
            
        case .tableClose:
            
            let table = currentParentElementStack.pop()
            apply(attrs, to: table, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .tableOpen:
            
            let tableOpenElement = HTMLTableElement(document: document)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableOpenElement.appendChild(text, exception: &exception)
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            tableOpenElement.sourceStringFragment = token.sourceFragment(for: .All)
            setPseudoFragment(in: tableOpenElement, from: token, for: .Tag)
            setNotTextPseudoFragment(in: tableOpenElement, from: token, from: [.Tag])
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableOpenElement, exception: &exception)
            token.addAssociatedDomNode(tableOpenElement)
            currentParentElementStack.push(tableOpenElement)
            
        case .tBodyClose:
            
            let tBody = currentParentElementStack.pop()
            apply(attrs, to: tBody, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .tBodyOpen:
            
            let tableSectionElement = HTMLTableSectionElement(document: document, type: TableSectionType.TBody)
            tableSectionElement.sourceStringFragment = token.sourceFragment(for: .All)
//            assert(tableSectionElement.range != nil)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableSectionElement.appendChild(text, exception: &exception)
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableSectionElement, exception: &exception)
            token.addAssociatedDomNode(tableSectionElement)
            currentParentElementStack.push(tableSectionElement)
            
        case .tdClose:
            
            let td = currentParentElementStack.pop()
            apply(attrs, to: td, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .tdOpen:
            
            let tableDataCellElement = HTMLTableDataCellElement(document: document)
            
            if let attrs = token.attrs {
                for (name, value) in attrs {
                    tableDataCellElement.setAttributeValue(name, value: value)
                }
            }
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableDataCellElement.appendChild(text, exception: &exception)
            }
            
        
            tableDataCellElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableDataCellElement, exception: &exception)
            token.addAssociatedDomNode(tableDataCellElement)
            currentParentElementStack.push(tableDataCellElement)
            
        case .text: /// SelfClosing
            
            /// we use the transformed entities since it is considered best practice
            /// see http://stackoverflow.com/questions/436615/when-should-one-use-html-entities
            let segment = token.sourceFragment(for: .All)
            
            assert(segment != nil)
            if let segment = segment {
            
                let text = Text(sourceStringFragment: segment, document: document, data: token.content)
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .thClose:
            
            let th = currentParentElementStack.pop()
            apply(attrs, to: th, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
            
        case .theadClose:

            let tHead = currentParentElementStack.pop()
            apply(attrs, to: tHead, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }

        case .theadOpen:
            
            let tableSectionElement = HTMLTableSectionElement(document: document, type: TableSectionType.THead)
            tableSectionElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(tableSectionElement.range != nil)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableSectionElement.appendChild(text, exception: &exception)
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableSectionElement, exception: &exception)
            token.addAssociatedDomNode(tableSectionElement)
            currentParentElementStack.push(tableSectionElement)
            
        case .thOpen:
            
            let tableHeaderCellElement = HTMLTableHeaderCellElement(document: document)
            
            if let attrs = token.attrs {
                for (name, value) in attrs {
                    tableHeaderCellElement.setAttributeValue(name, value: value)
                }
            }
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableHeaderCellElement.appendChild(text, exception: &exception)
            }
            
            assert(token.sourceFragment(for: .All) != nil)
            tableHeaderCellElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableHeaderCellElement, exception: &exception)
            token.addAssociatedDomNode(tableHeaderCellElement)
            currentParentElementStack.push(tableHeaderCellElement)
            
        case .trOpen:
            
            let tableRowElement = HTMLTableRowElement(document: document)
            tableRowElement.sourceStringFragment = token.sourceFragment(for: .All)
            assert(tableRowElement.range != nil)
            
            if appendNewLineAfterOpeningTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                tableRowElement.appendChild(text, exception: &exception)
            }
            
            assert(currentParentElementStack.top != nil)
            currentParentElementStack.top?.appendChild(tableRowElement, exception: &exception)
            token.addAssociatedDomNode(tableRowElement)
            currentParentElementStack.push(tableRowElement)
            
        case .trClose:

            let tr = currentParentElementStack.pop()
            apply(attrs, to: tr, except: nil)
            
            if appendNewLineAfterClosingTag {
                
                // since there is no text node generated for this one we create one
                let text = Text(document: document, data: "\n")
                assert(currentParentElementStack.top != nil)
                currentParentElementStack.top?.appendChild(text, exception: &exception)
                token.addAssociatedDomNode(text)
            }
        }
        
        if exception.isError() {
            
            debugPrint("exception: \(exception.code)")
            
            #if DEBUG
                fatalError("")
            #endif
        }
    }
    
    ///
    /// This method checks if the hiddenElementsStack has a corresponding
    /// open element that was hidden.
    ///
    func hasHiddenParent(_ token: Token) -> Bool {
        
        if hiddenTokensStack.count > 0 {
            let hiddenTopToken = hiddenTokensStack.top!
            if hiddenTopToken.tag.hasPrefix(token.tag) {
                return true
            }
        }
        return false
    }
    
    private func apply(_ attrs: [(String, String?)]?, to node: ContainerNode?, except: Set<String>?) {

        if let attrs = attrs {
        
            let element = node as? Element
            
            assert(element != nil)
            if let element = element {
                
                var attributes: [String: Set<String>] = [:]
                
                func addAttribute(_ name: DOMString, value: DOMString?, exception: inout Exception) {
                    
                    if name == "class" {
                        
                        guard let value = value else {
                            assertionFailure("Error: value for class attributes shouln't be nil")
                            return
                        }
                        
                        if attributes["class"] == nil {
                            attributes["class"] = Set<String>()
                        }
                        
                        element.addClassAttributes(value)
                        attributes["class"]?.formUnion(value.split(separator: " ").map({ (substring) -> String in
                            return String(substring)
                        }))
                        
                    }
                    else if name == "id" {
                        
                        // we keep only the last value
                        if let value = value {
                            element.id = value
                            attributes["id"] = Set<String>(value.split(separator: " ").map({ (substring) -> String in
                                return String(substring)
                            }))
                        }
                    }
                    else {
                        
                        if attributes[name] == nil {
                            attributes[name] = Set<String>()
                        }
                        
                        if let value = value {
                            element.setAttribute(name, value: value, exception: &exception)
                            attributes[name]?.formUnion(value.split(separator: " ").map({ (substring) -> String in
                                return String(substring)
                            }))
                            exception.logIfError()
                        }
                        else {
                            let attribute = Attr(localName: name)
                            element.appendAttribute(attribute)
                        }
                    }
                }
                
                var exception = Exception()
                
                for (name, value) in attrs {
                    
                    if let except = except, !except.contains(name) {
                        addAttribute(name, value: value, exception: &exception)
                    }
                    else {
                        addAttribute(name, value: value, exception: &exception)
                    }
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                var attributesString = ""
                
                for (section, values) in attributes {
                    attributesString += section + ": ["
                    for (itemIndex, sectionValue) in values.enumerated() {
                        if itemIndex != values.count-1 {
                            attributesString += ", "
                        }
                        
                        attributesString += sectionValue.stringValue
                    }
                    attributesString += "]\n"
                }
                
                os_log("udpatedValues: %@", log: Log.WriterCommon.all, type: .info, %%attributesString)
                #endif
                
                // update the nodes attributes with all the collected ones
                self.nodesAttributes[element] = attributes
            }
        }
    }
    
    private func setPseudoFragment(in element: Element, from token: Token, for fragmentType: MarkdownSourceFragmentType) {
        
        let fragmentTypeSourceFragment = token.sourceFragment(for: fragmentType)
        
        // no assert here!!!
        if let fragmentTypeSourceFragment = fragmentTypeSourceFragment {
            
            element.setPseudoElementSourceStringFragment(with: §fragmentType, to: fragmentTypeSourceFragment)
        }
    }
    
    private func setNotTextPseudoFragment(in element: Element, from token: Token, from fragmentTypes: [MarkdownSourceFragmentType]) {
    
        var notTextRegion: SourceStringRegion? = SourceStringRegion()
        
        for fragmentType in fragmentTypes {
            if let fragmentTypeSourceFragment = token.sourceFragment(for: fragmentType) {
                notTextRegion = notTextRegion?.merged(with: fragmentTypeSourceFragment)
            }
        }
        
        assert(notTextRegion != nil)
        if let notTextRegion = notTextRegion {
            
            element.setPseudoElementSourceStringFragment(with: §PseudoSelectorType.NotText, to: notTextRegion)
        }
    }
    
    private func clearAttributesBlocs(for level: Int) {
        
        self.levelAttributesBlocs.removeValue(forKey: level)
    }
    
    private func addAttributesBlocs(_ attributesBlocs: [AttributesBloc], for level: Int) {
        
        if self.levelAttributesBlocs[level] == nil {
            self.levelAttributesBlocs[level] = [AttributesBloc]()
        }
        self.levelAttributesBlocs[level]!.append(contentsOf: attributesBlocs)
    }
    
    private func getAttributesAndClearThem(for level: Int) -> [(String, String?)]? {
        
        if let attributesBlocs = self.levelAttributesBlocs[level] {
            
            if attributesBlocs.isEmpty {
                clearAttributesBlocs(for: level)
            }
            else {
                
                let mergedAttributes = self.mergeAttributes(from: attributesBlocs)
                let attributesMap = mergedAttributes.convertToAttributesMap()
                var tokenAttributes = [(String, String?)]()
                
                for attribute in attributesMap {
                    
                    switch attribute.key {
                        
                    case §Attribute.AttributeType.elementName:
                        break
                        
                    case §Attribute.AttributeType.class:
                        
                        let classesString = attribute.value.joined(separator: " ")
                        tokenAttributes.append((§Attribute.AttributeType.class, classesString))
                        
                    case §Attribute.AttributeType.id:
                        
                        let idString = attribute.value.joined(separator: " ")
                        tokenAttributes.append((§Attribute.AttributeType.id, idString))
                        
                    default:
                        
                        let attributeValueString = attribute.value.joined(separator: " ")
                        tokenAttributes.append((attribute.key, attributeValueString))
                    }
                }
                
                tokenAttributes.append((§MarkdownAttributeType.highlight, nil))
                clearAttributesBlocs(for: level)
                return tokenAttributes
            }
        }
        return nil
    }
    
    ///
    /// This method returns the attributes in the form of
    ///
    private func getAttributesMap(for level: Int) -> [String: Set<String>]? {
        
        guard let attributesBlocs = self.levelAttributesBlocs[level] else {
            return nil
        }
        
        guard !attributesBlocs.isEmpty else {
            return nil
        }
        
        let mergedAttributes = self.mergeAttributes(from: attributesBlocs)
        return mergedAttributes.convertToAttributesMap()
    }
    
    private func getAttributesString(fromAttributesMap attributesMap: [String: Set<String>]) -> [(String, String)] {
        
        var tokenAttributes = [(String, String)]()
        
        for attribute in attributesMap {
            
            switch attribute.key {
                
            case §Attribute.AttributeType.elementName:
                break
            case §Attribute.AttributeType.class:
                let classesString = attribute.value.joined(separator: " ")
                tokenAttributes.append((§Attribute.AttributeType.class, classesString))
            case §Attribute.AttributeType.id:
                let idString = attribute.value.joined(separator: " ")
                tokenAttributes.append((§Attribute.AttributeType.id, idString))
            default:
                let attributeValueString = attribute.value.joined(separator: " ")
                tokenAttributes.append((attribute.key, attributeValueString))
            }
        }
        
        tokenAttributes.append((§MarkdownAttributeType.highlight, "true"))
        
        return tokenAttributes
    }
    
    
    private func mergeAttributes(from attributesBlocs: [AttributesBloc]) -> [Attribute] {
        
        var mergedAttributesBlocs = [Attribute]()
        
        for attributesBloc in attributesBlocs {
            mergedAttributesBlocs.append(contentsOf: attributesBloc.attributes)
        }
        return mergedAttributesBlocs
    }
}
