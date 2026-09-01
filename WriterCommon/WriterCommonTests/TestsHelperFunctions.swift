//
//  TestsHelperFunctions.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-12-31.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import XCTest
import Common
@testable import WriterCommon
import os
import Igloo

class BundleType {
    
}

enum Result {
    case success
    case error(color: NSColor)
}

func urlOfFile(named name: String) -> URL? {
    
    let unitTestBundle = Bundle(for: BundleType.self)
    
    let resourcesDirectoryURL = unitTestBundle.resourceURL!
    
    let fileManager = FileManager.default
    
    let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
    
    for url in resourcesDirectoryURLs {
        
        let last = url.lastPathComponent
        if last == name {
            return url
        }
    }
    return nil
}

