//
//  ApplicationPluginManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

class ApplicationPluginManager {
    
    internal private(set) var registry: [String: StyloPlugin&ApplicationPlugin]
    
    init() {
        
        self.registry = [String: StyloPlugin&ApplicationPlugin]()
    }
    
    public func loadApplicationPlugins(from styloApplication: StyloApplication) {
        
        assert(Thread.isMainThread)
        guard let pluginsClasses = PluginManager.PluginsClasses else {
            assertionFailure("Error: PluginManager.pluginsClasses is nil")
            return
        }
        
        for pluginClass in pluginsClasses {
            
            if let StyloCommonPrincipalClass = pluginClass as? (StyloPlugin&ApplicationPlugin).Type {
                
                guard let styloPlugin: StyloPlugin&ApplicationPlugin = StyloCommonPrincipalClass.init(styloApplication: styloApplication) else {
                    assertionFailure("Error: styloPlugin is nil")
                    continue
                }
                
                if isApplicationPluginEnabled(withName: styloPlugin.name) {
                    register(styloPlugin: styloPlugin)
                }
            }
        }
    }
    
    private func isApplicationPluginEnabled(withName name: String) -> Bool {
        
        if name == "ThemeEditor" {
            #if DEBUG
            return true
            #else
            return false
            #endif
        }

        // for now always return true
        return true
    }
    
    private func register(styloPlugin: StyloPlugin&ApplicationPlugin) {
        
        registry[styloPlugin.name] = styloPlugin
        styloPlugin.pluginDidLoad()
    }
}
