//
//  ProcessingInstruction.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#processinginstruction
//interface ProcessingInstruction : CharacterData {
//    readonly attribute DOMString target;
//};

final class ProcessingInstruction : CharacterData {
    
    var target: DOMString
    
    init(document: Document?, data: DOMString, target: DOMString) {
        
        self.target = target
        super.init(sourceStringFragment: nil, document: document, data: data)
        self.nodeName = self.target
        nodeType = NodeType.processing_instruction_node
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = ProcessingInstruction
    
    override func cloneNode(_ deep: Bool = false) -> ProcessingInstruction {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! ProcessingInstruction
    }
    
    override func createInstance() -> ProcessingInstruction {
        
        return ProcessingInstruction(document: nil, data: self.data, target: self.target)
    }
    
    func cloneFields(_ copy: inout ProcessingInstruction) {
        
        var node = copy as CharacterData
        
        super.cloneFields(&node)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? ProcessingInstruction {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }

                if self.target != other.target {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: target are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not ProcessingInstruction.", log: Log.Web.all, type: .debug)
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
        
        if let otherProcessingInstruction = node as? ProcessingInstruction {
        
            if self.target != otherProcessingInstruction.target {
                
                return false;
            }
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
//        // readonly attribute DOMString target;
//        
//        h = h ^ target.hashValue
//        
//        return h
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

func == (lhs: ProcessingInstruction, rhs: ProcessingInstruction) -> Bool {
    
    return lhs.isEqualNode(rhs)
}






