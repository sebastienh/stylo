//
//  MarkdownHtmlDomOperationTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-11-06.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Markdown
import Web
import Common
@testable import WriterCommon

class MarkdownHtmlDomOperationTest: WriterCommonTests {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testMarkdownPartialCompilation3() {
//        
//        let url = urlOfFile(named: "markdown-partial-compilation-2.md")
//        let markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
//        let env = StyloMarkdownEnv()
//        
//        let sourceStringChangeDescription = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "", changeLength: 0, sourceString: NSMutableAttributedString(string: markdownString))
//        
//        let firstMarkdownCharactersChangeRequest = MarkdownChangeRequest(changeRequestType: ChangeRequestType.all, sourceStringChangeDescription: sourceStringChangeDescription)
//        firstMarkdownCharactersChangeRequest.env = env
//        let stringResourceModelRenderingState = StringResourceModelRenderingState()
//        firstMarkdownCharactersChangeRequest.stringResourceModelRenderingState = stringResourceModelRenderingState
//        
//        let markdownTokensCreateOperation = MarkdownTokensCreateOperation(stringContainer: firstMarkdownCharactersChangeRequest, markdownChangeRequest: firstMarkdownCharactersChangeRequest, markdownPresetName: nil, completionBlock: { () -> Void in
//        })
//        
//        markdownTokensCreateOperation.start()
//        
//        print("tokens: \(firstMarkdownCharactersChangeRequest.markdownTokens!.toString())")
//        
//        let tokenValues = firstMarkdownCharactersChangeRequest.markdownTokens!.tokenValues
//        
//        XCTAssert(tokenValues[0].type == .HeadingOpen)
//        XCTAssert(tokenValues[0].tag == "h1")
//        XCTAssert(tokenValues[0].markup == "#")
//        
//        XCTAssert(tokenValues[1].type == .Inline)
//        XCTAssert(tokenValues[1].level == 1)
//        XCTAssert(tokenValues[1].content == "titre de niveau 1")
//
//        XCTAssert(tokenValues[2].type == .HeadingClose)
//        XCTAssert(tokenValues[2].tag == "h1")
//        
//        XCTAssert(tokenValues[3].type == .HeadingOpen)
//        XCTAssert(tokenValues[3].tag == "h1")
//        XCTAssert(tokenValues[3].markup == "=")
//        
//        XCTAssert(tokenValues[4].type == .Inline)
//        XCTAssert(tokenValues[4].level == 1)
//        XCTAssert(tokenValues[4].content == "Heading 1")
//        
//        XCTAssert(tokenValues[5].type == .HeadingClose)
//        XCTAssert(tokenValues[5].tag == "h1")
//        
//        XCTAssert(tokenValues[6].type == .HeadingOpen)
//        XCTAssert(tokenValues[6].tag == "h2")
//        XCTAssert(tokenValues[6].markup == "##")
//        
//        XCTAssert(tokenValues[7].type == .Inline)
//        XCTAssert(tokenValues[7].level == 1)
//        XCTAssert(tokenValues[7].content == "titre de niveau 2")
//
//        XCTAssert(tokenValues[8].type == .HeadingClose)
//        XCTAssert(tokenValues[8].tag == "h2")
//        
//        XCTAssert(tokenValues[9].type == .HeadingOpen)
//        XCTAssert(tokenValues[9].tag == "h2")
//        XCTAssert(tokenValues[9].markup == "-")
//        
//        XCTAssert(tokenValues[10].type == .Inline)
//        XCTAssert(tokenValues[10].level == 1)
//        XCTAssert(tokenValues[10].content == "Heading 2")
//        
//        XCTAssert(tokenValues[11].type == .HeadingClose)
//        XCTAssert(tokenValues[11].tag == "h2")
//        
//        XCTAssert(tokenValues[12].type == .HeadingOpen)
//        XCTAssert(tokenValues[12].tag == "h3")
//        XCTAssert(tokenValues[12].markup == "###")
//        
//        XCTAssert(tokenValues[13].type == .Inline)
//        XCTAssert(tokenValues[13].level == 1)
//        XCTAssert(tokenValues[13].content == "tsdghsdghs")
//        
//        XCTAssert(tokenValues[14].type == .HeadingClose)
//        XCTAssert(tokenValues[14].tag == "h3")
//        
//        XCTAssert(tokenValues[15].type == .ParagraphOpen)
//        XCTAssert(tokenValues[15].tag == "p")
//
//        XCTAssert(tokenValues[16].type == .Inline)
//        XCTAssert(tokenValues[16].level == 1)
//        XCTAssert(tokenValues[16].content == "Test this is a test. A new test.")
//        
//        XCTAssert(tokenValues[17].type == .ParagraphClose)
//        XCTAssert(tokenValues[17].tag == "p")
//        
//        
//        
//        let newMarkdownString = (markdownString as NSString).replacingOccurrences(of: "## titre de niveau 2", with:"## titre de niveau ")
//        
//        // delete the 1 value inside the heading 1
//        let sourceStringChangeDescription2 = SourceStringChangeDescription(range: NSMakeRange(73, 1), stringReplacement: "", changeLength: -1, sourceString: NSMutableAttributedString(string: newMarkdownString))
//        
//        let markdownCharactersChangeRequest = MarkdownChangeRequest(changeRequestType: ChangeRequestType.all, sourceStringChangeDescription: sourceStringChangeDescription2)
//        markdownCharactersChangeRequest.env = env
//        markdownCharactersChangeRequest.stringResourceModelRenderingState = stringResourceModelRenderingState
//        
//        let secondMarkdownTokensCreateOperation = MarkdownTokensCreateOperation(stringContainer: markdownCharactersChangeRequest, markdownChangeRequest: markdownCharactersChangeRequest, markdownPresetName: nil, completionBlock: { () -> Void in
//        })
//        
//        secondMarkdownTokensCreateOperation.start()
//        
//        let finalTokenValues = markdownCharactersChangeRequest.markdownTokens!.tokenValues
//
//        XCTAssert(finalTokenValues[0].type == .HeadingOpen)
//        XCTAssert(finalTokenValues[0].tag == "h1")
//        XCTAssert(finalTokenValues[0].markup == "#")
//        
//        XCTAssert(finalTokenValues[1].type == .Inline)
//        XCTAssert(finalTokenValues[1].level == 1)
//        XCTAssert(finalTokenValues[1].content == "titre de niveau 1")
//        
//        XCTAssert(finalTokenValues[2].type == .HeadingClose)
//        XCTAssert(finalTokenValues[2].tag == "h1")
//        
//        XCTAssert(finalTokenValues[3].type == .HeadingOpen)
//        XCTAssert(finalTokenValues[3].tag == "h1")
//        XCTAssert(finalTokenValues[3].markup == "=")
//        
//        XCTAssert(finalTokenValues[4].type == .Inline)
//        XCTAssert(finalTokenValues[4].level == 1)
//        XCTAssert(finalTokenValues[4].content == "Heading 1")
//        
//        XCTAssert(finalTokenValues[5].type == .HeadingClose)
//        XCTAssert(finalTokenValues[5].tag == "h1")
//        
//        XCTAssert(finalTokenValues[6].type == .HeadingOpen)
//        XCTAssert(finalTokenValues[6].tag == "h2")
//        XCTAssert(finalTokenValues[6].markup == "##")
//        
//        XCTAssert(finalTokenValues[7].type == .Inline)
//        XCTAssert(finalTokenValues[7].level == 1)
//        XCTAssert(finalTokenValues[7].content == "titre de niveau", "received value: \(finalTokenValues[7].content)")
//        
//        XCTAssert(finalTokenValues[8].type == .HeadingClose)
//        XCTAssert(finalTokenValues[8].tag == "h2")
//        
//        XCTAssert(finalTokenValues[9].type == .HeadingOpen)
//        XCTAssert(finalTokenValues[9].tag == "h2")
//        XCTAssert(finalTokenValues[9].markup == "-")
//        
//        XCTAssert(finalTokenValues[10].type == .Inline)
//        XCTAssert(finalTokenValues[10].level == 1)
//        XCTAssert(finalTokenValues[10].content == "Heading 2")
//        
//        XCTAssert(finalTokenValues[11].type == .HeadingClose)
//        XCTAssert(finalTokenValues[11].tag == "h2")
//        
//        XCTAssert(finalTokenValues[12].type == .HeadingOpen)
//        XCTAssert(finalTokenValues[12].tag == "h3")
//        XCTAssert(finalTokenValues[12].markup == "###")
//        
//        XCTAssert(finalTokenValues[13].type == .Inline)
//        XCTAssert(finalTokenValues[13].level == 1)
//        XCTAssert(finalTokenValues[13].content == "tsdghsdghs")
//        
//        XCTAssert(finalTokenValues[14].type == .HeadingClose)
//        XCTAssert(finalTokenValues[14].tag == "h3")
//        
//        XCTAssert(finalTokenValues[15].type == .ParagraphOpen)
//        XCTAssert(finalTokenValues[15].tag == "p")
//        
//        XCTAssert(finalTokenValues[16].type == .Inline)
//        XCTAssert(finalTokenValues[16].level == 1)
//        XCTAssert(finalTokenValues[16].content == "Test this is a test. A new test.")
//        
//        XCTAssert(finalTokenValues[17].type == .ParagraphClose)
//        XCTAssert(finalTokenValues[17].tag == "p")
//    }
//
//    func testMarkdownPartialCompilation4() {
//        
//        let url = urlOfFile(named: "markdown-partial-compilation-2.md")
//        let markdownString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
//        
//        let attributedString = NSAttributedString(string: markdownString)
//        let textStorage = NSTextStorage(attributedString: attributedString)
//        
//        let env = StyloMarkdownEnv()
//        
//        
//        /**************/
//        /* First Pass */
//        /**************/
//        
//        // send this change request just to get a list of previous tokens
//        let sourceStringChangeDescription = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "", changeLength: 0, sourceString: NSMutableAttributedString(string: markdownString))
//        
//        let firstMarkdownCharactersChangeRequest = MarkdownChangeRequest(changeRequestType: ChangeRequestType.all, sourceStringChangeDescription: sourceStringChangeDescription)
//        firstMarkdownCharactersChangeRequest.env = env
//        let stringResourceModelRenderingState = StringResourceModelRenderingState()
//        firstMarkdownCharactersChangeRequest.stringResourceModelRenderingState = stringResourceModelRenderingState
//        
//        let markdownTokensCreateOperation = MarkdownTokensCreateOperation(stringContainer: firstMarkdownCharactersChangeRequest, markdownChangeRequest: firstMarkdownCharactersChangeRequest, markdownPresetName: nil, completionBlock: { () -> Void in
//        })
//        
//        markdownTokensCreateOperation.start()
//        
//        let markdownHtmlDomOperation = MarkdownHtmlDomOperation(changeRequest: firstMarkdownCharactersChangeRequest)
//        
//        markdownHtmlDomOperation.start()
//        
//        let firstVersionOfHtmlDocument = firstMarkdownCharactersChangeRequest.htmlDocument!
//        
//        let bodyDescendants = firstVersionOfHtmlDocument.body.descendants()
//        
//        debugPrint("bodyDescendants.length \(bodyDescendants.length)")
//        
//        for (index, node) in bodyDescendants.enumerated() {
//            
//            debugPrint("node \(index): \(node.nodeName)")
//            debugPrint("node \(index) sourceStringFragment: \(node.sourceStringFragment)")
//        }
//        
//        var sourceStringRegion = SourceStringRegion()
//        sourceStringRegion.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 2, endIntegerIndex: 21))
//        XCTAssert((bodyDescendants[0]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion)
//        
//        XCTAssert(bodyDescendants[1]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[2]!.sourceStringFragment ==  nil)
//        
//        var sourceStringRegion3 = SourceStringRegion()
//        sourceStringRegion3.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 23, endIntegerIndex: 32))
//        XCTAssert((bodyDescendants[3]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion3)
//        
//        XCTAssert(bodyDescendants[4]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[5]!.sourceStringFragment ==  nil)
//        
//        var sourceStringRegion6 = SourceStringRegion()
//        sourceStringRegion6.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 44, endIntegerIndex: 64))
//        XCTAssert((bodyDescendants[6]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion6)
//        
//        XCTAssert(bodyDescendants[7]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[8]!.sourceStringFragment ==  nil)
//        
//        var sourceStringRegion9 = SourceStringRegion()
//        sourceStringRegion9.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 66, endIntegerIndex: 75))
//        XCTAssert((bodyDescendants[9]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion9)
//        
//        XCTAssert(bodyDescendants[10]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[11]!.sourceStringFragment ==  nil)
//        
//        var sourceStringRegion12 = SourceStringRegion()
//        sourceStringRegion12.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 90, endIntegerIndex: 104))
//        XCTAssert((bodyDescendants[12]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion12)
//        
//        XCTAssert(bodyDescendants[13]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[14]!.sourceStringFragment ==  nil)
//        
//        var sourceStringRegion15 = SourceStringRegion()
//        sourceStringRegion15.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 106, endIntegerIndex: 139))
//        XCTAssert((bodyDescendants[15]!.sourceStringFragment! as! SourceStringRegion) == sourceStringRegion15)
//        
//        XCTAssert(bodyDescendants[16]!.sourceStringFragment ==  nil)
//        XCTAssert(bodyDescendants[17]!.sourceStringFragment ==  nil)
//        
//        /***************/
//        /* Second Pass */
//        /***************/
//        
//        let newMarkdownString = (markdownString as NSString).replacingOccurrences(of: "## titre de niveau 2", with:"## titre de niveau ")
//        
//        // delete the 1 value inside the heading 1
//        // send this change request just to get a list of previous tokens
//        let sourceStringChangeDescription2 = SourceStringChangeDescription(range: NSMakeRange(64, 1), stringReplacement: "", changeLength: -1, sourceString: NSString(string: newMarkdownString))
//        
//        let secondMarkdownCharactersChangeRequest = MarkdownChangeRequest(changeRequestType: ChangeRequestType.all, sourceStringChangeDescription: sourceStringChangeDescription2)
//        secondMarkdownCharactersChangeRequest.env = env
//        secondMarkdownCharactersChangeRequest.markdownTokens = firstMarkdownCharactersChangeRequest.markdownTokens
//        secondMarkdownCharactersChangeRequest.stringResourceModelRenderingState = stringResourceModelRenderingState
//        
//        let secondMarkdownTokensCreateOperation = MarkdownTokensCreateOperation(stringContainer: secondMarkdownCharactersChangeRequest, markdownChangeRequest: secondMarkdownCharactersChangeRequest, markdownPresetName: nil, completionBlock: { () -> Void in
//        })
//        
//        secondMarkdownTokensCreateOperation.start()
//    
//        let secondMarkdownHtmlDomOperation = MarkdownHtmlDomOperation(changeRequest: secondMarkdownCharactersChangeRequest)
// 
//        secondMarkdownHtmlDomOperation.start()
//        
//        let secondVersionOfHtmlDocument = secondMarkdownCharactersChangeRequest.htmlDocument!
//        
//        let secondBodyDescendants = secondVersionOfHtmlDocument.body.descendants()
//        
//        debugPrint("secondBodyDescendants.length \(secondBodyDescendants.length)")
//        
//        for node in secondBodyDescendants {
//            
//            debugPrint("node \(node.nodeName)")
//            debugPrint("node sourceStringFragment: \(String(describing: node.sourceStringFragment))")
//        }
//        
//        assert(secondBodyDescendants.length == bodyDescendants.length)
//        
//        var _sourceStringRegion = SourceStringRegion()
//        _sourceStringRegion.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 2, endIntegerIndex: 21))
//        XCTAssert((secondBodyDescendants[0]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion)
//        
//        XCTAssert(secondBodyDescendants[1]!.sourceStringFragment ==  nil)
//        XCTAssert(secondBodyDescendants[2]!.sourceStringFragment ==  nil)
//        
//        var _sourceStringRegion3 = SourceStringRegion()
//        _sourceStringRegion3.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 23, endIntegerIndex: 32))
//        XCTAssert((secondBodyDescendants[3]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion3)
//        
//        XCTAssert(secondBodyDescendants[4]!.sourceStringFragment ==  nil)
//        XCTAssert(secondBodyDescendants[5]!.sourceStringFragment ==  nil)
//        
//        var _sourceStringRegion6 = SourceStringRegion()
//        _sourceStringRegion6.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 44, endIntegerIndex: 62))
//        XCTAssert((secondBodyDescendants[6]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion6, "Received: \((secondBodyDescendants[6]!.sourceStringFragment! as! SourceStringRegion))")
//        
//        XCTAssert(secondBodyDescendants[7]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[7]! as! Text).data)
//        XCTAssert(secondBodyDescendants[8]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[8]! as! Text).data)
//        
//        var _sourceStringRegion9 = SourceStringRegion()
//        _sourceStringRegion9.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 65, endIntegerIndex: 74))
//        XCTAssert((secondBodyDescendants[9]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion9)
//        
//        XCTAssert(secondBodyDescendants[10]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[10]! as! Text).data)
//        XCTAssert(secondBodyDescendants[11]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[11]! as! Text).data)
//        
//        var _sourceStringRegion12 = SourceStringRegion()
//        _sourceStringRegion12.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 89, endIntegerIndex: 103))
//        XCTAssert((secondBodyDescendants[12]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion12)
//        
//        XCTAssert(secondBodyDescendants[13]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[13]! as! Text).data)
//        XCTAssert(secondBodyDescendants[14]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[14]! as! Text).data)
//        
//        var _sourceStringRegion15 = SourceStringRegion()
//        _sourceStringRegion15.addSourceStringSegment(SourceStringSegment(startIntegerIndex: 105, endIntegerIndex: 138))
//        XCTAssert((secondBodyDescendants[15]!.sourceStringFragment! as! SourceStringRegion) == _sourceStringRegion15)
//        
//        XCTAssert(secondBodyDescendants[16]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[16]! as! Text).data)
//        XCTAssert(secondBodyDescendants[17]!.sourceStringFragment ==  nil)
//        debugPrint((secondBodyDescendants[17]! as! Text).data)
//        
//    }
}
