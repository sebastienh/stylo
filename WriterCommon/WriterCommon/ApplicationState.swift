//
//  ApplicationState.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-12.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import os

public class ApplicationState: State {

    // for the moment we keep all StylesheetDocumentStore in an
    // array without taking care ogg grouping them by style, it
    // may change in the futur.
    var stylesheetDocumentStores: [StylesheetDocumentStore]
    
    // independent style stores reference
    // (not linked to a user style)
    var styleAssemblyStores: [StyleAssemblyStore]
    
    var themeStores: [ThemeStore]
    
    var jsonStores: [JsonStore]
    
    var themeSetStore: ThemeSetStore!
    
    var themeTemplateStore: TemplateStore!
    
    var styloApplicationStore: StyloApplicationStore?
    
    init() {
        
        self.stylesheetDocumentStores = [StylesheetDocumentStore]()
        self.styleAssemblyStores = [StyleAssemblyStore]()
        self.themeStores = [ThemeStore]()
        self.jsonStores = [JsonStore]()
    }
    
    public func destroyCurrentThemeState() {
        
        themeSetStore = nil
        themeStores.removeAll()
    }
    
    /// Add a store to the global state
    public func add<S: Store>(store: S) {
        
        switch store {
            
        case let stylesheetDocumentStore as StylesheetDocumentStore:
            
            stylesheetDocumentStores.append(stylesheetDocumentStore)
            
        case let styleAssemblyStore as StyleAssemblyStore:
            
            styleAssemblyStores.append(styleAssemblyStore)
            
        case let styloApplicationStore as StyloApplicationStore:
            
            self.styloApplicationStore = styloApplicationStore
            
        case let themeStores as ThemeStore:
            
            self.themeStores.append(themeStores)
            
        case let themeSetStore as ThemeSetStore:
            
            self.themeSetStore = themeSetStore
            
        case let themeTemplateStore as TemplateStore:
            
            self.themeTemplateStore = themeTemplateStore
            
        case let jsonStore as JsonStore:
            
            self.jsonStores.append(jsonStore)
            
        default:
            assert(false, "unsupported store type")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("unsupported store type", log: Log.WriterCommon.all, type: .error, %%store)
            #endif
        }
    }
    
    
}
