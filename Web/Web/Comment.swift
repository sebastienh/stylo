//
//  Comment.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#comment
//[Constructor(optional DOMString data = "")]
//interface Comment : CharacterData {
//};

final class Comment: CharacterData {
    
    override init(sourceStringFragment: SourceStringFragment?, document: Document?, data: DOMString) {

        super.init(sourceStringFragment: sourceStringFragment, document: document, data: data)
        
        self.nodeType = NodeType.comment_node
        self.nodeName = "#comment"
    }
    
    convenience init(document: Document, data: DOMString = "") {
        
        self.init(sourceStringFragment: nil, document: document, data: data)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = Comment
    
    override func cloneNode(_ deep: Bool = false) -> Comment {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! Comment
    }
    
    override func createInstance() -> Comment {
        
        return Comment(document: nil, data: self.data)
    }
    
    func cloneFields(_ copy: inout Comment) {
        
        var node = copy as CharacterData
        
        super.cloneFields(&node)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? Comment {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not Comment.", log: Log.Web.all, type: .debug)
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
    //                                  MARK: EquatableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// https://dom.spec.whatwg.org/#dom-node-isequalnode
    override func isEqualNode(_ node: Node?) -> Bool {
        
        if !super.isEqualNode(node) {
            
            return false
        }
        
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override internal var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//        
//        return h
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: Comment, rhs: Comment) -> Bool {
    
    return lhs.isEqualNode(rhs)
}








