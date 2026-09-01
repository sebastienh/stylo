//
//  MarkdownStylingDocumentStoreTests.swift
//  WriterCommonTests
//
//  Created by Sebastien hamel on 2019-02-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

let red = NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 1)
let yellow = NSColor(deviceRed: 1, green: 1, blue: 0, alpha: 1)
let green = NSColor(deviceRed: 0, green: 128/255, blue: 0, alpha: 1)
let pink = NSColor(deviceRed: 1, green: 192/255, blue: 203/255, alpha: 1)
let blue = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 1)
let black = NSColor(deviceRed: 0, green: 0, blue: 0, alpha: 1)
let white = NSColor(deviceRed: 1, green: 1, blue: 1, alpha: 1)
let orange = NSColor(deviceRed: 1, green: 165/255, blue: 0, alpha: 1)
let purple = NSColor(deviceRed: 128/255, green: 0, blue: 128/255, alpha: 1)

class MarkdownStylingDocumentStoreTests: MarkdownDocumentStoreTests {

    enum Result {
        
        case success
        case error(color: NSColor)
    }
    
    func computeAttributes(markdownFileName: String, styleFilename: String) -> NSAttributedString {
        
        return computeAttributesInMarkdownStyleStore(markdownFileName: markdownFileName, styleFilename: styleFilename).1.attributesStore.attributedString
    }
    
    func computeAttributesInMarkdownStyleStore(markdownFileName: String, styleFilename: String) -> (MarkdownDocumentStore, MarkdownStyleStore) {
        
        let url = urlOfFile(named: markdownFileName)
        let sourceString = try! String(contentsOf: url!, encoding: String.Encoding.utf8)
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(uaStylesheetFilename: "markdown-ua.css", authorStylesheetFilename: styleFilename)
        
        let markdownStyleStore = compileMarkdown(fromSourceString: sourceString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        
        
        return (markdownDocumentStore, markdownStyleStore!)
    }
    
}
