//
//  DotStringTestUtils.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-11-10.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import XCTest

public extension XCTestCase {
    
    public func createDotFile(dotFileName: String, content: String) {
        
        let dirs : [String]? = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
        
        var pathURL = URL(fileURLWithPath: "")
        
        if let directories = dirs {
            
            let dir = directories[0]; //documents directory
            
            pathURL = pathURL.appendingPathComponent(dir)
            pathURL = pathURL.appendingPathComponent(dotFileName)
            
            do {
                try content.write(toFile: pathURL.relativeString, atomically: false, encoding: String.Encoding.utf8)
            } catch _ {
            }
        }
    }
    
}
