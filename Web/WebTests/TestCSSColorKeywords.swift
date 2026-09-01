//
//  TestCSSColorKeywords.swift
//  WebTests
//
//  Created by Sébastien Hamel on 2018-01-23.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest

class TestCSSColorKeywords: TestCSSDOM {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // blue
    func testKeywordBlueColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :blue;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 0, green: 0, blue: 255/255, alpha: 1), "Color is not blue.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    // black: CIColor(red: 0, green: 0, blue: 0, alpha: 1)
    func testKeywordBlackColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :black;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 0, green: 0, blue: 0, alpha: 1), "Color is not black.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    // blanchedalmond: CIColor(red: 255, green: 235, blue: 205, alpha: 1)
    func testKeywordblanchedalmondColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :blanchedalmond;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 255/255, green: 235/255, blue: 205/255, alpha: 1), "Color is not blanchedalmond.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    // transparent: CIColor(red: 0, green: 0, blue: 0, alpha: 0)
    // aliceblue: CIColor(red: 240, green: 248, blue: 255, alpha: 1)
    // antiquewhite: CIColor(red: 250, green: 235, blue: 215, alpha: 1)
    // aqua: CIColor(red: 0, green: 255, blue: 255, alpha: 1)
    // aquamarine: CIColor(red: 127, green: 255, blue: 212, alpha: 1)
    // azure: CIColor(red: 240, green: 255, blue: 255, alpha: 1)
    // beige: CIColor(red: 245, green: 245, blue: 220, alpha: 1)
    // bisque: CIColor(red: 255, green: 228, blue: 196, alpha: 1)
    // blue: CIColor(red: 0, green: 0, blue: 255, alpha: 1)
    // blueviolet: CIColor(red: 138, green: 43, blue: 226, alpha: 1)
    // brown: CIColor(red: 165, green: 42, blue: 42, alpha: 1)
    // burlywood: CIColor(red: 222, green: 184, blue: 135, alpha: 1)
    // cadetblue: CIColor(red: 95, green: 158, blue: 160, alpha: 1)
    // chartreuse: CIColor(red: 127, green: 255, blue: 0, alpha: 1)
    // chocolate: CIColor(red: 210, green: 105, blue: 30, alpha: 1)
    // coral: CIColor(red: 255, green: 127, blue: 80, alpha: 1)
    // cornflowerblue: CIColor(red: 100, green: 149, blue: 237, alpha: 1)
    // cornsilk: CIColor(red: 255, green: 248, blue: 220, alpha: 1)
    // crimson: CIColor(red: 220, green: 20, blue: 60, alpha: 1)
    // cyan: CIColor(red: 0, green: 255, blue: 255, alpha: 1)
    // darkblue: CIColor(red: 0, green: 0, blue: 139, alpha: 1)
    // darkcyan: CIColor(red: 0, green: 139, blue: 139, alpha: 1)
    // darkgoldenrod: CIColor(red: 184, green: 134, blue: 11, alpha: 1)
    // darkgray: CIColor(red: 169, green: 169, blue: 169, alpha: 1)
    // darkgreen: CIColor(red: 0, green: 100, blue: 0, alpha: 1)
    // darkgrey: CIColor(red: 169, green: 169, blue: 169, alpha: 1)
    // darkkhaki: CIColor(red: 189, green: 183, blue: 107, alpha: 1)
    // darkmagenta: CIColor(red: 139, green: 0, blue: 139, alpha: 1)
    // darkolivegreen: CIColor(red: 85, green: 107, blue: 47, alpha: 1)
    // darkorange: CIColor(red: 255, green: 140, blue: 0, alpha: 1)
    // darkorchid: CIColor(red: 153, green: 50, blue: 204, alpha: 1)
    // darkred: CIColor(red: 139, green: 0, blue: 0, alpha: 1)
    // darksalmon: CIColor(red: 233, green: 150, blue: 122, alpha: 1)
    // darkseagreen: CIColor(red: 143, green: 188, blue: 143, alpha: 1)
    // darkslateblue: CIColor(red: 72, green: 61, blue: 139, alpha: 1)
    // darkslategray: CIColor(red: 47, green: 79, blue: 79, alpha: 1)
    // darkslategrey: CIColor(red: 47, green: 79, blue: 79, alpha: 1)
    // darkturquoise: CIColor(red: 0, green: 206, blue: 209, alpha: 1)
    // darkviolet: CIColor(red: 148, green: 0, blue: 211, alpha: 1)
    // deeppink: CIColor(red: 255, green: 20, blue: 147, alpha: 1)
    // deepskyblue: CIColor(red: 0, green: 191, blue: 255, alpha: 1)
    // dimgray: CIColor(red: 105, green: 105, blue: 105, alpha: 1)
    // dimgrey: CIColor(red: 105, green: 105, blue: 105, alpha: 1)
    // dodgerblue: CIColor(red: 30, green: 144, blue: 255, alpha: 1)
    // firebrick: CIColor(red: 178, green: 34, blue: 34, alpha: 1)
    // floralwhite: CIColor(red: 255, green: 250, blue: 240, alpha: 1)
    // forestgreen: CIColor(red: 34, green: 139, blue: 34, alpha: 1)
    // fuchsia: CIColor(red: 255, green: 0, blue: 255, alpha: 1)
    // gainsboro: CIColor(red: 220, green: 220, blue: 220, alpha: 1)
    // ghostwhite: CIColor(red: 248, green: 248, blue: 255, alpha: 1)
    // gold: CIColor(red: 255, green: 215, blue: 0, alpha: 1)
    // goldenrod: CIColor(red: 218, green: 165, blue: 32, alpha: 1)
    // gray: CIColor(red: 128, green: 128, blue: 128, alpha: 1)
    func testKeywordgrayColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :gray;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1), "Color is not gray.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    // green: CIColor(red: 0, green: 128, blue: 0, alpha: 1)
    // greenyellow: CIColor(red: 173, green: 255, blue: 47, alpha: 1)
    // grey: CIColor(red: 128, green: 128, blue: 128, alpha: 1)
    // honeydew: CIColor(red: 240, green: 255, blue: 240, alpha: 1)
    // hotpink: CIColor(red: 255, green: 105, blue: 180, alpha: 1)
    // indianred: CIColor(red: 205, green: 92, blue: 92, alpha: 1)
    // indigo: CIColor(red: 75, green: 0, blue: 130, alpha: 1)
    // ivory: CIColor(red: 255, green: 255, blue: 240, alpha: 1)
    // khaki: CIColor(red: 240, green: 230, blue: 140, alpha: 1)
    // lavender: CIColor(red: 230, green: 230, blue: 250, alpha: 1)
    // lavenderblush: CIColor(red: 255, green: 240, blue: 245, alpha: 1)
    // lawngreen: CIColor(red: 124, green: 252, blue: 0, alpha: 1)
    // lemonchiffon: CIColor(red: 255, green: 250, blue: 205, alpha: 1)
    // lightblue: CIColor(red: 173, green: 216, blue: 230, alpha: 1)
    // lightcoral: CIColor(red: 240, green: 128, blue: 128, alpha: 1)
    // lightcyan: CIColor(red: 224, green: 255, blue: 255, alpha: 1)
    // lightgoldenrodyellow: CIColor(red: 250, green: 250, blue: 210, alpha: 1)
    // lightgray: CIColor(red: 211, green: 211, blue: 211, alpha: 1)
    // lightgreen: CIColor(red: 144, green: 238, blue: 144, alpha: 1)
    // lightgrey: CIColor(red: 211, green: 211, blue: 211, alpha: 1)
    // lightpink: CIColor(red: 255, green: 182, blue: 193, alpha: 1)
    // lightsalmon: CIColor(red: 255, green: 160, blue: 122, alpha: 1)
    // lightseagreen: CIColor(red: 32, green: 178, blue: 170, alpha: 1)
    func testKeywordlightseagreenColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :lightseagreen;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 32/255, green: 178/255, blue: 170/255, alpha: 1), "Color is not lightseagreen.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    
    // lightskyblue: CIColor(red: 135, green: 206, blue: 250, alpha: 1)
    // lightslategray: CIColor(red: 119, green: 136, blue: 153, alpha: 1)
    // lightslategrey: CIColor(red: 119, green: 136, blue: 153, alpha: 1)
    // lightsteelblue: CIColor(red: 176, green: 196, blue: 222, alpha: 1)
    // lightyellow: CIColor(red: 255, green: 255, blue: 224, alpha: 1)
    // lime: CIColor(red: 0, green: 255, blue: 0, alpha: 1)
    // limegreen: CIColor(red: 50, green: 205, blue: 50, alpha: 1)
    // linen: CIColor(red: 250, green: 240, blue: 230, alpha: 1)
    // magenta: CIColor(red: 255, green: 0, blue: 255, alpha: 1)
    // maroon: CIColor(red: 128, green: 0, blue: 0, alpha: 1)
    // mediumaquamarine: CIColor(red: 102, green: 205, blue: 170, alpha: 1)
    // mediumblue: CIColor(red: 0, green: 0, blue: 205, alpha: 1)
    // mediumorchid: CIColor(red: 186, green: 85, blue: 211, alpha: 1)
    // mediumpurple: CIColor(red: 147, green: 112, blue: 219, alpha: 1)
    // mediumseagreen: CIColor(red: 60, green: 179, blue: 113, alpha: 1)
    // mediumslateblue: CIColor(red: 123, green: 104, blue: 238, alpha: 1)
    // mediumspringgreen: CIColor(red: 0, green: 250, blue: 154, alpha: 1)
    // mediumturquoise: CIColor(red: 72, green: 209, blue: 204, alpha: 1)
    // mediumvioletred: CIColor(red: 199, green: 21, blue: 133, alpha: 1)
    // midnightblue: CIColor(red: 25, green: 25, blue: 112, alpha: 1)
    // mintcream: CIColor(red: 245, green: 255, blue: 250, alpha: 1)
    func testKeywordmintcreamColorParsing() {
        
        let cssString =
            "   body {                          " +
                "       color :mintcream;         " +
        "   }                               ";
        
        if let color = colorValueFromCSSColorProperty(sourceString: cssString as NSString) {
            
            XCTAssert(color ==  CIColor(red: 245/255, green: 255/255, blue: 250/255, alpha: 1), "Color is not mintcream.")
        }
        else {
            XCTAssert(false, "Color is nil.")
        }
    }
    // mistyrose: CIColor(red: 255, green: 228, blue: 225, alpha: 1)
    // moccasin: CIColor(red: 255, green: 228, blue: 181, alpha: 1)
    // navajowhite: CIColor(red: 255, green: 222, blue: 173, alpha: 1)
    // navy: CIColor(red: 0, green: 0, blue: 128, alpha: 1)
    // oldlace: CIColor(red: 253, green: 245, blue: 230, alpha: 1)
    // olive: CIColor(red: 128, green: 128, blue: 0, alpha: 1)
    // olivedrab: CIColor(red: 107, green: 142, blue: 35, alpha: 1)
    // orange: CIColor(red: 255, green: 165, blue: 0, alpha: 1)
    // orangered: CIColor(red: 255, green: 69, blue: 0, alpha: 1)
    // orchid: CIColor(red: 218, green: 112, blue: 214, alpha: 1)
    // palegoldenrod: CIColor(red: 238, green: 232, blue: 170, alpha: 1)
    // palegreen: CIColor(red: 152, green: 251, blue: 152, alpha: 1)
    // paleturquoise: CIColor(red: 175, green: 238, blue: 238, alpha: 1)
    // palevioletred: CIColor(red: 219, green: 112, blue: 147, alpha: 1)
    // papayawhip: CIColor(red: 255, green: 239, blue: 213, alpha: 1)
    // peachpuff: CIColor(red: 255, green: 218, blue: 185, alpha: 1)
    // peru: CIColor(red: 205, green: 133, blue: 63, alpha: 1)
    // pink: CIColor(red: 255, green: 192, blue: 203, alpha: 1)
    // plum: CIColor(red: 221, green: 160, blue: 221, alpha: 1)
    // powderblue: CIColor(red: 176, green: 224, blue: 230, alpha: 1)
    // purple: CIColor(red: 128, green: 0, blue: 128, alpha: 1)
    // red: CIColor(red: 255, green: 0, blue: 0, alpha: 1)
    // rosybrown: CIColor(red: 188, green: 143, blue: 143, alpha: 1)
    // royalblue: CIColor(red: 65, green: 105, blue: 225, alpha: 1)
    // saddlebrown: CIColor(red: 139, green: 69, blue: 19, alpha: 1)
    // salmon: CIColor(red: 250, green: 128, blue: 114, alpha: 1)
    // sandybrown: CIColor(red: 244, green: 164, blue: 96, alpha: 1)
    // seagreen: CIColor(red: 46, green: 139, blue: 87, alpha: 1)
    // seashell: CIColor(red: 255, green: 245, blue: 238, alpha: 1)
    // sienna: CIColor(red: 160, green: 82, blue: 45, alpha: 1)
    // silver: CIColor(red: 192, green: 192, blue: 192, alpha: 1)
    // skyblue: CIColor(red: 135, green: 206, blue: 235, alpha: 1)
    // slateblue: CIColor(red: 106, green: 90, blue: 205, alpha: 1)
    // slategray: CIColor(red: 112, green: 128, blue: 144, alpha: 1)
    // slategrey: CIColor(red: 112, green: 128, blue: 144, alpha: 1)
    // snow: CIColor(red: 255, green: 250, blue: 250, alpha: 1)
    // springgreen: CIColor(red: 0, green: 255, blue: 127, alpha: 1)
    // steelblue: CIColor(red: 70, green: 130, blue: 180, alpha: 1)
    // tan: CIColor(red: 210, green: 180, blue: 140, alpha: 1)
    // teal: CIColor(red: 0, green: 128, blue: 128, alpha: 1)
    // thistle: CIColor(red: 216, green: 191, blue: 216, alpha: 1)
    // tomato: CIColor(red: 255, green: 99, blue: 71, alpha: 1)
    // turquoise: CIColor(red: 64, green: 224, blue: 208, alpha: 1)
    // violet: CIColor(red: 238, green: 130, blue: 238, alpha: 1)
    // wheat: CIColor(red: 245, green: 222, blue: 179, alpha: 1)
    // white: CIColor(red: 255, green: 255, blue: 255, alpha: 1)
    // whitesmoke: CIColor(red: 245, green: 245, blue: 245, alpha: 1)
    // yellow: CIColor(red: 255, green: 255, blue: 0, alpha: 1)
    // yellowgreen: CIColor(red: 154, green: 205, blue: 50, alpha: 1)
    

}
