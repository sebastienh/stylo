//
//  Element+NwElementId.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-02-11.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common
import os

extension Element {

    /// Element StyloId: added for particular Stylo functionality.
    /// We do not use the special "id" attribute since we want to keep it
    /// free for the user.
    public var nwElementId: String? {
        
        get {
            
            return getAttribute(§DomAttributeString.ElementId)
        }
        set {
            
            if let newValue = newValue {
            
                var exception = Exception()
                
                setAttribute(§DomAttributeString.ElementId, value: newValue, exception: &exception)
            
                if exception.isError() {
                    
                    assert(false, "Exception occured: \(exception)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Exception occured: %@", log: Log.Web.all, type: .error, %%exception)
                    #endif
                }
            }
            else {
                
                removeAttributeByName(§DomAttributeString.ElementId)
            }
        }
    }
}
