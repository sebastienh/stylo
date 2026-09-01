//
//  Editable+EditTests_UndoRedo.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-11-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Common
import Web
import Igloo
@testable import WriterCommon

class Editable_EditTests_UndoRedo: WriterCommonTests {
    
    private let editorId = UUID().uuidString
    
    private var undoManager: StyloUndoManager? {
        return self.textManager?.undoManager as? StyloUndoManager
    }
    
    private var textManager: TestTextManager?
    
    private var textStorage: NSTextStorage?
    
    private var sourceStringAttributesRenderer: SourceStringAttributesRenderer?
    
    var testUserAgentStylesheetDocumentStore: StylesheetDocumentStore {
    
        let store = StylesheetDocumentStore(origin: .userAgent, appearances: [.dark])
        store.stylesheet.setValue(CSSStyleSheet(origin: .userAgent))
        return store
    }
    
    var testDocumentState: DocumentState {
        
        return DocumentState()
    }
    
    var testStyloDocumentDispatcher: Dispatcher {
        
        return StyloDocumentDispatcher(state: testDocumentState)
    }
    
    var testStyleManager: StyleManager {
        
        let styleManager: StyleManager = StyleManager(title: "test", id: "test", order: 0, userAgentStyleSheetDocumentStore: testUserAgentStylesheetDocumentStore, dispatcher: testStyloDocumentDispatcher, editedStyleLanguage: .CSS, styleManagerType: .style)
        
        styleManager.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: .textDarkStyleAssemblyDescriptor)
        return styleManager
    }
    
    override func setUpWithError() throws {
        
        try self.setupTextManager()
        try self.registerEditor()
        
        XCTAssert(self.textManager != nil, "Error: self.textManager is nil")
        XCTAssert(self.undoManager != nil, "Error: self.undoManager is nil")
        XCTAssert(self.textStorage != nil, "Error: self.textStorage is nil")
        XCTAssert(self.sourceStringAttributesRenderer != nil, "Error: self.sourceStringAttributesRenderer is nil")
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBasicUndo() throws {
    
        let change = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: "a")
        self.update(withChange: change)
        assert(self.textStorage!.string == "a")
        undoManager!.undo()
        assert(self.textStorage!.string == "", "Received: \"\(self.textStorage!.string)\"")
    }

    func testBasicUndoMutlipleCharactersDeletion() throws {
    
        var source = "\n"
        source += "This is a sentence\n"
        source += "This is a sentence\n"
        source += "This is a sentence\n"
        source += "This is a sentence\n"
        
        let change = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: source)
        self.update(withChange: change)
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == source, "Received: \"\(self.textStorage!.string)\"")
        
        
        let change2 = StringChange(affectedRange: NSMakeRange(11, 8), replacementString: "")
        self.update(withChange: change2)
        
        var sourceAfterChange = "\n"
        sourceAfterChange += "This is a \n"
        sourceAfterChange += "This is a sentence\n"
        sourceAfterChange += "This is a sentence\n"
        sourceAfterChange += "This is a sentence\n"
        
        undoManager!.undo()
        XCTAssert(self.textStorage!.string == source, "Received: \"\(self.textStorage!.string)\"")
        XCTAssert(undoManager!.redoStack.top != nil)
        
        
        print("\(undoManager!.redoStack.top)")
        undoManager!.redo()
        
        print("sourceAfterChange: \"\(sourceAfterChange)\"")
        XCTAssert(self.textStorage!.string == sourceAfterChange, "Expected: \"\(sourceAfterChange)\", received: \"\(self.textStorage!.string)\"")
    }
    
    
    func testBasicUndo2() throws {
    
        let change = StringChange(affectedRange: NSMakeRange(0, 0), replacementString: "a")
        self.update(withChange: change)
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == "a")
        self.update(withChange: change)
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == "aa")
        self.update(withChange: change)
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == "aaa")
        
        
        let change2 = StringChange(affectedRange: NSMakeRange(3, 0), replacementString: " ")
        self.update(withChange: change2)
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == "aaa ")
        undoManager!.undo()
        print("textstorage: \(self.textStorage!.string)")
        XCTAssert(self.textStorage!.string == "aaa", "Received: \"\(self.textStorage!.string)\"")
    }

    func testUndoError() throws {
    
        update(range: NSMakeRange(0, 0), withString: "\n{.test}\n# rsrrr \n\n\n## this this is something\n")
        update(range: NSMakeRange(19, 0), withString: "{")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{\n## this this is something\n")
        
        //  pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional("}")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(20, 0), withString: "}")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{}\n## this this is something\n")
        
        //  pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional(".")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(20, 0), withString: ".")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {21, 0}, changeLength: 1, stringReplacement: Optional("t")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(21, 0), withString: "t")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.t}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {22, 0}, changeLength: 1, stringReplacement: Optional("e")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(22, 0), withString: "e")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.te}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {23, 0}, changeLength: 1, stringReplacement: Optional("s")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(23, 0), withString: "s")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.tes}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {24, 0}, changeLength: 1, stringReplacement: Optional("t")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(24, 0), withString: "t")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.test}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {23, 0}, changeLength: 1, stringReplacement: Optional("s")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.tes}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {22, 0}, changeLength: 1, stringReplacement: Optional("e")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.te}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {21, 0}, changeLength: 1, stringReplacement: Optional("t")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.t}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional(".")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.}\n## this this is something\n")
    
        //  changeType: pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional("}")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{}\n## this this is something\n")
        
        //  changeType: pureAddition, range: {19, 0}, changeLength: 1, stringReplacement: Optional("{")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{\n## this this is something\n")
        
        //  changeType: replaceAddition, range: {0, 46}, changeLength: 46, stringReplacement: Optional("\n{.test}\n# rsrrr \n\n\n## this this is something\n")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n\n## this this is something\n")
        
        //  changeType: pureAddition, range: {19, 0}, changeLength: 1, stringReplacement: Optional("{")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(19, 0), withString: "{")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {20, 0}, changeLength: 1, stringReplacement: Optional(".")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(20, 0), withString: ".")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {21, 0}, changeLength: 1, stringReplacement: Optional("t")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(21, 0), withString: "t")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.t\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {22, 0}, changeLength: 1, stringReplacement: Optional("e")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(22, 0), withString: "e")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.te\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {23, 0}, changeLength: 1, stringReplacement: Optional("s")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(23, 0), withString: "s")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.tes\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {24, 0}, changeLength: 1, stringReplacement: Optional("t")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(24, 0), withString: "t")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.test\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {25, 0}, changeLength: 1, stringReplacement: Optional("}")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(25, 0), withString: "}")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.test}\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureRemoval, range: {19, 7}, changeLength: -7, stringReplacement: Optional("")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        update(range: NSMakeRange(19, 7), withString: "")
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureAddition, range: {25, 0}, changeLength: 1, stringReplacement: Optional("}")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.test}\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureRemoval, range: {19, 7}, changeLength: -7, stringReplacement: Optional("")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.redo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n\n## this this is something\n", "Received: \(self.textStorage!.string)")
        
        //  changeType: pureRemoval, range: {19, 7}, changeLength: -7, stringReplacement: Optional("")., forEditorWithId: 0E56C727-714C-4C0D-95A6-0603FC193F2D, withUndoManager: Optional(<NSUndoManager: 0x6000063b6cb0>))
        undoManager?.undo()
        XCTAssert(self.textStorage!.string == "\n{.test}\n# rsrrr \n\n{.test}\n## this this is something\n", "Received: \(self.textStorage!.string)")
    }
    
    private func update(range: NSRange, withString string: String) {
        
        let change = StringChange(affectedRange: range, replacementString: string)
        self.update(withChange: change)
    }
    
    private func update(withChange stringChange: StringChange) {
        
        guard let changeDescription = self.sourceStringChangeDescription(fromSourceString: self.textStorage!.string, stringChange: stringChange) else {
            
            XCTAssert(false, "Error: changeDescription is nil")
            return
        }
        
        textStorage!.update(withSourceStringChangeDescription: changeDescription)
        let notification = Notification(name: NSNotification.Name(rawValue: "test"), object: self.sourceStringAttributesRenderer!)
        self.textManager!.textViewDidChange(notification)
    }
    
    
    func setupTextManager(withString string: String = "") throws  {
        
        self.textManager = TestTextManager()
        textManager!.setText(string: string)
        textManager!.compileInitialDocument()
        textManager!.styleManager.setValue(self.testStyleManager)
    }
    
    func registerEditor() throws {
        
        self.textStorage = textManager!.textStorage(forEditorWithId: editorId)
        self.sourceStringAttributesRenderer = SourceStringAttributesRendererMock(textStorage: textStorage!, id: editorId)
        try textManager!.registerEditor(withRenderer: sourceStringAttributesRenderer!)
    }
    
    func sourceStringChangeDescription(fromSourceString string: String, stringChange: StringChange) -> SourceStringChangeDescription? {
        
        var string = string
        let changeLength = stringChange.replacementString.utf16.count - stringChange.affectedRange.length
        let range = stringChange.affectedRange
        let replacementString = stringChange.replacementString
        
        let startRangeIndex = string.utf16.index(string.utf16.startIndex, offsetBy: range.lowerBound)
        let endRangeIndex = string.utf16.index(string.utf16.startIndex, offsetBy: range.upperBound)
        if string.startIndex <= startRangeIndex && endRangeIndex <= string.endIndex {
            string.replaceSubrange(startRangeIndex..<endRangeIndex, with: replacementString)
            
            return SourceStringChangeDescription(range: stringChange.affectedRange, stringReplacement: replacementString, changeLength: changeLength, targetString: string)
        }
        return nil
    }
    
}
