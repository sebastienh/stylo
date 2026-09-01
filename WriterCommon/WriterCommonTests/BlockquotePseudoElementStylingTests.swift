//
//  BlockquotePseudoElementStylingTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-07-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest

class BlockquotePseudoElementStylingTests: MarkdownStylingDocumentStoreTests {

    // {.highlight}
    // > bloc text
    func testBlockquote1() {
        
        var markdownString = "{.highlight}\n"
        markdownString += "> bloc text"
        
        let styleString = """
            body {
                color: red;
            }
            
            blockquote.highlight::tag {
                color: blue;
            }
        """
        
        let compiledAttributes = self.computeAttributes(markdownString: markdownString, styleString: styleString)
        
        debugPrint("compiledAttributes: \(compiledAttributes)")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 13, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }

    // {.highlight}
    // > bloc **text**
    func testBlockquote2() {
        
        var markdownString = "{.highlight}\n"
        markdownString += "> bloc **text**"
        
        let styleString = """
            body {
                color: red;
            }
            
            blockquote.highlight::tag {
                color: blue;
            }

            blockquote.highlight strong::tag {
                color: blue;
            }
        """
        
        let compiledAttributes = self.computeAttributes(markdownString: markdownString, styleString: styleString)
        
        debugPrint("compiledAttributes: \(compiledAttributes)")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 20, expected: blue)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
                  
    // {.highlight}
    // > bloc **text**
    func testBlockquote3() {
        
        var markdownString = "\n"
        markdownString += "{.achilles  .eros}\n"
        markdownString += "> First Chaos came to be, but next... Earth... and dim Tartarus in the depth of the... Earth, and Eros...\n"
        
        let styleString = """
            body {
            background-color:  #002129;
            color:  rgb(147,154,154);

            }

            .achilles, .chaos, .eros, .focus, .hearth, .heaven, .hesiod, .nereid, .nyx, .peleus, .thetis {
            color:  #2aa198;

            }

            .achilles strong::tag, .chaos strong::tag, .eros strong::tag, .focus strong::tag, .hearth strong::tag, .heaven strong::tag, .hesiod strong::tag, .nereid strong::tag, .nyx strong::tag, .peleus strong::tag, .thetis strong::tag, .achilles emphasis::tag, .chaos emphasis::tag, .eros emphasis::tag, .focus emphasis::tag, .hearth emphasis::tag, .heaven emphasis::tag, .hesiod emphasis::tag, .nereid emphasis::tag, .nyx emphasis::tag, .peleus emphasis::tag, .thetis emphasis::tag {
            color:  #2aa198;

            }

            .achilles+strong::tag, .chaos+strong::tag, .eros+strong::tag, .focus+strong::tag, .hearth+strong::tag, .heaven+strong::tag, .hesiod+strong::tag, .nereid+strong::tag, .nyx+strong::tag, .peleus+strong::tag, .thetis+strong::tag {
            color:  #2aa198;

            }

            h1.achilles::tag, h1.chaos::tag, h1.eros::tag, h1.focus::tag, h1.hearth::tag, h1.heaven::tag, h1.hesiod::tag, h1.nereid::tag, h1.nyx::tag, h1.peleus::tag, h1.thetis::tag {
            color:  yellow;

            }

            h2.achilles::tag, h2.chaos::tag, h2.eros::tag, h2.focus::tag, h2.hearth::tag, h2.heaven::tag, h2.hesiod::tag, h2.nereid::tag, h2.nyx::tag, h2.peleus::tag, h2.thetis::tag {
            color:  red;

            }

            blockquote.achilles::tag, blockquote.chaos::tag, blockquote.eros::tag, blockquote.focus::tag, blockquote.hearth::tag, blockquote.heaven::tag, blockquote.hesiod::tag, blockquote.nereid::tag, blockquote.nyx::tag, blockquote.peleus::tag, blockquote.thetis::tag {
            color:  pink
            ;

            }

            code.achilles::tag, code.chaos::tag, code.eros::tag, code.focus::tag, code.hearth::tag, code.heaven::tag, code.hesiod::tag, code.nereid::tag, code.nyx::tag, code.peleus::tag, code.thetis::tag {
            color:  pink
            ;

            }
        """
        
        let compiledAttributes = self.computeAttributes(markdownString: markdownString, styleString: styleString)
        
        debugPrint("compiledAttributes: \(compiledAttributes)")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 20, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
        
    }
    
    
    // {.highlight}
    // > bloc **text**
    func testBlockquote4() {
        
        var markdownString = "{.achilles  .eros}\n"
        markdownString += "> First Chaos came to be, but next... Earth... and dim Tartarus in the depth of the... Earth, and Eros..."
        
        let styleString = """
            body {
            background-color:  #002129;
            color:  rgb(147,154,154);

            }

            .achilles, .chaos, .eros, .focus, .hearth, .heaven, .hesiod, .nereid, .nyx, .peleus, .thetis {
            color:  #2aa198;

            }

            .achilles strong::tag, .chaos strong::tag, .eros strong::tag, .focus strong::tag, .hearth strong::tag, .heaven strong::tag, .hesiod strong::tag, .nereid strong::tag, .nyx strong::tag, .peleus strong::tag, .thetis strong::tag, .achilles emphasis::tag, .chaos emphasis::tag, .eros emphasis::tag, .focus emphasis::tag, .hearth emphasis::tag, .heaven emphasis::tag, .hesiod emphasis::tag, .nereid emphasis::tag, .nyx emphasis::tag, .peleus emphasis::tag, .thetis emphasis::tag {
            color:  #2aa198;

            }

            .achilles+strong::tag, .chaos+strong::tag, .eros+strong::tag, .focus+strong::tag, .hearth+strong::tag, .heaven+strong::tag, .hesiod+strong::tag, .nereid+strong::tag, .nyx+strong::tag, .peleus+strong::tag, .thetis+strong::tag {
            color:  #2aa198;

            }

            h1.achilles::tag, h1.chaos::tag, h1.eros::tag, h1.focus::tag, h1.hearth::tag, h1.heaven::tag, h1.hesiod::tag, h1.nereid::tag, h1.nyx::tag, h1.peleus::tag, h1.thetis::tag {
            color:  yellow;

            }

            h2.achilles::tag, h2.chaos::tag, h2.eros::tag, h2.focus::tag, h2.hearth::tag, h2.heaven::tag, h2.hesiod::tag, h2.nereid::tag, h2.nyx::tag, h2.peleus::tag, h2.thetis::tag {
            color:  red;

            }

            blockquote.achilles::tag, blockquote.chaos::tag, blockquote.eros::tag, blockquote.focus::tag, blockquote.hearth::tag, blockquote.heaven::tag, blockquote.hesiod::tag, blockquote.nereid::tag, blockquote.nyx::tag, blockquote.peleus::tag, blockquote.thetis::tag {
            color:  pink
            ;

            }

            code.achilles::tag, code.chaos::tag, code.eros::tag, code.focus::tag, code.hearth::tag, code.heaven::tag, code.hesiod::tag, code.nereid::tag, code.nyx::tag, code.peleus::tag, code.thetis::tag {
            color:  pink
            ;

            }
        """
        
        let compiledAttributes = self.computeAttributes(markdownString: markdownString, styleString: styleString)
        
        debugPrint("compiledAttributes: \(compiledAttributes)")
        
        let result = WriterCommonTests.validateColor(in: compiledAttributes, at: 19, expected: pink)
        
        switch result {
        case .error(let receivedColor):
            XCTAssert(false, "Received: \(receivedColor)")
        case .success:
            XCTAssert(true)
        }
    }
    
    func computeAttributes(markdownString: String, styleString: String) -> NSAttributedString {
        
        let dispatcher = createDispatcher()
        let markdownDocumentStore = createMarkdownDocumentStore()
        dispatcher.register(store: markdownDocumentStore)
        
        let style = createStyle(authorStylesheetString: styleString)
        
        let markdownStyleStore = compileMarkdown(fromSourceString: markdownString, in: markdownDocumentStore, dispatcher: dispatcher, with: style)
        
        //////////////////////////////////////////////////////////////////
        ///////////////// compare the Attributes /////////////////////////
        //////////////////////////////////////////////////////////////////
        
        return markdownStyleStore!.attributesStore.attributedString
    }
    
}
