//
//  main.swift
//  MarkdownParserPerformanceTestApp
//
//  Created by Sébastien Hamel on 2016-09-22.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
//import Markdown

class App {
    
    init() {}
    
    func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
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
    
    func run() {
        
        let markdownItString = try! String(contentsOf: urlOfFile(named: "markdown-performance.md")! as URL, encoding: String.Encoding.utf8)
        let md = MarkdownParser()
        
        for _ in 0..<10 {
            md.parse(markdownItString)
        }
    }
}

let app = App()
app.run()

