//
//  TestCascading.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-14.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Common
@testable import WriterCommon

class TestCascading: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testBasicUserAgentPseudoStyleCascading() {
//
//        let loadOperationQueue = NSOperationQueue()
//        loadOperationQueue.qualityOfService = NSQualityOfService.UserInteractive
//        
//        /// This method load the user-agent pseudo css style sheet (pseudo-css.css) that
//        /// is used to style the pseudo css source files. It also creates
//        /// the pseudo css style used to style all the pseudo css author resources.
//
//        
//        let pseudoCssCss = urlOfFile(named: "pseudo-css.css")!
//        
//        // load the pseudo-css.css
//        let loadFileOperation = LoadFileContentOperation(href: pseudoCssCss)
//        
//        // add the load file content operation to the queue
//        loadOperationQueue.addOperations([loadFileOperation], waitUntilFinished: true)
//        
//        let ccssUserAgentStyleSheet = UserAgentCCSSStyleSheetResource()
//        
//        ccssUserAgentStyleSheet.load(afterOperation: loadFileOperation)
//        
//        let style = Style(id: "pseudo-css", userAgentStyleSheetResource: ccssUserAgentStyleSheet)
//        
//        XCTAssert(style.styleCreateOperation != nil, "style.styleCreateOperation == nil")
//        
//    }

    func urlOfFile(named name: String) -> NSURL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        
        let fileManager = FileManager.default
        
        let resourcesDirectoryURLs: [NSURL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants) as [NSURL])
        
        for url in resourcesDirectoryURLs {
            
            if url.lastPathComponent == name {
                
                return url
            }
        }
        
        return nil
    }

}
