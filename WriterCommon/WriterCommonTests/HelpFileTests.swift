//
//  HelpFileTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2018-12-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Web
import Markdown
import os
@testable import WriterCommon

class HelpFileTests: RandomChangeTest {
    
    override func setUp() {
        
        super.setUp()
        
        let url = urlOfFile(named: "help.md")
        self.sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
    }
    
    func testError1() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(55802, 17), replacementString: "CSS:\n\n``")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // failed change: stringChange: {\n    affectedRange: {80313, 5},\n    replacementString: thic \n}"
    func testError2() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80313, 5), replacementString: "thic ")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError3() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80186, 3), replacementString: "h3> \n\n")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // failed change:
    //  stringChange: {
    //      affectedRange: "{80380, 8}",
    //      replacementString: "stinatio"
    //  }
    func testError4() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80380, 8), replacementString: "stinatio")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError5() {
        
        // replacementString    String    ":\n\n- Tex"
        let stringChange = StringChange(affectedRange: NSMakeRange(54780, 8), replacementString: ":\n\n- Tex")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    
    //failed change: stringChange: {
    //affectedRange: "{80136, 11}",
    //replacementString: "ple lang"
    //}
    func testError6() {
    
        let stringChange = StringChange(affectedRange: NSMakeRange(80136, 11), replacementString: "ple lang")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //2018-12-01 20:01:43.980802+0700 xctest[3023:9144039] [all] Not equals: length is different.
    //failed change: stringChange: {
    //affectedRange: "{69872, 0}",
    //replacementString: "n of t"
    //}
    func testError7() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(69872, 0), replacementString: "n of t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    
//    2018-12-01 20:06:36.206138+0700 xctest[3157:9156733] [all] Not equals: length is different.
//    failed change: stringChange: {
//    affectedRange: "{80381, 2}",
//    replacementString: ""
//    }
    func testError8() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80381, 2), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
//    2018-12-01 20:08:03.977555+0700 xctest[3157:9156733] [all] Not equals: length is different.
//    failed change: stringChange: {
//    affectedRange: "{80378, 1}",
//    replacementString: "vel"
//    }
    func testError9() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80378, 1), replacementString: "vel")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
//    2018-12-01 20:11:23.645153+0700 xctest[3157:9156733] [all] Not equals: length is different.
//    failed change: stringChange: {
//    affectedRange: "{80296, 8}",
//    replacementString: ""
//    }
    func testError10() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80296, 8), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    
    func testError11() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(28189, 10), replacementString: "tr>\n\t\t\t<t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError12() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80364, 8), replacementString: "\n<p>\n\t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError13() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80364, 2), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError14() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(8364, 2), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // failed change: { affectedRange: {80163, 10}, replacementString: ->r) pro<-}"
    func testError15() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(80163, 10), replacementString: "r) pro")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // failed change: { affectedRange: {68169, 2}, replacementString: -><-}"
    func testError16() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(68169, 2), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // failed change: { affectedRange: {68177, 2}, replacementString: ->Th<-}"
    func testError17() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(68177, 2), replacementString: "Th")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError18() {
        let stringChange = StringChange(affectedRange: NSMakeRange(40962, 4), replacementString: "rd s")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80100, 6}, replacementString: -><-}"
    func testError19() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80100, 6), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80119, 1}, replacementString: ->en to all<-}"
    func testError20() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80119, 1), replacementString: "en to all")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80133, 4}, replacementString: -><-}"
    func testError21() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80133, 4), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80199, 0}, replacementString: ->ession<-}"
    func testError22() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80199, 0), replacementString: "ession")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80234, 4}, replacementString: -><-}"
    func testError23() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80234, 4), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {74503, 6}, replacementString: -><-}"
    func testError24() {
        let stringChange = StringChange(affectedRange: NSMakeRange(74503, 6), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    //    "failed change: { affectedRange: {80371, 2}, replacementString: -><-}"
    func testError25() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80371, 2), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError26() {
        let stringChange = StringChange(affectedRange: NSMakeRange(74573, 6), replacementString: "f Styl")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }

    func testError27() {
        let stringChange = StringChange(affectedRange: NSMakeRange(69927, 9), replacementString: "(besides ")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80441, 0}, replacementString: -> va<-}"
    func testError28() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80441, 0), replacementString: " va")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError29() {
        let stringChange = StringChange(affectedRange: NSMakeRange(30098, 8), replacementString: "ense, \"w")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError30() {
        let stringChange = StringChange(affectedRange: NSMakeRange(40143, 15), replacementString: " ways:")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80424, 1}, replacementString: ->do<-}"
    func testError31() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80424, 1), replacementString: "do")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError32() {
        let stringChange = StringChange(affectedRange: NSMakeRange(11961, 9), replacementString: "html>\n\t\t<")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80116, 0}, replacementString: ->paces,<-}"
    func testError33() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80116, 0), replacementString: "paces,")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80237, 0}, replacementString: ->nverted i<-}"
    func testError34() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80237, 0), replacementString: "nverted i")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {76662, 4}, replacementString: -><-}"
    func testError35() {
        let stringChange = StringChange(affectedRange: NSMakeRange(76662, 4), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80298, 7}, replacementString: ->down: \n<-}"
    func testError36() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80298, 7), replacementString: "down: \n")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80235, 0}, replacementString: ->o e<-}"
    func testError37() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80235, 0), replacementString: "o e")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80144, 6}, replacementString: -><-}"
    func testError38() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80144, 6), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {69883, 4}, replacementString: -><-}"
    func testError39() {
        let stringChange = StringChange(affectedRange: NSMakeRange(69883, 4), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError40() {
        let stringChange = StringChange(affectedRange: NSMakeRange(77022, 4), replacementString: "he `Start")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80182, 1}, replacementString: -><-}"
    func testError41() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80182, 1), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError42() {
        let stringChange = StringChange(affectedRange: NSMakeRange(18634, 0), replacementString: ">\n\t\t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError43() {
        let stringChange = StringChange(affectedRange: NSMakeRange(83623, 4), replacementString: "n.\n\n1")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError44() {
        let stringChange = StringChange(affectedRange: NSMakeRange(14736, 1), replacementString: "{\n\tfon")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80179, 0}, replacementString: ->treu<-}"
    func testError45() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80179, 0), replacementString: "treu")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80185, 0}, replacementString: -> prope<-}"
    func testError46() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80185, 0), replacementString: " prope")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80246, 0}, replacementString: ->dee<-}"
    func testError47() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80246, 0), replacementString: "dee")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {76660, 5}, replacementString: ->144,2<-}"
    func testError48() {
        let stringChange = StringChange(affectedRange: NSMakeRange(76660, 5), replacementString: "144,2")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80345, 6}, replacementString: ->the ele<-}"
    func testError49() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80345, 6), replacementString: "the ele")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80191, 1}, replacementString: -> neigh<-}"
    func testError50() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80191, 1), replacementString: " neigh")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80327, 1}, replacementString: ->co<-}"
    func testError51() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80327, 1), replacementString: "co")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80191, 3}, replacementString: ->ssion<-}"
    func testError52() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80191, 3), replacementString: "ssion")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80342, 0}, replacementString: -> can nest<-}"
    func testError53() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80342, 0), replacementString: " can nest")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {74523, 0}, replacementString: ->\t\t\t<p>\n<-}"
    func testError54() {
        let stringChange = StringChange(affectedRange: NSMakeRange(74523, 0), replacementString: "\t\t\t<p>\n")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80437, 3}, replacementString: -><-}"
    func testError55() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80437, 3), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError56() {
        let stringChange = StringChange(affectedRange: NSMakeRange(40143, 8), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {80401, 16}, replacementString: ->#### Hide<-}"
    func testError57() {
        let stringChange = StringChange(affectedRange: NSMakeRange(80401, 16), replacementString: "#### Hide")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError58() {
        let stringChange = StringChange(affectedRange: NSMakeRange(74581, 5), replacementString: "phs \n- nu")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError59() {
        let stringChange = StringChange(affectedRange: NSMakeRange(45296, 12), replacementString: "s-list\"")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // crash
    func testError60() {
        let stringChange = StringChange(affectedRange: NSMakeRange(40387, 9), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {86507, 5}, replacementString: ->istic<-}"
    func testError61() {
        let stringChange = StringChange(affectedRange: NSMakeRange(86507, 5), replacementString: "istic")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "failed change: { affectedRange: {46821, 9}, replacementString: -><-}"
    func testError62() {
        let stringChange = StringChange(affectedRange: NSMakeRange(46821, 9), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // All these sizes are based on the `medium` size which is set to 16px in Stylo.\n\n| Keyword | Value |\n| ----- | ------ |\n| xx-small | 9.6px |\n| x-small | 12px |\n| medium | 16 px |\n| wide | 19.2px |\n| x-large | 24px |\n| xx-large | 32px\n\t<\n\n
    func testError64() {
        let stringChange = StringChange(affectedRange: NSMakeRange(68413, 3), replacementString: "\n\t<")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError65() {
        let stringChange = StringChange(affectedRange: NSMakeRange(16293, 6), replacementString: "comma-")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError66() {
        let stringChange = StringChange(affectedRange: NSMakeRange(77059, 7), replacementString: "heet")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // From:
    //
    // ##### Ordered
    //
    // The `<number>.` or the `<number>)` can be used to create ordered lists.
    //
    // Markdown:
    //
    // ``` markdown
    // 1. first item
    // 2. second item
    // 3. third item
    // ```
    //
    // To:
    //
    // The `<number>.` or the `<number>)` can be used to create ordered lists.
    //
    // Markdowributed`` markdown
    // 1. first item
    // 2. second item
    // 3. third item
    // ```
    func testError67() {
        let stringChange = StringChange(affectedRange: NSMakeRange(33894, 5), replacementString: "ributed")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }

    func testError68() {
        let stringChange = StringChange(affectedRange: NSMakeRange(33263, 14), replacementString: " \n\n\n\nAs a")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }

    func testError69() {
        let stringChange = StringChange(affectedRange: NSMakeRange(69950, 4), replacementString: "r, wi")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError70() {
        let stringChange = StringChange(affectedRange: NSMakeRange(20635, 7), replacementString: "evel 2 ")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError71() {
        let stringChange = StringChange(affectedRange: NSMakeRange(88860, 12), replacementString: "e li")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError72() {
        let stringChange = StringChange(affectedRange: NSMakeRange(89275, 1), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError73() {
        let stringChange = StringChange(affectedRange: NSMakeRange(88862, 8), replacementString: "is defi")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError74() {
        let stringChange = StringChange(affectedRange: NSMakeRange(54137, 4), replacementString: "` ht")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError75() {
        let stringChange = StringChange(affectedRange: NSMakeRange(57243, 10), replacementString: "L:\n\n```")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33069, 3}, replacementString: ->the<-}"
    func testError76() {
    
        let stringChange = StringChange(affectedRange: NSMakeRange(33069, 3), replacementString: "the")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33823, 8}, replacementString: ->out valu<-}"
    func testError77() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33823, 8), replacementString: "out valu")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33895, 0}, replacementString: ->t<-}"
    func testError78() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33895, 0), replacementString: "t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33029, 6}, replacementString: ->y the<-}"
    func testError79() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33029, 6), replacementString: "y the")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33156, 7}, replacementString: -><-}"
    func testError80() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33156, 7), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33255, 1}, replacementString: -><-}"
    func testError81() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33255, 1), replacementString: "")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {33192, 1}, replacementString: ->Select<-}"
    func testError82() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(33192, 1), replacementString: "Select")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // testing: { affectedRange: {5666, 0}, replacementString: ->1>\n\t\t<-}"
    func testError83() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(5666, 0), replacementString: "1>\n\t\t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }

    // testing: { affectedRange: {34213, 0}, replacementString: ->\n- `clos<-}"
    func testError84() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(34213, 0), replacementString: "\n- `clos")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    // "619 -> testing: { affectedRange: {71258, 18}, replacementString: ->ed it swi<-}"
    func testError85() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(74699, 0), replacementString: "yle\n- ")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError86() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(25057, 7), replacementString: "that sh")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError87() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(3900, 0), replacementString: "ml\n<P>\n")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    func testError88() {
        
        let stringChange = StringChange(affectedRange: NSMakeRange(53365, 0), replacementString: "ml\n<h1>t")
        XCTAssert(testChange(stringChange: stringChange), "failed")
    }
    
    
//    func testRandomChanges() {
//
//        var failedChanges = [StringChange]()
//        var passed: Int = 0
//
//
//        while failedChanges.count < 100 {
//
//            autoreleasepool {
//
//                if let stringChange = nextStringChange {
//
//                    debugPrint("\(passed) -> testing: \(stringChange)")
//
//                    if !testChange(stringChange: stringChange) {
//
//                        debugPrint("failure")
//                        failedChanges.append(stringChange)
//                    }
//                    else {
//
//                        passed += 1
//                        debugPrint("success")
//                    }
//                }
//            }
//        }
//
//        debugPrint("number of passed: \(passed)")
//
//        debugPrint("Failed changes: ")
//        for failedChange in failedChanges {
//
//            debugPrint("failed change: \(failedChange)")
//        }
//        XCTAssert(failedChanges.isEmpty, "Failed changed: \(failedChanges)")
//    }

//    func testAddSingleSpaceEverywhere() {
//        
//        var failedIndexes = [Int]()
//        
//        for i in 0...sourceString.count {
//            
//            autoreleasepool {
//            
//                let stringChange = StringChange(affectedRange: NSMakeRange(i, 0), replacementString: " ")
//                
//                if !testChange(stringChange: stringChange) {
//                    
//                    failedIndexes.append(i)
//                }
//                else {
//                    debugPrint("success: \(stringChange)")
//                }
//            }
//        }
//        
//        XCTAssert(failedIndexes.isEmpty, "Failed at index: \(failedIndexes)")
//    }
    

}
