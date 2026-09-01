//
//  EventTarget.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import os

// https://dom.spec.whatwg.org/#eventtarget
//interface EventTarget {
//    void addEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
//    void removeEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
//    boolean dispatchEvent(Event event);
//};
//


protocol EventTarget: class {
    
    // void addEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func addEventListener(_ type: DOMString, callback: EventListener, capture: Bool)
 
    // void removeEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func removeEventListener(_ type: DOMString, callback: EventListener, capture: Bool)
    
    // boolean dispatchEvent(Event event);
    func dispatchEvent(_ event: Event) -> Bool
}

final class DOMEventTarget : EventTarget {
    
    // void addEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func addEventListener(_ type: DOMString, callback: EventListener, capture: Bool) {
        // TODO
        assert(false, "Method addEventListener(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method addEventListener(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    // void removeEventListener(DOMString type, EventListener? callback, optional boolean capture = false);
    func removeEventListener(_ type: DOMString, callback: EventListener, capture: Bool) {
        // TODO
        assert(false, "Method removeEventListener(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method removeEventListener(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    // boolean dispatchEvent(Event event);
    func dispatchEvent(_ event: Event) -> Bool {
        // TODO
        assert(false, "Method dispatchEvent(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method dispatchEvent(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
        return false
    }
}


