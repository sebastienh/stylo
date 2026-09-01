//
//  DocumentFragment.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-22.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#documentfragment
//interface DocumentFragment : Node {
//};
//DocumentFragment implements ParentNode;
open class DocumentFragment: ContainerNode, ScopingElement {
    
    /// see https://dom.spec.whatwg.org/#concept-documentfragment-host
    let host: Element?
    
    public convenience init(document: Document?, host: Element? = nil) {

        self.init(sourceStringFragment: nil, document: document, host: host)
    }
    
    public init(sourceStringFragment: SourceStringFragment?, document: Document?, host: Element? = nil) {
        
        self.host = host
        super.init(document: document, sourceStringFragment: sourceStringFragment)
        self.nodeName = "#document-fragment"
        self.nodeType = NodeType.document_fragment_node
    }
    
    // MARK: locate namespace
    
    /// Locate a namespace : default implementation
    /// see https://dom.spec.whatwg.org/#locate-a-namespace
    /// Overidden by Element, Document, DocumentType and DocumentFragment
    override func locateNamespace(_ prefix: DOMString?) -> DOMString? {
        
        // Return null.
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = DocumentFragment
    
    override open func cloneNode(_ deep: Bool = false) -> DocumentFragment {
        
        var copy = createInstance()
        
        cloneFields(&copy)
        
        if deep {
            
            cloneChildren(into: copy, deep: deep)
        }
        
        return copy
    }
    
    // Let Node version do it's job
    func cloneFields(_ copy: inout DocumentFragment) {
        
        var containerNode = copy as ContainerNode
        
        super.cloneFields(&containerNode)
    }
    
    /// Create instance suppot
    override open func createInstance() -> DocumentFragment {
        
        return DocumentFragment(document: nil, host: self.host)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? DocumentFragment {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not DocumentFragment.", log: Log.Web.all, type: .debug)
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
    
    
    /// boolean isEqualNode(Node? node);
    /// https://dom.spec.whatwg.org/#dom-node-isequalnode
    override func isEqualNode(_ other: Node?) -> Bool {
        
        if !super.isEqualNode(other) {
            return false
        }
        
        if let otherDocumentFragment = other as? DocumentFragment {
            
            if let _ = host {
                
                if let _ = otherDocumentFragment.host {
                    
                }
                else {
                    return false
                }
            }
            else if otherDocumentFragment.host != nil {
                
                return false
            }
        }
        
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//        
//        if let host = host {
//            h = h ^ host.hashValue
//        }
//        
//        return h
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

public func ==(lhs: DocumentFragment, rhs: DocumentFragment) -> Bool {
    
    return lhs.isEqualNode(rhs)
}


















