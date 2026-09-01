//
//  CSSDOMStyleSheetElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSDOMStyleSheetElement: CSSDOMElement {
    
    override public var isRoot: Bool {
        return true
    }
    
    public var rulesChildren: HTMLCollection {
        
        let filter = RulesFilter(root: self)
        return HTMLCollection(root: self, filter: filter)
    }
    
    /// The style sheet may be empty in this case there is no source segment
    init(sourceStringSegment: SourceStringSegment?, document: CSSDOMDocument?) {
        
        super.init(segment: sourceStringSegment,
            document: document,
            localName: §CSSElementType.CSSStyleSheet)
    }
    
    public func childRuleElement(at index: Int) -> Node? {
    
        var child = self.firstChild
        
        while let comment = child as? CSSDOMTokenElement, comment.tokenClass == .CommentToken {
            child = comment.nextSibling
        }
        
        for _ in 0..<index {
            child = child?.nextSibling
        }
        return child
    }
    
    public func insertCommentsInOrder(comments: [CSSDOMTokenElement]) {
        
        #if DEBUG
        validateCommentsAreInOrder(comments: comments)
        #endif
        
        var exception = Exception()
        
        // take a modifiable copy
        var _comments = comments
        
        // iterate through the childs
        var child = self.firstChild
        
        while child != nil {
            
            if let commentChild = child as? CSSDOMTokenElement, commentChild.tokenClass == .CommentToken {
            
                let commentChildourceStringSegment = commentChild.sourceStringSegment
                
                assert(commentChildourceStringSegment != nil)
                if let commentChildourceStringSegment = commentChildourceStringSegment {
                
                    var insertedCount = 0
                    for i in 0..<_comments.count {
                    
                        let tokenElement = _comments[i]
                        assert(tokenElement.tokenClass == .CommentToken)
                        if tokenElement.tokenClass == .CommentToken {
                            
                            let sourceStringSegment = tokenElement.sourceStringSegment
                            
                            assert(sourceStringSegment != nil)
                            if let sourceStringSegment = sourceStringSegment {
                             
                                if sourceStringSegment.endIndex <= commentChildourceStringSegment.startIndex {
                                    
                                    self.insertBefore(tokenElement, before: commentChild, exception: &exception)
                                    insertedCount += 1
                                }
                            }
                        }
                    }
                    
                    // delete the inserted comments
                    for _ in 0..<insertedCount {
                        _comments.removeFirst()
                    }
                }
            }
            else {

                // if there is any comments left we insert them all
                for _comment in _comments {
                    
                    #if DEBUG
                    if let sourceStringSegment = _comment.sourceStringSegment {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Inserted comment source string segment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
                        #endif
                    }
                    #endif
                    
                    self.insertBefore(_comment, before: child, exception: &exception)
                    exception.logIfError()
                }
                
                _comments.removeAll()
                
                // validate all following elements are not comments
                #if DEBUG
                validateFollowingChildsAreNotComments(from: child)
                #endif
                
                break
            }
            child = child?.nextSibling
        }
        
        // it's possible for the comments to be not empty at this
        // point since there could be only comments in a modified
        // stylesheet and nothing else.
        if !_comments.isEmpty {
            
            for _comment in _comments {
                self.append(_comment, exception: &exception)
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSDOMStyleSheetElement {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSDOMStyleSheetElement.", log: Log.Web.all, type: .debug)
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
    override public func accept<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        let nodeInfo = visitor.visit(self)
        
        if let _nodeInfo = nodeInfo , _nodeInfo.visitChildren {
            
            visitor.push(_nodeInfo)
            
            for child in children {
                
                if let childCSSDOMVisitableElement = child as? CSSDOMVisitable {
                    
                    childCSSDOMVisitableElement.accept(visitor)
                }
                else {
                    
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("child is not CSSDOMVisitable.", log: Log.Web.all, type: .error)
                    #endif
                }
            }   
            visitor.pop()
        }
        return nodeInfo
    }
    
    @discardableResult
    override public func acceptSingle<Visitor: CSSDOMVisitor>(_ visitor: Visitor) -> Visitor.NodeInfoType? {
        
        return visitor.visit(self)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: DEBUG implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func validateFollowingChildsAreNotComments(from startingChild: Node?) {
        
        var child = startingChild
        
        // validate all following elements are not comments
        #if DEBUG
        while child != nil {
            if let commentChild = child as? CSSDOMTokenElement, commentChild.tokenClass == .CommentToken {
                assert(false, "we have found a comment that is later in the document, this shouln't be as all comments should be at the start of the document.")
            }
            child = child?.nextSibling
        }
        #endif
    }
    
    private func validateCommentsAreInOrder(comments: [CSSDOMTokenElement]) {
        
        #if DEBUG
        
        var previousSegment: SourceStringSegment?
        
        for comment in comments {
        
            let sourceStringSegment = comment.sourceStringSegment
            
            assert(sourceStringSegment != nil)
            if let previousSegment = previousSegment, let sourceStringSegment = sourceStringSegment {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("previousSegment: %@", log: Log.Web.all, type: .info, %%previousSegment)
                os_log("current sourceStringSegment: %@", log: Log.Web.all, type: .info, %%sourceStringSegment)
                #endif
                
                let range = sourceStringSegment.range
                
                assert(range != nil)
                if let range = range {
                
                    let relativePosition = previousSegment.relativePosition(from: range)
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("relativePosition: %@", log: Log.Web.all, type: .info, %%String(describing: relativePosition))
                    #endif
                    assert(relativePosition == .before || relativePosition == .same || relativePosition == .inside)
                }
            }
            previousSegment = sourceStringSegment
        }
        
        #endif
    }
    
}
