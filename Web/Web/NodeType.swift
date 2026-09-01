//
//  NodeType.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

//    const unsigned short ELEMENT_NODE = 1;
//    const unsigned short ATTRIBUTE_NODE = 2; // historical
//    const unsigned short TEXT_NODE = 3;
//    const unsigned short CDATA_SECTION_NODE = 4; // historical
//    const unsigned short ENTITY_REFERENCE_NODE = 5; // historical
//    const unsigned short ENTITY_NODE = 6; // historical
//    const unsigned short PROCESSING_INSTRUCTION_NODE = 7;
//    const unsigned short COMMENT_NODE = 8;
//    const unsigned short DOCUMENT_NODE = 9;
//    const unsigned short DOCUMENT_TYPE_NODE = 10;
//    const unsigned short DOCUMENT_FRAGMENT_NODE = 11;
//    const unsigned short NOTATION_NODE = 12; // historical
/**
 *  It is the node type enum identifier. 
 *
 *  The UInt64 is used in order to be able to mask the value 
 *  with WhatToShow enum which is defined as unsigned long.
 *
 *  All historical values has been deleted since it will not be 
 *  implemented here. It is DOM Level 4 implementation.
 */
public enum NodeType : UInt64, Hashable, CustomStringConvertible {
    
    case element_node = 1
    case text_node = 3
    case processing_instruction_node = 7
    case comment_node = 8
    case document_node = 9
    case document_type_node = 10
    case document_fragment_node = 11
    case `nil` = 13
    
    public var description: String {
        
        switch self {
            
        case .element_node:
            return "element_node"
        case .text_node:
            return "text_node"
        case .processing_instruction_node:
            return "processing_instruction_node"
        case .comment_node:
            return "comment_node"
        case .document_node:
            return "document_node"
        case .document_type_node:
            return "document_fragment_node"
        case .document_fragment_node:
            return "document_fragment_node"
        case .nil:
            return "nil"
        }
    }
    
    public var hashValue: Int {
        
        get {
            return self.rawValue.hashValue
        }
    }
}

public func == (lhs: NodeType, rhs: NodeType) -> Bool {
    
    switch (lhs, rhs) {

    case (.element_node,.element_node):
        return true
        
    case (.text_node,.text_node):
        return true
        
    case (.processing_instruction_node, .processing_instruction_node):
        return true
        
    case (.comment_node,.comment_node):
        return true
        
    case (.document_node,.document_node):
        return true
        
    case (.document_type_node,.document_type_node):
        return true
        
    case (.document_fragment_node,.document_fragment_node):
        return true
    
    case (.nil,.nil):
        return true
        
    default:
        return false
    }
}
