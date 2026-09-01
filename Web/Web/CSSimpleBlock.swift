//
//  SimpleBlock.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-30.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSimpleBlock: CSLanguageObject, CSVisitable, Equatable {

    var startToken: Token
    var endToken: Token
    
    var componentValueList: [CSComponentValue]
    
    init(startToken: Token, endToken: Token, componentValueList: [CSComponentValue] = [CSComponentValue]()) {
    
        self.startToken = startToken
        self.endToken = endToken
        self.componentValueList =  componentValueList
        
        let sourceStringSegment = SourceStringSegment(startIndex: startToken.sourceStringSegment!.startIndex, endIndex: endToken.sourceStringSegment!.endIndex)

        super.init(sourceStringSegment: sourceStringSegment)
    }
    
    func clone() -> CSSimpleBlock {
        
        var clonedComponents = [CSComponentValue]()
        
        for componentValue in componentValueList {
            clonedComponents.append(componentValue.clone())
        }
        
        let simpleBlock = CSSimpleBlock(startToken: startToken, endToken: endToken, componentValueList: clonedComponents)
        simpleBlock.messageHandler = self.messageHandler
        return simpleBlock
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.startToken.move(count)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("startToken.sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: startToken.sourceStringSegment))
        #endif
        
        for i in 0..<componentValueList.count {
            componentValueList[i].move(count)
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("componentValueList[%d]: %@", log: Log.Web.all, type: .info, i, %%String(describing: componentValueList[i].sourceStringSegment))
            #endif
        }
        
        self.endToken.move(count)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("endToken.sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: endToken.sourceStringSegment))
        #endif
        
        self.sourceStringSegment = SourceStringSegment(startIndex: startToken.sourceStringSegment!.startIndex, endIndex: endToken.sourceStringSegment!.endIndex)
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("sourceStringSegment: %@", log: Log.Web.all, type: .info, %%String(describing: sourceStringSegment))
        #endif
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // 1. Visit the root.
    // 2. Traverse the left subtree.
    // 3. Traverse the right subtree.
    public func accept(_ visitor: CSVisitor) -> NodeInfo {
        
        let nodeInfo = visitor.visit(self)

        visitor.push(nodeInfo)
        
        // The upper visitor does all the work 
        // no need to visit child nodes because
        // it implies parsing a lot of component values
        // which would be hard to handle in a visitor
        // way
//        for componentValue in componentValueList {
//            componentValue.accept(visitor)
//        }
        
        visitor.pop()
        
        return nodeInfo
    }

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSSimpleBlock {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if !startToken.equals(to: other.startToken, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: startToken are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if componentValueList.count != other.componentValueList.count {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: componentValueList.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                assert(componentValueList.count == other.componentValueList.count)
                for index in 0..<other.componentValueList.count {
                    
                    if !componentValueList[index].equals(to: other.componentValueList[index], comparePositions: comparePositions)  {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: componentValueList element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CSSimpleBlock.", log: Log.Web.all, type: .debug)
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
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: CSTextNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSimpleBlock: CSTextNode {
    
    func cssText() -> DOMString {
        
        var cssTextValue = DOMString(startToken.rawStringValue)
        
        for componentValue in componentValueList {
            cssTextValue = cssTextValue + componentValue.cssText()
        }
        
        cssTextValue += endToken.rawStringValue
        return cssTextValue
    }
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: DotStringNode protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

extension CSSimpleBlock: DotStringNode {
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSSimpleBlock\"];\n"
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
public func ==(lhs: CSSimpleBlock, rhs: CSSimpleBlock) -> Bool {
    
    return lhs.equals(to: rhs)
}
