//
//  NSAttributedString+Additions-Test.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-05-30.
//  Copyright © 2017 NM. All rights reserved.
//

import XCTest

class NSAttributedString_Additions_Test: XCTestCase {

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
    
    private var string2: NSAttributedString {
        
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
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(1,1))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(1,1))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(2,9))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(2,9))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(11,2))
        string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(11,2))
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
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testdifferentAtributesRanges1() {
        
        let attributes = string1.attributes(at: 2, effectiveRange: nil)
        let attributes2 = string2.attributes(at: 0, effectiveRange: nil)
        
        debugPrint("attributes: \(attributes)")
        debugPrint("===============================================")
        debugPrint("attributes2: \(attributes2)")
        
        let differentAttributesRanges = string2.differentAttributesRanges(in: NSMakeRange(0, 11), from: attributes, shouldStop: false)

        XCTAssertTrue(differentAttributesRanges.count == 2)
        
        let range1 = NSMakeRange(0, 1)
        var foundRange1 = false
        
        let range2 = NSMakeRange(2, 9)
        var foundRange2 = false
        
        for differentRange in differentAttributesRanges {
            
            if differentRange == range2 {
                foundRange2 = true
            }
            
            if differentRange == range1 {
                foundRange1 = true
            }
        }
        
        XCTAssertTrue(foundRange1)
        XCTAssertTrue(foundRange2)
    }

    func testdifferentAtributesRanges2() {
        
        let attributes = string1.attributes(at: 2, effectiveRange: nil)
        
        let differentAttributesRanges = string2.differentAttributesRanges(in: NSMakeRange(2, 9), from: attributes, shouldStop: false)
        
        // string 1
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(0,1))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(0,1))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(1,12))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(1,12))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(13,1))
        
        // string 2
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(0,1))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(0,1))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(1,1))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(1,1))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor3, range:NSMakeRange(2,9))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(2,9))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor2, range:NSMakeRange(11,2))
        // string.addAttribute(NSAttributedString.Key.font, value:stringFont1, range:NSMakeRange(11,2))
        // string.addAttribute(NSAttributedString.Key.foregroundColor, value:stringColor1, range:NSMakeRange(13,1))
        
        
        XCTAssertTrue(differentAttributesRanges.count == 1)
    }
    
}
