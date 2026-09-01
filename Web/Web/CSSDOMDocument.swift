//
//  CSSSourceDOMDocument.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

///
/// A css source dom document has pointers to one or more
/// css source style sheets.
///
public final class CSSDOMDocument: Document, CSSDOMVisitable {
    
    public static func Create() -> CSSDOMDocument {
        
        var exception = Exception()
        
        let cssDomDocument = CSSDOMDocument()
        
        let documentType = DocumentType(document: cssDomDocument, name: "css")
        cssDomDocument.append(documentType, exception: &exception)
        
        // create the CSSDOMStyleSheet which acts as the
        // documentElement
        cssDomDocument.styleSheet = CSSDOMStyleSheetElement(sourceStringSegment: nil, document: cssDomDocument)
        
        cssDomDocument.append(cssDomDocument.styleSheet, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Exception while creating style sheet", log: Log.Web.all, type: .error)
            #endif
        }
        
        return cssDomDocument
    }
    
    public var styleSheet: CSSDOMStyleSheetElement!
    
    fileprivate override init() {
        
        super.init()
        self.contentType = §Language.CSS
    }
    
    /// Replaces all childs in the specified range with the new nodes
    /// in the order they are in the array.
    /// NOT A DOM OFFICIAL METHOD: should not be made available to javascript.
    public func replaceStylesheetElementChilds(_ deletedDomTopNodes: ContiguousArray<Node>, withDocumentFragment documentFragment: CSSDOMDocumentFragment, updatedStoppedCompilationRuleIndex: Int?) -> (Node?, ContiguousArray<Element>) {
        
        var exception = Exception()
        var nodeToInsertBefore: Node? = nil
        var rootElements = ContiguousArray<Element>()
        
        // delete the range and keep a pointer to the last Node
        // in order to insert the DocumentFragment using insertBefore.
        if self.styleSheet.hasChildNodes() {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("number of childs before removing: %d", log: Log.Web.all, type: .info, self.styleSheet.length)
            os_log("number of childs to delete: %d", log: Log.Web.all, type: .info, deletedDomTopNodes.count)
            #endif
            
            if !deletedDomTopNodes.isEmpty {
    
                for nodeToDelete in deletedDomTopNodes {
                    
                    if let nodeToDelete = nodeToDelete as? CSSDOMTokenElement {
                        
                        if nodeToDelete.tokenClass != .CommentToken {
                            nodeToInsertBefore = nodeToDelete.nextSibling
                            self.styleSheet.remove(nodeToDelete, exception: &exception)
                            exception.logIfError()
                        }
                    }
                    else {
                        nodeToInsertBefore = nodeToDelete.nextSibling
                        self.styleSheet.remove(nodeToDelete, exception: &exception)
                        exception.logIfError()
                    }
                }
            }
        
            if let updatedStoppedCompilationRuleIndex = updatedStoppedCompilationRuleIndex, nodeToInsertBefore == nil {
                
                var numberOfInsertedNodes = documentFragment.length
                numberOfInsertedNodes = numberOfInsertedNodes - documentFragment.commentsCount
                let originalStoppedCompilationRuleIndex = updatedStoppedCompilationRuleIndex - numberOfInsertedNodes
                assert(originalStoppedCompilationRuleIndex < self.styleSheet.length)
                
                nodeToInsertBefore = styleSheet.childRuleElement(at: originalStoppedCompilationRuleIndex)
            }
        
            let comments = documentFragment.removeAllComments()
            
            // when we arrive here we must have ajusted the positions
            // of the comments that were already there otherwise it will
            // not be possible to insert them in order.
            self.styleSheet.insertCommentsInOrder(comments: comments)
            
            // comments too will need to be redisplayed
            // all comments are root elements (all childs of the DocumentFragment)
            for comment in comments {
                rootElements.append(comment)
            }
            
            // only the child elements of the document fragment are returned
            let nodes = self.styleSheet.insertBefore(documentFragment, before: nodeToInsertBefore, exception: &exception)
            exception.logIfError()
            
            if let nodes = nodes {
                for node in nodes {
                    if let element = node as? Element {
                        rootElements.append(element)
                    }
                }
            }
        }
        
        return (nodeToInsertBefore, rootElements)
    }
    
    /// Functions that update the positions of the existing comments
    /// in the current document. The index passed is based on the old
    /// string since all comments are still based on it.
    public func updateCommentsPositions(after oldStringIndex: Int, of count: Int) {
        
        let children = styleSheet.children
        
        for child in children {
            
            if let comment = child as? CSSDOMTokenElement, comment.tokenClass == .CommentToken {
                
                let commentSourceStringSegment = comment.sourceStringFragment as? SourceStringSegment
                
                assert(commentSourceStringSegment != nil)
                if var commentSourceStringSegment = commentSourceStringSegment{
                    
                    if oldStringIndex <= commentSourceStringSegment.startIndex {
                        
                        commentSourceStringSegment.move(count)
                        
                        // replace the sourceStringFragment with the moved copy 
                        comment.sourceStringFragment = commentSourceStringSegment
                    }
                }
            }
            else {
                break
            }
        }
        
    }
    
    public func removeComments(in range: Range<Int>) -> [Element] {
        
        var exception = Exception()
        let children = styleSheet.children
        var removedComments = [Element]()
        
        for child in children {
            
            if let comment = child as? CSSDOMTokenElement, comment.tokenClass == .CommentToken {
                
                let commentSourceStringSegment = comment.sourceStringFragment as? SourceStringSegment
                
                assert(commentSourceStringSegment != nil)
                if let commentSourceStringSegment = commentSourceStringSegment{
                    
                    if commentSourceStringSegment.isInside(range: range) {
                        
                        styleSheet.remove(comment, exception: &exception)
                        removedComments.append(comment)
                        exception.logIfError()
                    }
                }
            }
            else {
                break
            }
        }
        return removedComments
    }
    
    public func removeAllComments() -> [Element] {
        
        var exception = Exception()
        let children = styleSheet.children
        var removedComments = [Element]()
        
        for child in children {
            
            if let comment = child as? CSSDOMTokenElement, comment.tokenClass == .CommentToken {
                
                styleSheet.remove(comment, exception: &exception)
                removedComments.append(comment)
                exception.logIfError()
            }
        }
        return removedComments
    }
    
    private func updateComments(fromDocumentFragment documentFragment: CSSDOMDocumentFragment) -> ContiguousArray<Element> {
        
        // 1. remove them from the document fragment
        let comments = documentFragment.removeAllComments()
        
        // when we arrive here we must have ajusted the positions
        // of the comments that were already there otherwise it will
        // not be possible to insert them in order.
        self.styleSheet.insertCommentsInOrder(comments: comments)
        
        var removedComments = ContiguousArray<Element>()
        
        // comments too will need to be redisplayed
        // all comments are root elements (all childs of the DocumentFragment)
        for comment in comments {
            removedComments.append(comment)
        }
        
        return removedComments
    }
    
    /*

                                              css-style-rule
                                                    |
                                        ____________|____________
                                       /                         \
                                      /                           \
                                selector-list              style-declaration-block

    */
    public func styleRuleElement(atIndex ruleIndex: Int) -> Element? {
        
        guard let element = self.styleSheet.rulesChildren[ruleIndex] as? CSSDOMElement else {
            assertionFailure("Error: element is nil")
            return nil
        }
        
        guard element.localName == §CSSElementType.StyleRule else {
            assertionFailure("Error: element.localName is not: \(§CSSElementType.StyleRule )")
            return nil
        }
        
        return element
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSDOMDocument {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: super is not CSSDOMDocument.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSDOMVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    @discardableResult
    public func accept<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo , _nodeInfo.visitChildren {
        
            visitor.push(_nodeInfo)
            
            if let documentElement = self.documentElement as? CSSDOMVisitable {
                
                documentElement.accept(visitor)
            }

            visitor.pop()        
        }
        
        return nodeInfo
    }
    
    @discardableResult
    public func acceptSingle<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
}
