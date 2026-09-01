//
//  ResourceLoadTests.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-09-03.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import XCTest

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

/// Common functions for all operations tests.
class OperationsTests: XCTestCase {
    
    func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        
        let fileManager = FileManager.default
        
        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)) 
        
        for url in resourcesDirectoryURLs {
            
            if url.lastPathComponent == name {
                
                return url
            }
        }
        
        return nil
    }
    
    
    func loadFileFromURL(url: URL) -> LoadFileContentOperation {
        
        let loadFileContentOperation = LoadFileContentOperation(href: url as URL)
        
        loadFileContentOperation.start()
        
        return loadFileContentOperation
    }
    
    
}
