//
//  CSSDOMUnsupportedPropertyParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-04.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class CSSDOMUnsupportedPropertyParser: CSSDOMPropertyParser {
    
    func parseUnsupportedDeclarationAfterNameToDOM() {
        
        parseWhitespaces()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Number of components to parse: %d", log: Log.Web.all, type: .info, self.componentValueArray.count)
        #endif
        
        // we pass the first component value
        advanceComponentValueIndex()
        parseRestOfComponents()
    }
    
    func parseUnsupportedPropertyValueToDOM() {
        
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
                
                handleComponentValueToDom(componentValue!, in: parentPropertyElement, messageCode: MessageCode.unexpectedToken)
                advanceComponentValueIndex()
                componentValue = currentComponentValue()
            }
        }
    }
}

