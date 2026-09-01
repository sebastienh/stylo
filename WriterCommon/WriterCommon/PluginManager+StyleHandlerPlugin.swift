//
//  PluginManager+StyleHandlerPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension PluginManager: StyleHandlerPlugin {
    
    public func disableStyleControls() {
        for (_, plugin) in registry {
            if let styleHandlerPlugin = plugin as? StyleHandlerPlugin {
                styleHandlerPlugin.disableStyleControls()
            }
        }
    }
    
    public func enableStyleControls() {
        for (_, plugin) in registry {
            if let styleHandlerPlugin = plugin as? StyleHandlerPlugin {
                styleHandlerPlugin.enableStyleControls()
            }
        }
    }
}
