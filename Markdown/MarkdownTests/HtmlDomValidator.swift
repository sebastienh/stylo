//
//  HtmlDomValidator.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-03-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

final class HtmlDomValidator: HtmlDomVisitor {
    
    typealias NodeInfoType = HtmlDomValidatorNodeInfo
    
    var validationStack: Stack<String>
    
    var parentStack: Stack<HtmlDomValidatorNodeInfo>
    
    var success: Bool = true
    
    init() {
        
        self.validationStack = Stack<String>()
        self.parentStack = Stack<HtmlDomValidatorNodeInfo>()
    }
    
    func pop() {
        
        parentStack.pop()
    }
    
    func push(_ nodeInfo: HtmlDomValidatorNodeInfo) {
        
        parentStack.push(nodeInfo)
    }
    
    internal func top() -> HtmlDomValidatorNodeInfo? {
        
        return parentStack.top
    }
    
    func pushNodeNameToValidate(_ nodeName: String) {
        
        validationStack.push(nodeName)
    }

    
    func commonVisit(_ node: Element) -> HtmlDomValidator.NodeInfoType? {
        
        let topNodeName = validationStack.top
        
        debugPrint("Visiting node: \(node.localName)")
        
        if node.localName == topNodeName {
            
            validationStack.pop()
            
            return HtmlDomValidatorNodeInfo()
        }
        else {
            
            success = false
            
            debugPrint("Received: \(node.localName), expecting: \(String(describing: topNodeName))")
            
            return HtmlDomValidatorNodeInfo(visitChildren: false)
        }
    }
    
    func visit(_ node: HtmlDocument) -> HtmlDomValidator.NodeInfoType? {
        
        self.validationStack.reverse()
        
        debugPrint("Visiting node: html document")
        
        // nohing to do on the document itself.
        return HtmlDomValidatorNodeInfo()
    }
    
    func visit(_ node: HTMLElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: HTMLPreElement) -> HtmlDomValidatorNodeInfo? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: PseudoElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: Text) -> HtmlDomValidator.NodeInfoType? {
        
        let topNodeName = validationStack.top
        
        debugPrint("Visiting node: #text")
        debugPrint("text: \(node.data)")
        
        if node.nodeName == topNodeName {
            
            validationStack.pop()
            
            return HtmlDomValidatorNodeInfo()
        }
        else {
            
            debugPrint("Received: \(node.nodeName), expecting: \(topNodeName)")
            
            success = false 
            
            return HtmlDomValidatorNodeInfo(visitChildren: false)
        }
    }
    
    func visit(_ node: PreservedText) -> HtmlDomValidator.NodeInfoType? {
        
        let topNodeName = validationStack.top
        
        debugPrint("Visiting node: #text")
        debugPrint("text: \(node.data)")
        
        if node.nodeName == topNodeName {
            
            validationStack.pop()
            
            return HtmlDomValidatorNodeInfo()
        }
        else {
            
            debugPrint("Received: \(node.nodeName), expecting: \(topNodeName)")
            
            success = false
            
            return HtmlDomValidatorNodeInfo(visitChildren: false)
        }
    }
    
    func visit(_ node: HTMLHtmlElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: HTMLBodyElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: HTMLHeadElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: HTMLTitleElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: HTMLStyleElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
    
    func visit(_ node: MarkdownElement) -> HtmlDomValidator.NodeInfoType? {
        
        return commonVisit(node)
    }
}


