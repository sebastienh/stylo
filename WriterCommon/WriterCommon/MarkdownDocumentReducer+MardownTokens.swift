//
//  MarkdownDocumentReducer+MardownTokens.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Markdown
import Web
import Common
import PromiseKit
import os

extension MarkdownDocumentReducer {
    
    /// Return value: the DOM nodes deleted in case of a partial compilation, if this value
    /// is nil we can assume it was a complete compilation.
    func compileTokens(markdownDocumentStore: MarkdownDocumentStore, sourceStringChangeDescription: SourceStringChangeDescription, recompilation: Bool = false) -> MarkdownCompilationResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start compileTokens", log: Log.WriterCommon.all, type: .info)
        #endif
        
        if let markdownTokens = markdownDocumentStore.markdownTokens, markdownTokens.length > 5 {
            
            // early exit if the change length is zero
            // only in the case where it's not a recompilation request
            if !(sourceStringChangeDescription.changeLength == 0 && sourceStringChangeDescription.utf16SubsequenceReplacement.count == 0 &&
                !recompilation) {
                
                // get the tokens range associated with the changeIndex
                // Note: the range is excluding the last index.
                    
                let originalTokenRange = markdownTokens.rangeOfBlockTokensAround(changeDescription: sourceStringChangeDescription)
                
                assert(originalTokenRange != nil)
                if var originalTokenRange = originalTokenRange {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("originalTokenRange: %@", log: Log.WriterCommon.all, type: .info, %%originalTokenRange)
                    #endif
                    assert(originalTokenRange.lowerBound <= originalTokenRange.upperBound)
                    
                    // we are asked to recompile everything
                    if originalTokenRange.count == markdownTokens.length {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Markdown complete compilation...", log: Log.WriterCommon.all, type: .info)
                        #endif
                        
                        // make sure we clean the existring references since we will recreate then all
                        markdownDocumentStore.env!.clean()
                        
                        let string = sourceStringChangeDescription.targetString.string
                        let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName)
                        let tokens = mardownParser.parse(string, env: markdownDocumentStore.env)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("end", log: Log.WriterCommon.all, type: .info)
                        #endif
                        return MarkdownCompilationResult.complete(tokens: tokens)
                    }
                    else {
                        
                        let oldReferencesSignature = markdownDocumentStore.env!.referencesSignature
                        
                        var partialCompilationResult = partialCompileMarkdown(markdownTokens: markdownTokens, originalTokenRange: originalTokenRange, description: sourceStringChangeDescription, markdownDocumentStore: markdownDocumentStore)
                        
                        if !recompilation {
                        
                            let newReferencesSignature = markdownDocumentStore.env!.referencesSignature
                        
                            if newReferencesSignature != oldReferencesSignature {
                        
                                // for each referencing token that may have been affeted
                                // we request a recompilation.
                                let env = markdownDocumentStore.env
                                
                                assert(env != nil)
                                if let env = env {
                                    
                                    var recompileRequiredRanges = [NSRange]()
                                    
                                    func addTokenToCompilationRequiredRanges(referencingToken: Token) {
                                        
                                        let tokenFragment = referencingToken.sourceStringFragment
                                        
                                        assert(tokenFragment != nil)
                                        if let tokenFragment = tokenFragment {
                                            
                                            let tokenRange = tokenFragment.range
                                            
                                            assert(tokenRange != nil)
                                            if let tokenRange = tokenRange {
                                                
                                                recompileRequiredRanges.append(tokenRange)
                                            }
                                        }
                                    }
                                    
                                    if let affectedReferencesKeys = partialCompilationResult?.affectedReferencesKeys {
                                    
                                        // keep a local copy since we will modify the env
                                        let referencingTokens = env.referencingTokens
                                        
                                        for referencingToken in referencingTokens {
                                            
                                            if referencingToken.type == .image || referencingToken.type == .linkOpen {
                                                if let referenceLabel = referencingToken.referenceLabel {
                                                    if affectedReferencesKeys.contains(referenceLabel) {
                                                        addTokenToCompilationRequiredRanges(referencingToken: referencingToken)
                                                    }
                                                }
                                            }
                                            else {
                                                assert(referencingToken.type == .text)
                                                addTokenToCompilationRequiredRanges(referencingToken: referencingToken)
                                            }
                                        }
                                        partialCompilationResult?.recompileRequiredRanges = recompileRequiredRanges
                                    }
                                }
                            }
                        }
                        
                        assert(partialCompilationResult != nil)
                        if let partialCompilationResult = partialCompilationResult {
                            
                            return MarkdownCompilationResult.partial(partialCompilationResult)
                        }
                    }
                }
            }
            else {
                
                // the early exit
                return nil
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Markdown complete compilation...", log: Log.WriterCommon.all, type: .info)
            #endif
            // complete compilation
            // see comment above
            markdownDocumentStore.env?.clean()
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("end", log: Log.WriterCommon.all, type: .info)
            #endif
            let string = sourceStringChangeDescription.targetString.string
            let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName)
            let tokens = mardownParser.parse(string, env: markdownDocumentStore.env)
            return MarkdownCompilationResult.complete(tokens: tokens)
        }
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Previous errors cause Markdown compilation to fail.", log: Log.WriterCommon.all, type: .error)
        #endif
        return nil
    }
    
    private func partialCompileMarkdown(markdownTokens: Tokens, originalTokenRange: Range<Int>, description: SourceStringChangeDescription, markdownDocumentStore: MarkdownDocumentStore) -> MarkdownPartialCompilationResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        let tokensString = markdownTokens.toString()
        os_log("original tokens: %@", log: Log.WriterCommon.all, type: .info, %%tokensString)
        os_log("start: markdown partial compilation...", log: Log.WriterCommon.all, type: .info)
        #endif
        
        let startBlock = markdownTokens[originalTokenRange.lowerBound]!
        let globalStartIndex = startBlock.startStringIndex
        
        // when we compile the end of the document, it's simple
        // we just compile it and replace evrything with the
        // the compiled tokens
        if originalTokenRange.upperBound == markdownTokens.length {
            
            // the string extract always return from the startToken index until the end
            let stringExtract = markdownTokens.pessimisticStringExtract(originalTokenRange: originalTokenRange, description: description)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("stringExtract:\n%@", log: Log.WriterCommon.all, type: .info, %%stringExtract)
            #endif
            
            let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName, cleanReferencesAsParsing: true, globalPositionOffset: globalStartIndex)
            
            var globalEndIndex = description.targetString.length
            
            // we should adjust this globakEndIndex with the
            // description length change.
            globalEndIndex -= description.changeLength
            let length = globalEndIndex - globalStartIndex
            
            let correspondingOriginaRange = NSMakeRange(globalStartIndex, length)
            
            assert(markdownDocumentStore.env != nil)
            let sensibleReferences = markdownDocumentStore.env?.clean(in: correspondingOriginaRange)
            
            let afterCompilationStartIndex = globalStartIndex + length
            
            markdownDocumentStore.env?.moveReferences(after: afterCompilationStartIndex, by: description.changeLength)
            
            // parse the extracted range
            let computedTokens = mardownParser.parse(stringExtract as String, env: markdownDocumentStore.env)
            
            var referencesLabels = mardownParser.compiledReferencesLabels
            
            // Remove the common labels, which are the ones
            // that didn't change.
            assert(sensibleReferences != nil)
            if let sensibleReferences = sensibleReferences {
                for sensibleReference in sensibleReferences {
                    referencesLabels.insert(sensibleReference)
                }
            }
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            let computedTokensString = computedTokens.toString()
            os_log("complete computedTokens tokens: %@", log: Log.WriterCommon.all, type: .info, %%computedTokensString)
            #endif
            
            return compileEnd(markdownTokens: markdownTokens, replaceTokenRange: originalTokenRange, description: description, markdownDocumentStore: markdownDocumentStore, computedTokens: computedTokens, referencesLabels: referencesLabels)
            
        }
        else {
            
            // get the range from it
            // this is the range we should try to stop at
            // This range is the range start of the token after
            // the range we really want to compile
            let range = markdownTokens.computeOptimisticStopRange(originalTokenRange: originalTokenRange, description: description)
            
            assert(range != nil)
            if let range = range {
                
                var stopped: Bool = false
                var computedTokens: Tokens?
                
                var referencesLabels = Set<String>()
                
                // the string extract always return from the startToken index until the end
                if let stringExtract = markdownTokens.optimisticStringExtract(optimisticTokenRange: originalTokenRange, description: description) {
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("stringExtract:\n%@", log: Log.WriterCommon.all, type: .info, %%stringExtract)
                    #endif
                
                    let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName, stopOpeningTokenRange: range, cleanReferencesAsParsing: true, globalPositionOffset: globalStartIndex)
                
                    let endBlock = markdownTokens[originalTokenRange.upperBound]!
                    var globalEndIndex = endBlock.startStringIndex
                    
                    // we should adjust this globakEndIndex with the
                    // description length change.
                    globalEndIndex -= description.changeLength
                    let length = globalEndIndex - globalStartIndex
                    
                    // we only to delete references in the real original range
                    // no need to modify anything
                    let originaRange = NSMakeRange(globalStartIndex, endBlock.startStringIndex - globalStartIndex)
                    
                    assert(markdownDocumentStore.env != nil)
                    let sensibleReferences = markdownDocumentStore.env?.clean(in: originaRange)
                    
                    let compilationEndIndex = globalStartIndex + length
                    
                    assert(markdownDocumentStore.env != nil)
                    markdownDocumentStore.env?.moveReferences(after: compilationEndIndex, by: description.changeLength)
                    
                    // parse the extracted range
                    computedTokens = mardownParser.parse(stringExtract as String, env: markdownDocumentStore.env, stopped: &stopped)
                    
                    assert(sensibleReferences != nil)
                    if let sensibleReferences = sensibleReferences {
                        for sensibleReference in sensibleReferences {
                            referencesLabels.insert(sensibleReference)
                        }
                    }
                    
                    for compiledReference in mardownParser.compiledReferencesLabels {
                        referencesLabels.insert(compiledReference)
                    }
                }
                
                if let computedTokens = computedTokens, stopped {
                    
                    // update the fragments of the computed tokens
                    // only if we didn't compile from the start of the document
                    if originalTokenRange.lowerBound != 0 {
                        
                        let env = markdownDocumentStore.env
                        
                        assert(env != nil)
                        if let env = env {
                            
                            computedTokens.move(globalStartIndex, env: env)
                        }
                    }
                    
                    #if DEBUG
                    let nesting = computedTokens[computedTokens.length-1]!.nesting
                    assert(nesting == .closing || nesting == .selfClosing)
                    #endif
                    
                    return compile(markdownTokens: markdownTokens, originalTokenRange: originalTokenRange, description: description, markdownDocumentStore: markdownDocumentStore, computedTokens: computedTokens, affectedReferencesKeys: referencesLabels)
                }
                else {
                    
                    // the string extract always return from the startToken index until the end
                    let stringExtract = markdownTokens.pessimisticStringExtract(originalTokenRange: originalTokenRange, description: description)
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("stringExtract:\n%@", log: Log.WriterCommon.all, type: .info, %%stringExtract)
                    #endif
                    
                    let mardownParser = MarkdownParser(presetName: markdownDocumentStore.markdownPresetName, stopOpeningTokenRange: range, cleanReferencesAsParsing: true, globalPositionOffset: globalStartIndex)
                    
                    var globalEndIndex = description.targetString.length
                    
                    // we should adjust this globakEndIndex with the
                    // description length change.
                    globalEndIndex -= description.changeLength
                    let length = globalEndIndex - globalStartIndex
                    
                    // we only to delete references in the real original range
                    // no need to modify anything
                    let originaRange = NSMakeRange(globalStartIndex, length)
                    
                    assert(markdownDocumentStore.env != nil)
                    let sensibleReferences = markdownDocumentStore.env?.clean(in: originaRange)
                    
                    var stopped: Bool = false
                    // parse the extracted range
                    let computedTokens = mardownParser.parse(stringExtract as String, env: markdownDocumentStore.env, stopped: &stopped)
                    
                    assert(sensibleReferences != nil)
                    if let sensibleReferences = sensibleReferences {
                        for sensibleReference in sensibleReferences {
                            referencesLabels.insert(sensibleReference)
                        }
                    }
                    
                    for compiledReference in mardownParser.compiledReferencesLabels {
                        referencesLabels.insert(compiledReference)
                    }
                    
                    let endTokensRange = originalTokenRange.lowerBound..<markdownTokens.length
                    
                    return compileEnd(markdownTokens: markdownTokens, replaceTokenRange: endTokensRange, description: description, markdownDocumentStore: markdownDocumentStore, computedTokens: computedTokens, referencesLabels: referencesLabels)
                }
            }
        }
        return nil
    }
    
    private func compileEnd(markdownTokens: Tokens, replaceTokenRange tokenRange: Range<Int>, description: SourceStringChangeDescription, markdownDocumentStore: MarkdownDocumentStore, computedTokens: Tokens, referencesLabels: Set<String>) -> MarkdownPartialCompilationResult {
        
        // update the fragments of the computed tokens from the lower bound
        // only if we didn't compile from the start of the document
        if tokenRange.lowerBound != 0 {
            
            let startBlock = markdownTokens[tokenRange.lowerBound]!
            let env = markdownDocumentStore.env
            
            assert(env != nil)
            if let env = env {
            
                computedTokens.move(startBlock.startStringIndex, env: env)
            }
        }
        
        let markdownDocument = markdownDocumentStore.document.value as! HtmlDocument
        let deletedDomNodes = collectTopDomNodes(fromTokenRange: tokenRange, inTokens: markdownTokens, from: markdownDocument)
        
        let attributesBlocsChange = computeAttributesBlocsChange(recompiledTokenRange: tokenRange, replacingTokens: computedTokens, currentTokens: markdownTokens, changeLength: description.changeLength)
        
        // replace the tokens with the new claculated tokens
        markdownTokens.replaceTokensSubrange(tokenRange, with: computedTokens.tokenValues)
        
        updateTokensPositions(markdownDocumentStore: markdownDocumentStore, tokenRange: tokenRange, computedTokens: computedTokens, changeLength: description.changeLength)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end", log: Log.WriterCommon.all, type: .info)
        #endif
        return MarkdownPartialCompilationResult(tokens: computedTokens, deletedTopDomNodes: deletedDomNodes, changeDescription: description, affectedReferencesKeys: referencesLabels, attributesBlocsChange: attributesBlocsChange)
    }

    private func compile(markdownTokens: Tokens, originalTokenRange: Range<Int>, description: SourceStringChangeDescription, markdownDocumentStore: MarkdownDocumentStore, computedTokens: Tokens, affectedReferencesKeys: Set<String>) -> MarkdownPartialCompilationResult {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("cut computedTokens tokens: %@", log: Log.WriterCommon.all, type: .info, %%computedTokens.toString())
        os_log("number of compiled top tokens left: %d", log: Log.WriterCommon.all, type: .info, computedTokens.length)
        #endif
        
        let tokenRange = originalTokenRange.lowerBound..<originalTokenRange.upperBound
        let markdownDocument = markdownDocumentStore.document.value as! HtmlDocument
        let deletedDomNodes = collectTopDomNodes(fromTokenRange: tokenRange, inTokens: markdownTokens, from: markdownDocument)
        
        // we need to do this before we replace the tokens since we need to know the difference
        // between the current tokens and the new ones
        let attributesBlocsChange = computeAttributesBlocsChange(recompiledTokenRange: tokenRange, replacingTokens: computedTokens, currentTokens: markdownTokens, changeLength: description.changeLength)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        switch attributesBlocsChange {
        case .modified(let attributes):
            os_log("Number of modified attributes %@", log: Log.WriterCommon.all, type: .info, %%attributes.count)
        case .all:
            os_log("All attributes have been modified", log: Log.WriterCommon.all, type: .info)
        case .none:
            os_log("No attributes have been modified", log: Log.WriterCommon.all, type: .info)
        }
        #endif
        
        // replace the tokens with the new claculated tokens
        markdownTokens.replaceTokensSubrange(tokenRange, with: computedTokens.tokenValues)
        
        updateTokensPositions(markdownDocumentStore: markdownDocumentStore, tokenRange: tokenRange, computedTokens: computedTokens, changeLength: description.changeLength)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end", log: Log.WriterCommon.all, type: .info)
        #endif
        return MarkdownPartialCompilationResult(tokens: computedTokens, deletedTopDomNodes: deletedDomNodes, changeDescription: description, affectedReferencesKeys: affectedReferencesKeys, attributesBlocsChange: attributesBlocsChange)
    }
    
    private func computeAttributesBlocsChange(recompiledTokenRange: Range<Int>, replacingTokens: Tokens, currentTokens: Tokens, changeLength: Int) -> AttributesBlocsChange {
        
        if currentTokens.length == recompiledTokenRange.upperBound {
            return .all
        }
        else {
            
            let currentAttributesBlocs = currentTokens.collectTopLevelAttributesBlocs(in: recompiledTokenRange)
            let compiledAttributesBlocs = replacingTokens.collectTopLevelAttributesBlocs(in: 0..<replacingTokens.length)
            
            return currentAttributesBlocs.attributesBlocsChange(from: compiledAttributesBlocs, otherPositionChange: changeLength)
        }
    }
    
    private func updateTokensPositions(markdownDocumentStore: MarkdownDocumentStore, tokenRange: Range<Int>, computedTokens: Tokens, changeLength: Int) {
        
        let env = markdownDocumentStore.env
        
        assert(markdownDocumentStore.markdownTokens != nil)
        assert(env != nil)
        if let markdownTokens = markdownDocumentStore.markdownTokens, let env = env, changeLength != 0 {
            
            #if DEBUG
            var treatedNodes = Set<Node>()
            for i in tokenRange.lowerBound + computedTokens.length..<markdownTokens.length {
                
                let associatedDomNodes = markdownTokens[i]!.getAssociatedDomNodes()
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                for associatedDomNode in associatedDomNodes {
                    debugPrint("before associatedDomNode segment: \(associatedDomNode.sourceStringSegment)")
                    if let element = associatedDomNode as? Element {
                        for (name, segment) in element.markdownAssociatedPseudoElements {
                            debugPrint("brefore pseudo \(name) segment: \(segment)")
                        }
                    }
                }
                #endif
                
                for associatedDomNode in associatedDomNodes {
                    assert(!treatedNodes.contains(associatedDomNode))
                }
                
                markdownTokens[i]!.move(changeLength, env: env)
                
                // make sure we dont move an element more than once
                for associatedDomNode in associatedDomNodes {
                    treatedNodes.insert(associatedDomNode)
                }
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                for associatedDomNode in associatedDomNodes {
                    debugPrint("after associatedDomNode segment: \(associatedDomNode.sourceStringSegment)")
                    if let element = associatedDomNode as? Element {
                        for (name, segment) in element.markdownAssociatedPseudoElements {
                            debugPrint("after pseudo \(name) segment: \(segment)")
                        }
                    }
                }
                #endif
            }
            #else
            Activity.initiate("Update tokens positions") {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("start update tokens positions", log: Log.WriterCommon.all, type: .info)
                #endif
                // update the fragments after the inserted ones
                
                let low = tokenRange.lowerBound + computedTokens.length
                let high = markdownTokens.length
                let totalTokens = high - low
                
                DispatchQueue.global(qos: .userInteractive).sync {
                    DispatchQueue.concurrentPerform(iterations: totalTokens) { i in
                        if let unmanagedToken = markdownTokens.unsafeToken(at: i+low) {
                            unmanagedToken._withUnsafeGuaranteedRef {
                                $0.move(changeLength, env: env)
                            }
                        }
                    }
                }
            }
            #endif
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("end update tokens positions", log: Log.WriterCommon.all, type: .info)
        #endif
    }
    
    /// Collect all the deleted elements from the dom,
    /// not only the the parents of them, all of them.
    /// We want to collect all the elements since we want
    /// to keep a reference to deleted elements because
    /// we want to delete the style associated with them later.
    func collectTopDomNodes(fromTokenRange range: Range<Int>, inTokens tokens: Tokens, from document: HtmlDocument) -> ContiguousArray<Node> {
        
        var nodes = ContiguousArray<Node>()
        let body = document.body
        
        for i in range.lowerBound..<range.upperBound {
            
            let associatedNodes = tokens[i]!.getAssociatedDomNodes()
            
            #if false
            debugPrint("nodes associated with token: \(tokens[i]!.type)")
            
            for node in associatedNodes {
                if let element = node as? Element {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    debugPrint("adding node to delete: \(element.localName)")
                    debugPrint("path of node to delete: \(element.path)")
                    #endif
                }
                else {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    debugPrint("adding node to delete: \(node.nodeName)")
                    debugPrint("path of node to delete: \(node.path)")
                    #endif 
                    
                    if node.path.count == 0 {
                        
                        debugPrint("node path: \(node.path)")
                    }
                }
            }
            #endif
            for associatedNode in associatedNodes {
                if associatedNode.parentNode === body {
                    nodes.append(associatedNode)
                }
            }
        }
        return nodes
    }
    
}



