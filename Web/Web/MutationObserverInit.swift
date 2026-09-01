//
//  MutationObserverInit.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common
import os

// https://dom.spec.whatwg.org/#mutationobserverinit
//dictionary MutationObserverInit {
//    boolean childList = false;
//    boolean attributes;
//    boolean characterData;
//    boolean subtree = false;
//    boolean attributeOldValue;
//    boolean characterDataOldValue;
//    sequence<DOMString> attributeFilter;
//};
enum MutationOptionType : String {
    
    case ChildList = "childList"
    case Attributes = "attributes"
    case CharacterData = "characterData"
    case Subtree = "subtree"
    case AttributeOldValue = "attributeOldValue"
    case CharacterDataOldValue = "characterDataOldValue"
    case AttributeFilter = "attributeFilter"
}

final class MutationObserverInit : JSDictionary {
    
    override init() {
        
        super.init()
        
        //    boolean childList = false;
        values.updateValue(JSDictionaryMember(self.globalIndex,false), forKey: §MutationOptionType.ChildList)
        globalIndex += 1
        
        //    boolean attributes;
        values.updateValue(JSDictionaryMember(self.globalIndex), forKey: §MutationOptionType.Attributes)
        globalIndex += 1
        
        //    boolean characterData;
        values.updateValue(JSDictionaryMember(self.globalIndex), forKey: §MutationOptionType.CharacterData)
        globalIndex += 1
        
        //    boolean subtree = false;
        values.updateValue(JSDictionaryMember(self.globalIndex, false), forKey: §MutationOptionType.Subtree)
        globalIndex += 1
        
        //    boolean attributeOldValue;
        values.updateValue(JSDictionaryMember(self.globalIndex), forKey: §MutationOptionType.AttributeOldValue)
        globalIndex += 1
        
        //    boolean characterDataOldValue;
        values.updateValue(JSDictionaryMember(self.globalIndex), forKey: §MutationOptionType.CharacterDataOldValue)
        globalIndex += 1
        
        //    sequence<DOMString> attributeFilter;
        values.updateValue(JSDictionaryMember(self.globalIndex), forKey: §MutationOptionType.AttributeFilter)
        globalIndex += 1
    }

    /// Construtor used as a copy constructor
    /// in order to implement Clonable protocol.
    internal init(values: [String:JSDictionaryMember], globalIndex: Int) {
        
        super.init()
        
        self.values = values
        self.globalIndex = globalIndex
    }
    
    func setPresentValue(_ value: MutationOptionType) {
        
        if let dictionaryMember = self.values[value.rawValue] {

            dictionaryMember.present = true
        }
        else {
            assert(false, "dictionary member is not present programming error!")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("dictionary member is not present programming error!", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    func isOptionPresent(_ option: MutationOptionType) -> Bool {
        
        if let dictionaryMember = self.values[option.rawValue] {
            
            return dictionaryMember.present
        }
        else {
            assert(false, "dictionary member is not present programming error!")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("dictionary member is not present programming error!", log: Log.Web.all, type: .error)
            #endif
        }
        return false
    }
    
    func getBoolOptionValue(_ option: MutationOptionType) -> Bool? {
        
        let optionMember = getOption(option)
        
        if let _value: Any = optionMember.value {
            
            if let __value = _value as? Bool {
                
                return __value
            }
            else {
                assert(false, "Mutation option option is expected to be of type Bool.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Mutation option option is expected to be of type Bool.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "If option is present it is expected to be not nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("If option is present it is expected to be not nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    // This method is mainly for attributeFilter which is a sequence<DOMString>
    func getDOMStringArrayOptionValue(_ option: MutationOptionType) -> [DOMString]? {
        
        let optionMember = getOption(MutationOptionType.AttributeFilter)
        
        if let _value: Any = optionMember.value {
            
            if let __value = _value as? [DOMString] {
                
                return __value
            }
            else {
                assert(false, "Mutation option attribute filter is expected to be of type Bool.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Mutation option attribute filter is expected to be of type Bool.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        else {
            assert(false, "If option is present it is expected to be not nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("If option is present it is expected to be not nil.", log: Log.Web.all, type: .error)
            #endif
        }
        return nil
    }
    
    func getOption(_ option: MutationOptionType) -> JSDictionaryMember {
        
        if let dictionaryMember = self.values[option.rawValue] {
            
            return dictionaryMember
        }
        else {
            fatalError("Option is not present but must be.")
        }
    }
    
}
