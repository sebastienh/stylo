//
//  NSURL+ApplicationSupport.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-12-11.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension URL {
    
    static func bundleApplicationSupportDirectory() -> URL? {

        let bundleID: String = Bundle.main.bundleIdentifier!
        let fm: FileManager = FileManager.default
        
        var dirPath: URL?
    
        // Find the application support directory in the home directory.
        let appSupportDir: Array = fm.urls(for: .applicationSupportDirectory, in:.userDomainMask)

        if appSupportDir.count > 0 {
            
            // Append the bundle ID to the URL for the
            // Application Support directory
            dirPath = appSupportDir.first!.appendingPathComponent(bundleID)
    
            // If the directory does not exist, this method creates it.
            // This method is only available in OS X v10.7 and iOS 5.0 or later.
            do {
            
                try fm.createDirectory(at: dirPath!, withIntermediateDirectories:true, attributes:nil)
            }
            catch {
                
                return nil
            }
        }
        
        return dirPath
    }
    
}
