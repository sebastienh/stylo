//
//  MutationObserver.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import os

typealias MutationCallback = (_ mutationRecordArray: [MutationRecord], _ mutationObserver: MutationObserver) -> Void

// https://dom.spec.whatwg.org/#interface-mutationobserver
//[Constructor(MutationCallback callback)]
//interface MutationObserver {
//    void observe(Node target, MutationObserverInit options);
//    void disconnect();
//    sequence<MutationRecord> takeRecords();
//};

public final class MutationObserver {
    
    internal let mutationCallback: MutationCallback
    internal var recordQueue: [MutationRecord]
    var nodes: [Node]
    
    init(mutationCallback: @escaping MutationCallback) {
        
        // A callback set on creation.
        self.mutationCallback = mutationCallback
        
        // A list of nodes on which it is a registered observer's observer
        // that is initially empty.
        self.nodes = [Node]()
        
        // A list of MutationRecord objects called the record queue that is initially empty.
        // see https://dom.spec.whatwg.org/#concept-mo-queue
        self.recordQueue = [MutationRecord]()
    }
    
    /// Append a new mutation record to the MutationObserver recordQueue.
    func appendMutationRecord(_ mutationRecord: MutationRecord) {
        
        recordQueue.append(mutationRecord)
    }
    
    // void observe(Node target, MutationObserverInit options);
    // see https://dom.spec.whatwg.org/#dom-mutationobserver-observe
    func observe(_ target: Node, options: MutationObserverInit, error: inout JSError) {

        // 1. If either options' attributeOldValue or attributeFilter
        // is present and options' attributes is omitted, 
        // set options' attributes to true.
        if options.isOptionPresent(MutationOptionType.AttributeOldValue)
            || options.isOptionPresent(MutationOptionType.AttributeFilter) {
                
            if !options.isOptionPresent(MutationOptionType.Attributes) {
                    
                let attributesOption = options.getOption(MutationOptionType.Attributes)
                attributesOption.present = true
                attributesOption.value = true
            }
        }
        
        // 2. If options' characterDataOldValue is present and
        // options' characterData is omitted, 
        // set options' characterData to true.
        if options.isOptionPresent(MutationOptionType.CharacterDataOldValue)
            && !options.isOptionPresent(MutationOptionType.CharacterData) {
            
            let characterDataOption = options.getOption(MutationOptionType.CharacterData)
            characterDataOption.present = true
            characterDataOption.value = true
        }
        
        // 3. If none of options' childList attributes, and
        // characterData is true, throw a TypeError.
        if !(options.isOptionPresent(MutationOptionType.ChildList)
            || options.isOptionPresent(MutationOptionType.CharacterData)) {
            
            let childListOption = options.getBoolOptionValue(MutationOptionType.ChildList)
            let characterDataOption = options.getBoolOptionValue(MutationOptionType.CharacterData)
            
            if let childListOption = childListOption, let characterDataOption = characterDataOption
                , !(childListOption || characterDataOption)  {
                
                error = JSError.typeError
                return
            }
        }
        
        // 4. If options' attributeOldValue is true and options' attributes 
        // is false, throw a TypeError.
        if options.isOptionPresent(MutationOptionType.AttributeOldValue) {
            
            // FIXME : maybe this verification is not necessary
            // if the using algorythm care of this option 
            // only if it's present...
            if !options.isOptionPresent(MutationOptionType.Attributes) {
                error = JSError.typeError
                return
            }
                
            let attributeOldValueOption = options.getBoolOptionValue(MutationOptionType.AttributeOldValue)
            let attributesOption = options.getBoolOptionValue(MutationOptionType.Attributes)
                
            if let attributeOldValueOption = attributeOldValueOption, let attributesOption = attributesOption
                , attributeOldValueOption && !attributesOption {
                
                error = JSError.typeError
                return
            }
        }
        
        // 5. If options' attributeFilter is present and 
        // options' attributes is false, throw a TypeError.
        if options.isOptionPresent(MutationOptionType.AttributeFilter) {
            
            // FIXME : maybe this verification is not necessary
            // if the using algorythm care of this option
            // only if it's present...
            if !options.isOptionPresent(MutationOptionType.Attributes) {
                error = JSError.typeError
                return
            }
            
            let optionValue = options.getBoolOptionValue(MutationOptionType.Attributes)
            
            if let optionValue = optionValue , !optionValue {
             
                if !optionValue {
                    
                    error = JSError.typeError
                    return
                }
            }
            else {
                assert(false, "If option is present it is expected to be not nil.")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("If option is present it is expected to be not nil.", log: Log.Web.all, type: .error)
                #endif
            }
        }
        
        // 6. If options' characterDataOldValue is true and 
        // options' characterData is false, throw a TypeError.
        if options.isOptionPresent(MutationOptionType.CharacterDataOldValue) {
        
            // FIXME : maybe this verification is not necessary
            // if the using algorythm care of this option
            // only if it's present...
            if !options.isOptionPresent(MutationOptionType.CharacterData) {
                error = JSError.typeError
                return
            }
            
            let characterDataOldValueOption = options.getBoolOptionValue(MutationOptionType.CharacterDataOldValue)
            let characterDataOption = options.getBoolOptionValue(MutationOptionType.CharacterData)
            
            if let characterDataOldValueOption = characterDataOldValueOption, let characterDataOption = characterDataOption
                , characterDataOldValueOption && !characterDataOption {
            
                error = JSError.typeError
                return
            }
        }
        
        // 7. For each [registered observer](https://dom.spec.whatwg.org/#registered-observer) registered 
        // in target's list of [registered observers](...) whose observer is the 
        // [context object](https://dom.spec.whatwg.org/#context-object):
        
        // Boolean to know if we are registered in the target node...
        var registeredInTarget = false
        
        if let registeredObservers = target.mutationObserverRegistry?.registeredObservers {
        
            for registeredObserver in registeredObservers {
            
                var (observer, observerOptions) = registeredObserver
            
                if observer == self {
                
                    // 1. Remove all transient registered observers whose
                    // source is registered.
                    // FIXME: transient registered observers not supported yet.
                
                
                    // 2. Replace registered's options with options.
                    observerOptions = options
                
                    registeredInTarget = true
                }
            }
        }
        // 8. Otherwise, add a new registered observer to target's list
        // of registered observers with the context object as the observer 
        // and options as the options, and add target to context object's 
        // list of nodes on which it is registered.
        if !registeredInTarget {
            
            target.registerObserver(self, withOptions: options)
            nodes.append(target)
        }
        
    }
    
    // The disconnect() method must, for each node node in the context object's list of nodes, 
    // remove any registered observer on node for which the context object is the observer, 
    // and also empty context object's record queue.
    //
    // void disconnect();
    // see https://dom.spec.whatwg.org/#dom-mutationobserver-disconnect
    func disconnect() {
        
        for node in nodes {
            node.removeRegisteredObserver(self)
        }
        
        recordQueue.removeAll(keepingCapacity: false)
        nodes.removeAll(keepingCapacity: false)
    }
    
    // sequence<MutationRecord> takeRecords();
    func takeRecords() -> [MutationRecord] {

        return recordQueue
    }
    
    // Empty the records queue
    func emptyRecordsQueue() {
        
        recordQueue.removeAll(keepingCapacity: false)
    }    
}


