//
//  CSSStyleSheet+IncrementalCompilation.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-06-05.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension CSSStyleSheet {
    
    public var styleRulesCount: Int {
        
        return self.cssRules.length
    }
    
    public subscript(index: Int) -> CSSRule? {
        
        get {
            return cssRules[index]
        }
        set(styleRule) {
            
            cssRules[index] = styleRule
        }
    }
    
    public func updateSelectorList(startCompilationRuleIndex: Int?, stoppedCompilationRuleIndex: Int?, compiledStylesheet: CSSStyleSheet, description: SourceStringChangeDescription) -> StylesheetCompilationResult {
        
        if let startCompilationRuleIndex = startCompilationRuleIndex, let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex, startCompilationRuleIndex == stoppedCompilationRuleIndex {
            
            compiledStylesheet.updateCommentsRange(fromRuleIndex: startCompilationRuleIndex, inStylesheet: self)
            
            return self.updateSelectors(inRuleAtIndex: startCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
        }

        return self.updateStylesheetRules(startCompilationRuleIndex: startCompilationRuleIndex, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
    }
    
    ///
    /// When we call this method is because we know we stopped the compilation
    /// and only need to update the selector list in the rule at `ruleIndex`.
    ///
    public func updateSelectors(inRuleAtIndex ruleIndex: Int, compiledStylesheet: CSSStyleSheet, description: SourceStringChangeDescription) -> StylesheetCompilationResult {
        
        guard let startStringIndex = self.startStringIndexFromRule(at: ruleIndex) else {
            assertionFailure("Error: startStringIndex is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("startStringIndex is nil... triggering complete recompilation", log: Log.Web.all, type: .error)
            #endif
            return StylesheetCompilationResult.complete(stylesheet: compiledStylesheet)
        }
                
            // update rules positions in the compiled stylesheet
            // to be in sync with the position in the current stylesheet
        compiledStylesheet.updateRulesPositions(fromRuleIndex: 0, changeLength: startStringIndex)
        
        let deletedSelectorListDomNodes = self.collectDeletedSelectorListDomNodes(fromStyleRuleAtIndex: ruleIndex)
        
        guard let selectorList = compiledStylesheet.firstSelectorList else {
            assertionFailure("Error: selectorList is nil")
            return StylesheetCompilationResult.complete(stylesheet: compiledStylesheet)
        }
        
        self.replaceOldSelectorList(atRuleIndex: ruleIndex, with: selectorList)
        
        // update all positions
        self.updatePositions(afterSelectorListInRuleAtIndex: ruleIndex, changeLength: description.changeLength)

        return StylesheetCompilationResult.selectorList(deletedTopNodes: deletedSelectorListDomNodes, partialStylesheet: compiledStylesheet, selectorList: selectorList, ruleIndex: ruleIndex)
    }
    
    
    ///
    /// When we cal this method is because we know we stopped the compilation
    /// and only need to update the declarations list in the rule at `ruleIndex`.
    ///
    public func updateDeclarationsRange(inRuleAtIndex ruleIndex: Int, declarationsRange: Range<Int>, compiledDeclarationRange: Range<Int>?, compilationStringStartIndex: Int, compiledStylesheet: CSSStyleSheet, description: SourceStringChangeDescription) -> StylesheetCompilationResult {
        
        let declarationIndex = declarationsRange.lowerBound != -1 ? 0 : -1
        
        guard let compiledResultStartPosition = compiledStylesheet.declarationStartIndex(atDeclarationIndex: declarationIndex, inRuleAtIndex: 0) else {
            assertionFailure("Error: firstDeclarationOriginalPosition is nil")
            return StylesheetCompilationResult.complete(stylesheet: compiledStylesheet)
        }
        
        let difference = compilationStringStartIndex - compiledResultStartPosition
        
        // update rules positions in the compiled stylesheet
        // to be in sync with the position in the current stylesheet
        compiledStylesheet.updateRulesPositions(fromRuleIndex: 0, changeLength: difference)
        
        let deletedSelectorListDomNodes = self.collectDeletedDeclarationsDomNodes(fromStyleRuleAtIndex: ruleIndex, declarationsRange: declarationsRange)
        
        guard let declarations: [CSDeclaration] = compiledStylesheet.declarationsFromFirstRule else {
            assertionFailure("Error: declarations is nil")
            return StylesheetCompilationResult.complete(stylesheet: compiledStylesheet)
        }
        
        self.replaceDeclarationsRange(atRuleIndex: ruleIndex, declarationsRange: declarationsRange, with: declarations)
        
        // update all positions
        self.updatePositions(afterDeclarationsRange: declarationsRange, inRuleAtIndex: ruleIndex, changeLength: description.changeLength)

        return StylesheetCompilationResult.declarations(deletedTopNodes: deletedSelectorListDomNodes, partialStylesheet: compiledStylesheet, ruleIndex: ruleIndex, declarationsRange: declarationsRange)
    }
    
    private func declarationStartIndex(atDeclarationIndex declarationIndex: Int, inRuleAtIndex ruleIndex: Int) -> Int? {
        
        guard let styleRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil at index: \(ruleIndex)")
            return nil
        }
        
        if declarationIndex == -1 {
            
            guard let startStringIndex = styleRule.style?.startStringIndex else {
                assertionFailure("Error: startStringIndex is nil")
                return nil
            }
            return startStringIndex+1
        }
        else {
        
            guard let declaration = styleRule.style?.declaration(atIndex: declarationIndex) else {
                assertionFailure("Error: declaration is nil at index: \(declarationIndex)")
                return nil
            }
            
            return declaration.startStringIndex
        }
    }
    
    public func updateCommentsRange(fromRuleIndex ruleIndex: Int, inStylesheet stylesheet: CSSStyleSheet) {
        
        guard let startStringIndex = stylesheet.startStringIndexFromRule(at: ruleIndex) else {
            assertionFailure("Error: startStringIndex is nil")
            return
        }
        
        self.moveComments(by: startStringIndex)
    }
    
    public func updateStylesheetRules(startCompilationRuleIndex: Int?, stoppedCompilationRuleIndex: Int?, compiledStylesheet: CSSStyleSheet, description: SourceStringChangeDescription) -> StylesheetCompilationResult {
        
        if let startCompilationRuleIndex = startCompilationRuleIndex {
            
            if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
                
                let rulesRange = startCompilationRuleIndex..<stoppedCompilationRuleIndex
                
                compiledStylesheet.updateCommentsRange(fromRuleIndex: rulesRange.lowerBound, inStylesheet: self)
                
                return self.updateRulesRange(rulesRange, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
            }
            else {
                
                let rulesRange = startCompilationRuleIndex..<self.styleRulesCount
                
                compiledStylesheet.updateCommentsRange(fromRuleIndex: rulesRange.lowerBound, inStylesheet: self)
                
                return self.updateRulesRange(rulesRange, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
            }
        }
        else if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
            
            return self.updateRulesRange(0..<stoppedCompilationRuleIndex, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
        }
        
        return StylesheetCompilationResult.replace(stylesheet: compiledStylesheet, deletedTopNodes: self.collectAllStylesheetDeletedRulesDomNodes())
    }
    
    /// Function that updates the stylesheet with the compiledStylesheet rules.
    /// The stoppedCompilationRuleIndex is needed here because the rulesRanges
    /// doesn't tell us if the compilation was until the end or not and we want
    // to keep this specific information for later.
    public func updateRulesRange(_ rulesRange: CountableRange<Int>, stoppedCompilationRuleIndex: Int?, compiledStylesheet: CSSStyleSheet, description: SourceStringChangeDescription) -> StylesheetCompilationResult {
    
        let startStringIndex = self.startStringIndexFromRule(at: rulesRange.lowerBound)
        let numberOfInsertedRules = compiledStylesheet.cssRules.length
        
        assert(startStringIndex != nil)
        if let startStringIndex = startStringIndex {
            
            if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex, stoppedCompilationRuleIndex == 0 {
            
                // we inseted at the start so we don't need to do anything
            }
            else {
            
                // update rules positions in the compiled stylesheet
                compiledStylesheet.updateRulesPositions(fromRuleIndex: 0, changeLength: startStringIndex)
            }
            let deletedRulesDomNodes = self.collectDeletedRulesDomNodes(fromStyleRuleRange: rulesRange)
            
            self.replaceOldStyleRules(in: rulesRange, with: compiledStylesheet.cssRules)
            
            // update all positions
            self.updateRulesPositions(fromRuleIndex: rulesRange.lowerBound+numberOfInsertedRules, changeLength: description.changeLength)
            
            if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
            
                let rulesLengthChange = numberOfInsertedRules - rulesRange.count
                
                return StylesheetCompilationResult.rules(deletedTopNodes: deletedRulesDomNodes, partialStylesheet: compiledStylesheet, updatedStoppedCompilationRuleIndex: stoppedCompilationRuleIndex + rulesLengthChange)
            }
            else {
                
                return StylesheetCompilationResult.rules(deletedTopNodes: deletedRulesDomNodes, partialStylesheet: compiledStylesheet, updatedStoppedCompilationRuleIndex: nil)
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("startStringIndex is nil... triggering complete recompilation", log: Log.Web.all, type: .error)
            #endif
            assert(false)
            return StylesheetCompilationResult.complete(stylesheet: compiledStylesheet)
        }
    }
    
    /// Remove the tokens between the first start block token before
    /// the changeIndex and the first start block token after non-inclusively and
    /// return the index of the first start block token before.
    public func rulesAdjacency(_ range: NSRange) -> RangeElementsAdjacency? {
        
        return self.cssRules.rules.adjacencies(from: range)
    }

    
    public func replaceDeclarationsRange(atRuleIndex ruleIndex: Int, declarationsRange: Range<Int>, with declarations: [CSDeclaration]) {
    
        guard let styleRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return
        }
     
        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return
        }
        
        let adjustedDeclarationsRange = styleDeclaration.adjustedDeclarationsRange(fromRange: declarationsRange)
        
        styleDeclaration.removePropertyDeclarations(inRange: adjustedDeclarationsRange)
        
        let originalInsertionIndex = adjustedDeclarationsRange.lowerBound
        for (index, declaration) in declarations.enumerated() {
            let insertionIndex = originalInsertionIndex + index
            styleDeclaration.insertPropertyDeclaration(declaration.propertyName, declaration: declaration, atIndex: insertionIndex)
        }
        
        styleDeclaration.clearDeclarationsData()
        styleDeclaration.updateDeclarationsData(computePropertyValues: true)
    }
    
    public func replaceOldSelectorList(atRuleIndex ruleIndex: Int, with selectorList: SelectorList) {
    
        guard let styleRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return
        }
        
        styleRule.selectorList = selectorList
    }
    
    /// Function to replace the rules in a range with the rules
    /// as parameter.
    ///
    /// Note: there could be no rules to replace with, in this case
    /// we just delete the rules to replace.
    public func replaceOldStyleRules(in range: CountableRange<Int>, with rules: CSSRuleList) {
        
        for _ in range.lowerBound..<range.upperBound {

            self.deleteRule(at: range.lowerBound)
        }
        
        for i in 0..<rules.length {
            
            let rule = rules[i]
            
            assert(rule != nil)
            if let rule = rule {
                self.insertRule(rule, at: range.lowerBound + i)
            }
        }
    }
    
    public func removeComments(inOriginalStringRange range: Range<Int>?) {
        if let range = range {
            self.removeComments(in: range)
        }
        else {
            self.removeAllComments()
        }
    }

    public func updatePositions(afterDeclarationsRange declarationsRange: Range<Int>, inRuleAtIndex ruleIndex: Int, changeLength: Int) {
        
        guard let styleRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil at index: \(ruleIndex)")
            return
        }
        
        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return
        }
        
        // move declarations after
        if styleDeclaration.propertyStyleDeclarations.count > declarationsRange.upperBound {
            for i in declarationsRange.upperBound..<styleDeclaration.propertyStyleDeclarations.count {
                styleDeclaration.propertyStyleDeclarations[i].1.move(changeLength)
            }
        }
            
        styleRule.style?.sourceStringSegment?.moveEnd(changeLength)
        styleRule.updatePosition()
        
        // move all the remaining rules
        self.updateRulesPositions(fromRuleIndex: ruleIndex+1, changeLength: changeLength)
    }
    
    public func updatePositions(afterSelectorListInRuleAtIndex ruleIndex: Int, changeLength: Int) {
        
        guard let styleRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil at index: \(ruleIndex)")
            return
        }
        
        styleRule.style?.move(changeLength)
        
        // move all the remaining rules
        self.updateRulesPositions(fromRuleIndex: ruleIndex+1, changeLength: changeLength)
    }

    public func updateDeclarationsPositions(fromRuleIndex index: Int = 0, changeLength: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start update stylesheet positions from index: %@", log: Log.Web.all, type: .info, %%index)
        #endif
        // update the fragments after the inserted ones
        
        let low = index
        let high = self.styleRulesCount
        let totalRules = high - low

        #if DEBUG
        for i in low..<high {
            moveRule(at: i, by: changeLength)
        }
        #else
        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
            DispatchQueue.concurrentPerform(iterations: totalRules) { [weak self] i in
                self?.moveRule(at: i+low, by: changeLength)
            }
        }
        #endif
    }
    
    public func updateRulesPositions(fromRuleIndex index: Int, changeLength: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start update stylesheet positions from index: %@", log: Log.Web.all, type: .info, %%index)
        #endif
        // update the fragments after the inserted ones
        
        let low = index
        let high = self.styleRulesCount
        let totalRules = high - low

        #if DEBUG
        for i in low..<high {
            moveRule(at: i, by: changeLength)
        }
        #else
        DispatchQueue.global(qos: .userInitiated).sync { [weak self] in
            DispatchQueue.concurrentPerform(iterations: totalRules) { [weak self] i in
                self?.moveRule(at: i+low, by: changeLength)
            }
        }
        #endif
    }
    
    public func moveRule(at index: Int, by count: Int) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Updating position at index: %d.", log: Log.Web.all, type: .info, index)
        #endif
        
        assert(self[index] != nil)
        self[index]?.move(count)
        
        #if DEBUG
        let sourceStringSegment = self[index]?.sourceStringSegment
        assert(sourceStringSegment != nil)
        if let sourceStringSegment = sourceStringSegment {
            assert(sourceStringSegment.startIndex >= 0)
            assert(sourceStringSegment.startIndex <= sourceStringSegment.endIndex)
        }
        #endif
    }
    
    /// Collect all the deleted elements from associated with the
    /// selector list in the rule at ruleIndex.
    public func collectDeletedSelectorListDomNodes(fromStyleRuleAtIndex index: Int) -> ContiguousArray<Node> {
        
        guard let styleRule = self[index] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return ContiguousArray<Node>()
        }
            
        guard let associatedNodes = styleRule.selectorList?.associatedDomNodes else {
            assertionFailure("Error: associatedNodes is nil")
            return ContiguousArray<Node>()
        }
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("nodes associated with rule: %@", log: Log.Web.all, type: .info, %%rule.type)
        logAssociatedNodes(associatedNodes: associatedNodes)
        #endif
        
        return associatedNodes
    }
    
    /// Collect all the deleted elements from associated with the
    /// selector list in the rule at ruleIndex.
    public func collectDeletedDeclarationsDomNodes(fromStyleRuleAtIndex index: Int, declarationsRange: Range<Int>) -> ContiguousArray<Node> {
        
        guard let styleRule = self[index] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil")
            return ContiguousArray<Node>()
        }

        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return ContiguousArray<Node>()
        }

        var associatedNodes = ContiguousArray<Node>()

        // because it can contain -1 and Int.max
        let adjustedDeclarationRange = styleDeclaration.adjustedDeclarationsRange(fromRange: declarationsRange)
        
        for i in adjustedDeclarationRange {

            guard let declaration = styleDeclaration.declaration(atIndex: i) else {
                assertionFailure("Error: declaration is nil")
                continue
            }

            guard let associatedDomNodes = declaration.associatedDomNodes else {
//                assertionFailure("Error: associatedDomNodes is nil")
                continue
            }
            
            associatedNodes.append(contentsOf: associatedDomNodes)
        }

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("nodes associated with rule: %@", log: Log.Web.all, type: .info, %%rule.type)
        logAssociatedNodes(associatedNodes: associatedNodes)
        #endif
        
        return associatedNodes
    }
    
    public func collectAllStylesheetDeletedRulesDomNodes() -> ContiguousArray<Node>? {
        if !self.cssRules.isEmpty {
            return self.collectDeletedRulesDomNodes(fromStyleRuleRange: 0..<self.cssRules.length)
        }
        return nil
    }
    
    public func startStringIndexFromRule(at index: Int) -> Int? {
        
        let rule = self[index]
        
        // the block after the last one
        assert(rule != nil)
        if let rule = rule {
            
            return rule.startStringIndex
        }
        return nil
    }
    
    public func endStringIndexFromRule(at index: Int) -> Int? {
        
        let rule = self[index]
        
        // the block after the last one
        assert(rule != nil)
        if let rule = rule {
            
            return rule.endStringIndex
        }
        return nil
    }
    
    public func stylesheetRecompilationType(fromRulesAdjacency rulesAdjacency: RangeElementsAdjacency, description: SourceStringChangeDescription, forceRules: Bool = false) -> StylesheetRecompilationType {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("computeStringExtract from rulesAdjacency: %@.\n", log: Log.Web.all, type: .info, %%rulesAdjacency)
        #endif
        
        switch rulesAdjacency {
        case .start:
            
            if !self.cssRules.isEmpty {
                
                let rulesStopIndex = self.ruleStopIndexFromRule(index: 0, startCompilationIndex: nil, description: description)
                
                // was description.changedString(between: lowerElement, and: upperElement)
                return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: rulesStopIndex)
            }
            
        case .between(let low, let up):
            
            assert(low < up)
            let lowerElement = self[low]
            
            assert(lowerElement != nil)
            if let lowerElement = lowerElement {
                
                let lowerElementStartIndex = lowerElement.startStringIndex
                
                assert(lowerElementStartIndex != nil)
                if let lowerElementStartIndex = lowerElementStartIndex {
                    
                    let rulesStopIndex = self.ruleStopIndexFromRule(index: up, startCompilationIndex: lowerElementStartIndex,  description: description)
                    
                    // was description.changedString(between: lowerElement, and: upperElement)
                    return StylesheetRecompilationType.rules(stringExtract: description.changedString(startingFrom: lowerElement), startCompilationRuleIndex: low, rulesStopIndex: rulesStopIndex)
                }
            }
            
        case .covering(let indexes):
            
            if indexes.count == self.cssRules.length {
                
                // complete compilation
                return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: nil)
            }
            else {
                
                assert(!indexes.isEmpty)
                if let firstIndex = indexes.first, let lastIndex = indexes.last {
                    
                    if firstIndex == 0 && lastIndex == self.cssRules.length - 1 {
                        
                        // complete compilation
                        assert(false)
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("This case should have been covered in the first condition: indexes.count == currentStylesheet.cssRules.length", log: Log.Web.all, type: .debug)
                        #endif
                        return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: nil)
                    }
                    // if the first index is included then we should
                    // recompile starting from the start until the upper element
                    else if firstIndex == 0 {
                        
                        assert(lastIndex != self.cssRules.length - 1)
                        
                        let stopIndex = ruleStopIndexFromRule(index: lastIndex+1, startCompilationIndex: nil, description: description)
                        
                        return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: stopIndex)
                    }
                    // if the last index is included then we should
                    // recompile starting from the lower element until the end
                    else if lastIndex == self.cssRules.length - 1 {
                        
                        let lowerElement = self[firstIndex-1]
                        
                        if let lowerElement = lowerElement {
                            
                            return StylesheetRecompilationType.rules(stringExtract: description.changedString(startingFrom: lowerElement), startCompilationRuleIndex: firstIndex-1, rulesStopIndex: nil)
                        }
                    }
                    else {
                        let lowerElement = self[firstIndex-1]
                        
                        assert(lowerElement != nil)
                        if let lowerElement = lowerElement {
                            
                            let lowerElementStartIndex = lowerElement.startStringIndex
                            
                            assert(lowerElementStartIndex != nil)
                            if let lowerElementStartIndex = lowerElementStartIndex {
                                
                                let stopIndex = ruleStopIndexFromRule(index: lastIndex+1, startCompilationIndex: lowerElementStartIndex, description: description)
                                
                                return StylesheetRecompilationType.rules(stringExtract: description.changedString(startingFrom: lowerElement), startCompilationRuleIndex: firstIndex-1, rulesStopIndex: stopIndex)
                            }
                        }
                    }
                }
            }
            
        case .exclusivelyInside(let ruleIndex):
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("exclusivelyInside: %d", log: Log.Web.all, type: .info, index)
            #endif
            
            guard !description.changeReplacementContains(character: Character("{")) else {
                return self.completeRuleRecompilationType(atIndex: ruleIndex, description: description)
            }
            
            guard !description.changeReplacementContains(character: Character("}")) else {
                return self.completeRuleRecompilationType(atIndex: ruleIndex, description: description)
            }
            
            if !forceRules && self.onlyEditedSelectors(ruleIndex: ruleIndex, description: description) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("onlyEditedSelectors", log: Log.Web.all, type: .info, index)
                #endif
                
                guard let selectorListRecompilationType = self.selectorListRecompilationType(atRuleIndex: ruleIndex, description: description) else {
                    assertionFailure("Error: selectorListRecompilationType is nil")
                    return self.completeRuleRecompilationType(atIndex: ruleIndex, description: description)
                }
                return selectorListRecompilationType
            }
            else if !forceRules && self.onlyEditedDeclarations(ruleIndex: ruleIndex, description: description) {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("onlyEditedDeclarations", log: Log.Web.all, type: .info, index)
                #endif
                guard let declarationsRecompilationType = self.declarationsRecompilationType(atRuleIndex: ruleIndex, description: description) else {
                    assertionFailure("Error: declarationsRecompilationType is nil")
                    return self.completeRuleRecompilationType(atIndex: ruleIndex, description: description)
                }
                return declarationsRecompilationType
            }
            else {
                return self.completeRuleRecompilationType(atIndex: ruleIndex, description: description)
            }
            
        case .end:
            
            assert(self.cssRules.length >= 1)
            let lastRule = self.lastTopRule
            
            // the first block
            assert(lastRule != nil)
            if let lastRule = lastRule {
                
                return StylesheetRecompilationType.rules(stringExtract: description.changedString(startingFrom: lastRule), startCompilationRuleIndex: self.cssRules.length-1, rulesStopIndex: nil)
            }
        }
        return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: nil)
    }
    
    /// 
    /// Return the compilation affected range in the original string
    /// from a rules range for the selector compilation case.
    ///
    public func originalStringRangeAffectedByDeclarationsCompilation(startCompilationRuleIndex: Int?, stoppedCompilationRuleIndex: Int?, description: SourceStringChangeDescription) -> Range<Int>? {
        
        if let startCompilationRuleIndex = startCompilationRuleIndex {
            
            if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
                
                guard let startCompilationRule = self[startCompilationRuleIndex] as? CSSStyleRule else {
                    assertionFailure("Error: startCompilationRule is nil")
                    return nil
                }
                
                guard let startCompilationRuleStartIndex = startCompilationRule.startStringIndex else {
                    assertionFailure("Error: startCompilationRuleStartIndex is nil")
                    return nil
                }
                
                // two cases:
                // 1. we stopped in the same rule: successfull case
                // 2. we stopped in another rule... should not happen since we should have
                // had nil when getting the stoppedCompilationRuleIndex.
                //
                // so if the stoppedCompilationRuleIndex is not nil
                // it must be the same as the startCompilationRuleIndex
                assert(startCompilationRuleIndex == stoppedCompilationRuleIndex)
                guard let stoppedCompilationRuleStartIndex = startCompilationRule.style?.styleDeclarationStartIndex else {
                    assertionFailure("Error: stoppedCompilationRuleStartIndex is nil")
                    return nil
                }
                
                return startCompilationRuleStartIndex..<stoppedCompilationRuleStartIndex
            }
            else {
                
                // we
                let startCompilationRule = self[startCompilationRuleIndex]
                
                assert(startCompilationRule != nil)
                if let startCompilationRule = startCompilationRule {
                    
                    let startCompilationRuleStartIndex = startCompilationRule.startStringIndex
                    
                    assert(startCompilationRuleStartIndex != nil)
                    if let startCompilationRuleStartIndex = startCompilationRuleStartIndex {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("source string: %@", log: Log.Web.all, type: .info, %%description.targetString)
                        #endif
                        let endIndex = description.targetString.length - description.changeLength
                        
                        return startCompilationRuleStartIndex..<endIndex
                    }
                }
            }
        }
        else if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
            
            // remove comments until the start of the start index of
            // the stopped compilation rule
            guard let stoppedCompilationRule = self[stoppedCompilationRuleIndex] as? CSSStyleRule else {
                assertionFailure("Error: stoppedCompilationRule is nil")
                return nil
            }
            
            // if we didn't have the start it means it must have been 0.
            // so stoppedCompilationRuleIndex must be 0 too because in the selector
            // case we stop in the same rule if successfull.
            assert(stoppedCompilationRuleIndex == 0)
            let stoppedCompilationRuleStartIndex = stoppedCompilationRule.style?.styleDeclarationStartIndex
            
            assert(stoppedCompilationRuleStartIndex != nil)
            if let stoppedCompilationRuleStartIndex = stoppedCompilationRuleStartIndex {
                
                return 0..<stoppedCompilationRuleStartIndex
            }
        }
        return nil
    }
    
    
    /// Return the compilation affected range in the original string
    /// from a rules range for the selector compilation case.
    ///
    ///
    public func originalStringRangeAffectedBySelectorListCompilation(ruleIndex: Int, description: SourceStringChangeDescription) -> Range<Int>? {
        
        guard let startCompilationRule = self[ruleIndex] as? CSSStyleRule else {
            assertionFailure("Error: startCompilationRule is nil")
            return nil
        }
        
        guard let startCompilationRuleStartIndex = startCompilationRule.startStringIndex else {
            assertionFailure("Error: startCompilationRuleStartIndex is nil")
            return nil
        }
        
        // two cases:
        // 1. we stopped in the same rule: successfull case
        // 2. we stopped in another rule... should not happen since we should have
        // had nil when getting the stoppedCompilationRuleIndex.
        //
        // so if the stoppedCompilationRuleIndex is not nil
        // it must be the same as the startCompilationRuleIndex
        guard let stoppedCompilationRuleStartIndex = startCompilationRule.style?.styleDeclarationStartIndex else {
            assertionFailure("Error: stoppedCompilationRuleStartIndex is nil")
            return nil
        }
        
        return startCompilationRuleStartIndex..<stoppedCompilationRuleStartIndex
    }
    
    /// Return the compilation affected range in the original string
    /// from a rules range.
    public func originalStringRangeAffectedByRulesRangeCompilation(startCompilationRuleIndex: Int?, stoppedCompilationRuleIndex: Int?, description: SourceStringChangeDescription) -> Range<Int>? {
    
        if let startCompilationRuleIndex = startCompilationRuleIndex {
            
            if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
                
                let startCompilationRule = self[startCompilationRuleIndex]
                
                assert(startCompilationRule != nil)
                if let startCompilationRule = startCompilationRule {
                    
                    let startCompilationRuleStringStartIndex = startCompilationRule.startStringIndex
                    
                    assert(startCompilationRuleStringStartIndex != nil)
                    if let startCompilationRuleStringStartIndex = startCompilationRuleStringStartIndex {
                        
                        let stoppedCompilationRule = self[stoppedCompilationRuleIndex]
                        
                        assert(stoppedCompilationRule != nil)
                        if let stoppedCompilationRule = stoppedCompilationRule {
                            
                            let stoppedCompilationRuleStringStartIndex = stoppedCompilationRule.startStringIndex
                            
                            assert(stoppedCompilationRuleStringStartIndex != nil)
                            if let stoppedCompilationRuleStringStartIndex = stoppedCompilationRuleStringStartIndex {
                                
                                return startCompilationRuleStringStartIndex..<stoppedCompilationRuleStringStartIndex
                            }
                        }
                    }
                }
            }
            else {
                
                let startCompilationRule = self[startCompilationRuleIndex]
                
                assert(startCompilationRule != nil)
                if let startCompilationRule = startCompilationRule {
                    
                    let startCompilationRuleStartIndex = startCompilationRule.startStringIndex
                    
                    assert(startCompilationRuleStartIndex != nil)
                    if let startCompilationRuleStartIndex = startCompilationRuleStartIndex {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("source string: %@", log: Log.Web.all, type: .info, %%description.targetString)
                        #endif
                        let endIndex = description.targetString.length - description.changeLength
                        
                        return startCompilationRuleStartIndex..<endIndex
                    }
                }
            }
        }
        else if let stoppedCompilationRuleIndex = stoppedCompilationRuleIndex {
            
            // remove comments until the start of the start index of
            // the stopped compilation rule
            let stoppedCompilationRule = self[stoppedCompilationRuleIndex]
            
            assert(stoppedCompilationRule != nil)
            if let stoppedCompilationRule = stoppedCompilationRule {
                
                let stoppedCompilationRuleStartIndex = stoppedCompilationRule.startStringIndex
                
                assert(stoppedCompilationRuleStartIndex != nil)
                if let stoppedCompilationRuleStartIndex = stoppedCompilationRuleStartIndex {
                    
                    return 0..<stoppedCompilationRuleStartIndex
                }
            }
        }
        return nil
    }
    
    /// This method returns the index of the rule in which we stopped we stopped
    /// the compilation if we stopped or nil otherwise.
    /// So, getting a non-nil value from this method means that we have
    /// successfully stopped the compilation.
    public func stoppedRuleIndex(fromDeclarationStoppedIndex declarationStoppedIndex: Int?, startCompilationRuleIndex: Int?, description: SourceStringChangeDescription, currentStylesheet: CSSStyleSheet) -> Int? {
        
        guard let declarationStoppedIndex = declarationStoppedIndex else {
            return nil
        }
            
        let startRuleStartStringIndex = currentStylesheet.startCompilationRuleStartIndex(from: startCompilationRuleIndex)
        
        // we must convert the value in the original string since
        // all indexes in the current stylesheet are still in the old
        // indexing scheme (before change)
        let originalStoppedIndex = declarationStoppedIndex - description.changeLength + startRuleStartStringIndex
        
        let startCompilationRuleIndex = startCompilationRuleIndex ?? 0
        
        // get the rule index
        for i in startCompilationRuleIndex..<currentStylesheet.styleRulesCount {
            
            guard let styleRule: CSSStyleRule = currentStylesheet[i] as? CSSStyleRule else {
                continue
            }
                
            guard let startStringIndex = styleRule.style?.styleDeclarationStartIndex else {
                assertionFailure("Error: startStringIndex is nil")
                continue
            }

            if startStringIndex == originalStoppedIndex {
                return i
            }
            else if startStringIndex > originalStoppedIndex {
                return nil
            }
        }
        return nil
    }
    
    public func stoppedRuleIndex(fromRulesStoppedIndex rulesStoppedIndex: Int?, startCompilationRuleIndex: Int?, description: SourceStringChangeDescription, currentStylesheet: CSSStyleSheet) -> Int? {
        
        if let rulesStoppedIndex = rulesStoppedIndex {
            
            let startRuleStartStringIndex = currentStylesheet.startCompilationRuleStartIndex(from: startCompilationRuleIndex)
            
            // we must convert the value in the original string since
            // all indexes in the current stylesheet are still in the old
            // indexing scheme (before change)
            let originalStoppedIndex = rulesStoppedIndex - description.changeLength + startRuleStartStringIndex
            
            let startCompilationRuleIndex = startCompilationRuleIndex ?? 0
            
            // get the rule index
            for i in startCompilationRuleIndex..<currentStylesheet.styleRulesCount {
                
                guard let rule: CSSRule = currentStylesheet[i] else {
                    assertionFailure("Error: rule is nil")
                    continue
                }

                guard let startStringIndex = rule.startStringIndex else {
                    assertionFailure("Error: startStringIndex is nil")
                    continue
                }
                
                if startStringIndex == originalStoppedIndex {
                    return i
                }
                else if startStringIndex > originalStoppedIndex {
                    return nil
                }
            }
        }
        return nil
    }
    
    /// Collect all the deleted elements from associated with the
    /// rules. No descendants are collected.
    public func collectDeletedRulesDomNodes(fromStyleRuleRange range: CountableRange<Int>) -> ContiguousArray<Node> {
        
        var nodes = ContiguousArray<Node>()
        
        for i in range.lowerBound..<range.upperBound {
            
            if let rule = self[i] {
                
                if let associatedNodes = rule.associatedDomNodes {
                    
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("nodes associated with rule: %@", log: Log.Web.all, type: .info, %%rule.type)
                    logAssociatedNodes(associatedNodes: associatedNodes)
                    #endif
                    
                    nodes.append(contentsOf: associatedNodes)
                }
            }
        }
        return nodes
    }
    
    private func startCompilationRuleStartIndex(from startCompilationRuleIndex: Int?) -> Int {
        
        // let _startCompilationRuleIndex = startCompilationRuleIndex ?? 0
        if let startCompilationRuleIndex = startCompilationRuleIndex {
            
            let startRule = self[startCompilationRuleIndex]
            
            assert(startRule != nil)
            if let startRule = startRule {
                
                let startRuleStartStringIndex = startRule.startStringIndex
                
                assert(startRuleStartStringIndex != nil)
                if let startRuleStartStringIndex = startRuleStartStringIndex {
                    
                    return startRuleStartStringIndex
                }
            }
        }
        return 0
    }
    
    private func declarationsRecompilationType(atRuleIndex ruleIndex: Int, description: SourceStringChangeDescription) -> StylesheetRecompilationType? {
        
        guard let (startDeclaration, declarationsRange) = self.declarationsRange(inRuleAtIndex: ruleIndex, description: description) else {
            assertionFailure("Error: selectorStopIndex is nil")
            // complete rule compilation
            return nil
        }
        
        guard let (declarationsStopIndex, originalDeclarationsRangeEndIndex) = self.declarationsStopIndex(fromDeclarationsRange: declarationsRange, atRuleIndex: ruleIndex, description: description) else {
            assertionFailure("Error: declarationsStopIndex is nil")
            return nil
        }
        
        guard let compilationStringStartIndex = self.declarationsCompilationStartIndex(atRuleIndex: ruleIndex, startDeclaration: startDeclaration) else {
            assertionFailure("Error: compilationStringStartIndex is nil")
            return nil
        }
        
        guard let stringExtract = description.targetString.substring(compilationStringStartIndex) else {
            assertionFailure("Error: stringExtract is nil")
            return nil
        }
        
        return StylesheetRecompilationType.declarations(stringExtract: stringExtract, compilationStringStartIndex: compilationStringStartIndex, ruleIndex: ruleIndex, declarationsRange: declarationsRange, declarationStopIndex: declarationsStopIndex, originalDeclarationsRangeEndIndex: originalDeclarationsRangeEndIndex)
    }
    
    private func declarationsCompilationStartIndex(atRuleIndex ruleIndex: Int, startDeclaration: CSDeclaration?) -> Int? {
        
        if let startDeclaration = startDeclaration {
            return startDeclaration.startStringIndex
        }
        else {
            guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
                
                // complete compilation
                assert(false)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("This case should have been covered in the first condition: indexes.count == currentStylesheet.cssRules.length", log: Log.Web.all, type: .debug)
                #endif
                return nil
            }
            
            guard let styleDeclaration = styleRule.style else {
                assertionFailure("Error: styleDeclaration is nil")
                return nil
            }
            guard let startStringIndex = styleDeclaration.startStringIndex else {
                assertionFailure("Error: startStringIndex is nil")
                return nil
            }
            return startStringIndex + 1
        }
    }
    
    private func declarationsStopIndex(fromDeclarationsRange declarationsRange: Range<Int>, atRuleIndex ruleIndex: Int, description: SourceStringChangeDescription) -> (declarationStopIndex: DeclarationStopIndex, originalDeclarationsRangeEndIndex: Int)? {
        
        guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
            
            // complete compilation
            assert(false)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("This case should have been covered in the first condition: indexes.count == currentStylesheet.cssRules.length", log: Log.Web.all, type: .debug)
            #endif
            return nil
        }
        
        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        
        guard let startIndex: Int = {
            
            if declarationsRange.lowerBound == -1 {
                guard let styleStartStringIndex = styleRule.style!.startStringIndex else {
                    assertionFailure("Error: styleStartStringIndex is nil")
                    return nil
                }
                
                return styleStartStringIndex+1
            }
            else {
                guard let startDeclaration: CSDeclaration = styleDeclaration.declaration(atIndex: declarationsRange.lowerBound) else {
                    assertionFailure("Error: startDeclaration is nil")
                    return nil
                }
                return startDeclaration.startStringIndex
            }
        }() else {
            assertionFailure("Error: endIndex is nil")
            return nil
        }
        
        guard let endIndex: Int = {
            
            if declarationsRange.upperBound == Int.max {
                guard let styleEndStringIndex = styleRule.style!.endStringIndex else {
                    assertionFailure("Error: styleStartStringIndex is nil")
                    return nil
                }
                
                return styleEndStringIndex
            }
            else {
                guard let endDeclaration: CSDeclaration = styleDeclaration.declaration(atIndex: declarationsRange.upperBound-1) else {
                    assertionFailure("Error: startDeclaration is nil")
                    return nil
                }
                return endDeclaration.endSemiColonToken?.endStringIndex
            }
        }() else {
            assertionFailure("Error: endIndex is nil")
            return nil
        }
        
        
        
        if declarationsRange.upperBound == Int.max {
            let stopIndex = (endIndex - startIndex) + description.changeLength
            return (DeclarationStopIndex.endOfStyleDeclarationBloc(index: stopIndex), endIndex)
        }
        else {
            let stopIndex = ((endIndex - 1) - startIndex) + description.changeLength
            return (DeclarationStopIndex.endOfDeclaration(index: stopIndex), endIndex)
        }
    }
    
    /// This method returns the index at which the compilation should tentatively stop
    /// along with the declaration ranges which should be recompiled.
    private func declarationsRange(inRuleAtIndex ruleIndex: Int, description: SourceStringChangeDescription) -> (startDeclaration: CSDeclaration?, declarationsRange: Range<Int>)? {
        
        guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
            
            // complete compilation
            assert(false)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("This case should have been covered in the first condition: indexes.count == currentStylesheet.cssRules.length", log: Log.Web.all, type: .debug)
            #endif
            return nil
        }
        
        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        
        guard let declarationsRange: Range<Int> = styleDeclaration.declarationsRange(aroundChangeDescription: description) else {
            assertionFailure("Error: declarationsRange is nil")
            return nil
        }
        
        // since we use -1 to indicate that modification has been done
        // before the first declaration, in this case the start declaration is nil
        // which is not an error
        let startDeclaration: CSDeclaration? = styleDeclaration.declaration(atIndex: declarationsRange.lowerBound)
        return (startDeclaration, declarationsRange)
    }
    
    private func selectorListRecompilationType(atRuleIndex ruleIndex: Int, description: SourceStringChangeDescription) -> StylesheetRecompilationType? {
        
        guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
            
            // complete rule compilation
            assert(false)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("This case should have been covered in the first condition: indexes.count == currentStylesheet.cssRules.length", log: Log.Web.all, type: .debug)
            #endif
            return nil
        }
        
        guard let ruleStartStringIndex = styleRule.startStringIndex else {
            assertionFailure("Error: ruleStartStringIndex is nil")
            return nil
        }
        
        guard let selectorStopIndex = selectorStopIndexInRule(index: ruleIndex, description: description) else {
            assertionFailure("Error: selectorStopIndex is nil")
            // complete rule compilation
            return nil
        }
        
        guard let styleDeclarationStartStringIndex = styleRule.style?.startStringIndex else {
            assertionFailure("Error: ruleStartStringIndex is nil")
            return nil
        }
        
        let originalSelectorStringRange = ruleStartStringIndex..<styleDeclarationStartStringIndex
        
        return StylesheetRecompilationType.selectorList(stringExtract: description.changedString(startingFrom: styleRule), originalSelectorStringRange: originalSelectorStringRange, ruleIndex: ruleIndex, selectorStopIndex: selectorStopIndex)
    }
    
    public func onlyEditedSelectors(ruleIndex: Int, description: SourceStringChangeDescription) -> Bool {
        
        guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
            return false
        }
        
        return styleRule.onlyEditedSelectors(description: description)
    }
    
    public func onlyEditedDeclarations(ruleIndex: Int, description: SourceStringChangeDescription) -> Bool {
        
        #if DEBUG
        assert(!onlyEditedSelectors(ruleIndex: ruleIndex, description: description))
        #endif
        
        guard let styleRule: CSSStyleRule = self[ruleIndex] as? CSSStyleRule else {
            return false
        }
        
        return styleRule.onlyEditedDeclarations(description: description)
    }
    
    private func completeRuleRecompilationType(atIndex index: Int, description: SourceStringChangeDescription) -> StylesheetRecompilationType {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("exclusivelyInside: %d", log: Log.Web.all, type: .info, index)
        #endif
        
        let element = self[index]
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        for (index, rule) in currentStylesheet.cssRules.enumerated() {
            os_log("rule at index: %d, segment: %@", log: Log.Web.all, type: .info, index, %%rule.sourceStringSegment!)
        }
        #endif
        
        assert(element != nil)
        if let element = element {
            
            let elementStartIndex = element.startStringIndex
            
            assert(elementStartIndex != nil)
            if let elementStartIndex = elementStartIndex {
                
                let rulesStopIndex = self.ruleStopIndexFromRule(index: index+1, startCompilationIndex: elementStartIndex, description: description)
                
                return StylesheetRecompilationType.rules(stringExtract: description.changedString(startingFrom: element), startCompilationRuleIndex: index, rulesStopIndex: rulesStopIndex)
            }
        }
        
        return StylesheetRecompilationType.rules(stringExtract: description.targetString.string, startCompilationRuleIndex: nil, rulesStopIndex: nil)
    }
    
    private func selectorStopIndexInRule(index: Int, description: SourceStringChangeDescription) -> Int? {
        
        guard let styleRule = self[index] as? CSSStyleRule else {
            assertionFailure("Error: styleRule is nil at index: \(index)")
            return nil
        }
        
        guard let styleDeclaration = styleRule.style else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        
        guard let styleDeclarationStartIndex = styleDeclaration.styleDeclarationStartIndex else {
            assertionFailure("Error: styleDeclarationStartIndex is nil")
            return nil
        }
        
        guard let styleRuleStartStringIndex = styleRule.startStringIndex else {
            assertionFailure("Error: styleRuleStartStringIndex is nil")
            return nil
        }
        
        return (styleDeclarationStartIndex - styleRuleStartStringIndex) + description.changeLength
    }
    
    private func ruleStopIndexFromRule(index: Int, startCompilationIndex: Int?, description: SourceStringChangeDescription) -> Int? {
        
        let nextElement = self[index]
        
        if let nextElement = nextElement {
            
            let nextElementStartIndex = nextElement.startStringIndex
            
            assert(nextElementStartIndex != nil)
            if let nextElementStartIndex = nextElementStartIndex {
                
                if let startCompilationIndex = startCompilationIndex {
                    return nextElementStartIndex + description.changeLength - startCompilationIndex
                }
                else {
                    return nextElementStartIndex + description.changeLength
                }
            }
        }
        return nil
    }
}
