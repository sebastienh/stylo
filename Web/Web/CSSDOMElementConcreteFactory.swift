 //
//  CSSDOMElementConcreteFactory.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSDOMElementConcreteFactory {
    
    /// Singleton instance.
    static var shared = CSSDOMElementConcreteFactory()
    
    fileprivate init() {
        
    }
    
    func createCssDomDocument() -> CSSDOMDocument? {

        return CSSDOMDocument.Create()
    }

    func createCssDomStyleSheet(_ cssDomDocument: CSSDOMDocument, cssStyleSheet: CSSStyleSheet) -> CSSDOMElement? {
        
        // create the CSSDOMStyleSheet which acts as the
        // documentElement
        cssDomDocument.styleSheet.sourceStringFragment = cssStyleSheet.sourceStringFragment
        cssStyleSheet.updateCorrespondingCssDomElement(cssDomDocument.styleSheet)
        return cssDomDocument.styleSheet
    }
    
    
    /*
    
                                   wqname_prefix
                                    /            \
                                   /              \
    css-token.<delim-token>|<ident-token>   css-token.delim-token
    
    */
    func createCssDomWQNamePrefixElement(_ cssDomDocument: CSSDOMDocument?, wqNamePrefix: WQNamePrefix, parentElement: CSSDOMElement, beforeElement: CSSDOMElement) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let wqnamePrefixElement = buildCssDomElement(wqNamePrefix.sourceStringSegment!, cssElemenType: CSSElementType.WQNameSelectorPrefix, classeNames: nil, document: cssDomDocument)
        
        parentElement.insertBefore(wqnamePrefixElement, before: beforeElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        if let wqnamePrefixToken = wqNamePrefix.namespacePrefix {
        
            let wqnamePrefixTokenElement = CSSDOMTokenElement(segment: wqnamePrefixToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.tokenClassFromTokenId(CSTokenId(rawValue: wqnamePrefixToken.tokenId)!), textValue: wqnamePrefixToken.stringRepresentation)
        
            for additionnalClass in wqnamePrefixToken.cssTokenAdditionalApplicableDomClasses {
            
                wqnamePrefixTokenElement.addClassAttribute(additionnalClass)
            }
        
            assert(!(wqnamePrefixElement is CSSDOMTokenElement))
            wqnamePrefixElement.appendChild(wqnamePrefixTokenElement, exception: &exception)
        
            if exception.logIfError() {
                return nil
            }
        }
        
        let wqnamePrefixEndSeparatorToken = wqNamePrefix.endSeparator
        
        let wqnamePrefixSeparatorTokenElement = CSSDOMTokenElement(segment: wqnamePrefixEndSeparatorToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.tokenClassFromTokenId(CSTokenId(rawValue: wqnamePrefixEndSeparatorToken.tokenId)!), textValue: wqnamePrefixEndSeparatorToken.stringRepresentation)
        
        assert(!(wqnamePrefixElement is CSSDOMTokenElement))
        wqnamePrefixElement.appendChild(wqnamePrefixSeparatorTokenElement, exception: &exception)

        if exception.logIfError() {
            return nil
        }
        
        return wqnamePrefixElement
    }
    
    /*
    
                                css-style-sheet
                                        |
                 _______________________|________________________
                /                       |                        \
               / 						|		 				  \
        css-style-rule		            *                      css-style-rule
    
    */
    func createCssDomStyleRuleElement(_ cssDomDocument: CSSDOMDocument?, cssStyleRule: CSSStyleRule, containerNode: ContainerNode, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        let styleRuleElement = buildCssDomElement(cssStyleRule.sourceStringSegment!, cssElemenType: CSSElementType.StyleRule, classeNames: nil, document: cssDomDocument)
        
        cssStyleRule.updateCorrespondingCssDomElement(styleRuleElement)
        
        if let beforeElement = beforeElement {
            containerNode.insertBefore(styleRuleElement, before: beforeElement, exception: &exception)
        }
        else {
            containerNode.appendChild(styleRuleElement, exception: &exception)
        }
        
        if exception.logIfError() {
            return nil
        }
        return styleRuleElement
    }
    
    func createCssDomStyleRuleElement(_ cssDomDocument: CSSDOMDocument?, cssStyleRule: CSSStyleRule, documentFragment: DocumentFragment, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let styleRuleElement = buildCssDomElement(cssStyleRule.sourceStringSegment!, cssElemenType: CSSElementType.StyleRule, classeNames: nil, document: cssDomDocument)
        
        cssStyleRule.updateCorrespondingCssDomElement(styleRuleElement)
        
        if let beforeElement = beforeElement {
            documentFragment.insertBefore(styleRuleElement, before: beforeElement, exception: &exception)
        }
        else {
            documentFragment.appendChild(styleRuleElement, exception: &exception)
        }
        
        if exception.logIfError() {
            return nil
        }
        return styleRuleElement
    }
    
    func createCssDomUnrecognizedRuleElement(_ cssDomDocument: CSSDOMDocument?, unrecognizedAtRule: UnrecognizedAtRule, containerNode: ContainerNode, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {
    
        var exception = Exception()
        
        let unrecognizedRuleSourceStringSegment = unrecognizedAtRule.sourceStringSegment//SourceStringSegment(startIndex: unrecognizedAtRule.sourceStringSegment!.startIndex, endIndex: unrecognizedAtRule.endSemiColon?.sourceStringSegment!.endIndex)
        
        let unrecognizedRuleElement = buildCssDomElement(unrecognizedRuleSourceStringSegment, cssElemenType: CSSElementType.UnrecognizedAtRule, classeNames: [§CSSDOMCommonClassType.AtRule], document: cssDomDocument)
        
        unrecognizedRuleElement.addMessages(unrecognizedAtRule.allMessages)
        
        if let beforeElement = beforeElement {
            containerNode.insertBefore(unrecognizedRuleElement, before: beforeElement, exception: &exception)
        }
        else {
            containerNode.appendChild(unrecognizedRuleElement, exception: &exception)
        }
        
        unrecognizedAtRule.updateCorrespondingCssDomElement(unrecognizedRuleElement)
        
        handleComponentsList(cssDomDocument, componentValuesList: unrecognizedAtRule.componentValuesList, parent: unrecognizedRuleElement, addError: false)
        
        if let endSemiColon = unrecognizedAtRule.endSemiColon {
            
            let commaTokenElement = CSSDOMTokenElement(segment: endSemiColon.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.CommaToken, textValue: endSemiColon.stringRepresentation)
            
            assert(!(unrecognizedRuleElement is CSSDOMTokenElement))
            unrecognizedRuleElement.appendChild(commaTokenElement, exception: &exception)
        }
        
        return unrecognizedRuleElement
    }
        
    /*
 
                                    css-namespace-rule.at-rule
                                                |
                                                |
                    ----------------------------------------------------------------
                  /				   |				       |						 \
                 /				   |				       |						  \
        at-rule-name		 namespace-prefix		 namespace-uri		     css-token.semi-colon
                |                  |                       |
                |                  |				       |
    css-token.at-keyword-token	css-token.ident-token	css-token.(url-token|string-token)
    
    */
    func createCssDomNamespaceRuleElement(_ cssDomDocument: CSSDOMDocument?, namespaceRule: CSSNamespaceRule, containerNode: ContainerNode, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {

        var exception = Exception()
        
        /////// css-namespace-rule
        let namespaceRuleElement = buildCssDomElement(namespaceRule.sourceStringSegment, cssElemenType: CSSElementType.NamespaceRule, classeNames: [§CSSDOMCommonClassType.AtRule], document: cssDomDocument)
        
        namespaceRule.updateCorrespondingCssDomElement(namespaceRuleElement)
        
        namespaceRuleElement.addMessages(namespaceRule.allMessages)
        
        if let beforeElement = beforeElement {
            containerNode.insertBefore(namespaceRuleElement, before: beforeElement, exception: &exception)
        }
        else {
            containerNode.appendChild(namespaceRuleElement, exception: &exception)
        }
        
        if exception.logIfError() {
            return nil
        }
        
        /////// at-rule-name
        
        let atRuleNameElement = buildCssDomElement(namespaceRule.sourceStringSegment!, cssElemenType: CSSElementType.AtRuleName, classeNames: nil, document: cssDomDocument)
        
        namespaceRuleElement.appendChild(atRuleNameElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let atKeywordTokenElement = CSSDOMTokenElement(segment: namespaceRule.atKeywordToken!.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.AtKeywordToken, textValue: namespaceRule.atKeywordToken!.stringRepresentation)
        
        assert(!(atRuleNameElement is CSSDOMTokenElement))
        atRuleNameElement.appendChild(atKeywordTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        /////// css-token.semi-colon
        if let endSemiColon = namespaceRule.endSemiColon {
            
            let tokenElement = CSSDOMTokenElement(segment: endSemiColon.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColon.stringRepresentation)
            
            assert(!(namespaceRuleElement is CSSDOMTokenElement))
            namespaceRuleElement.appendChild(tokenElement, exception: &exception)
        }
        return namespaceRuleElement
    }
    
    /*
        see above: createCssDomNamespaceRuleElement(...)
    */
    func createCssDomNamespacePrefixElement(_ cssDomDocument: CSSDOMDocument?, namespacePrefix: CSSNamespacePrefix, namespaceRuleElement: CSSDOMElement, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        
        /////// prefix
        let namespacePrefixElement = buildCssDomElement(namespacePrefix.sourceStringSegment!, cssElemenType: CSSElementType.NamespacePrefix, classeNames: nil, document: cssDomDocument)
        
        namespacePrefix.updateCorrespondingCssDomElement(namespacePrefixElement)
        
        if let beforeElement = beforeElement {
            namespaceRuleElement.insertBefore(namespacePrefixElement, before: beforeElement, exception: &exception)
        }
        else {
            namespaceRuleElement.appendChild(namespacePrefixElement, exception: &exception)
        }
        
        if exception.logIfError() {
            return nil
        }
        
        let tokenElement = CSSDOMTokenElement(segment: namespacePrefix.tokenValue.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: namespacePrefix.tokenValue.stringRepresentation)
        
        assert(!(namespacePrefixElement is CSSDOMTokenElement))
        namespacePrefixElement.appendChild(tokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        return namespacePrefixElement
    }
    
    /*
    see above: createCssDomNamespaceRuleElement(...)
    */
    func createCssDomNamespaceUriElement(_ cssDomDocument: CSSDOMDocument?, namespaceUri: CSSNamespaceURI, namespaceRuleElement: CSSDOMElement, beforeElement: CSSDOMElement? = nil) -> CSSDOMElement? {
        
        var exception = Exception()
        
        /////// naemespace-uri
        let namespaceUriElement = buildCssDomElement(namespaceUri.sourceStringSegment!, cssElemenType: CSSElementType.NamespaceURI, classeNames: nil, document: cssDomDocument)
        
        namespaceUri.updateCorrespondingCssDomElement(namespaceUriElement)
        
        if let beforeElement = beforeElement {
            namespaceRuleElement.insertBefore(namespaceUriElement, before: beforeElement, exception: &exception)
        }
        else {
            namespaceRuleElement.appendChild(namespaceUriElement, exception: &exception)
        }
        
        if exception.logIfError() {
            return nil
        }
        
        let tokenElement = CSSDOMTokenElement(segment: namespaceUri.tokenValue!.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: namespaceUri.tokenValue!.stringRepresentation)
        
        assert(!(namespaceUriElement is CSSDOMTokenElement))
        namespaceUriElement.appendChild(tokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        return namespaceUriElement
    }
    
    
    /*
                                  css-style-rule
                                        |
                            ____________|____________
                           /                         \
                          /						      \
                   selector-list			     style-declaration
    
    */
    func createCssDomSelectorListElement(_ cssDomDocument: CSSDOMDocument?, selectorList: SelectorList, styleRule: CSSDOMElement) -> CSSDOMElement? {
        
        assert(styleRule.localName == §CSSElementType.StyleRule, "styleRule.localName != §CSSElementType.StyleRule")
        
        var exception = Exception()
        
        let selectorListElement = buildCssDomElement(selectorList.sourceStringSegment, cssElemenType: CSSElementType.SelectorList, classeNames: nil, document: cssDomDocument)
        
        styleRule.appendChild(selectorListElement, exception: &exception)
            
        if exception.logIfError() {
            return nil
        }

        selectorList.updateCorrespondingCssDomElement(selectorListElement)
        return selectorListElement
    }
    
    
    /*
    
                                  selector-list
                                        |
                 _______________________|_________________________
                /                       |         			       \
               /						|						    \
         complex-selector		[css-token.comma                complex-selector]*
    
    */
    func createCssDomComplexSelectorElement(_ cssDomDocument: CSSDOMDocument?, complexeSelector: ComplexSelector, selectorListElement: CSSDOMElement) -> CSSDOMElement? {
        
        assert(selectorListElement.localName == §CSSElementType.SelectorList, "selectorListElement.localName != §CSSElementType.SelectorList")
        
        var exception = Exception()
        
        if let precedingCommaToken = complexeSelector.precedingCommaToken {
            
            let tokenElement = CSSDOMTokenElement(segment: precedingCommaToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.CommaToken, textValue: precedingCommaToken.stringRepresentation)
            
            assert(!(selectorListElement is CSSDOMTokenElement))
            selectorListElement.appendChild(tokenElement, exception: &exception)
        }
        
        // the complexe selector could be empty
        if complexeSelector.compoundSelectorList.count != 0 {
        
            let complexSelectorElement = buildCssDomElement(complexeSelector.sourceStringSegment!, cssElemenType: CSSElementType.ComplexSelector, classeNames: nil, document: cssDomDocument)
        
            selectorListElement.appendChild(complexSelectorElement, exception: &exception)
        
            if exception.logIfError() {
                return nil
            }
        
            complexeSelector.updateCorrespondingCssDomElement(complexSelectorElement)
            return complexSelectorElement
        }
        
        return nil
    }
    
    
    func createCssDomInvalidComplexSelectorElement(_ cssDomDocument: CSSDOMDocument?, invalidComplexSelector: InvalidComplexSelector, selectorListElement: CSSDOMElement) -> CSSDOMElement? {
        
        assert(selectorListElement.localName == §CSSElementType.SelectorList, "selectorListElement.localName != §CSSElementType.SelectorList")
        
        var exception = Exception()
        
        if let precedingCommaToken = invalidComplexSelector.precedingCommaToken {
            
            let tokenElement = CSSDOMTokenElement(segment: precedingCommaToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.CommaToken, textValue: precedingCommaToken.stringRepresentation)
            
            assert(!(selectorListElement is CSSDOMTokenElement))
            selectorListElement.appendChild(tokenElement, exception: &exception)
        }
        
        
        let sourceStringSegment = invalidComplexSelector.sourceStringSegment
        
        assert(sourceStringSegment != nil)
        if let sourceStringSegment = sourceStringSegment {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
            #endif
            
            let invalidComplexSelectorElement = buildCssDomElement(sourceStringSegment, cssElemenType: CSSElementType.InvalidComplexSelector, classeNames: nil, document: cssDomDocument)
            
            var exception = Exception()
            
            selectorListElement.appendChild(invalidComplexSelectorElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            invalidComplexSelector.updateCorrespondingCssDomElement(invalidComplexSelectorElement)
            return invalidComplexSelectorElement
        }
        return nil
    }
    
    
 
    /*
  
                                  complex-selector
                                        |
                 _______________________|_______________________________________________________________
                /                       |                                              |                \
               / 						|                                              |                 \
     compound-selector			 [ <selector-combinator>                        compound-selector ]       *
     */
    func createCssDomCompoundSelectorElement(_ cssDomDocument: CSSDOMDocument?, compoundSelector: CompoundSelector, complexeSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(complexeSelectorElement.localName == §CSSElementType.ComplexSelector, "complexeSelectorElement.localName != §CSSElementType.ComplexSelector")
        
        let compoundSelectorElement = buildCssDomElement(compoundSelector.sourceStringSegment!, cssElemenType: CSSElementType.CompoundSelector, classeNames: nil, document: cssDomDocument)
        
        var exception = Exception()
        
        complexeSelectorElement.appendChild(compoundSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        compoundSelector.updateCorrespondingCssDomElement(compoundSelectorElement)
        return compoundSelectorElement
    }
    
    func createCssDomInvalidCompoundSelectorElement(_ cssDomDocument: CSSDOMDocument?, invalidCompoundSelector: InvalidCompoundSelector, complexeSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(complexeSelectorElement.localName == §CSSElementType.ComplexSelector, "complexeSelectorElement.localName != §CSSElementType.ComplexSelector")
        
        let sourceStringSegment = invalidCompoundSelector.sourceStringSegment
        
        assert(sourceStringSegment != nil)
        if let sourceStringSegment = sourceStringSegment {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
            #endif
            
            let invalidCompoundSelectorElement = buildCssDomElement(sourceStringSegment, cssElemenType: CSSElementType.InvalidCompoundSelector, classeNames: nil, document: cssDomDocument)
            
            var exception = Exception()
            
            complexeSelectorElement.appendChild(invalidCompoundSelectorElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            invalidCompoundSelector.updateCorrespondingCssDomElement(invalidCompoundSelectorElement)
            return invalidCompoundSelectorElement
        }
        return nil
    }
    
    /*
                                 complex-selector
                                        |
                 _______________________|_______________________________________________________________
                /                       |                                              |                \
               / 						|                                              |                 \
     compound-selector			 [ <selector-combinator>                       compound-selector ]       *

    */
    func createCssDomSelectorCombinatorElement(_ cssDomDocument: CSSDOMDocument?, selectorCombinator: SelectorCombinator, complexeSelectorElement: CSSDOMElement!) -> CSSDOMElement? {
        
        assert(complexeSelectorElement.localName == §CSSElementType.ComplexSelector, "complexeSelectorElement.localName != §CSSElementType.ComplexSelector")
        
        var exception = Exception()
        
        let selectorCombinatorTypeClass: SelectorCombinatorClass
        
        #if DEBUG
        if selectorCombinator.combinatorType != .Whitespace {
            assert(selectorCombinator.tokenCount != 0, "selectorCombinator.tokenCount == 0.")
        }
        #endif
            
        switch selectorCombinator.combinatorType {
            
        case .DoubleGreaterSign:
            
            selectorCombinatorTypeClass = SelectorCombinatorClass.DescendantSelectorCombinator
            
        case .GreaterThanSign:
            
            selectorCombinatorTypeClass = SelectorCombinatorClass.ChildSelectorCombinator
            
        case .PlusSign:
            
            selectorCombinatorTypeClass = SelectorCombinatorClass.NextSiblingSelectorCombinator
            
        case .Tilde:
            
            selectorCombinatorTypeClass = SelectorCombinatorClass.FollowingSiblingSelectorCombinator
            
        case .Whitespace:
            
            selectorCombinatorTypeClass = SelectorCombinatorClass.DescendantSelectorCombinator
        }
        
        let selectorCombinatorElement = buildCssDomElement(selectorCombinator.sourceStringSegment!, cssElemenType: CSSElementType.SelectorCombinator, classeNames: [§selectorCombinatorTypeClass], document: cssDomDocument)
        
        
        selectorCombinatorElement.addMessages(selectorCombinator.allMessages)
        complexeSelectorElement.appendChild(selectorCombinatorElement, exception: &exception)
        
        selectorCombinator.updateCorrespondingCssDomElement(selectorCombinatorElement)
        
        for tokenIndex in 0..<selectorCombinator.tokenCount {
            
            let csToken: Token = selectorCombinator[tokenIndex]
            
            assert(csToken.tokenId == §CSTokenId.delimToken || csToken.tokenId == §CSTokenId.whitespaceToken, "csToken.tokenId != §CSTokenId.DelimToken && §CSTokenId.WhitespaceToken")
            
            let tokenClassType: TokenClassType
            
            if csToken.tokenId == §CSTokenId.delimToken {
                tokenClassType = TokenClassType.DelimToken
            }
            else {
                
                assert(csToken.tokenId == §CSTokenId.whitespaceToken, "csToken.tokenId != §CSTokenId.WhitespaceToken")
                tokenClassType = TokenClassType.WhitespaceToken
            }
            
            let tokenElement = CSSDOMTokenElement(segment: csToken.sourceStringSegment, document: cssDomDocument, tokenClass: tokenClassType, textValue: csToken.stringRepresentation)
            
            // additional class may be added by the token itself, for example to specify
            // the character "tilde", "plus-sign", since they could be all delim-token
            for additionnalClass in csToken.cssTokenAdditionalApplicableDomClasses {
            
                tokenElement.addClassAttribute(additionnalClass)
            }
            
            assert(!(selectorCombinatorElement is CSSDOMTokenElement))
            selectorCombinatorElement.appendChild(tokenElement, exception: &exception)
        }
        return selectorCombinatorElement
    }
    
    
    /*

                       type-selector.simple-selector
                       /                      |
                      /                       |
                wqname_prefix              element-name
                   /                          |
                  /                           |
css-token.<delim-token>|<ident-token>    css-token.ident-token.<element-name>
    
    
                                   OR
    
    
              type-selector.simple-selector.universal-selector
                   /                            |
                  /                             |
            wqname_prefix                 element-name
                /                               |
               /                                |
   css-token.<delim-token>|<ident-token>  css-token.delim-token.*
    

    */
    func createCssDomTypeSelectorElement(_ cssDomDocument: CSSDOMDocument?, typeSelector: TypeSelector, compoundSelectorElement: CSSDOMElement! ) -> CSSDOMElement? {

        assert(compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector, "compoundSelectorElement.localName != §CSSElementType.CompoundSelector")
        
        var exception = Exception()
        
        let typeSelectorElement = buildCssDomElement(typeSelector.sourceStringSegment!, cssElemenType: CSSElementType.TypeSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        compoundSelectorElement.appendChild(typeSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            
            return nil
        }
        
        typeSelector.updateCorrespondingCssDomElement(typeSelectorElement)
        
        let elementNameElement = buildCssDomElement(typeSelector.sourceStringSegment!, cssElemenType: CSSElementType.ElementName, classeNames: nil, document: cssDomDocument)
        
        assert(!(typeSelectorElement is CSSDOMTokenElement))
        typeSelectorElement.appendChild(elementNameElement, exception: &exception)
        
        if exception.logIfError() {
            
            return nil
        }
        
        // handle the universal selector
        switch typeSelector.selectorType {
            
        case .generic:
            
            let tokenElement = CSSDOMTokenElement(segment: typeSelector.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.DelimToken, textValue: "*")
            tokenElement.addClassAttribute("*")
            
            typeSelectorElement.addClassAttribute(§CSSDOMCommonClassType.UniversalSelector)
            
            assert(!(elementNameElement is CSSDOMTokenElement))
            elementNameElement.appendChild(tokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
        case .tag(let string):
            
            let tokenElement = CSSDOMTokenElement(segment: typeSelector.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: string)
            
            // Add the .<raw-string-value> class to the css-token
            tokenElement.addClassAttribute(string)
            
            assert(!(elementNameElement is CSSDOMTokenElement))
            elementNameElement.appendChild(tokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
        default:
            
            assert(false)
        }
        return typeSelectorElement
    }
    
    /*

                                            pseudo-element-selector.simple-selector
                                                                |
                                     ___________________________|________________________
                                    /                           |         			     \
                                   /				     		|						  \
                        css-token.colon-token         css-token.colon-token       css-token.ident-token.<raw-string-value>
    
    */
    func createCssDomPseudoElementSelectorElement(_ cssDomDocument: CSSDOMDocument?, pseudoElementSelector: PseudoElementSelector, compoundSelectorElement: CSSDOMElement! ) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let pseudoElementSelectorElement = buildCssDomElement(pseudoElementSelector.sourceStringSegment!, cssElemenType: CSSElementType.PseudoElementSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        compoundSelectorElement.appendChild(pseudoElementSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        pseudoElementSelector.updateCorrespondingCssDomElement(pseudoElementSelectorElement)

        let firstColonToken = CSSDOMTokenElement(segment: pseudoElementSelector.firstColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.ColonToken, textValue: pseudoElementSelector.firstColonToken.stringRepresentation)
        
        assert(!(pseudoElementSelectorElement is CSSDOMTokenElement))
        pseudoElementSelectorElement.appendChild(firstColonToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let secondColonToken = CSSDOMTokenElement(segment: pseudoElementSelector.secondColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.ColonToken, textValue: pseudoElementSelector.secondColonToken.stringRepresentation)
        
        assert(!(pseudoElementSelectorElement is CSSDOMTokenElement))
        pseudoElementSelectorElement.appendChild(secondColonToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let pseudoElementIdentToken = CSSDOMTokenElement(segment: pseudoElementSelector.ident.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: pseudoElementSelector.ident.identString)
        
        pseudoElementIdentToken.addClassAttribute(pseudoElementSelector.ident.identString)
        
        pseudoElementIdentToken.addMessages(pseudoElementSelector.allMessages)
        
        assert(!(pseudoElementSelectorElement is CSSDOMTokenElement))
        pseudoElementSelectorElement.appendChild(pseudoElementIdentToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        return pseudoElementSelectorElement
    }
    
    /*

                                              pseudo-class-selector.simple-selector
                                                                |
                                                    ____________|____________
                                                   /                         \
                                                  /						      \
                                    css-token.colon-token		css-token.ident-token.<raw-string-value>
    
    */
    func createCssDomPseudoClassSelectorElement(_ cssDomDocument: CSSDOMDocument?, pseudoClass: PseudoClass, parentElement: CSSDOMElement! ) -> CSSDOMElement? {
        
        assert(parentElement.localName == §CSSElementType.CompoundSelector || parentElement.localName == §CSSElementType.InvalidCompoundSelector, "parentElement.localName != §CSSElementType.CompoundSelector")
        
        var exception = Exception()
        
        let pseudoClassSelectorElement = buildCssDomElement(pseudoClass.sourceStringSegment!, cssElemenType: CSSElementType.PseudoClassSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        parentElement.appendChild(pseudoClassSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        pseudoClass.updateCorrespondingCssDomElement(pseudoClassSelectorElement)
        
        let firstColonToken = CSSDOMTokenElement(segment: pseudoClass.firstColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.ColonToken, textValue: ":")
        
        assert(!(pseudoClassSelectorElement is CSSDOMTokenElement))
        pseudoClassSelectorElement.appendChild(firstColonToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let classIdentToken = CSSDOMTokenElement(segment: pseudoClass.classIdentToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: pseudoClass.classIdentToken.stringRepresentation)
        
        classIdentToken.addClassAttribute(pseudoClass.classIdentToken.stringRepresentation)
        
        assert(!(pseudoClassSelectorElement is CSSDOMTokenElement))
        pseudoClassSelectorElement.appendChild(classIdentToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        return pseudoClassSelectorElement
    }
    
    /*

                                                class-selector.simple-selector
                                                                |
                                                    ____________|____________
                                                   /                         \
                                                  /						      \
                                    css-token.delim-token           css-token.ident-token.<raw-string-value>
    
    */
    func createCssDomClassSelectorElement(_ cssDomDocument: CSSDOMDocument?, classSelector: ClassSelector, compoundSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector, "compoundSelectorElement.localName != §CSSElementType.CompoundSelector")
        
        var exception = Exception()
        
        let classSelectorElement = buildCssDomElement(classSelector.sourceStringSegment!, cssElemenType: CSSElementType.ClassSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        compoundSelectorElement.appendChild(classSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        classSelector.updateCorrespondingCssDomElement(classSelectorElement)
        
        let dotDelimToken = CSSDOMTokenElement(segment: classSelector.dotDelimToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.DelimToken, textValue: ".")

        assert(!(classSelectorElement is CSSDOMTokenElement))
        classSelectorElement.appendChild(dotDelimToken, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let identTokenElement = CSSDOMTokenElement(segment: classSelector.ident.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: classSelector.ident.rawIdent)
        
        identTokenElement.addClassAttribute(classSelector.ident.rawIdent)
        
        assert(!(classSelectorElement is CSSDOMTokenElement))
        classSelectorElement.appendChild(identTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        return classSelectorElement
    }
    
    /*

                                                    id-selector.simple-selector
                                                                |
                                                                |
                                            css-token.hash-token.<formatted-string-value>

    */
    func createCssDomIdSelectorElement(_ cssDomDocument: CSSDOMDocument?, idSelector: IdSelector, compoundSelectorElement: CSSDOMElement! ) -> CSSDOMElement? {
        
        assert(compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector, "compoundSelectorElement.localName != §CSSElementType.CompoundSelector")
        
        var exception = Exception()
        
        let idSelectorElement = buildCssDomElement(idSelector.sourceStringSegment!, cssElemenType: CSSElementType.IdSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        compoundSelectorElement.appendChild(idSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        idSelector.updateCorrespondingCssDomElement(idSelectorElement)
        
        let hashTokenElement = CSSDOMTokenElement(segment: idSelector.hashToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.HashToken, textValue: idSelector.hashString)
        
        // This call should return the formatted string if it is present of the raw string otherwise
        hashTokenElement.addClassAttribute(idSelector.hashString)
        
        assert(!(idSelectorElement is CSSDOMTokenElement))
        idSelectorElement.appendChild(hashTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        return idSelectorElement
    }
    
    
    /*
                                                 attribute-selector.simple-selector
                                                                |
                               _________________________________|______________________________
                              /                                 |         			           \
                             /       				     		|						        \
            css-token.left-square-bracket-token         attribute-name     css-token.right-square-bracket-token
    
    
                                                                OR
    
                                                        attribute-selector.simple-selector
                                                                        |
            ____________________________________________________________|__________________________________________________________________________
           /                                        |         			|        				|				       |                           \
          /        				     		        |	 				|	        			|				       |                            \
    css-token.left-square-bracket-token     attribute-name        attribute-match	      attrib-value	 		attrib-flags    css-token.right-square-bracket-token
    
    */
    func createCssDomAttributeSelectorElement(_ cssDomDocument: CSSDOMDocument?, attribSelector: AttribSelector, compoundSelectorElement: CSSDOMElement! ) -> CSSDOMElement? {
        
        assert(compoundSelectorElement.localName == §CSSElementType.CompoundSelector || compoundSelectorElement.localName == §CSSElementType.InvalidCompoundSelector, "compoundSelectorElement.localName != §CSSElementType.CompoundSelector")
        
        var exception = Exception()
        
        let attribSelectorElement = buildCssDomElement(attribSelector.sourceStringSegment!, cssElemenType: CSSElementType.AttributeSelector, classeNames: [§CSSDOMCommonClassType.SimpleSelector], document: cssDomDocument)
        
        compoundSelectorElement.appendChild(attribSelectorElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        attribSelector.updateCorrespondingCssDomElement(attribSelectorElement)
        
        let leftSquareBraquetTokenElement = CSSDOMTokenElement(segment: attribSelector.leftSquareBracketToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.LeftSquareBraquetToken, textValue:  "[")
        
        assert(!(attribSelectorElement is CSSDOMTokenElement))
        attribSelectorElement.appendChild(leftSquareBraquetTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        let rightSquareBraquetTokenElement = CSSDOMTokenElement(segment: attribSelector.rightSquareBraquetToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.RightSquareBraquetToken, textValue: "]")
        
        assert(!(attribSelectorElement is CSSDOMTokenElement))
        attribSelectorElement.appendChild(rightSquareBraquetTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        return attribSelectorElement
    }
    
    
    /*

    
                                                              attrib-name
                                                                  |
                                                                  |
                                              css-token.ident-token.<raw-string-value>
    
    */
    func createCssDomAttributeNameSelectorElement(_ cssDomDocument: CSSDOMDocument?, attribName: AttribName, attribSelectorElement: CSSDOMElement) -> CSSDOMElement? {
        
        assert(attribSelectorElement.localName == §CSSElementType.AttributeSelector, "attribSelectorElement.localName != §CSSElementType.AttributeSelector")
        
        var exception = Exception()
        
        let attribNameSelectorElement = buildCssDomElement(attribName.sourceStringSegment!, cssElemenType: CSSElementType.AttributeName, classeNames: nil, document: cssDomDocument)
        
        // Could be in front of right square braquet
        if let lastChildElement = attribSelectorElement.lastChild as? CSSDOMTokenElement {
            
            assert(lastChildElement.tokenClass == TokenClassType.RightSquareBraquetToken, "associatedElement.tokenClass != TokenClassType.RightSquareBraquetToken")
            
            attribSelectorElement.insertBefore(attribNameSelectorElement, before: lastChildElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
            attribName.updateCorrespondingCssDomElement(attribNameSelectorElement)
            
            let identTokenElement = CSSDOMTokenElement(segment: attribName.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: attribName.ident!.identString)

            // FIXME: make sure that ident will always be non-nil.
            identTokenElement.addClassAttribute(attribName.ident!.identString)
            
            assert(!(attribNameSelectorElement is CSSDOMTokenElement))
            attribNameSelectorElement.appendChild(identTokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        else if let _ = attribSelectorElement.lastChild as? CSSDOMElement {
            assert(false, "Error: verify that we are not in front of an attrib-match.")
            
        } else {
            
            assert(false, "Error: we are not in front of a right square braquet.")
        }
        return attribNameSelectorElement
    }
    
    /*
    
    l. Exact Match
    
                          attrib-match
                                |
                                |
                    css-token.exact-match-token
    
    l. Prefix Match
    
                          attrib-match
                                |
                                |
                    css-token.prefix-match-token
    
    l. Suffix Match
    
                          attrib-match
                                |
                                |
                    css-token.sufix-match-token
    
    l. Substring Match
    
                          attrib-match
                                |
                                |
                    css-token.substring-match-token
    
    l. Include Match
    
                          attrib-match
                                |
                                |
                    css-token.include-match-token
    
    l. Dash Match
    
                          attrib-match
                                |
                                |
                    css-token.dash-match-token
    
    */
    func createCssDomAttributeMatchSelectorElement(_ cssDomDocument: CSSDOMDocument?, attribMatch: AttribMatch, attribSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(attribSelectorElement.localName == §CSSElementType.AttributeSelector, "attribSelectorElement.localName != §CSSElementType.AttributeSelector")
        
        var exception = Exception()
        
        let attribMatchSelectorElement = buildCssDomElement(attribMatch.sourceStringSegment!, cssElemenType: CSSElementType.AttributeMatch, classeNames: nil, document: cssDomDocument)
    
        
        // Could be in front of right square braquet
        if let lastChildElement = attribSelectorElement.lastChild as? CSSDOMTokenElement {
        
            assert(lastChildElement.tokenClass == TokenClassType.RightSquareBraquetToken, "associatedElement.tokenClass != TokenClassType.RightSquareBraquetToken")
            
            attribSelectorElement.insertBefore(attribMatchSelectorElement, before: lastChildElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
            attribMatch.updateCorrespondingCssDomElement(attribMatchSelectorElement)
            
            let matchTokenElement = CSSDOMTokenElement(segment: attribMatch.sourceStringSegment!, document: cssDomDocument, tokenClass: attribMatch.matchType.tokenClassTypeValue, textValue: attribMatch.selectorText)
            
            assert(!(attribMatchSelectorElement is CSSDOMTokenElement))
            attribMatchSelectorElement.appendChild(matchTokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        return attribMatchSelectorElement
    }
    
    /*
    
                              attribute-value
                                    |
                                    |
                    css-token.string-token.<string-value>
    
                                    OR
    
                              attribute-value
                                    |
                                    |
                css-token.ident-token.<ident-string-value>
    
    
    */
    func createCssDomAttributeValueSelectorElement(_ cssDomDocument: CSSDOMDocument?, attribValue: AttribValue, attribSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(attribSelectorElement.localName == §CSSElementType.AttributeSelector, "attribSelectorElement.localName != §CSSElementType.AttributeSelector")
        
        var exception = Exception()
        
        let attribValueSelectorElement = buildCssDomElement(attribValue.sourceStringSegment!, cssElemenType: CSSElementType.AttributeValue, classeNames: nil, document: cssDomDocument)

        
        // Could be in front of right square braquet
        if let lastChildElement = attribSelectorElement.lastChild as? CSSDOMTokenElement {
                
            assert(lastChildElement.tokenClass == TokenClassType.RightSquareBraquetToken, "lastChildElement.tokenClass != TokenClassType.RightSquareBraquetToken")
            
            attribSelectorElement.insertBefore(attribValueSelectorElement, before: lastChildElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
            attribValue.updateCorrespondingCssDomElement(attribValueSelectorElement)

            var valueToken: CSSDOMTokenElement!
            
            if let _ = attribValue.string {
                
                valueToken = CSSDOMTokenElement(segment: attribValue.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.StringToken, textValue: attribValue.stringValue!)
                
                valueToken.addClassAttribute(attribValue.stringValue!)
            }
            else if let _ = attribValue.ident {
                
                valueToken = CSSDOMTokenElement(segment: attribValue.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: attribValue.stringValue!)
                
                valueToken.addClassAttribute(attribValue.stringValue!)
            }
            
            assert(!(attribValueSelectorElement is CSSDOMTokenElement))
            attribValueSelectorElement.appendChild(valueToken, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        return attribValueSelectorElement
    }
    
    
    /*

                              attribute-flags
                                    |
                                    |
                        css-token.ident-token.<ident-string-value>

    */
    func createCssDomAttributeFlagsSelectorElement(_ cssDomDocument: CSSDOMDocument?, attribFlags: AttribFlags, attribSelectorElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(attribSelectorElement.localName == §CSSElementType.AttributeSelector, "attribSelectorElement.localName != §CSSElementType.AttributeSelector")
        
        var exception = Exception()
        
        let attribFlagsSelectorElement = buildCssDomElement(attribFlags.sourceStringSegment!, cssElemenType: CSSElementType.AttributeFlags, classeNames: nil, document: cssDomDocument)
        
        // Could be in front of right square braquet
        if let lastChildElement = attribSelectorElement.lastChild as? CSSDOMTokenElement {
            
            assert(lastChildElement.tokenClass == TokenClassType.RightSquareBraquetToken, "lastChildElement.tokenClass != TokenClassType.RightSquareBraquetToken")
            
            attribSelectorElement.insertBefore(attribFlagsSelectorElement, before: lastChildElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
            attribFlags.updateCorrespondingCssDomElement(attribFlagsSelectorElement)
            
            let identTokenElement = CSSDOMTokenElement(segment: attribFlags.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.IdentToken, textValue: attribFlags.ident.identString)
            
            identTokenElement.addClassAttribute(attribFlags.ident.identString)
        
            assert(!(attribFlagsSelectorElement is CSSDOMTokenElement))
            attribFlagsSelectorElement.appendChild(identTokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        return attribFlagsSelectorElement
    }
    
    /*

                                              css-style-rule
                                                    |
                                        ____________|____________
                                       /                         \
                                      /						      \
                                selector-list			  style-declaration-block
    
    
                                         style-declaration-block
                                                    |
                    ________________________________|______________________________
                   /                                |                              \
                  / 								|					     		\
      css-token.left-curly-brace		  style-declaration         css-token.right-curly-brace
    
    
                                           style-declaration
                                                    |
                             _______________________|_________________________
                            /                       |         			      \
                           /						|						   \
                  css-declaration		            *                    css-declaration

    */
    func createCssDomStyleDeclarationElement(_ cssDomDocument: CSSDOMDocument?, styleDeclaration: CSSStyleDeclaration, styleRuleElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(styleRuleElement.localName == §CSSElementType.StyleRule, "styleRuleElement.localName != §CSSElementType.StyleRule")
        
        var exception = Exception()
            
        // create and add the style-declaration-block element
        
        // since the CSSStyleDeclaration sourcestringsegment comprise the block inside without considering
        // the braces, we need to compute the brace. 
        let completeStyleDeclarationSegment = styleDeclaration.sourceStringSegment!
        
        let styleDeclarationBlockElement = buildCssDomElement(completeStyleDeclarationSegment, cssElemenType: CSSElementType.StyleDeclarationBlock, classeNames: nil, document: cssDomDocument)
        
        styleRuleElement.appendChild(styleDeclarationBlockElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        styleDeclaration.updateCorrespondingCssDomElement(styleDeclarationBlockElement)
        
        // add the left curly brace
        let leftCurlyBraceTokenElement = CSSDOMTokenElement(segment: styleDeclaration.leftCurlyBrace.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.LeftCurlyBraceToken, textValue: styleDeclaration.leftCurlyBrace.stringRepresentation)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("leftCurlyBraceTokenElement segment: %@", log: Log.Web.all, type: .info, %%leftCurlyBraceTokenElement.sourceStringSegment!)
        #endif
        
        assert(!(styleDeclarationBlockElement is CSSDOMTokenElement))
        styleDeclarationBlockElement.appendChild(leftCurlyBraceTokenElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        // add the style declaration
        
        let styleDeclarationElement = buildCssDomElement(styleDeclaration.sourceStringSegment!, cssElemenType: CSSElementType.StyleDeclaration, classeNames: nil, document: cssDomDocument)
        
        styleDeclarationBlockElement.appendChild(styleDeclarationElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        // add the right curly brace
        if let rightCurlyBrace = styleDeclaration.rightCurlyBrace {
        
            let rightCurlyBraceTokenElement = CSSDOMTokenElement(segment: rightCurlyBrace.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.RightCurlyBraceToken, textValue: rightCurlyBrace.stringRepresentation)
        
            assert(!(styleDeclarationBlockElement is CSSDOMTokenElement))
            styleDeclarationBlockElement.appendChild(rightCurlyBraceTokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        return styleDeclarationElement
    }
    
    func createCssDomIgnoredBlockElement(_ cssDomDocument: CSSDOMDocument?, ignoredBlock: IgnoredSimpleBlock, styleDeclarationElement: CSSDOMElement) -> CSSDOMElement? {
        
        assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration, "styleDeclarationElement.localName != §CSSElementType.StyleDeclaration")
        
        return handleSimpleBlock(cssDomDocument, simpleBlock: ignoredBlock.value.value, parent: styleDeclarationElement)
    }
    
    /*
                                               style-declaration
                                                        |
                                 _______________________|_________________________
                                /                       |         			      \
                               /						|						   \
                     css-declaration		            *                   css-declaration
    
    
    
                                                 css-declaration
                                                        |
                                            ____________|____________
                                           /                         \
                                          /						      \
                                 property-name               property-value-block
    
    
    
                                                  property-name
                                                        |
                                                        |
                                      css-token.string-token.<string-value>
    
    
    
                                              property-value-block
                                                        |
                        ________________________________|__________________________________________________
                       /                                |                       |                          \
                      / 								|						|	                        \
            css-token.colon			             property-value    important-declaration[0..1]      css-token.semi-colon
    
    
    
    */
    func createCssDomDeclarationElement(_ cssDomDocument: CSSDOMDocument?, propertyDeclaration: CSDeclaration, styleDeclarationElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration, "styleDeclarationElement.localName != §CSSElementType.StyleDeclaration")
        
        var exception = Exception()
        
        // root ::css-declaration element node
        let cssDeclarationElement = createDeclarationElement(cssDomDocument, propertyDeclaration: propertyDeclaration)
    
        styleDeclarationElement.appendChild(cssDeclarationElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        propertyDeclaration.updateCorrespondingCssDomElement(cssDeclarationElement)
        
        // ::property-name subtree
        let propertyNameElement = createPropertyNameElementSubtree(cssDomDocument, propertyDeclaration: propertyDeclaration)
        
        cssDeclarationElement.append(propertyNameElement, exception: &exception)
        
        // // ::property-value-block subtree
        
        if let propertyValueSourceStringSegment = propertyDeclaration.propertyValueSourceStringSegment {
        
            let propertyValueBlockElement = buildCssDomElement(propertyValueSourceStringSegment, cssElemenType: CSSElementType.PropertyValueBlock, classeNames: nil, document: cssDomDocument)
            
            cssDeclarationElement.append(propertyValueBlockElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
            
            if let colonToken = propertyDeclaration.colonToken {
        
                // handle the start colon and end semi-colon tokens
                // add the colon token
                let colonTokenElement = CSSDOMTokenElement(segment: colonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.ColonToken, textValue: colonToken.stringRepresentation)
                
                assert(!(propertyValueBlockElement is CSSDOMTokenElement))
                propertyValueBlockElement.appendChild(colonTokenElement, exception: &exception)
                
                if exception.logIfError() {
                    return nil
                }
                
                // components value list handling
                if propertyDeclaration.hasPropertyValuePart() {
                    
                    let parentPropertyValueElement = CSSDOMElement(segment: propertyDeclaration.propertyValueComponentValueList.extractPositionFromComponents(), document: cssDomDocument, localName: §CSSElementType.PropertyValue)
                    
                    propertyValueBlockElement.append(parentPropertyValueElement, exception: &exception)
                    
                    if exception.isError() {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error while adding ::property-value to ::property-value-block.", log: Log.Web.all, type: .error)
                        #endif
                    }
                    
                    // end semi-colon token handling
                    if let endSemiColonToken = propertyDeclaration.endSemiColonToken {
                    
                        // add the semi-colon token
                        let semiColonTokenElement = CSSDOMTokenElement(segment: endSemiColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColonToken.stringRepresentation)
                    
                        assert(!(propertyValueBlockElement is CSSDOMTokenElement))
                        propertyValueBlockElement.appendChild(semiColonTokenElement, exception: &exception)
                        
                        if exception.logIfError() {
                            return nil
                        }
                    }
                    
                    // ::property-value subtree
                    CSSPropertyEvaluator.parsePropertyValueToDOM(propertyDeclaration, parentPropertyValueElement: parentPropertyValueElement )
                }
                // end semi-colon token handling
                else if let endSemiColonToken = propertyDeclaration.endSemiColonToken {
                        
                    // add the semi-colon token
                    let semiColonTokenElement = CSSDOMTokenElement(segment: endSemiColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColonToken.stringRepresentation)
                    
                    assert(!(propertyValueBlockElement is CSSDOMTokenElement))
                    propertyValueBlockElement.appendChild(semiColonTokenElement, exception: &exception)
                    
                    if exception.logIfError() {
                        return nil
                    }
                }
            }
            // end semi-colon token handling
            else if let endSemiColonToken = propertyDeclaration.endSemiColonToken {
                
                // handle malformed declaration
                let unsupportedPorpertyParser = CSSDOMUnsupportedPropertyParser(componentValueArray: propertyDeclaration.preservedDeclarationCompleteComponentValueList, parentPropertyElement: cssDeclarationElement)
                
                unsupportedPorpertyParser.parseUnsupportedDeclarationAfterNameToDOM()
                
                // add the semi-colon token
                let semiColonTokenElement = CSSDOMTokenElement(segment: endSemiColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColonToken.stringRepresentation)
                
                assert(!(propertyValueBlockElement is CSSDOMTokenElement))
                propertyValueBlockElement.appendChild(semiColonTokenElement, exception: &exception)
                
                if exception.logIfError() {
                    return nil
                }
            }
        }
        else {
            
            // handle malformed declaration
            let unsupportedPorpertyParser = CSSDOMUnsupportedPropertyParser(componentValueArray: propertyDeclaration.preservedDeclarationCompleteComponentValueList, parentPropertyElement: cssDeclarationElement)
            
            unsupportedPorpertyParser.parseUnsupportedDeclarationAfterNameToDOM()
            
            // end semi-colon token handling
            if let endSemiColonToken = propertyDeclaration.endSemiColonToken {
                
                // add the semi-colon token
                let semiColonTokenElement = CSSDOMTokenElement(segment: endSemiColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColonToken.stringRepresentation)
                
                assert(!(cssDeclarationElement is CSSDOMTokenElement))
                cssDeclarationElement.appendChild(semiColonTokenElement, exception: &exception)
                
                if exception.logIfError() {
                    return nil
                }
            }
        }
        
        return cssDeclarationElement
    }
    
    func createCssDomInvalidDeclarationElement(_ cssDomDocument: CSSDOMDocument?, invalidDeclaration: InvalidDeclaration, styleDeclarationElement: CSSDOMElement ) -> CSSDOMElement? {
        
        assert(styleDeclarationElement.localName == §CSSElementType.StyleDeclaration, "styleDeclarationElement.localName != §CSSElementType.StyleDeclaration")
        
        var exception = Exception()
 
        // css-declaration element
        var invalidDeclarationElement = buildCssDomElement(invalidDeclaration.sourceStringSegment!, cssElemenType: CSSElementType.InvalidDeclaration, classeNames: nil, document: cssDomDocument)
        
        styleDeclarationElement.appendChild(invalidDeclarationElement, exception: &exception)
        
        if exception.logIfError() {
            return nil
        }
        
        invalidDeclarationElement.addMessages(invalidDeclaration.allMessages)
        
        invalidDeclaration.updateCorrespondingCssDomElement(invalidDeclarationElement)
        
        // handle malformed declaration
        let unsupportedPorpertyParser = CSSDOMUnsupportedPropertyParser(componentValueArray: invalidDeclaration.preservedDeclarationCompleteComponentValueList, parentPropertyElement: invalidDeclarationElement)
        
        unsupportedPorpertyParser.parseUnsupportedPropertyValueToDOM()
        
        // end semi-colon token handling
        if let endSemiColonToken = invalidDeclaration.endSemiColonToken {
            
            // add the semi-colon token
            let semiColonTokenElement = CSSDOMTokenElement(segment: endSemiColonToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.SemicolonToken, textValue: endSemiColonToken.stringRepresentation)
            
            assert(!(invalidDeclarationElement is CSSDOMTokenElement))
            invalidDeclarationElement.appendChild(semiColonTokenElement, exception: &exception)
            
            if exception.logIfError() {
                return nil
            }
        }
        
        return invalidDeclarationElement
    }
    
    
    /*
    
                                       property-value-block
                                                |
                ________________________________|______________________________________________________
               /                                |                           | 						   \
              / 								|							|	 						\
        css-token.colon			  		 property-value        important-declaration	    css-token.semi-colon
    
    
                                      important-declaration
                                                |
                             ___________________|____________________
                            / 										 \
                           /	  									  \
                    css-token.delim-token 				   css-token.ident-token
    
    */
    func createCssDomImportantDeclarationElement(_ cssDomDocument: CSSDOMDocument?, propertyValueBlockElement: CSSDOMElement, importantDeclaration: CSImportantDeclaration ) -> CSSDOMElement? {
        
        assert(propertyValueBlockElement.localName == §CSSElementType.PropertyValueBlock, "propertyValueBlockElement.localName != §CSSElementType.PropertyValueBlock")
        
        var exception = Exception()
        
        if let importantDeclarationPosition = importantDeclaration.sourceStringSegment {
        
            // create the important declaration element
            let importantDeclarationElement = buildCssDomElement(importantDeclarationPosition, cssElemenType: CSSElementType.ImportantDeclaration, classeNames: nil, document: cssDomDocument)
            
            // Must be in front of the semi-colon
            if let lastChildElement = propertyValueBlockElement.lastChild as? CSSDOMTokenElement {
                    
                assert(lastChildElement.tokenClass == TokenClassType.SemicolonToken, "lastChildElement.tokenClass != TokenClassType.SemicolonToken")
        
                propertyValueBlockElement.insertBefore(importantDeclarationElement, before: lastChildElement, exception: &exception)
        
                if exception.logIfError() {
                    return nil
                }
                
                importantDeclaration.updateCorrespondingCssDomElement(importantDeclarationElement)
                
                let apostrophToken = importantDeclaration.apostrophToken!
                
                // TODO:  add the two tokens composing the important declaration
                let apostrophTokenElement = CSSDOMTokenElement(segment: apostrophToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.DelimToken, textValue: apostrophToken.value.stringRepresentation)
                
                assert(!(importantDeclarationElement is CSSDOMTokenElement))
                importantDeclarationElement.appendChild(apostrophTokenElement, exception: &exception)
                
                if exception.logIfError() {
                    return nil
                }
                
                let importantToken = importantDeclaration.importantKeyworkToken!
                
                let importantTokenElement = CSSDOMTokenElement(segment: importantToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.DelimToken, textValue: importantToken.value.stringRepresentation)
                
                assert(!(importantDeclarationElement is CSSDOMTokenElement))
                importantDeclarationElement.appendChild(importantTokenElement, exception: &exception)
                
                if !importantDeclaration.unexpectedTokens.isEmpty {
                
                    for unexpectedToken in importantDeclaration.unexpectedTokens {
                    
                        let unexpectedTokenElement = CSSDOMTokenElement(segment: unexpectedToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.UnexpectedToken, textValue: unexpectedToken.value.stringRepresentation)
                        unexpectedTokenElement.addMessage(MessageCode.unexpectedToken, args: [unexpectedToken.cssText()])
                        
                        assert(!(importantDeclarationElement is CSSDOMTokenElement))
                        importantDeclarationElement.appendChild(unexpectedTokenElement, exception: &exception)
                        exception.logIfError()
                    }
                }
                return importantDeclarationElement
            }
        }
        
        return nil
    }
    
    @discardableResult
    func handleComponentsList(_ cssDomDocument: CSSDOMDocument?, componentValuesList: [CSComponentValue], parent: CSSDOMElement, addError: Bool = true) -> CSSDOMElement? {
        
        var exception = Exception()
        
        for componentValue in componentValuesList {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
            #endif
            
            if let preservedComponentValue = componentValue as? CSPreservedTokenComponentValue {
                
                let tokenElement = CSSDOMTokenElement(segment: preservedComponentValue.sourceStringSegment!, document: cssDomDocument, tokenClass: preservedComponentValue.associatedTokenClass(), textValue: preservedComponentValue.cssText())
                tokenElement.addMessages(preservedComponentValue.allMessages)
                
                if addError {
                    
                    // tokenElement.addMessages(componentValue.allMessages)
                    tokenElement.addMessage(MessageCode.unexpectedToken, args: [preservedComponentValue.cssText()])
                }
                
                assert(!(parent is CSSDOMTokenElement))
                parent.appendChild(tokenElement, exception: &exception)
                exception.logIfError()
            }
            else if let simpleBlockComponentValue = componentValue as? CSSimpleBlockComponentValue {
                
                handleSimpleBlock(cssDomDocument, simpleBlock: simpleBlockComponentValue.value, parent: parent, addError: addError)
            }
            else if let functionComponentValue = componentValue as? CSFunctionComponentValue {
                
                handleFunction(cssDomDocument, function: functionComponentValue.value, parent: parent, addError: addError)
            }
        }
        return parent
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private methods
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @discardableResult
    private func handleSimpleBlock(_ cssDomDocument: CSSDOMDocument?, simpleBlock: CSSimpleBlock, parent: CSSDOMElement, addError: Bool = true) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let ignoredSimpleBlockElement = CSSDOMElement(segment: simpleBlock.sourceStringSegment, document: cssDomDocument, localName: §CSSElementType.IgnoredSimpleBlock)
        
        parent.append(ignoredSimpleBlockElement, exception: &exception)
        
        // add the left curly brace
        let leftCurlyBraceTokenElement = CSSDOMTokenElement(segment: simpleBlock.startToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.LeftCurlyBraceToken, textValue: simpleBlock.startToken.rawStringValue)
        leftCurlyBraceTokenElement.addMessages(simpleBlock.startToken.allMessages)
        
        if addError {
            leftCurlyBraceTokenElement.addMessage(MessageCode.unexpectedToken, args: [simpleBlock.startToken.rawStringValue])
        }
        
        assert(!(ignoredSimpleBlockElement is CSSDOMTokenElement))
        ignoredSimpleBlockElement.appendChild(leftCurlyBraceTokenElement, exception: &exception)
        exception.logIfError()
        
        for componentValue in simpleBlock.componentValueList {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
            #endif
            
            if let preservedComponentValue = componentValue as? CSPreservedTokenComponentValue {
                
                let tokenElement = CSSDOMTokenElement(segment: preservedComponentValue.sourceStringSegment!, document: cssDomDocument, tokenClass: preservedComponentValue.associatedTokenClass(), textValue: preservedComponentValue.cssText())
                tokenElement.addMessages(preservedComponentValue.allMessages)
                
                if addError {
                
                    // tokenElement.addMessages(preservedComponentValue.allMessages)
                    tokenElement.addMessage(MessageCode.unexpectedToken, args: [preservedComponentValue.cssText()])
                }
                
                assert(!(ignoredSimpleBlockElement is CSSDOMTokenElement))
                ignoredSimpleBlockElement.appendChild(tokenElement, exception: &exception)
                exception.logIfError()
            }
            else if let simpleBlockComponentValue = componentValue as? CSSimpleBlockComponentValue {
                
                handleSimpleBlock(cssDomDocument, simpleBlock: simpleBlockComponentValue.value, parent: ignoredSimpleBlockElement, addError: addError)
            }
            else if let functionComponentValue = componentValue as? CSFunctionComponentValue {
                
                handleFunction(cssDomDocument, function: functionComponentValue.value, parent: ignoredSimpleBlockElement, addError: addError)
            }
        }
        
        // add the right curly brace
        if simpleBlock.endToken.tokenId != §CSTokenId.cssEof {
            
            let rightCurlyBraceTokenElement = CSSDOMTokenElement(segment: simpleBlock.endToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.RightCurlyBraceToken, textValue: simpleBlock.endToken.rawStringValue)
        
            rightCurlyBraceTokenElement.addMessages(simpleBlock.endToken.allMessages)
            
            if addError {
                // rightCurlyBraceTokenElement.addMessages(simpleBlock.endToken.allMessages)
                rightCurlyBraceTokenElement.addMessage(MessageCode.unexpectedToken, args: [simpleBlock.endToken.rawStringValue])
            }
            
            assert(!(ignoredSimpleBlockElement is CSSDOMTokenElement))
            ignoredSimpleBlockElement.appendChild(rightCurlyBraceTokenElement, exception: &exception)
        }
        return ignoredSimpleBlockElement
    }
    
    @discardableResult
    private func handleFunction(_ cssDomDocument: CSSDOMDocument?, function: CSFunction, parent: CSSDOMElement, addError: Bool = false) -> CSSDOMElement? {
        
        var exception = Exception()
        
        let functionElement = CSSDOMElement(segment: function.completeSourceStringSegment, document: cssDomDocument, localName: §CSSElementType.Function)
        functionElement.addMessages(function.allMessages)
        
        // add the function name to the function element
        functionElement.addClassAttribute(function.name)
        
        parent.appendChild(functionElement, exception: &exception)
        exception.logIfError()
        
        let functionStartElement = CSSDOMElement(segment: function.sourceStringSegment, document: cssDomDocument, localName: §CSSElementType.FunctionStart)
        
        functionElement.appendChild(functionStartElement, exception: &exception)
        exception.logIfError()
        
        let functionToken = CSSDOMTokenElement(segment: function.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.FunctionToken, textValue: function.name)
        
        if addError {
            functionToken.addMessage(MessageCode.unexpectedToken, args: [function.cssText()])
        }
        
        functionToken.addClassAttribute(function.name)
        
        assert(!(functionStartElement is CSSDOMTokenElement))
        functionStartElement.appendChild(functionToken, exception: &exception)
        exception.logIfError()
        
        for componentValue in function.componentValueList {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component: %@", log: Log.Web.all, type: .info, %%componentValue.cssText())
            #endif
            
            if let preservedToken = componentValue as? CSPreservedTokenComponentValue {
                
                if preservedToken.isTokenId(§CSTokenId.commaToken) {
                    
                    let commaTokenElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.CommaToken, textValue: preservedToken.value.stringRepresentation)
                    commaTokenElement.addMessages(preservedToken.allMessages)
                    
                    if addError {
                        commaTokenElement.addMessage(MessageCode.unexpectedToken, args: [preservedToken.cssText()])
                    }
                    
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(commaTokenElement, exception: &exception)
                }
                else if preservedToken.isTokenId(§CSTokenId.whitespaceToken) {
                    
                    // nothing to do we just jump to the next component
                }
                else {
                    
                    let functionParameterElement = CSSDOMTokenElement(segment: preservedToken.sourceStringSegment!, document: cssDomDocument, tokenClass: preservedToken.associatedTokenClass(), textValue: preservedToken.cssText())
                    functionParameterElement.addMessages(preservedToken.allMessages)
                    
                    if addError {
                        // functionParameterElement.addMessages(preservedToken.allMessages)
                        functionParameterElement.addMessage(MessageCode.unexpectedToken, args: [preservedToken.cssText()])
                    }
                    
                    assert(!(functionElement is CSSDOMTokenElement))
                    functionElement.appendChild(functionParameterElement, exception: &exception)
                    exception.logIfError()
                }
            }
            else if let simpleBlockComponentValue = componentValue as? CSSimpleBlockComponentValue {
                
                handleSimpleBlock(cssDomDocument, simpleBlock: simpleBlockComponentValue.value, parent: functionElement, addError: addError)
            }
            else if let functionComponentValue = componentValue as? CSFunctionComponentValue {
                
                handleFunction(cssDomDocument, function: functionComponentValue.value, parent: functionElement, addError: addError)
            }
        }
        
        // handle the right parenthesis token which has a specific property
        // because we don't want to alter the parding algorythm logic by appending it
        // to the componentValueList
        if let rightParenthesisToken = function.rightParenthesisToken {
            
            let rightParenthesisTokenElement = CSSDOMTokenElement(segment: rightParenthesisToken.sourceStringSegment!, document: cssDomDocument, tokenClass: TokenClassType.RightParenthesisToken, textValue: rightParenthesisToken.stringRepresentation)
            rightParenthesisTokenElement.addMessages(rightParenthesisToken.allMessages)
            
            if addError {
                // rightParenthesisTokenElement.addMessages(rightParenthesisToken.allMessages)
                rightParenthesisTokenElement.addMessage(MessageCode.unexpectedToken, args: [rightParenthesisToken.rawStringValue])
            }
            
            assert(!(functionElement is CSSDOMTokenElement))
            functionElement.appendChild(rightParenthesisTokenElement, exception: &exception)
        }
        
        return functionElement
    }
    
    
    /*

                      property-name
                            |
                            |
            css-token.string-token.<string-value>
    
    */
    fileprivate func createPropertyNameElementSubtree(_ cssDomDocument: CSSDOMDocument?, propertyDeclaration: CSDeclaration) -> CSSDOMElement {
    
        var exception = Exception()
        
        // property-name element
        let propertyNameSegment = propertyDeclaration.propertyNamePreservedTokenComponentValue.sourceStringSegment
        
        let propertyNameElement = buildCssDomElement(propertyNameSegment!, cssElemenType: CSSElementType.PropertyName, classeNames: nil, document: cssDomDocument)
        
        // ::property-name token:
        // css-token.string-token.<string-value>
        let propertyNameTokenElement = CSSDOMTokenElement(segment: propertyNameSegment!, document: cssDomDocument, tokenClass: TokenClassType.StringToken, textValue: propertyDeclaration.propertyNamePreservedTokenComponentValue.value.stringRepresentation)
        
        let propertyName = propertyDeclaration.propertyName
        
        if  !CSSProperty.isCustomProperty(propertyName) && !CSSProperty.isSupportedCSSProperty(propertyName) {
            propertyNameTokenElement.addMessage(MessageCode.unsupportedProperty, args: [propertyName])
        }
        
        propertyNameTokenElement.addClassAttribute(propertyName)
        
        assert(!(propertyNameElement is CSSDOMTokenElement))
        propertyNameElement.appendChild(propertyNameTokenElement, exception: &exception)
        exception.logIfError()
        
        return propertyNameElement
    }
    
    fileprivate func createDeclarationElement(_ cssDomDocument: CSSDOMDocument?, propertyDeclaration: CSDeclaration) -> CSSDOMElement {
        
        // css-declaration element
        let cssDeclarationElement = buildCssDomElement(propertyDeclaration.sourceStringSegment!, cssElemenType: CSSElementType.Declaration, classeNames: nil, document: cssDomDocument)
        
        cssDeclarationElement.addMessages(propertyDeclaration.allMessages)
        
        propertyDeclaration.updateCorrespondingCssDomElement(cssDeclarationElement)
        
        return cssDeclarationElement
    }
    
    fileprivate func buildCssDomElement(_ segment: SourceStringSegment?, cssElemenType: CSSElementType, classeNames: [String]?, document: CSSDOMDocument?) -> CSSDOMElement {
        
        let element = CSSDOMElement(segment: segment, document: document, localName: §cssElemenType)
        
        if let classeNames = classeNames {
            for className in classeNames {
                element.addClassAttribute(className)
            }
        }
        return element
    }
    
}
