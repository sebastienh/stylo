//
//  SimilarOriginBrowsingContext.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-27.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import os

// see https://html.spec.whatwg.org/multipage/browsers.html#unit-of-related-similar-origin-browsing-contexts

final class SimilarOriginBrowsingContext {
    
    // mutation observer compound microtask queued flag
    var mutationObserverCompoundMicrotaskQueuedFlag: Bool
    
    //  list of MutationObserver objects which is initially empty.
    fileprivate var mutationObserverList: [MutationObserver]
    
    init() {
        
        self.mutationObserverCompoundMicrotaskQueuedFlag = false
        self.mutationObserverList = [MutationObserver]()
    }
    
    // see https://dom.spec.whatwg.org/#queue-a-mutation-observer-compound-microtask
    func queueMutationObserverCompoundMicrotask() {
        
        // If mutation observer compound microtask queued flag is set, terminate these steps.
        if !mutationObserverCompoundMicrotaskQueuedFlag {
            
            // Set mutation observer compound microtask queued flag.
            mutationObserverCompoundMicrotaskQueuedFlag = true
            
            // Queue a compound microtask to notify mutation observers.
            // def : https://html.spec.whatwg.org/multipage/webappapis.html#compound-microtask
            // Each event loop has a microtask queue. A microtask is a task that is originally 
            // to be queued on the microtask queue rather than a task queue. There are two kinds 
            // of microtasks: solitary callback microtasks, and compound microtasks.
            
            // FIXME: Method queueMutationObserverCompoundMicrotask() is not terminated.
            assert(false, "Method queueMutationObserverCompoundMicrotask() is not terminated.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Method queueMutationObserverCompoundMicrotask() is not terminated", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    // see https://dom.spec.whatwg.org/#notify-mutation-observers
    func notifyMutationObservers(_ exception: inout ExceptionCode) {
        
        // 1. Unset mutation observer compound microtask queued flag.
        mutationObserverCompoundMicrotaskQueuedFlag = false
        
        // 2. Let notify list be a copy of unit of related similar-origin 
        // browsing contexts's list of MutationObserver objects.
        let notifyList = mutationObserverList
        
        // 3. For each MutationObserver object mo in notify list, execute a
        // compound microtask subtask to run these steps: [HTML]
        for mutationObserver in notifyList {
        
            // 1. Let queue be a copy of mo's record queue.
            let queue = mutationObserver.takeRecords()
        
            // 2. Empty mo's record queue.
            mutationObserver.emptyRecordsQueue()
            
            // 3. Remove all transient registered observers whose observer is mo.
            // TODO : transient observers are not supported for the moment
            
            // 4. If queue is non-empty, call mo's callback with queue as first argument,
            // and mo (itself) as second argument and callback this value. If this throws
            // an exception, report the exception.
            if !queue.isEmpty {
                
                // typealias MutationCallback = (mutationRecords: [MutationRecord], mutationObserver: MutationObserver)
                mutationObserver.mutationCallback(queue, mutationObserver)
                
//                if (ExceptionCode.NoError != exception) {
//                    // return instead of break since we don't code modifications
//                    // after the for loop to alter this behavior.
//                    return
//                }
            }
        }
    }
    
}
