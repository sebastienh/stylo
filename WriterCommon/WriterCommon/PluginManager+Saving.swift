//
//  PluginManager+Saving.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension PluginManager: Saving {
    
    public var fileWrapperId: String {
        
        return Constants.Filename.PluginsDataDirectoryFilename
    }
    
    public func createFileWrapper(at url: URL?) -> FileWrapper {
        
        // we alrewady have one to ourselve on
        if let pluginsFileWrapper = self.pluginsFileWrapper {
        
            for (pluginName, plugin) in registry {
                
                if let dataPlugin = plugin as? DataPlugin {
                    
                    if let pluginFileWrapper = pluginsFileWrapper.fileWrapper(at: pluginName) {
                        if let newPluginFileWrapper = dataPlugin.fileWrapper(fromCurrentFileWrapper: pluginFileWrapper) {
                            pluginsFileWrapper.removeFileWrapper(pluginFileWrapper)
                            newPluginFileWrapper.preferredFilename = pluginName
                            pluginsFileWrapper.addFileWrapper(newPluginFileWrapper)
                        }
                    }
                    else {
                        // we create a new fileWrapper for that plugin
                        if let pluginFileWrapper = dataPlugin.createFileWrapper() {
                            if let fileWrappers = pluginFileWrapper.fileWrappers, !fileWrappers.isEmpty {
                                pluginFileWrapper.preferredFilename = pluginName
                                pluginsFileWrapper.addFileWrapper(pluginFileWrapper)
                            }
                        }
                    }
                }
            }
        }
        else {
            // create a new file wrapper
            let pluginsFileWrapper = FileWrapper(directoryWithFileWrappers: createFileWrapperDict())
            pluginsFileWrapper.preferredFilename = self.fileWrapperId
            self.pluginsFileWrapper = pluginsFileWrapper
        }
        return self.pluginsFileWrapper!
    }
    
    public func createFileWrapper() -> FileWrapper? {
        
        assertionFailure("Error: this method is not relevant anymore")
        return nil
    }
    
    private func createFileWrapperDict() -> [String: FileWrapper] {
        
        var pluginsFileWrappers: [(String, FileWrapper)] = self.registry.compactMap({ (arg0) -> (String, FileWrapper)? in
            let (name, plugin) = arg0
            
            if let savingPlugin = plugin as? Saving {
                if let fileWrapper = savingPlugin.createFileWrapper() {
                    return (name, fileWrapper)
                }
            }
            return nil
        })
        
        pluginsFileWrappers.append(contentsOf: pluginsData.map({ (pluginData) -> (String, FileWrapper) in
            return pluginData
        }))
        
        return pluginsFileWrappers.reduce(into: [:]) { $0[$1.0] = $1.1 }
    }
}
