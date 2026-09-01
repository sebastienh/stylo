//
//  ComputedStylesCache.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-10-19.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

public class ComputedStylesCache {
    
    public static let shared = ComputedStylesCache()
    
    private var stylesCache: [StyleAssemblyIdentifier: ResourceComputedStyle]
    
    private let lock: NSLock
    
    private init() {
        
        self.lock = NSLock()
        self.stylesCache = [StyleAssemblyIdentifier: ResourceComputedStyle]()
    }
    
    public func removeComputedStyle(forStyleDefinition styleDefinition: StyleDefinition) {
        
        let identifier = styleDefinition.styleAssemblyIdentifier
         
         #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("removeComputedStyle(forStyleDefinition: %@)", log: Log.Web.all, type: .info, %%styleDefinition.styleAssemblyIdentifier)
         #endif
          
        self.removeComputedStyle(forStyleAssemblyIdentifier: identifier)
    }
    
    public func removeComputedStyle(forStyleAssemblyIdentifier identifier: StyleAssemblyIdentifier) {
         
         #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
         os_log("removeComputedStyle(forStyleAssemblyIdentifier: %@)", log: Log.Web.all, type: .info, %%styleDefinition.styleAssemblyIdentifier)
         #endif
         
         return lock.withCriticalSection {
            self.stylesCache.removeValue(forKey: identifier)
         }
    }
    
    public func resourceComputedStyle(for styleDefinition: StyleDefinition) -> ResourceComputedStyle {
        
        let identifier = styleDefinition.styleAssemblyIdentifier
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("resourceComputedStyle(for: %@)", log: Log.Web.all, type: .info, %%styleDefinition.styleAssemblyIdentifier)
        #endif
        
        return lock.withCriticalSection {
            
            if let styleCache = self.stylesCache[identifier] {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("resourceComputedStyle -> returning existing resourceComputedStyle for: %@", log: Log.Web.all, type: .info, %%styleDefinition.styleAssemblyIdentifier)
                #endif
                
                return styleCache
            }
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("resourceComputedStyle -> creating new resourceComputedStyle for: %@", log: Log.Web.all, type: .info, %%styleDefinition.styleAssemblyIdentifier)
            #endif
            
            let computedStyles = ResourceComputedStyle(styleDefinition: styleDefinition)
            self.stylesCache[identifier] = computedStyles
            return computedStyles
        }
    }
}
