//
//  TestCascading.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-29.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
@testable import Web

class TestCascading: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /// h1
    /// p
    /// h2
    /// 
    ///
    func buildBasicHtmlDocument() -> HtmlDocument? {
        
        let htmlDocument = HtmlDocument.Create("test-document")
        
        if let body = htmlDocument?.body {
            
            var exception = Exception()
            
            // h1
            let h1 = HTMLHeadingElement(document: htmlDocument, localName: "h1")
            body.append(h1, exception: &exception)
            
            // p
            let p1 = HTMLParagraphElement(document: htmlDocument)
            body.append(p1, exception: &exception)
            
            // h2
            let h2 = HTMLHeadingElement(document: htmlDocument, localName: "h2")
            
            body.append(h2, exception: &exception)
            
            // p
            let p2 = HTMLParagraphElement(document: htmlDocument)
            body.append(p2, exception: &exception)
        }
        
        return htmlDocument
    }
    
    func getStyledCSSDOMDocument(sourceString: NSString) -> CSSDOMDocument? {
        
        let cssDomModule = CSSDOMModule.shared
        
        let dom = cssDomModule.domFromCSSString(sourceString, origin: .author )
        
        if dom!.hasErrors() {
            
            XCTAssert(false, "Parser report has errors.")
            
            return nil
        }
        
        return dom
    }
    
    func getStylingCSSStyleSheet(sourceString: NSString) -> CSSStyleSheet? {
        
        let cssOmModule = CSSOMModule.shared
        
        let cssStyleSheet = cssOmModule.parseStyleSheet(sourceString, origin: .author, computePropertyValues: true)
        
        if cssStyleSheet!.hasErrors() {
            
            XCTAssert(false, "Parser report has errors.")
            
            return nil
        }
        return cssStyleSheet
    }

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
    
    func validateFontSizeActualValue(fontSizeValue: CSSPropertyValueContainer, expectedValue: CGFloat) {
        
        switch fontSizeValue {
            
        case .fontSize(let fontSize):
            
            switch fontSize {
                
            case .length(let length):
                
                switch length {
                    
                case .px(let value):
                        
                    XCTAssert(value == expectedValue , "Expected \(expectedValue), received: \(value)")
                    
                default:
                    XCTAssert(false, "Expecting PX type length value")
                }
                
            default:
                XCTAssert(false, "Expecting CSSLength type value")
                
            }
            
        default:
            XCTAssert(false, "Expecting FontSize type value")
        }
        
        let bodyFontSizePixelValue = fontSizeValue.pixelFontSizeValue()
        
        let bodyPixelLengthValue = fontSizeValue.pixelLengthValue()
        
        XCTAssert(bodyFontSizePixelValue == bodyPixelLengthValue, "Values should be equal.")
        
        if bodyFontSizePixelValue != expectedValue {
            
            XCTAssert(false, "Should be equal to \(expectedValue)")
        }
    }

    func validateTextDecorationLineActualValue(textDecorationLineValue: CSSPropertyValueContainer, expectedValue: CSSTextDecorationLineType) {
        
        switch textDecorationLineValue {
            
        case .textDecorationLine(let textDecorationLine):
            
            XCTAssert(textDecorationLine.textDecorationLineArray.count == 1)
            let textDecorationLineInstance = textDecorationLine.textDecorationLineArray.first!
            XCTAssert(textDecorationLineInstance == expectedValue)

        default:
            XCTAssert(false, "Expecting FontSize type value")
        }
    }
    
}
