//
//  TestCSS.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class CssTests: WebTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func parseStylesheet(named name: String) -> CSSStyleSheet {
        
        let url = urlOfFile(named: name)
        let stylesheetString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        return parseStylesheet(stylesheetString: stylesheetString)
    }

    func parseStylesheet(stylesheetString string: String) -> CSSStyleSheet {

        let syntaxModule = CSSOMModule.shared
        let styleSheet: CSSStyleSheet = syntaxModule.parseStyleSheet(string as NSString, origin: .author)!
        return styleSheet
    }
    
    func colorValueFromCSSColorProperty(sourceString: NSString) -> CIColor? {
        
        let styleRules = CSSOMModule.shared.parseStyleRules(sourceString, origin: .author)
        
        XCTAssert(styleRules.count == 1 , "Pass")
        
        let rule = styleRules[0]
        
        if let style = rule.style {
            
            if let declaration = style["color"] {
                
                if let resultColor = CSSColorModule.parseColorToValue(declaration) {
                    
                    switch resultColor {
                        
                    case .custom(let color):
                        
                        return color
                        
                    default:
                        
                        return nil
                    }
                }
            }
            else {
                
                XCTAssert(false , "Absent color porperty.")
            }
        }
        else {
            
            XCTAssert(false , "Missing style in style rule.")
        }
        
        return nil
    }


}
