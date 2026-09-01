//
//  MarkdownParsingPerformanceTests.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-01-08.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

class MarkdownParsingPerformanceTests: MarkdownBasicTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //    func testMarkdownPerformanceMarkdownItReadme() {
    //
    //        let markdownItString = try! String(contentsOf: urlOfFile(named: "Readme.md")! as URL, encoding: String.Encoding.utf8)
    //
    //        let md = MarkdownParser()
    //
    //        self.measure {
    //
    //            for _ in 0..<10 {
    //
    //                md.parse(markdownItString)
    //            }
    //        }
    //    }
    
    func testNSMutableAttributedStringCopyPerformance() {
        
        let string = NSMutableAttributedString()
        
        for _ in 0..<300000 {
            
            string.append(NSAttributedString(string: "f"))
        }
        //        let size = 14
        //        let font = NSFont(name: "Helvetica", size: CGFloat(size))
        
        //        string.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, string.length))
        
        self.measure {
            
            let copy = string.mutableCopy()
        }
    }
    
    
    func testMarkdownPerformance() {
        
        let markdownItString = try! String(contentsOf: urlOfFile(named: "markdown-performance.md")! as URL, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        self.measure {
            
            for _ in 0..<10 {
                
                md.parse(markdownItString)
            }
        }
    }
    
    func testStringParsingSpeed() {
        
        let string = "<ffhjkfsfsdhfjkdfsdfhjdksfdsfdsfsdfdhsjkfsdfsdhfjkdsfdshjfkdsfds>"
        
        self.measure {
            
            for _ in 0..<100000{
                
                for i in 0..<string.length {
                    
                    if string.charAt(i) == 0x123 {
                        
                        
                    }
                    //                    string.slice(4, end: 8)
                    //                    string.slice(12, end: 25)
                }
            }
        }
    }
    
    //    func testUnsafeStringParsingSpeed() {
    //
    //        let string = UnsafeString(string: "<ffhjkfsfsdhfjkdfsdfhjdksfdsfdsfsdfdhsjkfsdfsdhfjkdsfdshjfkdsfds>")
    //
    //        self.measure {
    //
    //            for _ in 0..<100000{
    //
    //                for i in 0..<string.length {
    //
    //                    if string.charPtrAt(i).pointee == 0x123 {
    //
    //
    //                    }
    //                    //                    string.slice(4, end: 8)
    //                    //                    string.slice(12, end: 25)
    //
    //                }
    //            }
    //        }
    //    }
    //
    
    func testSpeed(){
        
        self.measure {
            
            var message = ""
            
            for _ in 0..<100000 {
                message += "1"
            }
        }
    }
    
    
}

