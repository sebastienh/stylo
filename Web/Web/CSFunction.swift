//
//  CSSFunction.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-29.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

final class CSFunction: CSLanguageObject, CSTextNode, DotStringNode, Equatable {
    
    let name: String
    var componentValueList: [CSComponentValue]
    var rightParenthesisToken: Token?
    
    var endIndex: Int {
        
        if let rightParenthesisToken = rightParenthesisToken {
            
            return rightParenthesisToken.sourceStringSegment!.endIndex
        }
        else if let lastComponent = componentValueList.last {
         
            return lastComponent.sourceStringSegment!.endIndex
        }
        return sourceStringSegment!.endIndex
    }
    
    /// This 
    var completeSourceStringSegment: SourceStringSegment? {
        
        if var sourceStringSegment = self.sourceStringSegment {
        
            for componentValue in componentValueList {
                
                let endIndex = componentValue.sourceStringSegment?.endIndex
                
                assert(endIndex != nil)
                if let endIndex = endIndex {
                    sourceStringSegment.endIndex = endIndex
                }
            }
            if let rightParenthesisToken = rightParenthesisToken {
                
                let endIndex = rightParenthesisToken.sourceStringSegment?.endIndex
                
                assert(endIndex != nil)
                if let endIndex = endIndex {
                    
                    sourceStringSegment.endIndex = endIndex
                }
            }
            return sourceStringSegment
        }
        return nil
    }
    
    init(name: String, sourceStringSegment: SourceStringSegment) {
        
        self.name = name
        self.componentValueList = [CSComponentValue]()
        let segment = SourceStringSegment(startIndex: sourceStringSegment.startIndex, endIndex: sourceStringSegment.endIndex)
        super.init(sourceStringSegment: segment)
    }
    
    func clone() -> CSFunction {
        
        let clone = CSFunction(name: self.name, sourceStringSegment: self.sourceStringSegment!)
        
        for componentValue in componentValueList {
            clone.componentValueList.append(componentValue.clone())
        }
        clone.rightParenthesisToken = rightParenthesisToken
        
        return clone
    }
    
    func cssText() -> DOMString {
        
        var cssTextValue = DOMString(name) + "("
        
        for componentValue in componentValueList {
            
            cssTextValue = cssTextValue + componentValue.cssText()
        }
        if let rightParenthesisToken = rightParenthesisToken {
            
            cssTextValue = cssTextValue + rightParenthesisToken.stringRepresentation
        }
        return cssTextValue
    }
    
    func addComponent(_ component: CSComponentValue) {
        
        componentValueList.append(component)
    }
    
    func dotString(_ nodeName: String) -> String {
        
        return "\(nodeName) [shape=record, label=\"CSFunction: \(name)\"];\n"
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
        for componentValue in componentValueList {
            componentValue.move(count)
        }
        rightParenthesisToken?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol  implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CSFunction {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.name != other.name {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: name are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.componentValueList.count != other.componentValueList.count {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: componentValueList.count are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                for index in 0..<other.componentValueList.count {
                    
                    if !self.componentValueList[index].equals(to: other.componentValueList[index]) {
                        
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: componentValueList element are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if let rightParenthesisToken = rightParenthesisToken {
                    
                    if !rightParenthesisToken.equals(to: other.rightParenthesisToken, comparePositions: comparePositions) {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: rightParenthesisToken are different.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                else if other.rightParenthesisToken != nil {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: other rightParenthesisToken is not nil.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other value is not CSFunction.", log: Log.Web.all, type: .debug)
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
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: CSFunction, rhs: CSFunction) -> Bool {
    
    return lhs.equals(to: rhs)
}

