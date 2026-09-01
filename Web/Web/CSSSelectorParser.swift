
//
//  CSSSelectorsLevel3.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/selectors4/
// selector level 4
final class CSSSelectorParser: CSSComponentsParser {
    
    // Supported selectors :
    // E	an element of type E
    // E:first-child	an E element, first child of its parent
    //
    // We pass a list of component value from the prelude of the
    // CSQualifiedRule
    func parseSelector(_ cssStyleRule: CSSRule? = nil) -> SelectorList? {
        
        return parseSelectorList(cssStyleRule)
    }
 
    // selector list parser
    // complex_selector_list
    //      :   complex_selector [ COMMA S* complex_selector ]*
    //      ;
    private func parseSelectorList(_ cssStyleRule: CSSRule?) -> SelectorList? {
        
        let selectorList = SelectorList(parent: cssStyleRule)
        
        if let complexSelector = parseComplexSelector(selectorList) {
            
            selectorList.appendComplexSelector(complexSelector)
            
            // consume all comas until it is not a comma
            // meaning we have reached a new complex selector
            // definition.
            while let commaPreservedToken = parseComma() {
                parseWhitespaces()
                if let complexSelector = parseComplexSelector(selectorList) {
                    complexSelector.precedingCommaToken = commaPreservedToken.value
                    selectorList.appendComplexSelector(complexSelector)
                }
            }
            
            assert(selectorList.selectorArray.first != nil, "firstIndex == nil")
            // setting position in the slector list
            if let firstIndex = selectorList.selectorArray.first?.sourceStringSegment?.startIndex {
                
                if let lastIndex = selectorList.selectorArray.last?.sourceStringSegment?.endIndex {
                    selectorList.sourceStringSegment = SourceStringSegment(startIndex: firstIndex, endIndex: lastIndex)
                }
                else if let lastIndex = selectorList.selectorArray.first?.sourceStringSegment?.endIndex {
                    selectorList.sourceStringSegment = SourceStringSegment(startIndex: firstIndex, endIndex: lastIndex)
                }
            }
            
            // validations list 
            // NW-136
            validateFirstLineAndFirstLetterPseudoElementsAreLast(in: selectorList)
            
            // we have at least one complex selector successfully parsed
            return selectorList
        }
        return nil
    }
    
    // A complex selector is basically a list of compound_selector selectors
    // separated by spaces, or not.
    //
    //  complex_selector
    //      :   compound_selector [ combinator compound_selector ]* S*
    //      ;
    private func parseComplexSelector(_ parentSelectorList: SelectorList) -> ComplexSelector? {

        let complexSelectorStartIndex = currentComponentValueIndex
        
        // if we encounter no whitespaces
        if parseWhitespaces() == nil {
            
            if currentComponentIsSelectorCombinator() {
                
                var currentComponent = self.currentComponentValue()
                assert(currentComponent != nil)
                currentComponent?.addMessage(.missingSelectorBeforeCombinator)
                return parseInvalidComplexSelector(from: complexSelectorStartIndex, selectorList: parentSelectorList)
            }
            else {
                
                let complexSelector = ComplexSelector(sourceStringSegment: nil, parent: parentSelectorList)
                
                let compoundSelectorResult = parseCompoundSelector(complexSelector)
                
                switch compoundSelectorResult {
                    
                case .success(let compoundSelector):
                    
                    let startIndex = compoundSelector.sourceStringSegment!.startIndex
                    var endIndex = compoundSelector.sourceStringSegment!.endIndex
                    
                    complexSelector.addCompoundSelector(compoundSelector)
                    
                    let parseResult = parseCombinatorCompoundSelectorCouples(complexSelector: complexSelector, endIndex: &endIndex)
                    
                    switch parseResult {
                        
                    case .none: fallthrough
                    case .success(_):
                        
                        complexSelector.sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
                        parseWhitespaces()
                        return complexSelector

                    case .failure(_):
                        
                        // There has been an error in the method : parseACompoundSelector
                        // the error message has been added by the method itself
                        // here we just return nil
                        return parseInvalidComplexSelector(from: complexSelectorStartIndex, selectorList: parentSelectorList)
                    }

                case .failure(_):
                    
                    return parseInvalidComplexSelector(from: complexSelectorStartIndex, selectorList: parentSelectorList)
                    
                case .none:
                    break
                }
            }
        }
        os_log("Error, reaching the end of parseComplexSelector: should not happend!", log: Log.Web.all, type: .error)
        return .none
    }
    
    private func parseCombinatorCompoundSelectorCouples(complexSelector: ComplexSelector, endIndex: inout Int) -> ParsingResult<CompoundSelector> {
        
        let parseCombinatorResult = parseCombinator(complexSelector)
        
        switch parseCombinatorResult {
        
        case .success(let (combinator, index)):
            
            endIndex = combinator.sourceStringSegment!.endIndex
            
            // there is a compound selector defined at the right of the combinator
            let linkedCompoundSelectorResult = parseCompoundSelector(complexSelector)
            
            switch linkedCompoundSelectorResult {
                
            case .success(let linkedCompoundSelector):
                
                let sourceStringSegment = linkedCompoundSelector.sourceStringSegment
                
                assert(sourceStringSegment != nil)
                if let sourceStringSegment = sourceStringSegment {
                    endIndex = sourceStringSegment.endIndex
                }
                complexSelector.addCombinator(combinator)
                complexSelector.addCompoundSelector(linkedCompoundSelector)
                return parseCombinatorCompoundSelectorCouples(complexSelector: complexSelector, endIndex: &endIndex)
                
            case .none:
                
                // we put the error on the selector combinator
                // only if it's not a whitespace combinator
                if let index = index {
                    var componentValue = self.componentValueArray[index]
                    componentValue.addMessage(.missingSelectorAfterCombinator)
                    return .failure(.missingSelectorAfterCombinator)
                }
                else {
                    return .none
                }
                
            case .failure(let code):
                
                // there has been a failure somewhere, the called code
                // took care of it
                return .failure(code)
            }
            
        case .failure(let code):
            return .failure(code)
        case .none:
            return .none
        }
    }
    

    // parse a compound selector
    //  compound_selector :
    //          type_selector [ id | class | attrib | pseudo ]*
    //      |   [ id | class | attrib | pseudo ]+
    //      ;
    private func parseCompoundSelector(_ parentComplexSelector: ComplexSelector) -> ParsingResult<CompoundSelector> {
        
        let compoundSelector = CompoundSelector(sourceStringSegment: nil, parent: parentComplexSelector)
        
        var allowEmpty: Bool = false
        
        if let preservedToken = currentComponentValue() {
            
            let startIndex: Int = preservedToken.sourceStringSegment!.startIndex
            var endIndex: Int = preservedToken.sourceStringSegment!.endIndex
            
            let typeSelectorResult = parseTypeSelector(compoundSelector)
            
            switch typeSelectorResult {
                
            case .success(let typeSelector):
                
                compoundSelector.insertSelector(typeSelector)
                endIndex = typeSelector.sourceStringSegment!.endIndex
                
                // we only empty selector list only if we have found 
                // a type_selector
                allowEmpty = true
                
            case .failure(let code):
                return .failure(code)
            case .none:
                break
            }
            
            // If we have parsed a type seletor we are now allowing coma.
            let simpleSelectorListResult = parseIdOrClassOrAttribOrPseudoSelectorList(compoundSelector, complexSelector: parentComplexSelector)
            
            switch simpleSelectorListResult {
                
            case .success(let simpleSelectorList):

                assert(!simpleSelectorList.isEmpty)
                // fill the compound selector with the simple selectors parsed.
                for simpleSelector in simpleSelectorList {
                    
                    compoundSelector.insertSelector(simpleSelector)
                    endIndex = simpleSelector.sourceStringSegment!.endIndex
                }

                compoundSelector.sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
                return .success(compoundSelector)
                
            case .failure(let code):
                return .failure(code)
            case .none:
                
                // if we don't allow empty list because there is no type selector
                // and the list is empty
                if !allowEmpty {
                    
                    // If we had no type selector and the simple selector list
                    // is empty and we are in front of a coma,
                    // we just have nothing to return
                    if currentComponentIsComa() {
                        return .none
                    }
                    else {
                     
                        if var currentComponentValue = currentComponentValue() {
                            currentComponentValue.addMessage(.unexpectedToken, args: [currentComponentValue.cssText()])
                            return .failure(.unexpectedToken)
                        }
                    }
                }
                else {
                    
                    compoundSelector.sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
                    return .success(compoundSelector)
                }
            }
        }
        return .none
    }
    
    // Parse :
    // [ id | class | attrib | pseudo ]*
    // the return value can be an empty array
    private func parseIdOrClassOrAttribOrPseudoSelectorList(_ parentCompoundSelector: CompoundSelector, complexSelector: ComplexSelector) -> ParsingResult<[SimpleSelector]> {
        
        var simpleSelectorList = [SimpleSelector]()
        
        outerLoop: while true {
        
            let idSelectorResult = parseId(parentCompoundSelector)
            
            switch idSelectorResult {
            case .success(let idSelector):
                simpleSelectorList.append(idSelector)
                continue
            case .failure(let code):
                return .failure(code)
            case .none:
                
                let classSelectorResult = parseClass(parentCompoundSelector)
                
                switch classSelectorResult {
                case .success(let classSelector):
                    simpleSelectorList.append(classSelector)
                    continue
                case .failure(let code):
                    return .failure(code)
                case .none:
                    
                    let attributeSelectorResult = parseAttrib(parentCompoundSelector)
                    
                    switch attributeSelectorResult {
                    case .success(let attributeSelector):
                        simpleSelectorList.append(attributeSelector)
                        continue
                    case .failure(let code):
                        return .failure(code)
                    case .none:
                        
                        let pseudoSelectorResult = parsePseudo(parentCompoundSelector)
                            
                        switch pseudoSelectorResult {
                        case .success(let pseudoSelector):
                            simpleSelectorList.append(pseudoSelector)
                            continue
                        case .failure(let code):
                            return .failure(code)
                        case .none:
                            break outerLoop
                        }
                    }
                }
            }
        }
        
        if simpleSelectorList.isEmpty {
            return .none
        }
        
        return ParsingResult.success(simpleSelectorList)
    }
    
    private func currentComponentIsComa() -> Bool {
        
        if let token = currentComponentValue() {
            
            if token.isTokenId(§CSTokenId.commaToken) {
                return true
            }
        }
        return false
    }
    
    private func currentComponentIsSelectorCombinator() -> Bool {
        
        var parsedPositions = 0
        
        parsedPositions += parseWhitespacesWithoutAdvancing()
        
        if let token = componentValueLookahead(with: parsedPositions) {
            
            if token.isTokenId(§CSTokenId.delimToken) {
                
                assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                // we know it is a preserved token since it is a delim token
                // if it is not we should through a fatal error (Log.error)
                if let preservedToken = token as? CSPreservedTokenComponentValue {
                    
                    let stringValue = preservedToken.value.rawStringValue
                    
                    if stringValue == ">" {
                        return true
                    }
                    else if stringValue == "+" {
                        return true
                    }
                    else if stringValue == "~" {
                        return true
                    }
                }
            }
        }
        
        // return true if we have parsed a whitespace
        return parsedPositions > 0
    }
    
    // Combinators in Selectors level 4 include:
    //      whitespace,
    //      “greater-than sign” (U+003E, >),
    //      “plus sign” (U+002B, +),
    //      and “tilde” (U+007E, ~).
    // combinator
    //      /* combinators can be surrounded by whitespace */
    //      : S+ | S* [ '>' | '>>' |'+' | '~' | '/' IDENT '/' ] S*
    //      ;
    private func parseCombinator(_ complexSelector: ComplexSelector) -> ParsingResult<(SelectorCombinator, Int?)> {

        var whitespacePosition: SourceStringSegment?
        
        if let position = parseWhitespaces() {
            
            // at least we have a whitespace combinator
            whitespacePosition = position
        }

        if var token = currentComponentValue() {
        
            // we know it is a preserved token since it is a delim token
            // if it is not we should through a fatal error (Log.error)
            if var preservedToken = token as? CSPreservedTokenComponentValue {
            
                if token.isTokenId(§CSTokenId.delimToken) {
                    
                    assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                    if preservedToken.value.rawStringValue == ">" {
                        
                        let selectorComponentInex = currentComponentValueIndex
                        advanceComponentValueIndex()
                        parseWhitespaces()
                        
                        let selectorCombinator = SelectorCombinator(type: CombinatorType.GreaterThanSign, sourceStringSegment: preservedToken.value.sourceStringSegment, parent: complexSelector)
                        
                        selectorCombinator.addToken(preservedToken.value)
                        return .success((selectorCombinator, selectorComponentInex))
                    }
                    else if preservedToken.value.rawStringValue == "+" {
                        
                        let selectorComponentInex = currentComponentValueIndex
                        advanceComponentValueIndex()
                        parseWhitespaces()
                        
                        let selectorCombinator = SelectorCombinator(type: CombinatorType.PlusSign, sourceStringSegment: preservedToken.value.sourceStringSegment, parent: complexSelector)
                        
                        selectorCombinator.addToken(preservedToken.value)
                        return .success((selectorCombinator, selectorComponentInex))
                    }
                    else if preservedToken.value.rawStringValue == "~" {

                        let selectorComponentInex = currentComponentValueIndex
                        advanceComponentValueIndex()
                        parseWhitespaces()
                        
                        var selectorCombinator = SelectorCombinator(type: CombinatorType.Tilde, sourceStringSegment: preservedToken.value.sourceStringSegment, parent: complexSelector)
                        
                        selectorCombinator.addToken(preservedToken.value)
                        selectorCombinator.addMessage(MessageCode.followingSiblingsSelectorMayImpactPerformance)
                        return .success((selectorCombinator, selectorComponentInex))
                    }
                }
                
                else if whitespacePosition == nil {
                    
                    if preservedToken.value.rawStringValue != "," && preservedToken.value.rawStringValue != "{" {
                        token.addMessage(.unexpectedToken, args: [token.cssText()])
                        return .failure(.unexpectedToken)
                    }
                }
                
            }
            
            if let position = whitespacePosition {
                
                return .success((SelectorCombinator(type: CombinatorType.Whitespace, sourceStringSegment: position, parent: complexSelector), nil))
            }
        }
        return .none
    }
    
    //  type_selector
    //      :   wqname_prefix? element_name
    //      ;
    private func parseTypeSelector(_ parentCompoundSelector: CompoundSelector) -> ParsingResult<TypeSelector> {
        
        // To fully support CSS, wqnameprefix should
        // be supported.
        let wqamePrefixResult = parseWQNamePrefix(currentComponentValue(), nextComponentValue: nextComponentValue())
        let lookahead: Int
        var wqamePrefix: WQNamePrefix? = nil
        
        switch wqamePrefixResult {
        case .success(let wqamePrefixValue):
            lookahead = 2
            wqamePrefix = wqamePrefixValue
        case .failure(let code):
            return .failure(code)
        case .none:
            lookahead = 0
        }
        
        if let (elementName, position) = parseElementName(parentCompoundSelector, lookahead: lookahead) {
            
            // we advance only if the element name parsing
            // is successfull, otherwise we stay on
            advanceComponentValueIndex(1+lookahead)
            let typeSelector = TypeSelector(sourceStringSegment: position, elementName: elementName, wqnamePrefix: wqamePrefix, parentCompoundSelector: parentCompoundSelector)
            return .success(typeSelector)
        }
        return .none
    }
    
    /// http://www.w3.org/TR/2011/REC-css3-namespace-20110929/
    ///
    /// wqname_prefix
    ///      :   namespace_prefix? '|'
    ///      |   '*' '|'
    ///       ;
    ///
    private final func parseWQNamePrefix(_ currentComponentValue: CSComponentValue?, nextComponentValue: CSComponentValue?) -> ParsingResult<WQNamePrefix> {
        
        if let identToken = parseNamespacePrefix(currentComponentValue) {
            
            if let preservedToken = nextComponentValue as? CSPreservedTokenComponentValue , preservedToken.isTokenId(§CSTokenId.delimToken) && preservedToken.value.stringRepresentation == "|" {
                
                let segment = SourceStringSegment(startIndex: identToken.sourceStringSegment!.startIndex, endIndex: preservedToken.sourceStringSegment!.endIndex)
                return .success(WQNamePrefix(sourceStringSegment: segment, namespacePrefix: identToken, endSeparator: preservedToken.value))
            }
        }
        else if let universalPrefix = parseUniversalPrefix(currentComponentValue) {
            
            if let preservedToken = nextComponentValue as? CSPreservedTokenComponentValue , preservedToken.isTokenId(§CSTokenId.delimToken) && preservedToken.value.stringRepresentation == "|" {
                
                let segment = SourceStringSegment(startIndex: universalPrefix.sourceStringSegment!.startIndex, endIndex: preservedToken.sourceStringSegment!.endIndex)
                return .success(WQNamePrefix(sourceStringSegment: segment, namespacePrefix: universalPrefix, endSeparator: preservedToken.value))
            }
        }
        else if let preservedToken = currentComponentValue as? CSPreservedTokenComponentValue , preservedToken.isTokenId(§CSTokenId.delimToken) && preservedToken.value.stringRepresentation == "|" {
            
            return .success(WQNamePrefix(sourceStringSegment: preservedToken.sourceStringSegment!, namespacePrefix: nil, endSeparator: preservedToken.value, explicitlyEmpty: true))
        }
        
        return ParsingResult.none
    }
    
    //
    //      |   '*' '|'
    private func parseUniversalPrefix(_ currentComponentValue: CSComponentValue?) -> Token? {
        
        if let preservedToken = currentComponentValue as? CSPreservedTokenComponentValue , preservedToken.isTokenId(§CSTokenId.delimToken) && preservedToken.value.stringRepresentation == "*" {
            
            return preservedToken.value
        }
        
        return nil
    }
    
    ///  namespace_prefix
    ///      : IDENT
    ///      ;
    ///
    private func parseNamespacePrefix(_ currentComponentValue: CSComponentValue?) -> Token? {
        
        if let preservedToken = currentComponentValue as? CSPreservedTokenComponentValue , preservedToken.isTokenId(§CSTokenId.identToken){
            
            return preservedToken.value
        }
        
        return nil
    }
    
    //  element_name
    //      :   IDENT | '*'
    //      ;
    private func parseElementName(_ parentCompoundSelector: CompoundSelector, lookahead: Int) -> (ElementName, SourceStringSegment?)? {
        
        if let token = componentValueLookahead(with: lookahead) {
        
            if token.isTokenId(§CSTokenId.identToken) {
            
                assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                if let preservedToken = token as? CSPreservedTokenComponentValue {
                
                    let ident = Ident(preservedIdentToken: preservedToken)

                    return (ElementName(ident: ident), preservedToken.sourceStringSegment)
                }
            }
            else if token.isTokenId(§CSTokenId.delimToken) {
             
                assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                if let preservedToken = token as? CSPreservedTokenComponentValue {
                    
                    // it's not a type selector if the DelimToken is not a star
                    // it could be a dot in the case of class selector, in this
                    // later case we must return nil.
                    if preservedToken.value.stringRepresentation == "*" {
                    
                        return (ElementName(delimToken: preservedToken.value), preservedToken.sourceStringSegment)
                    }
                }
            }
        }
        
        return nil
    }
    
    //  id
    //     :   HASH
    //     ;
    private func parseId(_ parentCompoundSelector: CompoundSelector) -> ParsingResult<IdSelector> {
        
        if let token = currentComponentValue() {
        
            if token.isTokenId(§CSTokenId.hashToken) {
                
                assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                if let preservedToken = token as? CSPreservedTokenComponentValue {
                
                    if let formattedString = preservedToken.value.formattedStringValue {
                        
                        advanceComponentValueIndex()
                        return .success(IdSelector(sourceStringSegment: preservedToken.value.sourceStringSegment,
                                rawHash: preservedToken.value.rawStringValue,
                                formattedHash: formattedString, hashToken: preservedToken.value as! HashToken, parentCompoundSelector: parentCompoundSelector))
                    }
                    else {
                        advanceComponentValueIndex()
                        return .success(IdSelector(sourceStringSegment: preservedToken.value.sourceStringSegment,
                                rawHash: preservedToken.value.rawStringValue, hashToken: preservedToken.value as! HashToken, parentCompoundSelector: parentCompoundSelector))
                    }
                }
            }
        }
        return .none
    }
    
    //  class
    //      : '.' IDENT
    //      ;
    private func parseClass(_ parentCompoundSelector: CompoundSelector) -> ParsingResult<ClassSelector> {
        
        if let token = currentComponentValue() {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("handling component value: %@", log: Log.Web.all, type: .info, %%token.cssText())
            #endif
            
            if token.isTokenId(§CSTokenId.delimToken) {
            
                assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                
                if let preservedToken = token as? CSPreservedTokenComponentValue {
                
                    if preservedToken.value.rawStringValue == "." {
                    
                        let startIndex: Int = preservedToken.value.sourceStringSegment!.startIndex
                        
                        if let nextToken = componentValueLookahead(with: 1) {
                        
                            if nextToken.isTokenId(§CSTokenId.identToken) {
                            
                                assert(nextToken is CSPreservedTokenComponentValue, "nextToken is not CSPreservedTokenComponentValue")
                                
                                if let nextPreservedToken = nextToken as? CSPreservedTokenComponentValue {
                                
                                    advanceComponentValueIndex(2)
                                    
                                    let ident = Ident(preservedIdentToken: nextPreservedToken)
                                    let position = SourceStringSegment(startIndex: startIndex, endIndex: nextPreservedToken.value.sourceStringSegment!.endIndex)
                                    
                                    return .success(ClassSelector(sourceStringSegment: position, ident: ident, dotDelimToken: preservedToken.value, parentCompoundSelector: parentCompoundSelector))
                                }
                            }
                        }
                    }
                }
            }
        }
        return .none
    }
    
    //  attrib
    //      :   '[' S* attrib_name ']'
    //      |   '[' S* attrib_name attrib_match [ IDENT | STRING ] S* attrib_flags? ']'
    //      ;
    private func parseAttrib(_ parentCompoundSelector: CompoundSelector) -> ParsingResult<AttribSelector> {
        
        if let component = currentComponentValue() {
            
            if let attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {
                
                var parsingIndex = 0
                let leftSquareBracketToken = attributeSelectorSimpleBlock.value.startToken
                let startIndex = leftSquareBracketToken.sourceStringSegment!.startIndex
                let endIndex = leftSquareBracketToken.sourceStringSegment!.endIndex
                
                // build the attribute selector
                let attribSelector = AttribSelector()
                attribSelector.leftSquareBracketToken = leftSquareBracketToken
                attribSelector.parent = parentCompoundSelector
                attribSelector.sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
                
                // parse the following whitespaces
                parseAttributeWhitespaces(from: &parsingIndex)
                
                let attribNameResult = parseAttribName(attribSelector, from: &parsingIndex)
                
                switch attribNameResult {
                case .success(let attribName):
                    return handleAttribNameSuccess(attribSelector: attribSelector, attribName: attribName, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock, parsingIndex: &parsingIndex)
                case .failure(let code):
                    return .failure(code)
                case .none:
                    return .none
                }
            }
        }
        return .none
    }
    
    private func handleAttribNameSuccess(attribSelector: AttribSelector, attribName: AttribName, attributeSelectorSimpleBlock: CSSimpleBlockComponentValue, parsingIndex: inout Int) -> ParsingResult<AttribSelector> {
        
        attribSelector.attribName = attribName
        
        attribName.parent = attribSelector
        
        let attribMatchResult = parseAttribMatch(attribSelector, from: parsingIndex)
        
        switch attribMatchResult {
            
        case .success(let attribMatch):
            return handleAttribMatchSuccess(attribSelector: attribSelector, attribMatch: attribMatch, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock, parsingIndex: &parsingIndex)
        case .failure(let code):
            return .failure(code)
        case .none:
            return handleAttribMatchNone(attribSelector: attribSelector, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock, parsingIndex: &parsingIndex)
        }
    }
    
    private func handleAttribMatchSuccess(attribSelector: AttribSelector, attribMatch: AttribMatch, attributeSelectorSimpleBlock: CSSimpleBlockComponentValue,  parsingIndex: inout Int) -> ParsingResult<AttribSelector> {
        
        attribSelector.attribMatch = attribMatch
        parsingIndex += 1
        
        parseAttributeWhitespaces(from: &parsingIndex)
        
        let attribValueResult = parseAttribValue(attribSelector, from: parsingIndex)
        
        switch attribValueResult {
        case .success(let attribValue):
            return handleAttribValueSuccess(attribSelector: attribSelector, attribValue: attribValue, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock,  parsingIndex: &parsingIndex)
        case .failure(let code):
            return .failure(code)
        case .none:
            return .failure(.missingAttributeValueInAttribSelector)
        }
    }

    private func handleAttribValueSuccess(attribSelector: AttribSelector, attribValue: AttribValue, attributeSelectorSimpleBlock: CSSimpleBlockComponentValue,  parsingIndex: inout Int) -> ParsingResult<AttribSelector> {
        
        attribSelector.attribValue = attribValue
        parsingIndex += 1
        
        parseAttributeWhitespaces(from: &parsingIndex)
        
        let attribFlagsResult = parseAttribFlags(attribSelector, from: parsingIndex)
        
        switch attribFlagsResult {
            
        case .none:
            return handleAttributeSelectorEnd(attribSelector: attribSelector, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock,  parsingIndex: &parsingIndex)
        case .success(let attribFlags):
            
            attribSelector.attribFlags = attribFlags
            parsingIndex += 1
            return handleAttributeSelectorEnd(attribSelector: attribSelector, attributeSelectorSimpleBlock: attributeSelectorSimpleBlock,  parsingIndex: &parsingIndex)
        case .failure(let code):
            return .failure(code)
        }
    }
    
    private func handleAttributeSelectorEnd(attribSelector: AttribSelector, attributeSelectorSimpleBlock: CSSimpleBlockComponentValue,  parsingIndex: inout Int) -> ParsingResult<AttribSelector> {
        
        // FIXME : maybe we should keep the possible spaces after the attrib name.
        parseAttributeWhitespaces(from: &parsingIndex)
        
        if parsingIndex < attributeSelectorSimpleBlock.count {
            return .none
        }
        
        attribSelector.rightSquareBraquetToken = attributeSelectorSimpleBlock.value.endToken
        
        let endIndex = attributeSelectorSimpleBlock.value.endToken.sourceStringSegment?.endIndex
        assert(endIndex != nil)
        if let endIndex = endIndex {
            attribSelector.sourceStringSegment?.endIndex = endIndex
        }
        
        advanceComponentValueIndex()
        return .success(attribSelector)
    }
    
    
    private func handleAttribMatchNone(attribSelector: AttribSelector, attributeSelectorSimpleBlock: CSSimpleBlockComponentValue,  parsingIndex: inout Int) -> ParsingResult<AttribSelector> {
    
        // this means we should find the end right square braquet
        // find the last ']' update the position, and return the attribSelector
        if var component = currentComponentValue() {
            
            if var attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {
                
                if var token = attributeSelectorSimpleBlock[parsingIndex] {
                    
                    // Missing right square braquet at the end of an attribute selector
                    // because the this is not the right token (we expect an attribute selector right square braquet.)
                    token.addMessage(.unexpectedToken)
                    return .failure(.unexpectedToken)
                }
                else {
                    
                    if attributeSelectorSimpleBlock.value.endToken.tokenId == §CSTokenId.rightSquareBracketToken {
                    
                        let lastToken = attributeSelectorSimpleBlock.value.endToken
                        attribSelector.rightSquareBraquetToken = lastToken
                        attribSelector.sourceStringSegment?.endIndex = lastToken.sourceStringSegment!.endIndex
                        self.advanceComponentValueIndex()
                        return .success(attribSelector)
                    }
                    else {
                        
                        attributeSelectorSimpleBlock.addMessage(MessageCode.missingAttributeSelectorRightSquareBracket)
                        return .failure(.missingAttributeSelectorRightSquareBracket)
                    }
                }
            }
            else {
                assert(false, "programming error since we are because we saw a CSSimpleBlockComponentValue")
                component.addMessage(.unexpectedToken)
                return .failure(.unexpectedToken)
            }
        }
        else {
            // there is current component value...
            assert(false, "programming error since we are because we saw a CSSimpleBlockComponentValue")
        }
        return .none
    }

    
    //  attrib_name
    //      :   wqname_prefix? IDENT S*
    //
    // Preconditions: We have founf the opening left square bracket 
    // we know we are in front of an attribute name.
    private func parseAttribName(_ parentAttribSelector: AttribSelector, from parsingIndex: inout Int) -> ParsingResult<AttribName> {
        
        if var component = currentComponentValue() {
        
            if var attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {

                let simpleBlock = attributeSelectorSimpleBlock.value
                
                if parsingIndex < simpleBlock.componentValueList.count {
                    
                    let token = simpleBlock.componentValueList[parsingIndex]

                    if token.isTokenId(§CSTokenId.identToken) {
                
                        // To fully support CSS, wqnameprefix should
                        // be supported.
                        var wqnamePrefix: WQNamePrefix?
                        
                        if simpleBlock.componentValueList.count > 1 {
                        
                            let currentComponentValue = simpleBlock.componentValueList[parsingIndex]
                            let nextComponentValue = simpleBlock.componentValueList[parsingIndex + 1]
                            
                            let wqnamePrefixResult = parseWQNamePrefix(currentComponentValue, nextComponentValue: nextComponentValue)
                            
                            switch wqnamePrefixResult {
                            
                            case .success(let wqnamePrefixValue):
                                
                                wqnamePrefix = wqnamePrefixValue
                                parsingIndex += 2
                                
                                let attribNameToken = simpleBlock.componentValueList[parsingIndex]
                                let preservedToken = attribNameToken as! CSPreservedTokenComponentValue
                                let ident = Ident(preservedIdentToken: preservedToken)
                                
                                parsingIndex += 1
                                
                                // FIXME: maybe we should keep the possible spaces after the attrib name.
                                parseAttributeWhitespaces(from: &parsingIndex)
                                
                                return .success(AttribName(sourceStringSegment: preservedToken.sourceStringSegment,
                                                           ident: ident, wqnamePrefix: wqnamePrefix,
                                                           parentAttribSelector: parentAttribSelector))
                                
                            case .failure(let code):
                                return .failure(code)
                            case .none:
                                
                                let preservedToken = token as! CSPreservedTokenComponentValue
                                let ident = Ident(preservedIdentToken: preservedToken)
                                parsingIndex += 1
                                
                                // FIXME: maybe we should keep the possible spaces after the attrib name.
                                parseAttributeWhitespaces(from: &parsingIndex)
                                
                                return .success(AttribName(sourceStringSegment: preservedToken.sourceStringSegment,
                                                           ident: ident, wqnamePrefix: wqnamePrefix,
                                                           parentAttribSelector: parentAttribSelector))
                            }
                        }
                        else {
                            
                            let preservedToken = token as! CSPreservedTokenComponentValue
                            let ident = Ident(preservedIdentToken: preservedToken)
                            
                            parsingIndex += 1
                            
                            // FIXME: maybe we should keep the possible spaces after the attrib name.
                            parseAttributeWhitespaces(from: &parsingIndex)
                            
                            return .success(AttribName(sourceStringSegment: preservedToken.sourceStringSegment,
                                              ident: ident, wqnamePrefix: wqnamePrefix,
                                              parentAttribSelector: parentAttribSelector))
                        }
                    }
                    else {
                        
                        // if it's not ident token we have unnexpected token
                        token.messageHandler.addMessage(MessageCode.unexpectedToken)
                        attributeSelectorSimpleBlock.addMessage(.missingAttributeNameInAttribSelector)
                        return .failure(.missingAttributeNameInAttribSelector)
                    }
                }
                else {
                    attributeSelectorSimpleBlock.addMessage(.missingAttributeNameInAttribSelector)
                    return .failure(.missingAttributeNameInAttribSelector)
                }
            }
            else {
                component.addMessage(.unexpectedToken)
                return .failure(.unexpectedToken)
            }
        }
        else {
            
            // Unexpected end of selector
            assert(false, "we are here because we saw a CSSimpleBlockComponentValue so this error should not happen...")
            return .failure(.unexpectedToken)
        }
        return .none
    }
    
    //  attrib_match
    //      :   [ '=' | PREFIX-MATCH | SUFFIX-MATCH | SUBSTRING-MATCH | INCLUDE-MATCH | DASH-MATCH ] S*
    private func parseAttribMatch(_ parentAttribSelector: AttribSelector, from index: Int) -> ParsingResult<AttribMatch> {
        
        if let component = currentComponentValue() {
        
            if let attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {
                
                if let token = attributeSelectorSimpleBlock[index] {
                
                    if token.isTokenId(§CSTokenId.delimToken) {
                        
                        assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                        
                        if let preservedToken = token as? CSPreservedTokenComponentValue {
                        
                            if preservedToken.value.rawStringValue == "=" {
                                
                                return .success(AttribMatch(sourceStringSegment: preservedToken.value.sourceStringSegment, matchType: MatchType.EqualMatch, parentAttribSelector: parentAttribSelector))
                            }
                        }
                    }
                    else if token.isTokenId(§CSTokenId.prefixMatchToken) {
                        
                        return .success(AttribMatch(sourceStringSegment: token.sourceStringSegment, matchType: MatchType.PrefixMatch, parentAttribSelector: parentAttribSelector))
                    }
                    else if token.isTokenId(§CSTokenId.suffixMatchToken) {
                        
                        return .success(AttribMatch(sourceStringSegment: token.sourceStringSegment, matchType: MatchType.SuffixMatch, parentAttribSelector: parentAttribSelector))
                    }
                    else if token.isTokenId(§CSTokenId.substringMatchToken) {
                        
                        return .success(AttribMatch(sourceStringSegment: token.sourceStringSegment, matchType: MatchType.SubstringMatch, parentAttribSelector: parentAttribSelector))
                    }
                    else if token.isTokenId(§CSTokenId.includeMatchToken) {
                        
                        return .success(AttribMatch(sourceStringSegment: token.sourceStringSegment, matchType: MatchType.IncludeMatch, parentAttribSelector: parentAttribSelector))
                    }
                    else if token.isTokenId(§CSTokenId.dashMatchToken) {
                        
                        return .success(AttribMatch(sourceStringSegment: token.sourceStringSegment, matchType: MatchType.DashMatch, parentAttribSelector: parentAttribSelector))
                    }
                }
            }
        }
        return .none
    }
    
    /// Parse a string or ident 
    /// [ IDENT | STRING ]
    private func parseAttribValue(_ parentAttribSelector: AttribSelector, from index: Int) -> ParsingResult<AttribValue> {
        
        if let component = currentComponentValue() {
            
            if let attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {
                
                if let token = attributeSelectorSimpleBlock[index] {
            
                    if token.isTokenId(§CSTokenId.identToken) {
                    
                        assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                        
                        if let preservedToken = token as? CSPreservedTokenComponentValue {
                            
                            let ident = Ident(preservedIdentToken: preservedToken)
                            
                            return .success(AttribValue(sourceStringSegment: preservedToken.sourceStringSegment, ident: ident, parentAttribSelector: parentAttribSelector))
                        }
                    }
                    else if token.isTokenId(§CSTokenId.stringToken) {
                        
                        assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                        
                        if let preservedToken = token as? CSPreservedTokenComponentValue {
                        
                            let string = StringToken(preservedIdentToken: preservedToken)
                            
                            return .success(AttribValue(sourceStringSegment: preservedToken.sourceStringSegment, string: string, parentAttribSelector: parentAttribSelector))
                        }
                    }
                }
            }
        }
        return .none
    }
    
    //  attrib_flags
    //      :   IDENT S*
    private func parseAttribFlags(_ parentAttribSelector: AttribSelector, from index: Int) -> ParsingResult<AttribFlags> {
        
        // TODO : we need to parse wqname_prefix
            
        if let component = currentComponentValue() {
            
            if let attributeSelectorSimpleBlock = component as? CSSimpleBlockComponentValue {
                
                if let token = attributeSelectorSimpleBlock[index] {
            
                    if token.isTokenId(§CSTokenId.identToken) {
                        
                        assert(token is CSPreservedTokenComponentValue, "token is not CSPreservedTokenComponentValue")
                        
                        if let preservedToken = token as? CSPreservedTokenComponentValue {
                        
                            let ident = Ident(preservedIdentToken: preservedToken)
                            
                            return .success(AttribFlags(sourceStringSegment: preservedToken.sourceStringSegment, ident: ident, parentAttribSelector: parentAttribSelector))
                        }
                    }
                }
            }
        }
        return .none
    }
    
    // pseudo : ':' ':'? [ IDENT | functional_pseudo ]
    // TODO: functional_pseudo
    private func parsePseudo(_ parentCompoundSelector: CompoundSelector) -> ParsingResult<Pseudo> {

        if let componentValue = currentComponentValue(), let preservedComponentValue = componentValue as? CSPreservedTokenComponentValue {
            
            // When reaching this method we don't know if we are in front
            // of pseudo. We need to determine this first.
            // Then we need to know which kind of pseudo: pseudo element or
            // or pseudo class, that's what the code here is doing.
            if componentValue.isTokenId(§CSTokenId.colonToken) {
            
                let firstColonToken = preservedComponentValue.value
                
                if let nextComponentValue = componentValueLookahead(with: 1), let nextPreservedComponentValue = nextComponentValue as? CSPreservedTokenComponentValue {
                
                    if nextComponentValue.isTokenId(§CSTokenId.colonToken) {
                        
                        let secondColonToken = nextPreservedComponentValue.value
                        let pseudoType = PseudoType.elementSelector(firstColonToken: firstColonToken, secondColonToken: secondColonToken)
                        return parseRestOfPseudo(pseudoType: pseudoType, parentCompoundSelector: parentCompoundSelector)
                    }
                    else {
                        
                        let pseudoType = PseudoType.classSelector(firstColonToken: firstColonToken)
                        return parseRestOfPseudo(pseudoType: pseudoType, parentCompoundSelector: parentCompoundSelector)
                    }
                }
            }
        }
        return .none
    }
    
    /// [ IDENT | functional_pseudo ]
    private func parseRestOfPseudo(pseudoType: PseudoType, parentCompoundSelector: CompoundSelector) -> ParsingResult<Pseudo> {
        
        // Starting from here, we know that we supposed to be in front of a pseudo
        // and we know which kind of pseudo we are in front of.
        if let functionOrIdentToken: CSComponentValue = componentValueLookahead(with: pseudoType.lookahead) {
            
            if functionOrIdentToken.isTokenId(§CSTokenId.identToken) {
                
                assert(functionOrIdentToken is CSPreservedTokenComponentValue)
                if let preservedToken = functionOrIdentToken as? CSPreservedTokenComponentValue {
                    
                    advanceComponentValueIndex(pseudoType.lookahead + 1)
                    
                    let startIndex = pseudoType.startIndex
                    
                    assert(startIndex != nil)
                    if let startIndex = startIndex {
    
                        let ident = Ident(preservedIdentToken: preservedToken)
                        let position = SourceStringSegment(startIndex: startIndex, endIndex: preservedToken.value.sourceStringSegment!.endIndex)
                        
                        switch pseudoType {
                        case .classSelector(let firstColonToken):
                            
                            let identPseudoClass = IdentPseudoClass(sourceStringSegment: position, ident: ident, parentCompoundSelector: parentCompoundSelector, firstColonToken: firstColonToken, classIdentToken: ident.preservedToken.value)
                            
                            return .success(identPseudoClass)
                            
                        case .elementSelector(let firstColonToken, let secondColonToken):
                            
                            let pseudoElementSelector = PseudoElementSelector(sourceStringSegment: position, ident: ident, parentCompoundSelector: parentCompoundSelector, firstColonToken: firstColonToken, secondColonToken: secondColonToken)
                            
                            if PseudoSelectorType(rawValue: ident.identString) == nil {
                                pseudoElementSelector.messageHandler.addMessage(MessageCode.unsupportedPseudoElement, args: [ident.identString])
                            }
                            
                            return .success(pseudoElementSelector)
                        }
                    }
                }
            }
            else {
                functionOrIdentToken.messageHandler.addMessage(MessageCode.unexpectedToken, args: [functionOrIdentToken.cssText()])
            }
        }
        return .none
    }
    
    
    func parseFunctionalPseudoClass() -> ParsingResult<FunctionalPseudoClass> {
        
        if let token = currentComponentValue() {
            
            // each functional pseudo-class should have it's own 
            // handler.
            if token.isTokenId(§CSTokenId.functionToken) {
                
                if let _ = token as? CSFunctionComponentValue {
                
                    let functionalPseudoClass = FunctionalPseudoClass()
                    
                    assert(false, "Missing implementation.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Missing parseFunctionalPseudoClass implementation.", log: Log.Web.all, type: .error)
                    #endif
                    
                    return .success(functionalPseudoClass)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("FunctionToken should be CSFunctionComponentValue.", log: Log.Web.all, type: .error)
                    #endif
                    return .failure(.unexpectedToken)
                }
            }
            else {
                // since the method has been called we should 
                // have encountered a function token.
                // security check : there is message to send 
                // to the user.
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("expected function token.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        return .none
    }
    
    private func parseInvalidComplexSelector(from index: Int, selectorList: SelectorList) -> InvalidComplexSelector? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("processing selector: %@", log: Log.Web.all, type: .info, %%self.componentsString)
        #endif
        
        var invalidComponentValues = [CSComponentValue]()
        
        resetComponentValueIndex(toIndex: index)
        
        var startIndex: Int?
        var endIndex: Int?
        
        while var componentValue = currentComponentValue() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("processing component: %@", log: Log.Web.all, type: .debug, %%componentValue.cssText())
            #endif
            if startIndex == nil {
                startIndex = componentValue.sourceStringSegment?.startIndex
            }
            
            endIndex = componentValue.sourceStringSegment?.endIndex
            invalidComponentValues.append(componentValue)
            advanceComponentValueIndex()
            if currentComponentIsComa() {
                break
            }
        }
        
        if !invalidComponentValues.isEmpty {
            
            var sourceStringSegment: SourceStringSegment?
            
            assert(startIndex != nil)
            assert(endIndex != nil)
            if let startIndex = startIndex, let endIndex = endIndex {
                sourceStringSegment = SourceStringSegment(startIndex: startIndex, endIndex: endIndex)
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
            #endif
            return InvalidComplexSelector(sourceStringSegment: sourceStringSegment, parent: selectorList, invalidComponentValues: invalidComponentValues)
        }
        
        return nil
    }
    
    private func accept<S : Selector>(_ selector: S) -> S {
        
        advanceComponentValueIndex()
        
        return selector
    }
    
    private func validateFirstLineAndFirstLetterPseudoElementsAreLast(in selectorList: SelectorList) {
        
        for complexSelector in selectorList.selectorArray {
            
            let validator = PseudoElementsSelectorsAreLastValidatorSelectorVisitor()
            validator.process(complexSelector)
        }
    }
    
}
