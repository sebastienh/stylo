//
//  Event.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common 
import os

//https://dom.spec.whatwg.org/#interface-event
//[Constructor(DOMString type, optional EventInit eventInitDict), Exposed=(Window,Worker)]
//interface Event {
//    readonly attribute DOMString type;
//    readonly attribute EventTarget? target;
//    readonly attribute EventTarget? currentTarget;
//    
//    const unsigned short NONE = 0;
//    const unsigned short CAPTURING_PHASE = 1;
//    const unsigned short AT_TARGET = 2;
//    const unsigned short BUBBLING_PHASE = 3;
//    readonly attribute unsigned short eventPhase;
//    
//    void stopPropagation();
//    void stopImmediatePropagation();
//    
//    readonly attribute boolean bubbles;
//    readonly attribute boolean cancelable;
//    void preventDefault();
//    readonly attribute boolean defaultPrevented;
//    
//    [Unforgeable] readonly attribute boolean isTrusted;
//    readonly attribute DOMTimeStamp timeStamp;
//    
//    void initEvent(DOMString type, boolean bubbles, boolean cancelable);
//};

enum EventPhase : UInt16  {
    case none = 0
    case capturing_PHASE = 1
    case at_TARGET = 2
    case bubbling_PHASE = 3
}

protocol Event: class {
    
//    Each event has the following associated flags that are all initially unset:
//    
//      stop propagation flag
//      stop immediate propagation flag
//      canceled flag
//      initialized flag
//      dispatch flag
    var stopPropagationFlag: Bool { get set }
    var stopImmediatePropagationFlag: Bool { get set }
    var canceledFlag: Bool { get set }
    var initializedFlag: Bool { get set }
    var dispatchFlag: Bool { get set }
    
    //    readonly attribute DOMString type;
    var type: DOMString { get }
    
    //    readonly attribute EventTarget? target;
    var target: EventTarget? { get }
    
    //    readonly attribute EventTarget? currentTarget;
    var currentTarget: EventTarget? { get }
    
    //    readonly attribute unsigned short eventPhase;
    var eventPhase: EventPhase { get }
    
    //    readonly attribute boolean defaultPrevented;
    var defaultPrevented: Bool { get }
    
    //    [Unforgeable] readonly attribute boolean isTrusted;
    var isTrusted: Bool { get }
    
    //    readonly attribute DOMTimeStamp timeStamp;
    var timeStamp: DOMTimeStamp { get }
    
    //    readonly attribute boolean bubbles;
    var bubbles: Bool { get }
    
    //    readonly attribute boolean cancelable;
    var cancelable: Bool { get }
    
    //    void stopPropagation();
    func stopPropagation()
    
    //    void stopImmediatePropagation();
    func stopImmediatePropagation()
    
    //    void preventDefault();
    func preventDefault()

    //    void initEvent(DOMString type, boolean bubbles, boolean cancelable);
    func initEvent(_ type: DOMString , bubbles: Bool, cancelable: Bool )
    
}

final class DOMEvent : Event {
 
    
    //    Each event has the following associated flags that are all initially unset:
    //
    //      stop propagation flag
    //      stop immediate propagation flag
    //      canceled flag
    //      initialized flag
    //      dispatch flag
    var stopPropagationFlag: Bool = false
    var stopImmediatePropagationFlag: Bool = false
    var canceledFlag: Bool = false
    var initializedFlag: Bool = false
    var dispatchFlag: Bool = false
    
    
    //    readonly attribute DOMString type;
    internal(set) var type: DOMString
    
    //    readonly attribute EventTarget? target;
    internal(set) var target: EventTarget?
    
    //    readonly attribute EventTarget? currentTarget;
    internal(set) var currentTarget: EventTarget?
    
    //    readonly attribute unsigned short eventPhase;
    // Initially the attribute must be initialized to NONE.
    internal(set) var eventPhase: EventPhase
    
    //    readonly attribute boolean defaultPrevented;
    internal(set) var defaultPrevented: Bool
    
    //    [Unforgeable] readonly attribute boolean isTrusted;
    internal(set) var isTrusted: Bool
    
    //    readonly attribute DOMTimeStamp timeStamp;
    internal(set) var timeStamp: DOMTimeStamp
    
    //    readonly attribute boolean bubbles;
    internal(set) var bubbles: Bool
    
    //    readonly attribute boolean cancelable;
    internal(set) var cancelable: Bool
    
    // event = new Event(type [, eventInitDict])
    // Returns a new event whose type attribute value is set to type. 
    // The optional eventInitDict argument allows for setting the bubbles 
    // and cancelable attributes via object members of the same name.
    init(type: DOMString, eventInitDict: Dictionary<String, Bool> = [:]) {
        
        self.type = type
        
        if let bubblesValue = eventInitDict["bubbles"] {
            self.bubbles = bubblesValue
        }
        else {
            self.bubbles = true
        }
        
        if let cancelableValue = eventInitDict["cancelable"] {
            self.cancelable = cancelableValue
        }
        else {
            self.cancelable = true
        }
        // Set the isTrusted attribute to false.
        self.isTrusted = false
        
        // Initially the attribute must be initialized to NONE.
        self.eventPhase = EventPhase.none
        
        self.defaultPrevented = canceledFlag
        
        // The timeStamp attribute must return the value it was initialized to. 
        // When an event is created the attribute must be initialized to the 
        // number of milliseconds that have passed since 00:00:00 UTC on 1 January 1970, 
        // ignoring leap seconds.
        self.timeStamp = Date().timeIntervalSince1970
    }
    
    //    void initEvent(DOMString type, boolean bubbles, boolean cancelable);
    func initEvent(_ type: DOMString , bubbles: Bool, cancelable: Bool) {
        // TODO
        assert(false, "Method initEvent(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method initEvent(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void stopPropagation();
    func stopPropagation() {
        // TODO
        assert(false, "Method stopPropagation(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method stopPropagation(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void stopImmediatePropagation();
    func stopImmediatePropagation() {
        // TODO
        assert(false, "Method stopImmediatePropagation(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method stopImmediatePropagation(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }
    
    //    void preventDefault();
    // The preventDefault() method must set the canceled flag if the cancelable attribute value is true.
    func preventDefault() {

        if cancelable {
            self.canceledFlag = true
        }
    }
    
}



// TODO
//dictionary EventInit {
//    boolean bubbles = false;
//    boolean cancelable = false;
//};
