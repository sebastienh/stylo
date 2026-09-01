//
//  EditorUndoCommandTests.swift
//  WriterCommonTests
//
//  Created by Sebastien Hamel on 2020-11-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
import Web
import Igloo
@testable import WriterCommon
import Common

class EditorUndoCommandTests: WriterCommonTests {

    private let editorId = UUID().uuidString
    
    private var undoManager: StyloUndoManager? {
        return self.textManager?.undoManager as? StyloUndoManager
    }
    
    private var textManager: TestTextManager?
    
    private var textStorage: NSTextStorage?
    
    private var sourceStringAttributesRenderer: SourceStringAttributesRenderer?
    
    var testUserAgentStylesheetDocumentStore: StylesheetDocumentStore {
    
        let store = StylesheetDocumentStore(origin: .userAgent, appearances: [.dark, .light])
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
    
    
    func testPureRemoval() throws {
        
        let source = "test"
        let destination = SourceStringChangeDescription(range: NSMakeRange(0, 4), stringReplacement: "", changeLength: -4, targetString: "")
        let undoChange = SourceStringChangeDescription(range: NSMakeRange(0, 0), stringReplacement: "test", changeLength: 4, targetString: "test")
        
        
        let command = EditorUndoCommand(sourceString: source, destinationChange: destination, editable: self.textManager!, editorId: self.editorId)
        
        XCTAssert(destination.changeType == .pureRemoval)
        
        XCTAssert(command.undoChange! == undoChange, "Expected: \(undoChange), received: \(command.undoChange!)")
        XCTAssert(command.redoChange == destination)
    }
    
    func testPureAddition() throws {
        
        let source = "test"
        let destination = SourceStringChangeDescription(range: NSMakeRange(4, 0), stringReplacement: "test", changeLength: 4, targetString: "testtest")
        let undoChange = SourceStringChangeDescription(range: NSMakeRange(4, 4), stringReplacement: "", changeLength: -4, targetString: "test")
        
        
        let command = EditorUndoCommand(sourceString: source, destinationChange: destination, editable: self.textManager!, editorId: self.editorId)
        
        XCTAssert(destination.changeType == .pureAddition)
        
        XCTAssert(command.undoChange! == undoChange, "Expected: \(undoChange), received: \(command.undoChange!)")
        XCTAssert(command.redoChange == destination)
    }
    
    func testPureReplace() throws {
        
        let source = "test"
        let destination = SourceStringChangeDescription(range: NSMakeRange(0, 4), stringReplacement: "1234", changeLength: 0, targetString: "1234")
        let undoChange = SourceStringChangeDescription(range: NSMakeRange(0, 4), stringReplacement: "test", changeLength: 0, targetString: "test")
        
        
        let command = EditorUndoCommand(sourceString: source, destinationChange: destination, editable: self.textManager!, editorId: self.editorId)
        
        XCTAssert(destination.changeType == .pureReplace)
        
        XCTAssert(command.undoChange! == undoChange, "Expected: \(undoChange), received: \(command.undoChange!)")
        XCTAssert(command.redoChange == destination)
    }
    
    func testReplaceAddition() throws {
        
        let source = "test"
        let destination = SourceStringChangeDescription(range: NSMakeRange(2, 2), stringReplacement: "1234", changeLength: 2, targetString: "te1234")
        let undoChange = SourceStringChangeDescription(range: NSMakeRange(2, 4), stringReplacement: "st", changeLength: -2, targetString: "test")
        
        
        let command = EditorUndoCommand(sourceString: source, destinationChange: destination, editable: self.textManager!, editorId: self.editorId)
        
        XCTAssert(destination.changeType == .replaceAddition, "Received: \(destination.changeType)")
        
        XCTAssert(command.undoChange! == undoChange, "Expected: \(undoChange), received: \(command.undoChange!)")
        XCTAssert(command.redoChange == destination)
    }
    
    func testReplaceRemoval() throws {
        
        let source = "test"
        let destination = SourceStringChangeDescription(range: NSMakeRange(2, 2), stringReplacement: "t", changeLength: -1, targetString: "tet")
        let undoChange = SourceStringChangeDescription(range: NSMakeRange(2, 1), stringReplacement: "st", changeLength: 1, targetString: "test")
        
        
        let command = EditorUndoCommand(sourceString: source, destinationChange: destination, editable: self.textManager!, editorId: self.editorId)
        
        XCTAssert(destination.changeType == .replaceRemoval, "Received: \(destination.changeType)")
        
        XCTAssert(command.undoChange! == undoChange, "Expected: \(undoChange), received: \(command.undoChange!)")
        XCTAssert(command.redoChange == destination)
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
