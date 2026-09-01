//
//  LayoutRenderTreeVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-10.
//  Copyright (c) 2015 NM. All rights reserved.
//
//
//import Foundation
//import Common
//
//final class LayoutRenderTreeVisitor: RenderTreeVisitor {
//    
//    let resourceComputedStyle: ResourceComputedStyle
//    
//    init(resourceComputedStyle: ResourceComputedStyle) {
//        
//        self.resourceComputedStyle = resourceComputedStyle
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: RenderTreeVisitor protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    func visit(_ node: RenderBlock) -> RenderObjectNodeInfo? {
//        
//        node.layout(resourceComputedStyle: resourceComputedStyle)
//        
//        return RenderObjectNodeInfo(node: node)
//    }
//    
//    func visit(_ node: RenderText) -> RenderObjectNodeInfo? {
//        
//        node.layout(resourceComputedStyle: resourceComputedStyle)
//        
//        return RenderObjectNodeInfo(node: node)
//    }
//    
//    func visit(_ node: RenderInline) -> RenderObjectNodeInfo? {
//        
//        node.layout(resourceComputedStyle: resourceComputedStyle)
//        
//        return RenderObjectNodeInfo(node: node)
//    }
//    
//    func visit(_ node: RenderDocumentElement) -> NodeInfoType? {
//        
//        node.layout(resourceComputedStyle: resourceComputedStyle)
//        
//        return RenderObjectNodeInfo(node: node)
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: Visitor protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    typealias NodeInfoType = RenderObjectNodeInfo
//    
//    func push(_ nodeInfo: RenderObjectNodeInfo) {
//        
//        // nothing to do yet
//    }
//    
//    // in pre order traversal, only the root node
//    // knows when to remove itself from the possible
//    // Visitor stack
//    func pop() {
//        
//        // nothing to do yet
//    }
//    
//}

