//
//  CSSDOMUnknownPropertyParser.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-12-14.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMUnknownPropertyParser: CSSDOMPropertyParser {
    
    func parseUnknownDeclarationAfterNameToDOM() {
        
        parseWhitespaces()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Number of components to parse: %d", log: Log.Web.all, type: .info, self.componentValueArray.count)
        #endif
        
        // we pass the first component value
        advanceComponentValueIndex()
        parseRestOfComponents()
    }
    
    func parseUnknownPropertyValueToDOM() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Number of components to parse: %d", log: Log.Web.all, type: .info, self.componentValueArray.count)
        #endif
        
        parseWhitespaces()
        parseRestOfComponents()
    }
 
    private func parseRestOfComponents() {
        
        var componentValue = currentComponentValue()
        
        let parentPropertyElement = self.parentPropertyElement
        
        assert(parentPropertyElement != nil)
        if let parentPropertyElement = parentPropertyElement {
            
            while componentValue != nil {
                
                handleComponentValueToDom(componentValue!, in: parentPropertyElement)
                advanceComponentValueIndex()
                componentValue = currentComponentValue()
            }
        }
    }
}
