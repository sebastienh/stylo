//
//  EventListener.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-25.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import os

// To implement NilLiteralConvertible :
// see http://jamesonquave.com/blog/using-equatable-and-nilliteralconvertible-to-re-implement-optionals-in-swift-part-2/

// Should be as simple as :
//
//      init(nilLiteral: ()) {
//          self = None
//      }
//
//callback interface EventListener {
//    void handleEvent(Event event);
//};
protocol EventListener: class {
    
    func handleEvent(_ event: Event)
}

final class DOMEventListener : EventListener {

    func handleEvent(_ event: Event) {
        // TODO
        assert(false, "Method handleEvent(...) is not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Method handleEvent(...) is not implemented", log: Log.Web.all, type: .error)
        #endif
    }

}
