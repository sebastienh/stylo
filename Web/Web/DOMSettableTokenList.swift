//
//  DOMSettableTokenList.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-02-26.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

/// A DOMSettableTokenList object is equivalent to a DOMTokenList object 
/// without an associated attribute.
///
/// see https://dom.spec.whatwg.org/#domsettabletokenlist
final class DOMSettableTokenList : DOMTokenList {
    
    var value: DOMString {
    
        get {
            return self.stringify()
        }
    }
    
    init(element: Web.Element) {
        
        super.init(element: element, attributeLocalName: "")
    }
    
    func setValue(_ newValue: DOMString, exception: inout Exception) {

        /// Setting the value attribute must run the ordered set parser
        /// for the given value and set tokens to the result.
            
        let tokens = OrderedSetParser.parse(newValue)
            
        add(tokens, exception: &exception)
        
        // This specific handling is not needed 
        // but it is preferable to make it explicit.
        // Less implicit as possible.
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            return
        }
    }
    
}
