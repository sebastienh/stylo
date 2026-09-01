//
//  PluginManager+PluginsClasses.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-07.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension PluginManager {
    
    public static var PluginsClasses: [AnyClass]? {
        
        guard let pluginsFolderUrl = PluginManager.pluginsFolderUrl else {
            assertionFailure("Error: self.pluginsFolderUrl is nil")
            return nil
        }
        
        do {
            
            if FileManager.default.fileExists(atPath: pluginsFolderUrl.path) {
                
                var pluginsClasses = [AnyClass]()
                
                let pluginsDirectoryContent = try FileManager.default.contentsOfDirectory(at: pluginsFolderUrl, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants.union(FileManager.DirectoryEnumerationOptions.skipsHiddenFiles))
                
                
                for directoryItem in pluginsDirectoryContent {
                    
                    guard directoryItem.lastPathComponent.hasSuffix(".bundle") else {
                        continue
                    }
                    
                    let bundleUrl = URL(fileURLWithPath: directoryItem.path, isDirectory: false, relativeTo: pluginsFolderUrl)
                    let bundle = Bundle(url: bundleUrl)
                    
                    guard let PrincipalClass = bundle?.principalClass else {
                        assertionFailure("Error: bundle?.principalClass is not a StyloCommon.")
                        continue
                    }
                    
                    pluginsClasses.append(PrincipalClass)
                }
                
                return pluginsClasses
            }
        }
        catch let exception {
            assertionFailure("Error: exception while loading plugins directory: \(exception)")
            return nil
        }
        return nil
    }
}
