 //
//  StylesheetDocumentReducer+StylesheetCompilation.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import PromiseKit
import Common
import os

extension StylesheetDocumentReducer {
    
    func createStylesheetAsync(description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> Promise<CSSStyleSheet> {
        
        return Promise<CSSStyleSheet> { fulfill, reject in
            
            self.serialCompilationQueue.async {

                if let stylesheet = self.createStylesheet(description: description, store: store) {
                    fulfill(stylesheet)
                }
                else {
                    reject(NWError.custom(message: "Error while compiling the stylesheet"))
                }
            }
        }
    }
    
    func createStylesheetSync(description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> CSSStyleSheet? {
    
        return self.serialCompilationQueue.sync {
            return self.createStylesheet(description: description, store: store)
        }
    }
    
    func compileStylesheet(description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> StylesheetCompilationResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start compileStylesheet", log: Log.WriterCommon.all, type: .info)
        #endif
        
        // check if the length of the file justify a partial recompilation
        guard let currentStylesheet = store.stylesheet.value else {
            assertionFailure("Error: currentStylesheet is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
        
        // check if the length of the file justify a partial recompilation
        guard description.targetString.length > Constants.CSS.RecompileSourceStringLength || store.alwaysAllowPartialCompilation else {
            assertionFailure("Error: currentStylesheet is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
            
        // early exit if the change length is zero
        guard !(description.changeLength == 0 && description.utf16SubsequenceReplacement.count == 0) else {
            assertionFailure("Error: description.changeLength == 0 && description.utf16SubsequenceReplacement.count == 0")
            return nil
        }
    
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        guard let rulesAdjacency = currentStylesheet.rulesAdjacency(description.range) else {
            assertionFailure("Error: rulesAdjacency is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("compileStylesheet.rulesAdjacency: %@", log: Log.WriterCommon.all, type: .info, %%rulesAdjacency)
        #endif
        
        let stylesheetRecompilationType = currentStylesheet.stylesheetRecompilationType(fromRulesAdjacency: rulesAdjacency, description: description)
        
        switch stylesheetRecompilationType {
        case .rules(let stringExtract, let startCompilationRuleIndex, let rulesStopIndex):
            return self.recompilesRules(stringExtract: stringExtract, startCompilationRuleIndex: startCompilationRuleIndex, rulesStopIndex: rulesStopIndex, description: description, store: store)
        case .selectorList(let stringExtract, let originalSelectorStringRange, let ruleIndex, let selectorStopIndex):
            return self.recompileSelectorList(stringExtract: stringExtract, originalSelectorStringRange: originalSelectorStringRange, ruleIndex: ruleIndex, selectorStopIndex: selectorStopIndex, description: description, store: store)
        case .declarations(let stringExtract, let compilationStringStartIndex, let ruleIndex, let declarationsRange, let declarationStopIndex, let originalDeclarationsRangeEndIndex):
            return self.recompileDeclarations(stringExtract: stringExtract, compilationStringStartIndex: compilationStringStartIndex, originalDeclarationsRangeEndIndex: originalDeclarationsRangeEndIndex, ruleIndex: ruleIndex, declarationsRange: declarationsRange, declarationStopIndex: declarationStopIndex, description: description, store: store)
        }
    }
    
    private func recompilesRules(stringExtract: String?, startCompilationRuleIndex: Int?, rulesStopIndex: Int?, description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> StylesheetCompilationResult? {
        
        // check if the length of the file justify a partial recompilation
        guard let currentStylesheet = store.stylesheet.value else {
            assertionFailure("Error: currentStylesheet is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
        
        guard let stringExtract = stringExtract, !stringExtract.isEmpty else {
            assertionFailure("Error: _stringExtract is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("stringExtract was nil, trigger complete recompilation.", log: Log.WriterCommon.all, type: .error)
            #endif
            return completeRecompilation(store: store, string: description.targetString)
        }
            
        // parse the extracted range
        // Note: compiledStylesheet.cssRules.length != 0 may not be true since
        // we may delete text in a comment or something like that.
        let (_compiledStylesheet, rulesStoppedIndex, _) = self.compileStylesheet(string: String(stringExtract), origin: store.origin, rulesStopIndex: rulesStopIndex, selectorStopIndex: nil)
        
        guard let compiledStylesheet = _compiledStylesheet else {
            assertionFailure("Error: compiledStylesheet is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("compiledStylesheet is nil... triggering complete recompilation", log: Log.WriterCommon.all, type: .error)
            #endif
            return self.completeRecompilation(store: store, string: description.targetString)
        }
            
        let stoppedCompilationRuleIndex = currentStylesheet.stoppedRuleIndex(fromRulesStoppedIndex: rulesStoppedIndex, startCompilationRuleIndex: startCompilationRuleIndex, description: description, currentStylesheet: currentStylesheet)
        
        let originalStringRange = currentStylesheet.originalStringRangeAffectedByRulesRangeCompilation(startCompilationRuleIndex: startCompilationRuleIndex, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, description: description)
        
        currentStylesheet.removeComments(inOriginalStringRange: originalStringRange)
        
        let removedComments = removeCommentsFromCurrentStylesheetDocument(store.document.value, in: originalStringRange)
        
        let stoppedCompilationStringIndex = rulesStopIndex ?? originalStringRange?.lowerBound ?? 0
        
        updateCommentsPositions(afterStoppedCompilationStringIndex: stoppedCompilationStringIndex, description: description, store: store)
        
        let compilationResult = currentStylesheet.updateStylesheetRules(startCompilationRuleIndex: startCompilationRuleIndex, stoppedCompilationRuleIndex: stoppedCompilationRuleIndex, compiledStylesheet: compiledStylesheet, description: description)
        
        return update(compilationResult: compilationResult, removedComments: removedComments)
    }
    
    private func recompileSelectorList(stringExtract: String?, originalSelectorStringRange: Range<Int>, ruleIndex: Int, selectorStopIndex: Int?, description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> StylesheetCompilationResult? {
        
        // check if the length of the file justify a partial recompilation
        guard let currentStylesheet = store.stylesheet.value else {
            assertionFailure("Error: currentStylesheet is nil")
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        guard let stringExtract = stringExtract, !stringExtract.isEmpty else {
            assertionFailure("Error: _stringExtract is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("stringExtract was nil, trigger complete recompilation.", log: Log.WriterCommon.all, type: .error)
            #endif
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        // parse the extracted range
        let (_compiledStylesheet, _, _selectorStoppedIndex) = self.compileStylesheet(string: stringExtract, origin: store.origin, rulesStopIndex: nil, selectorStopIndex: selectorStopIndex)
        
        guard let compiledStylesheet = _compiledStylesheet else {
            assertionFailure("Error: compiledStylesheet is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("compiledStylesheet is nil... triggering complete recompilation", log: Log.WriterCommon.all, type: .error)
            #endif
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        guard let selectorStoppedIndex = _selectorStoppedIndex else {
            assertionFailure("Error: recompiling by forcing rules compilation")
            return self.forcesRulesRecompilation(description: description, store: store)
        }
            
        currentStylesheet.removeComments(inOriginalStringRange: originalSelectorStringRange)

        let removedComments = removeCommentsFromCurrentStylesheetDocument(store.document.value, in: originalSelectorStringRange)
        
        updateCommentsPositions(afterStoppedCompilationStringIndex: selectorStoppedIndex, description: description, store: store)
        
        let compilationResult = currentStylesheet.updateSelectorList(startCompilationRuleIndex: ruleIndex, stoppedCompilationRuleIndex: ruleIndex, compiledStylesheet: compiledStylesheet, description: description)
        
        return update(compilationResult: compilationResult, removedComments: removedComments)
    }
    
    private func recompileDeclarations(stringExtract: String?, compilationStringStartIndex: Int, originalDeclarationsRangeEndIndex: Int, ruleIndex: Int, declarationsRange: Range<Int>?, declarationStopIndex: DeclarationStopIndex, description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> StylesheetCompilationResult? {
        
        // check if the length of the file justify a partial recompilation
        guard let currentStylesheet = store.stylesheet.value else {
            assertionFailure("Error: currentStylesheet is nil")
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        guard let stringExtract = stringExtract, !stringExtract.isEmpty else {
            assertionFailure("Error: _stringExtract is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("stringExtract was nil, trigger complete recompilation.", log: Log.WriterCommon.all, type: .error)
            #endif
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        // parse the extracted range
        let (_compiledStylesheet, _declarationStoppedIndex) = StyleProcessor.shared.createStyleSheet(withDeclarationStopIndex: declarationStopIndex, sourceString: stringExtract, origin: store.origin, computePropertyValues: true)
        
        guard let compiledStylesheet = _compiledStylesheet else {
            assertionFailure("Error: compiledStylesheet is nil")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("compiledStylesheet is nil... triggering complete recompilation", log: Log.WriterCommon.all, type: .error)
            #endif
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        guard let declarationsRange = declarationsRange else {
            assertionFailure("Error: declarationsRange is nil")
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        guard let declarationStoppedIndex = _declarationStoppedIndex else {
//            assertionFailure("Error: recompiling by forcing rules compilation")
            return self.forcesRulesRecompilation(description: description, store: store)
        }
        
        // +1 because declarationStoppedIndex is at the start of the semicolon
        // but we want the end of the declarations range
        let originalDeclarationsStringRange = compilationStringStartIndex..<originalDeclarationsRangeEndIndex
            
        currentStylesheet.removeComments(inOriginalStringRange: originalDeclarationsStringRange)

        let removedComments = removeCommentsFromCurrentStylesheetDocument(store.document.value, in: originalDeclarationsStringRange)
        
        updateCommentsPositions(afterStoppedCompilationStringIndex: declarationStoppedIndex, description: description, store: store)
        
        let compilationResult = currentStylesheet.updateDeclarationsRange(inRuleAtIndex: ruleIndex, declarationsRange: declarationsRange, compiledDeclarationRange: nil, compilationStringStartIndex: compilationStringStartIndex, compiledStylesheet: compiledStylesheet, description: description)
        
        return update(compilationResult: compilationResult, removedComments: removedComments)
    }
    
    ///
    /// This method is called when we know that the recompilation
    /// has not been to stop in the selection and the declaration cases.
    ///
    private func forcesRulesRecompilation(description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> StylesheetCompilationResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start compileStylesheet", log: Log.WriterCommon.all, type: .info)
        #endif
        
        // check if the length of the file justify a partial recompilation
        guard let currentStylesheet = store.stylesheet.value, description.targetString.length > Constants.CSS.RecompileSourceStringLength else {
            assertionFailure("Error: currentStylesheet is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
            
        // early exit if the change length is zero
        guard !(description.changeLength == 0 && description.utf16SubsequenceReplacement.count == 0) else {
            assertionFailure("Error: description.changeLength == 0 && description.utf16SubsequenceReplacement.count == 0")
            return nil
        }
    
        // get the style rules range associated with the changeIndex
        // Note: the range is excluding the last index.
        guard let rulesAdjacency = currentStylesheet.rulesAdjacency(description.range) else {
            assertionFailure("Error: rulesAdjacency is nil")
            return completeRecompilation(store: store, string: description.targetString)
        }
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("compileStylesheet.rulesAdjacency: %@", log: Log.WriterCommon.all, type: .info, %%rulesAdjacency)
        #endif
        
        let stylesheetRecompilationType = currentStylesheet.stylesheetRecompilationType(fromRulesAdjacency: rulesAdjacency, description: description, forceRules: true)
        
        assert(stylesheetRecompilationType.isRules)
        
        switch stylesheetRecompilationType {
        case .rules(let stringExtract, let startCompilationRuleIndex, let rulesStopIndex):
            return self.recompilesRules(stringExtract: stringExtract, startCompilationRuleIndex: startCompilationRuleIndex, rulesStopIndex: rulesStopIndex, description: description, store: store)
        default:
            assertionFailure("Error: forced ruels stylesheetRecompilationType is not of rules type")
            return completeRecompilation(store: store, string: description.targetString)
        }
    }
    
    private func update(compilationResult: StylesheetCompilationResult, removedComments: [Element]?) -> StylesheetCompilationResult {
        
        switch compilationResult {
        case .declarations(var deletedTopNodes, let partialStylesheet, let ruleIndex, let declarationsRange):
            if let removedComments = removedComments {
                deletedTopNodes?.append(contentsOf: removedComments)
            }
            return StylesheetCompilationResult.declarations(deletedTopNodes: deletedTopNodes, partialStylesheet: partialStylesheet, ruleIndex: ruleIndex, declarationsRange: declarationsRange)
        case .selectorList(var deletedTopNodes, let compiledStylesheet, let selectorList, let ruleIndex):
            if let removedComments = removedComments {
                deletedTopNodes?.append(contentsOf: removedComments)
            }
            return StylesheetCompilationResult.selectorList(deletedTopNodes: deletedTopNodes, partialStylesheet: compiledStylesheet, selectorList: selectorList, ruleIndex: ruleIndex)
        case .complete(_):
            return compilationResult
        case .rules(var deletedNodes, let partialStylesheet, let updatedStoppedCompilationRuleIndex):
            
            if let removedComments = removedComments {
                deletedNodes?.append(contentsOf: removedComments)
            }
            return StylesheetCompilationResult.rules(deletedTopNodes: deletedNodes, partialStylesheet: partialStylesheet, updatedStoppedCompilationRuleIndex: updatedStoppedCompilationRuleIndex)
        
        case .replace(let stylesheet, var deletedTopNodes):
            
            if let removedComments = removedComments {
                deletedTopNodes?.append(contentsOf: removedComments)
            }
            return StylesheetCompilationResult.replace(stylesheet: stylesheet, deletedTopNodes: deletedTopNodes)
        }
    }
    
    private func updateCommentsPositions(afterStoppedCompilationStringIndex stoppedCompilationStringIndex: Int?, description: SourceStringChangeDescription, store: StylesheetDocumentStore) {
        
        guard let stoppedCompilationStringIndex = stoppedCompilationStringIndex else {
            assertionFailure("Error: stoppedCompilationStringIndex is nil")
            return
        }
        
        guard let cssDomDocument = store.document.value as? CSSDOMDocument else {
            assertionFailure("Error cssDomDocument is nil")
            return
        }
        
        cssDomDocument.updateCommentsPositions(after: stoppedCompilationStringIndex, of: description.changeLength)
    }
    
    private func removeCommentsFromCurrentStylesheetDocument(_ document: Document?, in range: Range<Int>?) -> [Element]? {
     
        if let cssDocument = document as? CSSDOMDocument {
            
            if let range = range {
                
                return cssDocument.removeComments(in: range)
            }
            else {
                return cssDocument.removeAllComments()
            }
        }
        return nil
    }
    
    private func completeRecompilation(store: StylesheetDocumentStore, string: String) -> StylesheetCompilationResult? {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("CSS complete compilation...", log: Log.WriterCommon.all, type: .info)
        #endif
        // complete compilation
        // see commentary above
        
        let stylesheet = compileStylesheet(string: string, origin: store.origin)
        
        assert(stylesheet != nil)
        if let stylesheet = stylesheet {
            
            if let currentStyleSheet = store.stylesheet.value {
                return StylesheetCompilationResult.replace(stylesheet: stylesheet, deletedTopNodes: currentStyleSheet.collectAllStylesheetDeletedRulesDomNodes())
            }
            else {
                return StylesheetCompilationResult.complete(stylesheet: stylesheet)
            }
        }
        else {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("compiled stylesheet is nil.", log: Log.WriterCommon.all, type: .error)
            #endif
        }
        return nil
    }
    
    func compileStylesheet(string: String, origin: CSSOrigin) -> CSSStyleSheet? {
        
        let styleProcessor = StyleProcessor.shared
        
        /// the stylesheet must always be overwritten otherwise the changes could impact
        /// the operations using the snapshot since they keep a reference this the replaced
        /// stylesheet.
        return styleProcessor.createStyleSheet(string, origin: origin, computePropertyValues: true)
    }
    
    /// Second version of the compileStylesheet method which takes as
    /// supplementary argument a "stopIndex". This index is used to stop the parsing
    /// of the stylesheet if all rules are terminated (ending curly bracket). The real stop
    /// index is also returned by the function.
    func compileStylesheet(string: String, origin: CSSOrigin, rulesStopIndex: Int?, selectorStopIndex: Int?) -> (stylesheet: CSSStyleSheet?, rulesStoppedIndex: Int?, selectorStoppedIndex: Int?) {
        
        return StyleProcessor.shared.createStyleSheet(string, rulesStopIndex: rulesStopIndex, selectorStopIndex: selectorStopIndex, origin: origin, computePropertyValues: true)
    }

    private func logAssociatedNodes(associatedNodes: ContiguousArray<Node>) {
        
        for node in associatedNodes {
            
            if let element = node as? Element {
            
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("adding node to delete: %@", log: Log.WriterCommon.all, type: .info, %%element.localName)
                os_log("path of node to delete: %@", log: Log.WriterCommon.all, type: .info, %%element.path)
                #endif
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("adding node to delete: %@", log: Log.WriterCommon.all, type: .info, %%node.nodeName)
                os_log("path of node to delete: %@", log: Log.WriterCommon.all, type: .info, %%node.path)
                #endif
                
                if node.path.count == 0 {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("node path: %@", log: Log.WriterCommon.all, type: .info, %%node.path)
                    #endif
                }
            }
        }
    }
    
    func createStylesheet(description: SourceStringChangeDescription, store: StylesheetDocumentStore) -> CSSStyleSheet? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Before compileStylesheet...", log: Log.WriterCommon.all, type: .info)
        #endif
        
        if let _stylesheet = self.compileStylesheet(string: description.targetString.string, origin: store.origin) {
            
            store.stylesheet.setValue(_stylesheet)
               
            // Load the CSSDOM
            let document = CSSDOMDocument.Create()
            let cssDomRenderer = CSSDOMRenderer(document: document)
            
            // we take the stylesheet from the StyleSheetOperation
            let domDocument = cssDomRenderer.renderStylesheet(_stylesheet)
            
            store.sourceString.setValue(description.targetString.string)
            
            if let domDocument = domDocument {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("New CSS Dcoument: %@", log: Log.WriterCommon.all, type: .info, %%HTMLSerializer.createDefault().serializeHTMLFragment(domDocument))
                #endif
            }
            
            store.document.setValue(domDocument)
        }
        return store.stylesheet.value
    }
    
 
}

