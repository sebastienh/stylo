//
//  Tokens.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

public final class Tokens {
    
    public private(set) var tokenValues: [Token]
    
    public var length: Int {
        
        return tokenValues.count
    }
    
    /// Return the body element associated with the elements
    /// associated with the tokens in this Tokens.
    public var associatedDocumentBodyElement: HTMLElement? {
        
        // iterate until we find a token with associated element(s)
        for token in tokenValues {
            
            let nodes = token.getAssociatedDomNodes()
            
            if let node = nodes.first {
                
                let htmlDocument = node.document as! HtmlDocument
                return htmlDocument.body
            }
        }
        return nil
    }
    
    
    public func unsafeToken(at index: Int) -> Unmanaged<Token>? {
        
        if index >= 0 && index < tokenValues.count {
            return Unmanaged.passUnretained(tokenValues[index])
        }
        return nil
        
    }
    
    public subscript(index: Int) -> Token? {
        
        get {
            
            if index < tokenValues.count {
                return tokenValues[index]
            }
            return nil
        }
        set(token) {
            
            if let token = token {
                tokenValues[index] = token
            }
        }
    }
    
    weak var parentToken: Token?
    
    private let lazyContinuationTokenTypes: Set<TokenType> =  Set<TokenType>(arrayLiteral: .htmlBlock, .blockquoteOpen, .orderedListOpen, .bulletListOpen, .tableOpen, .codeBlock)
    
    
    public init() {
        self.tokenValues = [Token]()
    }
    
    /// Calling execute with the procedure on all token values
    /// in this Tokens instance.
    public func execute(_ procedure: (Token) -> ()) {
        
        for token in tokenValues {
            
            // execute the procedure on the token itself
            token.execute(procedure)
        }
    }
    
    func popLast() {
        
        tokenValues.popLast()
    }
    
    /// This method translate the position of the fragment using
    /// the count from which moving the fragment by adding this count
    /// to the start and end index.
    public func move(_ count: Int, env: Env) {
        
        if count != 0 {
            
            for i in 0..<tokenValues.count {
                
                if let unsafeToken = self.unsafeToken(at: i) {
                    unsafeToken._withUnsafeGuaranteedRef {
                        $0.move(count, env: env)
                    }
                }
            }
        }
    }
    
    /// Simple method to push
    @discardableResult
    public func push(_ token: Token) -> Token {
        
        token.parentTokens = self
        tokenValues.append(token)
        return token
    }
    
    
    /// Remove element from array and put another array at those position.
    /// Useful for some operations with tokens
    func arrayReplaceAt(_ pos: Int, newElements: [Token]) {
        
        for newElement in newElements {
            newElement.parentTokens = self
        }
        
        tokenValues.replaceSubrange(pos..<newElements.count, with: newElements)
    }
    
    public func rangeOfBlockTokensAround(changeDescription: SourceStringChangeDescription) -> Range<Int>? {
        
        guard let range = changeDescription.changeRange else {
            return nil
        }
        
        return self.rangeOfBlockTokensAround(range: range, changeType: changeDescription.changeType, changeLength: changeDescription.changeLength, isNonEmptyReplace: changeDescription.isNonEmptyReplace)
    }
    
    /// Remove the tokens between the first start block token before
    /// the changeIndex and the first start block token after non-inclusively and
    /// return the index of the first start block token before.
    public func rangeOfBlockTokensAround(range: NSRange, changeType: SourceStringChangeDescription.ChangeType = .unchanged, changeLength: Int = 0, isNonEmptyReplace: Bool = false) -> Range<Int>? {
        
        let affectedStartIndex = range.lowerBound
        let affectedEndIndex = range.upperBound
        var tokenRange: Range<Int>?
        
        // identify the range from the change index
        if let startTokenIndex = tokenIndexContaining(affectedStartIndex) {
            
            let startBlockTokenIndexBeforeChange = startBlockTokenIndexBefore(startTokenIndex)
            
            if let endTokenIndex = tokenIndexContaining(affectedEndIndex) {
                
                let startBlock = self.topLevelStartBlockTokenIndexAfter(endTokenIndex)
                tokenRange = startBlockTokenIndexBeforeChange..<startBlock
                
                let lastCompiledOpenToken = self.tokenValues[endTokenIndex]
                let lastCompiledOpenTokenRange = lastCompiledOpenToken.sourceStringFragment?.range
                
                var increaseEnd = false
                
                if startBlock < self.tokenValues.count && changeType.isAddition && self.tokenValues[startBlock].type == .codeBlock {
                
                    let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                    tokenRange = tokenRange!.lowerBound..<upperBound
                }
                
                if lazyContinuationTokenTypes.contains(lastCompiledOpenToken.type) || lastCompiledOpenToken.type == .hr {
                    
                    increaseEnd = true
                }
                else if let lastCompiledOpenTokenRange = lastCompiledOpenTokenRange, lastCompiledOpenTokenRange.upperBound < range.lowerBound {
                    
                    increaseEnd = true
                }
                
                if increaseEnd {
                    
                    let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                    tokenRange = tokenRange!.lowerBound..<upperBound
                }
            }
            else {
                tokenRange = startBlockTokenIndexBeforeChange..<tokenValues.count
            }
            
            assert(tokenRange != nil)
            if tokenRange != nil {
                
                // When we delete we don't want only the affected tokens we want the surrounding ones
                if changeType.isRemoval || changeType == .pureReplace {
                    
                    // in this case we should extend the range of tokens to compute passed
                    // the deletion.
                    let lowerBound = self.startBlockTokenIndexBefore(tokenRange!.lowerBound)
                    let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                    tokenRange = lowerBound..<upperBound
                }
                
                // In case of non-empty replace we can be greedy as we know the user
                // is not typing
                if isNonEmptyReplace ||
                    (changeType == .pureAddition && changeLength > 1) {
                    
                    let lowerBound = self.startBlockTokenIndexBefore(tokenRange!.lowerBound)
                    let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                    tokenRange = lowerBound..<upperBound
                }
                
                // When the last token is a fence we don't want to force stoping there
                // since there may be a change in the pairing
                let lastToken = self.tokenValues[tokenRange!.upperBound-1]
                
                if lastToken.type == .fence {
                    
                    let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                    tokenRange = tokenRange!.lowerBound..<upperBound
                }
                
                // if the next token is a lazy continuation token we should include
                // it in the compilation since it may be joinded with the previous
                // Note: this is only true if the token before was a lazy continuation
                // block of the same type as the next upper bound one...
                if tokenRange!.upperBound < self.length {
                    
                    let tokenAfterCompiledRange = self.tokenValues[tokenRange!.upperBound]
                    
                    if lazyContinuationTokenTypes.contains(tokenAfterCompiledRange.type) {
                        
                        // now we need to ckeck if the start compilation is the same type
                        // since there is no risk to join two blocks together if the start
                        // and the end part are not of the same type... e.g.
                        //
                        // [List]
                        // P
                        // [Code]
                        //
                        // In this example List and Code can not be joined together.
                        //
                        // Note: here a little security check
                        let rangeStartIndex = tokenRange!.lowerBound
                        
                        assert(rangeStartIndex < self.tokenValues.count && rangeStartIndex >= 0)
                        if rangeStartIndex < self.tokenValues.count && rangeStartIndex >= 0 {
                            
                            let startTokenType = self.tokenValues[rangeStartIndex].type
                            
                            if startTokenType == tokenAfterCompiledRange.type || changeType.isRemoval {
                                
                                let upperBound = self.topLevelStartBlockTokenIndexAfter(tokenRange!.upperBound)
                                tokenRange = tokenRange!.lowerBound..<upperBound
                            }
                        }
                    }
                }
            }
        }
        else {
            
            // always fall back to complete compilation in case of error
            // this way we avoid any crash possible.
            return 0..<tokenValues.count
        }
        
        
        let rangeWithTokenOneLineAbove = includeTokenAboveIfAttributesBlocsIsLineBelow(in: tokenRange)
        
        // after all this we need to take care of the attributes blocs
        // since they will have an impact on the markdown rendering
        let rangeWithAttributesAbove = includeAttributesBlocsTokensAbove(in: rangeWithTokenOneLineAbove)
        
        // make sure we include all blocs until we reach the bloc to which attributes
        // can be applied.
        let rangeWithBlocsTokensBelow = self.includeBlocsTokensBelow(in: rangeWithAttributesAbove)
        
        // make sure that when the last token is not a attr-bloc to
        // include the attr bloc on the line below.
        return includeAttributesBlocOnLineBelow(in: rangeWithBlocsTokensBelow)
    }
    
    ///
    /// Method that goes over the specified parameter range
    /// and looks for the attrsBlocs property of each top
    /// level token and return the union of them all.
    ///
    public func collectTopLevelAttributesBlocs(in range: Range<Int>) -> Set<AttributesBloc> {
        
        var topLevelAttributesBlocs = Set<AttributesBloc>()
        
        for i in range {
            
            assert(i >= 0 && i < self.tokenValues.count)
            if i >= 0 && i < self.tokenValues.count {
                let token = self.tokenValues[i]
                
                if let attrsBlocs = token.attrsBlocs {
                    topLevelAttributesBlocs.formUnion(attrsBlocs)
                }
            }
        }
        return topLevelAttributesBlocs
    }
    
    /// Include the token above if the current token is an attributes token,
    /// we can assign attributes to the token above and there is no
    /// empty line between the attributes bloc and the token above...
    private func includeTokenAboveIfAttributesBlocsIsLineBelow(in tokenRange: Range<Int>?) -> Range<Int>? {
        
        if let tokenRange = tokenRange {
            
            if self.tokenValues[tokenRange.lowerBound].type == .attrBlocOpen {
                
                if tokenRange.lowerBound >= 1 {
                
                    let previousToken = self.tokenValues[tokenRange.lowerBound-1]
                
                    if previousToken.type.acceptAttributes {
                
                        let startTokenIndexBefore = startBlockTokenIndexBefore(tokenRange.lowerBound)
                        return startTokenIndexBefore..<tokenRange.upperBound
                    }
                }
            }
        }
        return tokenRange
    }
    
    private func includeAttributesBlocOnLineBelow(in tokenRange: Range<Int>?) -> Range<Int>? {
        
        if let tokenRange = tokenRange {
            
            let lastTokenInRange = self.tokenValues[tokenRange.upperBound-1]
            assert(lastTokenInRange.level == 0)
            
            if lastTokenInRange.type != .attrBlocClose {
        
                let attributesBlocIndex = sameLevelAttributesBlocIndexOnLineBelow(tokenIndex: tokenRange.upperBound-1)
                
                if let attributesBlocIndex = attributesBlocIndex {
                    
                    let attributesBloc = self.tokenValues[attributesBlocIndex]
                    
                    if lastTokenInRange.isTokenLineBelow(attributesBloc) {
                    
                        if !attributesBloc.emptyLineAbove {
                        
                            // when we call this method we are only interested in the top level
                            // since it called from rangeOfBlockTokensAround for partial compilation.
                            let index = self.topLevelStartBlockTokenIndexAfter(attributesBlocIndex)
                            return tokenRange.lowerBound..<index
                        }
                    }
                }
            }
            return tokenRange
        }
        return nil
    }
    
    public func sameLevelAttributesBlocIndexOnLineBelow(tokenIndex index: Int) -> Int? {
        
        if index >= self.tokenValues.count-1 {
            return nil
        }
        
        assert(self.tokenValues[index].type != .attrBlocClose)
        if self.tokenValues[index].type != .attrBlocClose {
            
            let bloc = self.tokenValues[index]
            if let attributesBlocIndex = sameLevelAttributesBlocIndexAfter(index) {
                
                let attributesBloc = self.tokenValues[attributesBlocIndex]
                
                if bloc.isTokenLineBelow(attributesBloc) {
                
                    return attributesBlocIndex
                }
            }
        }
        return nil
    }
    
    /// When the last compiled attributes inside a range is an attributes bloc
    /// we should include the same level bloc below because it's attributes
    /// may have changed. We do this only if this last attributes bloc is not
    /// on the line below another bloc, that means this last block does not apply
    /// below...
    ///
    /// Note: now we always include it as we may be editing an invalid attrbutes bloc
    /// and transform it in a valid one... This means that we would need to detect
    /// if we are editing a "potential" attributes bloc which may be possible but the
    /// speed gain not sufficient to justify the complexity just to compile
    /// one less token...
    private func includeBlocsTokensBelow(in tokenRange: Range<Int>?) -> Range<Int>? {
        
        if let tokenRange = tokenRange {

            
            let index = self.secondStartBlockTokenIndexAfter(tokenRange.upperBound-1)
            var indexToValidate = index
            var extendedTokenRange = tokenRange.lowerBound..<index
            
            while extendedTokenRange.upperBound != self.tokenValues.count && !self.tokenValues[extendedTokenRange.upperBound-1].type.acceptAttributes {
                
                indexToValidate = extendedTokenRange.upperBound
                let index = self.secondStartBlockTokenIndexAfter(extendedTokenRange.upperBound-1)
                extendedTokenRange = tokenRange.lowerBound..<index
            }
            
            // we can not end with an attr-bloc-start that is not on a line
            // below a bloc
            if isAttributesBlocStartForFollowingBloc(at: indexToValidate) {
                
                let index = self.secondStartBlockTokenIndexAfter(extendedTokenRange.upperBound-1)
                extendedTokenRange = tokenRange.lowerBound..<index
            }
            
            return extendedTokenRange
            // while the next token is
        }
        return tokenRange
    }
    
    private func isAttributesBlocStartForFollowingBloc(at index: Int) -> Bool {
        
        guard index < self.tokenValues.count else {
            return false
        }
        
        // we can not end with an attr-bloc-start
        let nextToken = self.tokenValues[index]
        
        if nextToken.type.isAttributesBlocStartToken {
            // cannot end with an attributes blocs
            if !nextToken.isLineBelowToken {
                return true
            }
        }
        return false
    }
    
    
    private func includeAttributesBlocsTokensAbove(in tokenRange: Range<Int>?) -> Range<Int>? {
        
        if let tokenRange = tokenRange {
        
            let indexes = attributesBlocsStartTokenIndexesBefore(index: tokenRange.lowerBound)
            
            if let firstIndex = indexes.first {
                
                return firstIndex..<tokenRange.upperBound
            }
        }
        return tokenRange
    }
    
    public func attributesBlocsStartTokenIndexesBefore(index: Int) -> [Int] {
        
        var indexes = [Int]()
        var currentStartBlocIndex = index
        
        var sameLevelPreviousStartBlocIndex = self.sameLevelPreviousStartBlocIndex(currentStartBlocIndex)
        
        // we need to look until the start bloc token above
        // that is not a attributes bloc, if this attributes bloc is not
        // under another token, we include until then. Otherwise we need to do
        // the same process starting from the token above the last
        while let index = sameLevelPreviousStartBlocIndex, self.tokenValues[index].type.isAttributesBlocStartToken {
            
            func continueToNext() {
                
                indexes.append(index)
                currentStartBlocIndex = index
                sameLevelPreviousStartBlocIndex = self.sameLevelPreviousStartBlocIndex(currentStartBlocIndex)
            }
            
            if isTokenALineBelowNonAttributesToken(atIndex: index) {
                if self.tokenValues[index].emptyLineAbove {
                    continueToNext()
                }
                else {
                    break
                }
            }
            else {
                continueToNext()
            }
        }
        return indexes.reversed()
    }
    
    private func isTokenALineBelowNonAttributesToken(atIndex index: Int) -> Bool {
        
        if index == 0 {
            return false
        }
        
        let token = tokenValues[index]
        assert(token.type.isAttributesBlocStartToken)
        let tokenAbove = tokenValues[index-1]
        if tokenAbove.type.acceptAttributes {
            
            return tokenAbove.isTokenLineBelow(token)
        }
        return false
    }
    
    
    private func listTypeOpenToken(tokenType: TokenType?) -> Bool {
        
        if let tokenType = tokenType {
            if tokenType == .listItemOpen || tokenType == .bulletListOpen || tokenType == .orderedListOpen {
                return true
            }
        }
        return false
    }
    
    /// Utility method to get the range of a token at a certain index.
    private func tokenRange(at index: Int) -> NSRange? {
    
        let sourceStringFragment = self[index]?.sourceStringFragment
        
        assert(sourceStringFragment != nil)
        if let sourceStringFragment = sourceStringFragment {
            
            return sourceStringFragment.range
        }
        return nil
    }
    
    public func associatedOpenTokenIndex(of tokenIndex: Int) -> Int {
    
        let targetNesting = tokenValues[tokenIndex].nesting.associatedOpenNesting
        
        assert(targetNesting != nil)
        if let targetNesting = targetNesting {
            
            for i in stride(from: tokenIndex, through: 0, by: -1) {
                if tokenValues[i].block == true
                    && tokenValues[i].nesting == targetNesting
                    && tokenValues[i].level == 0
                    // we never partially compile a table
                    && tokenValues[i].tag != "tr"
                    && tokenValues[i].tag != "td"
                    && tokenValues[i].tag != "th"
                    && tokenValues[i].tag != "tbody"
                    && tokenValues[i].tag != "thead" {
                    
                    return i
                }
            }
        }
        // if there is only one block after the change we will
        // fall back to complete recompilation
        assert(false, "this situation should not append")
        return 0
    }
    
    /// Replace the specified range of tokens with the specified tokens
    public func replaceTokensSubrange(_ range: Range<Int>, with tokens: [Token]) -> [Token] {
        
        let removedTokens = self.tokenValues[range]
        tokenValues.replaceSubrange(range, with: tokens)
        return Array(removedTokens)
    }
    
    /// Return true if the token paremeter is the last token
    /// in the current Tokens object.
    func isLast(_ token: Token) -> Bool {
        if let lastToken = tokenValues.last , lastToken == token {
            return true
        }
        return false
    }
    
    /// Finds the next block start token before the token index.
    /// If the change is at the start of the document the returned 
    /// index is 0
    public func startBlockTokenIndexBefore(_ tokenIndex: Int) -> Int {
        
        if tokenIndex == 0 {
            return tokenIndex
        }
        
        for i in stride(from: tokenIndex - 1, through: 0, by: -1) {
            if tokenValues[i].validTopLevelBlockStartToken {
                return i
            }
        }
        return 0
    }
    
    /// Return the third start of block token index after the 
    /// specified token index.
    /// 
    /// Basically if there is a change in a block we want to recompile
    /// the affected block and the surrounding blocks also since
    /// the change in the middle block could have effect of merging
    /// all of them into one block. The reason to recompile also 
    /// the block after the second block is because we want to keep 
    /// the part of the string which close the last token we really want,
    /// the second start block index after. 
    private func thirdStartBlockTokenIndexAfter(_ tokenIndex: Int) -> Int {
        
        var nextBlockIndexNbr = 0
        
        for i in tokenIndex + 1..<tokenValues.count {
            if tokenValues[i].validTopLevelBlockStartToken {
                if nextBlockIndexNbr > 2 {
                    return i
                }
                else {
                    nextBlockIndexNbr += 1
                }
            }
        }
        // if there is only one block after the change we will
        // fall back to complete recompilation
        return tokenValues.count
    }
    
    private func secondStartBlockTokenIndexAfter(_ tokenIndex: Int) -> Int {
        
        var nextBlockIndexNbr = 0
        
        for i in tokenIndex + 1..<tokenValues.count {
            if tokenValues[i].validTopLevelBlockStartToken {
                if nextBlockIndexNbr > 0 {
                    return i
                }
                else {
                    nextBlockIndexNbr += 1
                }
            }
        }
        // if there is only one block after the change we will
        // fall back to complete recompilation
        return tokenValues.count
    }
    
    public func topLevelStartBlockTokenIndexAfter(_ tokenIndex: Int) -> Int {
        
        if tokenValues.count == tokenIndex {
            return tokenIndex
        }
        
        for i in tokenIndex + 1..<tokenValues.count {
            if tokenValues[i].validTopLevelBlockStartToken {
                return i
            }
        }
        // if there is only one block after the change we will
        // fall back to complete recompilation
        return tokenValues.count
    }
    
    public func nonEmptyInlineStartOrSelfClosingTokenBeforeAttrBloc(_ tokenIndex: Int) -> Token? {
        
        if tokenIndex <= 0 || tokenIndex >= tokenValues.count {
            return nil
        }
        
        assert(tokenValues[tokenIndex].type == .attrBlocOpen)
        assert(tokenValues[tokenIndex].nesting == .opening)
        assert(!tokenValues[tokenIndex].block)
        
        var lookupIndex = tokenIndex-1
        
        // skip empty texts
        while lookupIndex >= 0 {
            
            if let indexBefore = inlineCorrespondingOpenOrSelfClosingTokenIndexBefore(tokenIndex: lookupIndex) {
            
                assert(indexBefore <= lookupIndex)
                
                let tokenBefore = tokenValues[indexBefore]
                assert(tokenBefore.nesting == .opening || tokenBefore.nesting == .selfClosing)
                
                if tokenBefore.type == .text {
                    
                    if !tokenBefore.content.trimWhitespaces().isEmpty {
                        return tokenBefore
                    }
                }
                else if tokenBefore.type == .softbreak {
                    // we continue to turn
                }
                else {
                    return tokenBefore
                }
                lookupIndex = indexBefore - 1
            }
            else {
                break 
            }
        }
        return nil
    }
    
    /// In case we have an inline at the index, we return the index itself.
    private func inlineCorrespondingOpenOrSelfClosingTokenIndexBefore(tokenIndex index: Int) -> Int? {
        
        if index < 0 || index >= tokenValues.count {
            return nil
        }
        
        var lookupIndex = index
        
        if tokenValues[lookupIndex].nesting == .selfClosing {
            return index
        }
        
        let lookupType = tokenValues[lookupIndex].type.correspondindOpeningType
        
        lookupIndex -= 1
        while lookupIndex >= 0 {
            
            if tokenValues[lookupIndex].type == lookupType {
                return lookupIndex
            }
            else {
                lookupIndex -= 1
            }
        }
        return nil
    }
    
    public func sameLevelPreviousStartBloc(_ tokenIndex: Int) -> Token? {
        
        let index = self.sameLevelPreviousStartBlocIndex(tokenIndex)
        
        if let index = index {
            
            return tokenValues[index]
        }
        return nil
    }
    
    public func sameLevelPreviousStartBlocIndex(_ tokenIndex: Int) -> Int? {
     
        for i in stride(from: tokenIndex-1, through: 0, by: -1) {
            
            if tokenValues[i].level == tokenValues[tokenIndex].level {
                
                if tokenValues[i].nesting == .opening {
                    
                    return i
                }
            }
        }
        return nil
    }
    
    public func nextAttributesBlocSibling(_ tokenIndex: Int) -> Token? {
        
        assert(tokenValues[tokenIndex].type.acceptInlineAttributes)
        var level = tokenValues[tokenIndex].level
        
        var lookupIndex: Int
        
        switch tokenValues[tokenIndex].nesting {
        case .closing:
            assert(false, "this method should not be called with closing nesting token")
            return nil
        case .opening:
            
            let closeTokenIndex = correspondingCloseTokenIndex(of: tokenIndex)
            assert(closeTokenIndex != nil)
            if let closeTokenIndex = closeTokenIndex {
                lookupIndex = closeTokenIndex
            }
            else {
                return nil
            }
            
        case .selfClosing:
            lookupIndex = tokenIndex
            level += 1
        }
        
        
        lookupIndex += 1
        // skip empty texts
        while lookupIndex < tokenValues.count {
            
            if tokenValues[lookupIndex].type == .text {
                
                if tokenValues[lookupIndex].content.trimWhitespaces().isEmpty {
                    lookupIndex += 1
                }
                else {
                    return nil
                }
            }
            else if tokenValues[lookupIndex].type == .softbreak {
                lookupIndex += 1
            }
            else {
                break
            }
        }
        
        if lookupIndex < tokenValues.count {
            if tokenValues[lookupIndex].level == level {
                
                if tokenValues[lookupIndex].nesting == .opening {
                    
                    if tokenValues[lookupIndex].type == .attrBlocOpen {
                        
                        return tokenValues[lookupIndex]
                    }
                }
            }
        }
        return nil
    }
    
    public func sameLevelAttributesBlocAfter(_ tokenIndex: Int) -> Token? {
        
        if let index = sameLevelAttributesBlocIndexAfter(tokenIndex) {
                
            return tokenValues[index]
        }
        return nil
    }
    
    private func sameLevelAttributesBlocIndexAfter(_ tokenIndex: Int) -> Int? {
    
        if let index = sameLevelStartBlockTokenIndexAfter(tokenIndex) {
            
            if tokenValues[index].type == .attrBlocOpen {
                
                return index
            }
        }
        return nil
    }
    
    public func sameLevelStartBlockTokenIndexAfter(_ tokenIndex: Int) -> Int? {
        
        assert(tokenValues[tokenIndex].block)
        assert(tokenIndex < tokenValues.count)
        if tokenIndex >= tokenValues.count {
            return nil
        }
     
        let level = tokenValues[tokenIndex].level
        
        for i in tokenIndex+1..<tokenValues.count {
            
            if tokenValues[i].block && tokenValues[i].level == level && tokenValues[i].nesting == .opening {
                
                return i
            }
        }
        return nil
    }
    
    public func correspondingCloseTokenIndex(of openTokenIndex: Int) -> Int? {
     
        let openToken = tokenValues[openTokenIndex]
                
        assert(openToken.nesting == .opening)
        for i in openTokenIndex + 1..<tokenValues.count {
        
            let token = tokenValues[i]
            if openToken.level-1 == token.level && token.type == openToken.type.correspondindClosingType {
                return i
            }
        }
        return nil
    }
    
    /// Get the final block close token  index after the token 
    /// index given. 
    /// It returns also the index of the found token.
    public func secondCloseBlockTokenBefore(_ tokenIndex: Int) -> Int {
        
        var nextBlockIndexNbr = 0
        
        if tokenIndex < tokenValues.count {
            
            // return the second closing block
            for i in stride(from: tokenIndex, through: 0, by: -1) {
        
                if tokenValues[i].validTopLevelBlockEndToken {
                    if nextBlockIndexNbr > 0 {
                        return i
                    }
                    else {
                        // the first closing block is the current
                        // block closing token, we want the next.
                        nextBlockIndexNbr += 1
                    }
                }
            }
        }
        // if there is only one block after the change we will
        // fall back to complete recompilation
        return tokenValues.count - 1
    }
    
    public func index(of token: Token, withAssociatedOpenTokenRange range: NSRange, delta locationDelta: Int, from index: Int) -> Int? {
        
        // start iterating from before the end, because we know
        // we want to cut before it
        for i in index..<tokenValues.count {
            
            // TODO: remove the selfClosing condition
            if (tokenValues[i].nesting == .closing || tokenValues[i].nesting == .selfClosing)
                && tokenValues[i].block
                && tokenValues[i].level == 0 {
                
                // this token is at the right position
                let compiledAssociatedOpenTokenIndex = associatedOpenTokenIndex(of: i)
                let compiledOpenToken = tokenValues[compiledAssociatedOpenTokenIndex]
                let compiledOpenTokenRange = compiledOpenToken.sourceStringFragment?.range
                
                assert(compiledOpenTokenRange != nil)
                if let compiledOpenTokenRange = compiledOpenTokenRange {
                    
                    let location = compiledOpenTokenRange.location + locationDelta
                    
                    // the length may have changed so we cannot use the length of the range
                    if tokenValues[i].equals(to: token) && location == range.location {
                        
                        return i
                    }
                }
            }
        }
        return nil
    }
    
    /// Method to cut the tokens from the token parameter.
    /// All tokens after the token will be deleted.
    ///
    /// Since token can equal many wrong token in the compiled token, we
    /// need a way to identify it uniquely. This way is to use the associated
    /// open token range. So to make sure that two close tokens are the same
    /// we look at the positions of their associated open token. If they are
    /// the same then we know we are looking at the same close tokens.
    ///
    /// This method assumes that the range has been adjusted to include any
    /// change in position that may have occured before this method is called.
    public func cutTokensEnd(from token: Token, withAssociatedOpenTokenRange range: NSRange) {
        
        // start iterating from before the end, because we know
        // we want to cut before it 
        for i in stride(from: tokenValues.count - 1, through: 0, by: -1) {
            
            if tokenValues[i].nesting == .closing
                && tokenValues[i].block
                && tokenValues[i].level == 0 {
                
                // this token is at the right position
                let compiledAssociatedOpenTokenIndex = associatedOpenTokenIndex(of: i)
                let compiledOpenToken = tokenValues[compiledAssociatedOpenTokenIndex]
                let compiledOpenTokenRange = compiledOpenToken.sourceStringFragment?.range
                
                assert(compiledOpenTokenRange != nil)
                if let compiledOpenTokenRange = compiledOpenTokenRange {
        
                    // the length may have changed so we cannot use the length of the range 
                    if tokenValues[i].equals(to: token) && compiledOpenTokenRange.location == range.location {
                        break
                    }
                    else {
                        assert(tokenValues[i] == tokenValues.last)
                        tokenValues.removeLast()
                    }
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("compiledOpenTokenRange is nil for token type: %@.", log: Log.Markdown.all, type: .error, %%compiledOpenToken.type)
                    #endif
                    
                    // it may work but buggy, we should think of an alternate
                    // solution in case compiledOpenTokenRange is nil
                    if tokenValues[i].equals(to: token) {
                        break
                    }
                    else {
                        assert(tokenValues[i] == tokenValues.last)
                        tokenValues.removeLast()
                    }
                }
            }
            else {
                
                assert(tokenValues[i] == tokenValues.last)
                tokenValues.removeLast()
            }
        }
    }
    
    /// Method to remove all the token after the index 
    /// parameter
    public func cutEndOfTokensFrom(_ index: Int) {
    
        for _ in stride(from: tokenValues.count - 1, through: index + 1, by: -1) {

            tokenValues.removeLast()
        }
    }
    
    /// Return the token index containing the particular changeIndex.
    /// If it is not found we return nil. The caller should trig complete
    /// compilation for safety, but this situation should not occur.
//    public func tokenIndexContaining(_ changeIndex: Int) -> Int? {
//
//        var previousIndex: Int?
//        var previousRelativePosition: RelativePosition?
//
//        for (index, token) in tokenValues.enumerated() {
//
//            if token.type != .Inline && token.nesting != .closing {
//
//                let indexRelativePosition = token.indexRelativePositionFromAllFragment(changeIndex)
//
//                if indexRelativePosition == .contained {
//                    return index
//                }
//                else if indexRelativePosition == .before {
//
//                    if index == 0 {
//                        return 0
//                    }
//
//                    // if the previous relative position was after then we return the
//                    // previous index.
//                    if let previousIndex = previousIndex, let previousRelativePosition = previousRelativePosition,
//                        previousRelativePosition == .after {
//
//                        return previousIndex
//                    }
//                }
//                previousIndex = index
//                previousRelativePosition = indexRelativePosition
//            }
//        }
//
//        if let previousIndex = previousIndex, let previousRelativePosition = previousRelativePosition, previousRelativePosition == .after {
//
//            return previousIndex
//        }
//
//        #if DEBUG
//            fatalError("programming error: token index should not be nil.")
//        #else
//            debugPrint("programming error: token index should not be nil.")
//        #endif
//
//        return nil
//    }
    
    public func equals(to other: Tokens, comparePositions: Bool = false, compareChildren: Bool = false) -> Bool {
        
        if length != other.length {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Not equals: length is different.", log: Log.Markdown.all, type: .debug)
            #endif
            return false
        }
        
        for i in 0..<tokenValues.count {
            
            let token = tokenValues[i]
            let otherToken = other.tokenValues[i]
            
            if !token.equals(to: otherToken, comparePositions: comparePositions, compareChildren: compareChildren) {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not equals: token element is different.", log: Log.Markdown.all, type: .debug)
                #endif
                return false
            }
        }
        
        return true
    }
    
    /// Generate a String representation of the Tokens
    public func toString(includePosition: Bool = false) -> String {
        
        var str = "[\n"
        
        for (index,token) in tokenValues.enumerated() {
            
            str += token.toString(includePosition: includePosition)
            
            if index != tokenValues.count - 1 {
                str += ",\n"
            }
            else {
                str += "\n"
            }
        }
        str += "]\n"
        return str 
    }
}
