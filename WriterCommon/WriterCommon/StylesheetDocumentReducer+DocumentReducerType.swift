//
//  StylesheetDocumentReducer+CSSDOMDocument.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

extension StylesheetDocumentReducer: DocumentReducerType {

    /// Return the root elements of the updated document,
    /// or nil if the document was created.
    @discardableResult
    func createOrUpdateDocument(in store: StylesheetDocumentStore, stylesheetCompilationResult: StylesheetCompilationResult?, description: SourceStringChangeDescription) -> UpdateDocumentResult? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start createOrUpdateDocument", log: Log.WriterCommon.all, type: .info)
        #endif

        var rootElements: ContiguousArray<Element>? = nil

        var deleted: ContiguousArray<Node>? = nil
        
        var type: UpdateDocumentResult.UpdateType = .complete
        
        if let stylesheetCompilationResult = stylesheetCompilationResult {
        
            switch stylesheetCompilationResult {
            
            case .declarations(let deletedTopNodes, let partialStylesheet, let ruleIndex, let declarationsRange):
              
                deleted = deletedTopNodes
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("deleted %d nodes from the document.", log: Log.WriterCommon.all, type: .info, deletedNodes.count)
                #endif
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let string1 = HTMLSerializer.createWithGeneratedIds(rangesEnabled: true).serializeHTMLFragment(store.document.value!)
                os_log("Old document: %@", log: Log.WriterCommon.all, type: .info, %%string1)
                #endif
                
                rootElements = self.updateCssDocumentWithDeclarations(atRuleIndex: ruleIndex, declarationsRange: declarationsRange, stylesheetDocumentStore: store, compiledStylesheet: partialStylesheet, sourceStringChangeDescription: description)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let string = HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(store.document.value!)
                os_log("New document: %@", log: Log.WriterCommon.all, type: .info, %%string)
                #endif
            
            case .selectorList(let deletedTopNodes, let partialStylesheet, _, let ruleIndex):
                
                deleted = deletedTopNodes
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("deleted %d nodes from the document.", log: Log.WriterCommon.all, type: .info, deletedNodes.count)
                #endif
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let string1 = HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(store.document.value!)
                os_log("Old document: %@", log: Log.WriterCommon.all, type: .info, %%string1)
                #endif
                
                rootElements = self.updateCssDocumentWithSelectorList(atRuleIndex: ruleIndex, stylesheetDocumentStore: store, compiledStylesheet: partialStylesheet, sourceStringChangeDescription: description)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                let string = HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(store.document.value!)
                os_log("New document: %@", log: Log.WriterCommon.all, type: .info, %%string)
                #endif
                
            case .replace(let stylesheet, _):
                
                updateCompleteStylesheet(stylesheet, in: store)
                
            case .complete(let stylesheet):
                
                updateCompleteStylesheet(stylesheet, in: store)
                
            case .rules(let deletedNodes, let partialStylesheet, let updatedStoppedCompilationRuleIndex):

                if let deletedNodes = deletedNodes, let partialStylesheet = partialStylesheet {
                
                    deleted = deletedNodes
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("deleted %d nodes from the document.", log: Log.WriterCommon.all, type: .info, deletedNodes.count)
                    #endif
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    let string1 = HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(store.document.value!)
                    os_log("Old document: %@", log: Log.WriterCommon.all, type: .info, %%string1)
                    #endif
                
                    // compile document
                    rootElements = updateCssDocument(stylesheetDocumentStore: store, deletedDomNodes: deletedNodes, compiledStylesheet: partialStylesheet, updatedStoppedCompilationRuleIndex: updatedStoppedCompilationRuleIndex, sourceStringChangeDescription: description)
                
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    let string = HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(store.document.value!)
                    os_log("New document: %@", log: Log.WriterCommon.all, type: .info, %%string)
                    #endif
                }
                
                type = .partial
            }
        }
        
        guard let document = store.document.value else {
            assertionFailure("Error: store.document.value is nil")
            return nil
        }
        
        return UpdateDocumentResult(type: type, document: document, rootElements: rootElements, deletedNodes: deleted, attributesBlocsChange: nil)
    }
    
    fileprivate func updateCompleteStylesheet(_ stylesheet: CSSStyleSheet, in store: StylesheetDocumentStore) {
        
        // we take the stylesheet from the StyleSheetOperation
        let cssDomRenderer = CSSDOMRenderer(document: CSSDOMDocument.Create())
        let document = cssDomRenderer.renderStylesheet(stylesheet)
        
        assert(document != nil)
        if let document = document {
            
//            #if DEBUG
            //let string = HTMLSerializer.shared.serializeHTMLFragment(document)
            //#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//os_log("New document: \(string)", log: Log.WriterCommon.all, type: .info)
//#endif
//            #endif
            
            store.document.setValue(document)
            
//            #if DEBUG
            //let string2 = HTMLSerializer.shared.serializeHTMLFragment(store.document.value!)
            //#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//os_log("New document in store: \(string2)", log: Log.WriterCommon.all, type: .info)
//#endif
//            #endif
        }
    }
    
    
    /*

                                              css-style-rule
                                                    |
                                        ____________|____________
                                       /                         \
                                      /                              \
                                selector-list              style-declaration-block
    
    
                                         style-declaration-block
                                                    |
                    ________________________________|______________________________
                   /                                |                              \
                  /                                 |                                 \
      css-token.left-curly-brace          style-declaration         css-token.right-curly-brace
    
    
                                           style-declaration
                                                    |
                             _______________________|_________________________
                            /                       |                           \
                           /                        |                           \
                  css-declaration                    *                    css-declaration

    */
    private func updateCssDocumentWithDeclarations(atRuleIndex ruleIndex: Int, declarationsRange: Range<Int>, stylesheetDocumentStore: StylesheetDocumentStore, compiledStylesheet: CSSStyleSheet, sourceStringChangeDescription: SourceStringChangeDescription) -> ContiguousArray<Element>? {
    
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateCssDocumentWithDeclarations(atRuleIndex:declarationsRange:stylesheetDocumentStore:compiledStylesheet:sourceStringChangeDescription:)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard let cssDomDocument = stylesheetDocumentStore.document.value as? CSSDOMDocument else {
            assertionFailure("Error: cssDomDocument is nil")
            return nil
        }
        // css-style-rule
        guard let styleRuleElement = cssDomDocument.styleRuleElement(atIndex: ruleIndex) else {
            assertionFailure("Error: styleRuleElement is nil")
            return nil
        }
        assert(styleRuleElement.localName == §CSSElementType.StyleRule)
        
        styleRuleElement.moveEnd(sourceStringChangeDescription.changeLength)
        
        // style-declaration-block
        guard let styleDeclarationBloc = styleRuleElement.lastChild as? CSSDOMElement else {
            assertionFailure("Error: selectorList is nil")
            return nil
        }
        assert(styleDeclarationBloc.localName == §CSSElementType.StyleDeclarationBlock)
        styleDeclarationBloc.moveEnd(sourceStringChangeDescription.changeLength)
        
        // style-declaration
        guard let styleDeclaration = styleDeclarationBloc.childAtIndex(1) as? CSSDOMElement else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        assert(styleDeclaration.localName == §CSSElementType.StyleDeclaration)
        styleDeclaration.moveEnd(sourceStringChangeDescription.changeLength)
        
        // css-token class="right-curly-brace-token"
        guard let cssToken = styleDeclarationBloc.childAtIndex(2) as? CSSDOMElement else {
            assertionFailure("Error: styleDeclaration is nil")
            return nil
        }
        assert(cssToken.localName == §CSSElementType.Token)
        cssToken.move(sourceStringChangeDescription.changeLength)
        
        let declarationsAfterDeclarationsRange = self.removeDeclarations(startingFromIndex: declarationsRange.upperBound, inStyleDeclarationElement: styleDeclaration)
        
        // we do not keep those, they are the ones we replace
        let lowerBound = declarationsRange.lowerBound != -1 ? declarationsRange.lowerBound : 0
        self.removeDeclarations(startingFromIndex: lowerBound, inStyleDeclarationElement: styleDeclaration)
        
        let cssDomRenderer = CSSDOMRenderer(parentContainer: styleDeclaration)
        guard let rootElements = cssDomRenderer.render(stylesheetDeclarations: compiledStylesheet, inCssDocument: cssDomDocument) else {
            assertionFailure("Error: documentFragment is nil")
            return nil
        }
        
        var exception = Exception()
        for declaration in declarationsAfterDeclarationsRange {
            let inclusiveDescendants = declaration.inclusiveDescendants()
            for var inclusiveDescendant in inclusiveDescendants {
                inclusiveDescendant.move(sourceStringChangeDescription.changeLength)
            }
            styleDeclaration.appendChild(declaration, exception: &exception)
        }
        
        let stoppedCompilationNode = cssDomDocument.styleSheet.childRuleElement(at: ruleIndex+1)
        
        if let stoppedCompilationNode = stoppedCompilationNode {
        
            let insertedNodesRightSubtree = cssDomDocument.styleSheet.rightSubtree(ofChild: stoppedCompilationNode, inclusive: false)
            self.moveElements(insertedNodesRightSubtree, usingChangeDescription: sourceStringChangeDescription)
        }
        
        return rootElements
    }
    
    /*

                                              css-style-rule
                                                    |
                                        ____________|____________
                                       /                         \
                                      /                              \
                                selector-list              style-declaration-block
    
    
                                         style-declaration-block
                                                    |
                    ________________________________|______________________________
                   /                                |                              \
                  /                                 |                                 \
      css-token.left-curly-brace          style-declaration         css-token.right-curly-brace
    
    
                                           style-declaration
                                                    |
                             _______________________|_________________________
                            /                       |                           \
                           /                        |                           \
                  css-declaration                    *                    css-declaration

    */
    private func updateCssDocumentWithSelectorList(atRuleIndex ruleIndex: Int, stylesheetDocumentStore: StylesheetDocumentStore, compiledStylesheet: CSSStyleSheet, sourceStringChangeDescription: SourceStringChangeDescription) -> ContiguousArray<Element>? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updateCssDocument(stylesheetDocumentStore:deletedDomNodes:selectorList:sourceStringChangeDescription:)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard let cssDomDocument = stylesheetDocumentStore.document.value as? CSSDOMDocument else {
            assertionFailure("Error: cssDomDocument is nil")
            return nil
        }
        
        guard var styleRuleElement = cssDomDocument.styleRuleElement(atIndex: ruleIndex) else {
            assertionFailure("Error: styleRuleElement is nil")
            return nil
        }
        
        var exception = Exception()
        
        guard let selectorList = styleRuleElement.firstChild as? CSSDOMElement else {
            assertionFailure("Error: selectorList is nil")
            return nil
        }
        
        // remove its selector list
        styleRuleElement.removeChild(selectorList, exception: &exception)
        
        // get the style declaration block
        guard let styleDeclarationBlock = styleRuleElement.firstChild as? CSSDOMElement else {
            assertionFailure("Error: styleDeclarationBlock is nil")
            return nil
        }
        
        // we remove it to add it again after
        styleRuleElement.removeChild(styleDeclarationBlock, exception: &exception)
        
        let cssDomRenderer = CSSDOMRenderer(parentContainer: styleRuleElement)
        guard let comments = cssDomRenderer.render(stylesheetSelectorList: compiledStylesheet, inCssDocument: cssDomDocument) else {
            assertionFailure("Error: documentFragment is nil")
            return nil
        }
        
        let styleDeclarationBlockNodes = styleDeclarationBlock.inclusiveDescendants()
        self.moveElements(styleDeclarationBlockNodes, usingChangeDescription: sourceStringChangeDescription)
        
        // re-adding it
        styleRuleElement.appendChild(styleDeclarationBlock, exception: &exception)
        
        styleRuleElement.sourceStringSegment?.moveEnd(sourceStringChangeDescription.changeLength)
        
        let stoppedCompilationNode = cssDomDocument.styleSheet.childRuleElement(at: ruleIndex+1)
        
        if let stoppedCompilationNode = stoppedCompilationNode {
        
            let insertedNodesRightSubtree = cssDomDocument.styleSheet.rightSubtree(ofChild: stoppedCompilationNode, inclusive: false)
            self.moveElements(insertedNodesRightSubtree, usingChangeDescription: sourceStringChangeDescription)
        }
        
        guard let renderedSelectorList = styleRuleElement.firstChild as? CSSDOMElement else {
            assertionFailure("Error: selectorList is nil")
            return nil
        }
        
        var addedRootElements = ContiguousArray<Element>()
        addedRootElements.append(contentsOf: comments)
        addedRootElements.append(renderedSelectorList)
        return addedRootElements
    }
    
    /// Function that update the CSS document.
    /// @return the added root elements (including comments)
    private func updateCssDocument(stylesheetDocumentStore: StylesheetDocumentStore, deletedDomNodes: ContiguousArray<Node>, compiledStylesheet: CSSStyleSheet, updatedStoppedCompilationRuleIndex: Int?, sourceStringChangeDescription: SourceStringChangeDescription) -> ContiguousArray<Element>? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start update updateCssDocument", log: Log.WriterCommon.all, type: .info)
        #endif
        
        let cssDomRenderer = CSSDOMRenderer()
        guard let documentFragment = cssDomRenderer.renderRules(in: compiledStylesheet) else {
            assertionFailure("Error: documentFragment is nil")
            return nil
        }
    
        #if DEBUG
        logDocumentFragmentInfo(documentFragment: documentFragment)
        #endif
        
        guard let cssDomDocument = stylesheetDocumentStore.document.value as? CSSDOMDocument else {
            assertionFailure("Error: cssDomDocument is nil")
            return nil
        }
            
        let (_, addedRootElements) = cssDomDocument.replaceStylesheetElementChilds(deletedDomNodes, withDocumentFragment: documentFragment, updatedStoppedCompilationRuleIndex: updatedStoppedCompilationRuleIndex)
        
        if let updatedStoppedCompilationRuleIndex = updatedStoppedCompilationRuleIndex {
            
            // here the number of inserted rules should be considered
            // with a compilation rules indexes range of 0..<1, we should update the positions
            // of upperBound+numberOfInsertedRules, with 3 inserted rules, it means:
            // 4..<end
            let stoppedCompilationNode = cssDomDocument.styleSheet.childRuleElement(at: updatedStoppedCompilationRuleIndex)
            
            if let stoppedCompilationNode = stoppedCompilationNode {
            
                let insertedNodesRightSubtree = cssDomDocument.styleSheet.rightSubtree(ofChild: stoppedCompilationNode, inclusive: false)
                self.moveElements(insertedNodesRightSubtree, usingChangeDescription: sourceStringChangeDescription)
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("ends successfully", log: Log.WriterCommon.all, type: .info)
        #endif
        return addedRootElements
        
    }
    
    private func moveElements(_ nodeList: NodeList, usingChangeDescription changeDescription: SourceStringChangeDescription) {
        
        // update the fragments after the inserted ones
        for var node in nodeList {
            
            // FIXME: This is really strange, the move function of element
            // is not called unless I cast it to Element like this.
            // We shouldn't need to do this.
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("before node: %@", log: Log.WriterCommon.all, type: .info, %%node)
            os_log("before node sourceStringFragment: %@", log: Log.WriterCommon.all, type: .info, %%String(describing: node.sourceStringFragment))
            #endif
            if let element = node as? Element {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("before element sourceStringFragment: %@ with classes: %@", log: Log.WriterCommon.all, type: .info, %%String(describing: node.sourceStringFragment), %%element.classListString)
                #endif
                
                element.move(changeDescription.changeLength)
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("after node: %@", log: Log.WriterCommon.all, type: .info, %%node)
            os_log("after node sourceStringFragment: %@", log: Log.WriterCommon.all, type: .info, %%String(describing: node.sourceStringFragment))
            #endif
        }
    }
    
    private func logDocumentFragmentInfo(documentFragment: CSSDOMDocumentFragment) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("New fragment compiled from replacementTokens: %@", log: Log.WriterCommon.all, type: .debug, %%HTMLSerializer.createWithGeneratedIds().serializeHTMLFragment(documentFragment))
        
        if let childNodes = documentFragment.childNodes {
            for childNode in childNodes {
                if let element = childNode as? Element {
                    if let sourceStringSegment = element.sourceStringFragment as? SourceStringSegment {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error with fragment: %@", log: Log.WriterCommon.all, type: .info, %%sourceStringSegment)
                        #endif
                        assert(sourceStringSegment.startIndex >= 0)
                        assert(sourceStringSegment.startIndex <= sourceStringSegment.endIndex)
                    }
                    assert(element.nwElementId != nil)
                }
            }
        }
        
        if let childNodes = documentFragment.childNodes {
            for childNode in childNodes {
                if let element = childNode as? Element {
                    assert(element.nwElementId != nil)
                }
            }
        }
        #endif
    }
    
    
    /*
                                           style-declaration
                                                    |
                             _______________________|_________________________
                            /                       |                           \
                           /                        |                           \
                  css-declaration                    *                    css-declaration

    */
    @discardableResult
    private func removeDeclarations(startingFromIndex index: Int, inStyleDeclarationElement styleDeclaration: CSSDOMElement) -> [CSSDOMElement] {
        
        var removedDeclarations: [CSSDOMElement] = []
        
        assert(styleDeclaration.localName == §CSSElementType.StyleDeclaration)
        
        var child = styleDeclaration.firstChild
        var currentIndex = 0
        while let _child = child, currentIndex != index {
            child = _child.nextSibling
            currentIndex += 1
        }
        
        while let cssDeclaration = child as? CSSDOMElement {
            removedDeclarations.append(cssDeclaration)
            child = child?.nextSibling
        }
        
        var exception = Exception()
        for removedDeclaration in removedDeclarations {
            styleDeclaration.removeChild(removedDeclaration, exception: &exception)
        }
        
        return removedDeclarations
    }
    
}
