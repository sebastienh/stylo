//
//  String+Url.swift
//  WriterCommonTests
//
//  Created by Sébastien Hamel on 2018-08-09.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

//extension String {
//    
//    func contentOfFile(at url: URL) -> String {
//        
//        return try! String(contentsOf: url)
//    }
//    
//    func urlOfFile(named name: String) -> URL? {
//        
//        let unitTestBundle = Bundle(for: type(of: self))
//        
//        let resourcesDirectoryURL = unitTestBundle.resourceURL!
//        
//        let fileManager = FileManager.default
//        
//        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
//        
//        for url in resourcesDirectoryURLs {
//            
//            let last = url.lastPathComponent
//            if last == name {
//                return url
//            }
//        }
//        return nil
//    }
//    
//}
