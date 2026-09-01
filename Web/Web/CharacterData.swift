//
//  CharacterData.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

//https://dom.spec.whatwg.org/#characterdata
//interface CharacterData : Node {
//    [TreatNullAs=EmptyString] attribute DOMString data;
//    readonly attribute unsigned long length;
//    DOMString substringData(unsigned long offset, unsigned long count);
//    void appendData(DOMString data);
//    void insertData(unsigned long offset, DOMString data);
//    void deleteData(unsigned long offset, unsigned long count);
//    void replaceData(unsigned long offset, unsigned long count, DOMString data);
//};
open class CharacterData : Node {
    
    /// [TreatNullAs=EmptyString] attribute DOMString data;
    open var data: DOMString
    
    /// readonly attribute unsigned long length;
    public override var length: Int {
        
        get {
            return data.length
        }
    }
    
    public convenience init(document: Document?, data: DOMString = "") {
        
        self.init(sourceStringFragment: nil, document: document, data: data)
    }
    
    init(sourceStringFragment: SourceStringFragment?, document: Document?, data: DOMString = "") {
    
        self.data = data
        super.init(document: document, sourceStringFragment: sourceStringFragment)
    }
    
    /// DOMString substringData(unsigned long offset, unsigned long count);
    /// see https://dom.spec.whatwg.org/#concept-cd-substring
    func substringData(_ offset: Int, count: Int, exception: inout Exception) -> DOMString {
        
        // 1. Let length be node's length attribute value.
        let length = self.length
        
        // 2. If offset is greater than length, throw an IndexSizeError exception.
        if offset > length {
            
            exception.code = ExceptionCode.indexSizeError
            return ""
        }
        
        // 3. If offset plus count is greater than length, return a string 
        // whose value is the code units from the offsetth code unit 
        // to the end of node's data, and then terminate these steps.
        if (offset + count) > length {
        
            if let substring = data.substring(offset) {
                return substring
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Substring return value is nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 4. Return a string whose value is the code units from 
        // the offsetth code unit to the offset+countth code unit in node's data.
        if let substring = data.substring(offset, length: count) {
            return substring
        }
        else {
            assert(false, "Substring return value is nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Substring return value is nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return ""
    }
    
    /// This function replace data with node context object, offset length attribute value, 
    /// count 0, and data data.
    ///
    /// void appendData(DOMString data);
    /// see https://dom.spec.whatwg.org/#dom-characterdata-appenddata
    func appendData(_ data: DOMString, exception: inout Exception) {
        
        return replaceData(self.length, count: 0, data: data, exception: &exception)
    }
    
    /// This function must replace data with node context object, offset offset, 
    /// count 0, and data data.
    ///
    /// void insertData(unsigned long offset, DOMString data);
    /// see https://dom.spec.whatwg.org/#dom-characterdata-insertdata
    func insertData(_ offset: Int, data: DOMString, exception: inout Exception) {

        return replaceData(offset, count: 0, data: data, exception: &exception)
    }
    
    /// This function must replace data with node context object, offset offset, count count, 
    /// and data the empty string.
    ///
    /// void deleteData(unsigned long offset, unsigned long count);
    /// see
    func deleteData(_ offset: Int, count: Int, exception: inout Exception) {

        return replaceData(offset, count: count, data: "", exception: &exception)
    }
    
    /// void replaceData(unsigned long offset, unsigned long count, DOMString data);
    /// see https://dom.spec.whatwg.org/#concept-cd-replace
    func replaceData(_ offset: Int, count: Int, data: DOMString, exception: inout Exception) {

        // Keep an internalCount variable for assignment
        var internalCount = count
        
        // 1. Let length be node's [length](https://dom.spec.whatwg.org/#dom-characterdata-length) 
        // attribute value.
        let length = self.length
        
        // 2. If offset is greater than length, throw an IndexSizeError exception.
        if offset > length {
            
            exception.code = ExceptionCode.indexSizeError
            return
        }
        
        // 3. If offset plus count is greater than length let count be length minus offset.
        if (offset + count) > length {
            internalCount = length - offset
        }
        
        #if MUTATION_RECORDS
        // 4. [Queue a mutation record](https://dom.spec.whatwg.org/#queue-a-mutation-record) 
        // of "[characterData](https://dom.spec.whatwg.org/#characterdata)" 
        // for node with oldValue node's [data](https://dom.spec.whatwg.org/#concept-cd-data).
        if let mutationRecordManager = document.mutationRecordManager {
            
            let characterDataMutationRecord = mutationRecordManager.createCharacterDataMutationRecord(self)
            
            mutationRecordManager.queueMutationRecord(characterDataMutationRecord)
        }
        #endif
            
        // 5. Insert data into node's data after offset code units.
        self.data = self.data.insert(offset, data)
        
        // 6. Let delete offset be offset plus the number of code units in data.
        let deleteOffset = offset + data.length
        
        // 7. Starting from delete offset code units, remove count code units from node's data.
        let startDeleteIndex = self.data.index(self.data.startIndex, offsetBy: deleteOffset)
        let endDeleteIndex = self.data.index(startDeleteIndex, offsetBy: count)
        self.data.removeSubrange(startDeleteIndex..<endDeleteIndex)
        
        // 8. For each range whose start node is node 
        // and start offset is greater than offset 
        // but less than or equal to offset plus count, 
        // set its start offset to offset.
        for range in document.ranges {
                
            // range whose start node is node
            if range.startContainer == self {
                
                //  start offset is greater than offset
                if range.startOffset > offset {
                    
                    // less than or equal to offset plus count
                    if range.startOffset <= (offset + count) {
                        
                        // set its start offset to offset.
                        range.startOffset = offset
                    }
                }
            }
        }
    
        // 9. For each range whose end node is node 
        // and end offset is greater than offset 
        // but less than or equal to offset plus count, 
        // set its end offset to offset.
        for range in document.ranges {
            
            // range whose end node is node
            if range.endContainer == self {
                
                //  end offset is greater than offset
                if range.endOffset > offset {
                    
                    // less than or equal to offset plus count
                    if range.endOffset <= (offset + count) {
                        
                        // set its end offset to offset
                        range.endOffset = offset
                    }
                }
            }
        }
        
        // 10. For each range whose start node is node 
        // and start offset is greater than offset plus count, 
        // increase its start offset by the number of code units in data, 
        // then decrease it by count.
        for range in document.ranges {
            
            // range whose start node is node
            if range.startContainer == self {
                
                //  start offset is greater than offset plus count
                if range.startOffset > offset + count {
                    
                    // increase its start offset by the number of code units in data
                    range.startOffset = range.startOffset + data.length
                    
                    // then decrease it by count
                    range.startOffset = range.startOffset - count
                }
            }
        }
        
        // 11. For each range whose end node is node 
        // and end offset is greater than offset plus count, 
        // increase its end offset by the number of code units in data, 
        // then decrease it by count.
        for range in document.ranges {
            
            // range whose end node is node
            if range.endContainer == self {
                
                if range.endOffset > offset + count {
                
                    // increase its start offset by the number of code units in data
                    range.endOffset = range.endOffset + data.length
                    
                    // then decrease it by count
                    range.endOffset = range.endOffset - count
                }
            }
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: ClonableNode protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    typealias ClonableNodeType = CharacterData
    
    override open func cloneNode(_ deep: Bool = false) -> CharacterData {
        
        // The super.cloneNode() function is supposed to call
        // our implementations of cloneFields and createInstance.
        return super.cloneNode(deep) as! CharacterData
    }
    
    override open func createInstance() -> CharacterData {
        
        return CharacterData(document: nil, data: self.data)
    }
    
    func cloneFields(_ copy: inout CharacterData) {
        
        var node = copy as Node
        
        super.cloneFields(&node)
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: EquatableLanguageObject protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
            
            if let other = other as? CharacterData {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super is different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                if self.data != other.data {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: data are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not CharacterData.", log: Log.Web.all, type: .debug)
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
    
    typealias EquatableNodeType = CharacterData
    
    /// https://dom.spec.whatwg.org/#dom-node-isequalnode
    func isEqualNode(_ node: CharacterData?) -> Bool {
        
        if !super.isEqualNode(node) {
            
            return false
        }
        
        if self.data != node!.data {
            
            return false
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
//        // [TreatNullAs=EmptyString] attribute DOMString data;
//        
//        h = h ^ data.hashValue
//        
//        return h
    }
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////
func == (lhs: CharacterData, rhs: CharacterData) -> Bool {
    
    return lhs.isEqualNode(rhs)
}














