//
//  RenderingProcessingResult.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-20.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import Web
import os

public struct RenderingProcessingResult: CustomDebugStringConvertible, Equatable {

    enum AttributeAction {
        case delete
        case add
        case set
    }
    
    #if DEBUG
    var targetString: String?
    #endif
    
    /// element and in the CSS case it is the "stylesheet" element.
    var documentAttributes: DocumentAttributes?
    
    var attributes: [AttributeAction: [AttributesRange]]
    
    let renderedTopElements: ContiguousArray<Element>?
    
    let focusType: FocusType?
    
    public var isFocused: Bool {
        
        return focusType != nil
    }
    
    public var debugDescription: String {
        var _debugString = "attributes:\n\n"
        
        for (attributeAction, attribuesValues) in attributes {
            for attribuesValue in attribuesValues {
                _debugString += "\(attributeAction):\(attribuesValue.range) = \(attribuesValue.attributes)\n"
            }
        }
        return _debugString
    }
    
    init(documentAttributes: DocumentAttributes?, addedAttributes: [AttributesRange], setAttributes: [AttributesRange], deletedAttributes: [AttributesRange], renderedTopElements: ContiguousArray<Element>?, focusType: FocusType?) {
        
        self.attributes = [
            AttributeAction.add: addedAttributes,
            AttributeAction.set: setAttributes,
            AttributeAction.delete: deletedAttributes
        ]
        
        self.documentAttributes = documentAttributes
        self.renderedTopElements = renderedTopElements
        self.focusType = focusType
    }

    mutating func updateWithPendingRequests(_ pendingRequests: Queue<SourceStringChangeDescription>) {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("updateWithPendingRequests(%@)", log: Log.WriterCommon.all, type: .info, %%pendingRequests)
        #endif
        
        if !pendingRequests.isEmpty {

            assert(Thread.isMainThread)
            // we update the ranges with the requests
            pendingRequests.execute { pendingRequest in

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
                os_log("update with pending request: %@", log: Log.WriterCommon.all, type: .info, %%pendingRequest)
                #endif
                
                for (attributeAction, attributesValues) in attributes {
                    attributes[attributeAction] = updateAttributesRanges(attributesValues, with: pendingRequest)
                }
                
                #if DEBUG
                if var targetString = self.targetString {
                    let range = pendingRequest.range
                    let startRangeIndex = targetString.utf16.index(targetString.utf16.startIndex, offsetBy: range.lowerBound)
                    let endRangeIndex = targetString.utf16.index(targetString.utf16.startIndex, offsetBy: range.upperBound)
                    targetString.replaceSubrange(startRangeIndex..<endRangeIndex, with: pendingRequest.stringReplacement!)
                    self.targetString = targetString
                }
                #endif
            }
        }
    }

    private func updateAttributesRanges(_ attributesRanges: [AttributesRange], with request: SourceStringChangeDescription) -> [AttributesRange] {

        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("updateAttributesRanges(%@, with: %@)", log: Log.WriterCommon.all, type: .info, %%attributesRanges, %%request)
        #endif
        
        var result = [AttributesRange]()
        for attributesRange in attributesRanges {
            
            let ranges = attributesRange.range.update(with: request)
            if let ranges = ranges {
                for range in ranges {
                    result.append(AttributesRange(attributesRange.attributes, range, attributesRange.originNodeName))
                }
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("updateAttributesRanges -> result: %@", log: Log.WriterCommon.all, type: .info, %%result)
        #endif
        
        return result
    }
    
    static func displayDifference(lhs: RenderingProcessingResult, rhs: RenderingProcessingResult) {
        
        func compareAttributes(first: [AttributesRange], second: [AttributesRange], action: AttributeAction) {
            
            guard first.count == second.count else {
                print("Error: not same attributes amount: first: \(first.count), second: \(second.count) for action: \(action)")
                return
            }
            
            for y in 0..<first.count {
                
                let firstAttributes = first[y]
                let secondAttributes = second[y]
                
                if firstAttributes.originNodeName != secondAttributes.originNodeName {
                    print("originNodeName is different: first: \(firstAttributes.originNodeName), second: \(secondAttributes.originNodeName) for action: \(action)")
                }
                
                if firstAttributes.range != secondAttributes.range {
                    print("range is different: first: \(firstAttributes.range), second: \(secondAttributes.range) for action: \(action)")
                }
                
                if !firstAttributes.attributes.equals(to: secondAttributes.attributes) {
                    print("attributes is different: fast: \(firstAttributes.attributes), slow: \(secondAttributes.attributes)")
                }
            }
        }
        
        compareAttributes(first: lhs.attributes[.add]!, second: rhs.attributes[.add]!, action: .add)
        compareAttributes(first: lhs.attributes[.delete]!, second: rhs.attributes[.delete]!, action: .delete)
        compareAttributes(first: lhs.attributes[.set]!, second: rhs.attributes[.set]!, action: .set)
    }
    
    public static func ==(lhs: RenderingProcessingResult, rhs: RenderingProcessingResult) -> Bool {

        guard lhs.attributes[.add]?.count == rhs.attributes[.add]?.count else {
//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: count are different: %@ vs %@", log: Log.WriterCommon.all, type: .debug, %%lhs.attributes[.add]?.count, %%rhs.attributes[.add]?.count)
//            #endif
            return false
        }
        
        if let lhsAttributes = lhs.attributes[.add], let rhsAttributes = rhs.attributes[.add] {
            
            guard lhsAttributes.count == rhsAttributes.count else {

    //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: count are different", log: Log.WriterCommon.all, type: .debug)
                os_log("lhs[.add]: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributes.count)
                os_log("rhs[.add]: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributes.count)
    //            #endif
                return false
            }

            for i in 0..<lhsAttributes.count {
                let lhsAttributesRange = lhsAttributes[i]
                let rhsAttributesRange = rhsAttributes[i]
                
                if lhsAttributesRange != rhsAttributesRange {
                    
    //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: attributes are different", log: Log.WriterCommon.all, type: .debug)
                    os_log("lhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributesRange)
                    os_log("rhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributesRange)
    //                #endif
                    return false
                }
            }
        }
        
        if let lhsAttributes = lhs.attributes[.delete], let rhsAttributes = rhs.attributes[.delete] {
            guard lhsAttributes.count == rhsAttributes.count else {

    //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: count are different", log: Log.WriterCommon.all, type: .debug)
                os_log("lhs[.delete]: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributes.count)
                os_log("rhs[.delete]: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributes.count)
    //            #endif
                return false
            }

            for i in 0..<lhsAttributes.count {
                let lhsAttributesRange = lhsAttributes[i]
                let rhsAttributesRange = rhsAttributes[i]
                
                if lhsAttributesRange != rhsAttributesRange {
                    
    //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: attributes are different", log: Log.WriterCommon.all, type: .debug)
                    os_log("lhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributesRange)
                    os_log("rhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributesRange)
    //                #endif
                    return false
                }
            }
        }
        
        if let lhsAttributes = lhs.attributes[.set], let rhsAttributes = rhs.attributes[.set] {
            
            guard lhsAttributes.count == rhsAttributes.count else {

    //            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: count are different", log: Log.WriterCommon.all, type: .debug)
                os_log("lhs[.set]: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributes.count)
                os_log("rhs[.set]: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributes.count)
    //            #endif
                return false
            }

            for i in 0..<lhsAttributes.count {
                let lhsAttributesRange = lhsAttributes[i]
                let rhsAttributesRange = rhsAttributes[i]
                
                if lhsAttributesRange != rhsAttributesRange {
                    
    //                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: attributes are different", log: Log.WriterCommon.all, type: .debug)
                    os_log("lhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributesRange)
                    os_log("rhs attributes range: %@", log: Log.WriterCommon.all, type: .debug, %%rhsAttributesRange)
    //                #endif
                    return false
                }
            }
        }
        
        return true
    }
}

extension Array where Element == AttributesRange {

    static func ==(lhs: [AttributesRange], rhs: [AttributesRange]) -> Bool {

        guard lhs.count == rhs.count else {

//            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: count are different: %@ vs %@", log: Log.WriterCommon.all, type: .debug, %%lhs.count, %%rhs.count)
//            #endif
            return false
        }

        for i in 0..<lhs.count {
            let lhsAttributesRange = lhs[i]
            let rhsAttributesRange = rhs[i]
            
            if lhsAttributesRange != rhsAttributesRange {
                
//                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: attrobutes are different: %@ vs %@", log: Log.WriterCommon.all, type: .debug, %%lhsAttributesRange, %%rhsAttributesRange)
//                #endif
                return false
            }
        }
        
        return true
    }

}
