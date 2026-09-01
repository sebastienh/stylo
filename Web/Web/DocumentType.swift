//
//  DocumentTypeImpl.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#documenttype
//interface DocumentType : Node {
//    readonly attribute DOMString name;
//    readonly attribute DOMString publicId;
//    readonly attribute DOMString systemId;
//};
public final class DocumentType : Node {
    
    internal(set) var publicId: DOMString
    
    internal(set) var systemId: DOMString
    
    var name: DOMString

    override public var length: Int {
        
        return 0
    }
    
    init(document: Document?, name: DOMString, publicId: DOMString = "", systemId: DOMString = "") {

        self.publicId = publicId
        self.systemId = systemId
        self.name = name
        super.init(document: document, sourceStringFragment: nil)
        self.nodeName = self.name
        self.nodeType = NodeType.document_type_node
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
    //                                  MARK: DomInspectable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override var numberOfChildren: Int {
        
        return 0
    }
    
    public override var expandable: Bool {
     
        return false
    }
    
    public override var expandedOpenElementString: String {
        
        return ""
    }
    
    public override var unexpandedElementString: String {
        
        return "doctype " + name
    }
    
    public override func childAtIndex(_ index: Int) -> DomInspectable? {
        
        return nil
    }
    
    /// This method returns true is the current ContainerNode
    /// has only text nodes.
    public override func hasOnlyChildTextNodes() -> Bool {
        
        return false
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = DocumentType
    
    override public func cloneNode(_ deep: Bool = false) -> DocumentType {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! DocumentType
    }

    override public func createInstance() -> DocumentType {
        
        let instance = DocumentType(document: nil, name: self.name)
        
        return instance
    }
    
    func cloneFields(_ copy: inout DocumentType) {
        
        var node = copy as Node
        
        super.cloneFields(&node)
        
        copy.publicId = self.publicId
        copy.systemId = self.systemId
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? DocumentType {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
      
                if self.publicId != other.publicId {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: publicId are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false;
                }
                
                if self.systemId != other.systemId {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: systemId are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false;
                }
                
                if self.name != other.name {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: name are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false;
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not DocumentType.", log: Log.Web.all, type: .debug)
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
        
        if let otherDocumentType = node as? DocumentType {
        
            if self.publicId != otherDocumentType.publicId {
                
                return false;
            }
            
            if self.systemId != otherDocumentType.systemId {
                
                return false;
            }
            
            if self.name != otherDocumentType.name {
                
                return false;
            }
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override public var hashValue: Int {
        
        // FIXME: Test the proformance of this hash and make sure it is not
        // too slow in critical operations.

        return UInt(bitPattern: ObjectIdentifier(self)).hashValue
//        var h: Int = nodeType.hashValue ^ nodeName.hashValue ^ super.hashValue
//        
//        //    readonly attribute DOMString name;
//        //    readonly attribute DOMString publicId;
//        //    readonly attribute DOMString systemId;
//        
//        h = h ^ name.hashValue
//        
//        h = h ^ publicId.hashValue
//        
//        h = h ^ systemId.hashValue
//        
//        return h
    }
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: DocumentType, rhs: DocumentType) -> Bool {
    
    return lhs.isEqualNode(rhs)
}
