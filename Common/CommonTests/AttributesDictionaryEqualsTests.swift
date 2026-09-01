//
//  AttributesDictionaryEqualsTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-14.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
import Foundation
@testable import Common

class AttributesDictionaryEqualsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    private var string1: NSAttributedString {
        
        // Create the attributed string
        let string = NSMutableAttributedString(string:"> blocjeeee \n> thththththt\n         dddddddkkkkkkkkkk\n\n> djdjkdjdkdjkdjkdjdkjdkdjkdjk\n> dsjdkdsdjskdsdsdjksdsddsdsdsdsdsds\n\n# First title one ssss\n## First title level two  1ssss\n\n\n# this is really fast mmm\n# djdskjdskjsdksjdksdjsds\n\n\n\n## dashdkadsklddsadjksaldsadjksaldsadjaksldsadjkasldsadjklsadsadjklsadsjakdlsadjksladjsakldsajdklsadjasklasdkdlsakdljdklsadjskaldjsakdjsakdjskadjksladjksladjksladjklasdjsakdjksaldjklasj\n\n## sdjakdjddjkssdjksdjskhkskfhdfkjhfjjghghghghghghghghghghghghghghg\neeeeeeeeeeeeee")
        
        // Declare the fonts
        let stringFont1 = NSFont(name:"CourierNewPSMT", size:16.0)!
        let stringFont2 = NSFont(name:"Helvetica", size:12.0)!
        let stringFont3 = NSFont(name:"CourierNewPS-BoldMT", size:32.0)!
        let stringFont4 = NSFont(name:"CourierNewPS-BoldMT", size:24.0)!
        
        // Declare the colors
        let stringColor1 = NSColor(red: 0.985955, green: 0.000000, blue: 0.026940, alpha: 1.000000)
        let stringColor2 = NSColor(red: 0.057724, green: 0.439369, blue: 0.005367, alpha: 1.000000)
        let stringColor3 = NSColor(red: 0.000000, green: 0.000000, blue: 0.000000, alpha: 1.000000)
        let stringColor4 = NSColor(red: 0.906329, green: 0.396253, blue: 0.916052, alpha: 1.000000)
        
        // Create the attributes and add them to the string
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(0,1))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(0,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(1,12))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(1,12))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(13,1))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(13,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(14,40))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(14,40))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(54,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(55,1))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(55,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(56,30))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(56,30))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(86,1))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(86,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(87,36))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(87,36))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(123,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(124,22))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont3, range:NSMakeRange(124,22))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(146,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor4, range:NSMakeRange(147,31))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont4, range:NSMakeRange(147,31))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(178,3))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(181,25))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont3, range:NSMakeRange(181,25))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(206,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(207,25))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont3, range:NSMakeRange(207,25))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(232,4))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor4, range:NSMakeRange(236,185))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont4, range:NSMakeRange(236,185))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(421,2))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor4, range:NSMakeRange(423,67))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont4, range:NSMakeRange(423,67))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont2, range:NSMakeRange(490,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(491,14))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(491,14))
        
        return NSAttributedString(attributedString:string)

    }
    
    func test1() {
        
        let attributes1 = string1.attributes(at: 0, effectiveRange: nil)
        let attributes2 = string1.attributes(at: 0, effectiveRange: nil)
        XCTAssertTrue(attributes1.equals(to: attributes2))
    }
    
    func test2() {
        
        let attributes1 = string1.attributes(at: 0, effectiveRange: nil)
        let attributes2 = string1.attributes(at: 33, effectiveRange: nil)
        XCTAssertFalse(attributes1.equals(to: attributes2))
    }
}
