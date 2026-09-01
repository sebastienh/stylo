//
//  Visitor.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-07.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common

public protocol CSVisitor {
    
    func visit(_ node: CSStyleSheet) -> NodeInfo
    func visit(_ node: CSAtRule) -> NodeInfo
    func visit(_ node: CSQualifiedRule) -> NodeInfo
    func visit(_ node: CSSimpleBlock) -> NodeInfo
    //    func visit(node: CSDeclaration) -> NodeInfo
    //    func visit(node: CSComponentValue) -> NodeInfo
//    func visit(node: CSPreservedTokenComponentValue) -> NodeInfo
    //    func visit(node: CSFunctionComponentValue) -> NodeInfo
    //    func visit(node: CSSimpleBlockComponentValue) -> NodeInfo
    //    func visit(node: CSFunction) -> NodeInfo
    
    func push(_ nodeInfo: NodeInfo)
    
    // in pre order traversal, only the root node
    // knows when to remove itself from the possible
    // Visitor stack
    func pop()
    
}
