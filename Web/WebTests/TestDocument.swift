//
//  TestDocument.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-08.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Cocoa
import XCTest
import Common
@testable import Web

class TestDocument: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    
    // Inteface to test :
    //interface Document : Node {
    //    [SameObject] readonly attribute DOMImplementation implementation;
    //    readonly attribute DOMString URL;
    //    readonly attribute DOMString documentURI;
    //    readonly attribute DOMString origin;
    //    readonly attribute DOMString compatMode;
    //    readonly attribute DOMString characterSet;
    //    readonly attribute DOMString contentType;
    //
    //    readonly attribute DocumentType? doctype;
    //    readonly attribute Element? documentElement;
    //    HTMLCollection getElementsByTagName(DOMString localName);
    //    HTMLCollection getElementsByTagNameNS(DOMString? namespace, DOMString localName);
    //    HTMLCollection getElementsByClassName(DOMString classNames);
    //
    //    [NewObject] Element createElement(DOMString localName);
    //    [NewObject] Element createElementNS(DOMString? namespace, DOMString qualifiedName);
    //    [NewObject] DocumentFragment createDocumentFragment();
    //    [NewObject] Text createTextNode(DOMString data);
    //    [NewObject] Comment createComment(DOMString data);
    //    [NewObject] ProcessingInstruction createProcessingInstruction(DOMString target, DOMString data);
    //
    //    Node importNode(Node node, optional boolean deep = false);
    //    Node adoptNode(Node node);
    //
    //    [NewObject] Attr createAttribute(DOMString localName);
    //    [NewObject] Attr createAttributeNS(DOMString? namespace, DOMString name);
    //
    //    [NewObject] Event createEvent(DOMString interface);
    //
    //    [NewObject] Range createRange();
    //
    //    // NodeFilter.SHOW_ALL = 0xFFFFFFFF
    //    [NewObject] NodeIterator createNodeIterator(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
    //    [NewObject] TreeWalker createTreeWalker(Node root, optional unsigned long whatToShow = 0xFFFFFFFF, optional NodeFilter? filter = null);
    //};
    
    
    func testDocumentCreation() {

        let document = Document()
        
        XCTAssert(document.nodeType == NodeType.document_node, "Expected Document nodeType being NodeType.DOCUMENT_NODE")
        XCTAssert(document.document == document, "Document document should be document")
    }

    func testBasicHTMLDocumentCreation() {
        
            
        // 1. Let doc be a new document that is an HTML document.
        let document = Document()
        
        var exception = Exception()
        
        // 2. Set doc's content type to "text/html".
        document.contentType = §Language.HTML
        
        // 3. Create a doctype, with "html" as its name and with its node document set to doc.
        // Append the newly created node to doc.
        let documentType = DocumentType(document: document, name: "html")
        document.append(documentType, exception: &exception)
        
        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
        
        // 4. Create an html element in the HTML namespace,
        // and append it to doc.
        let htmlElement = Element(document: document, localName: "html")
        document.append(htmlElement, exception: &exception)
        
        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
        
        // 5. Create a head element in the HTML namespace,
        // and append it to the html element created in the previous step.
        let headElement = Element(document: document, localName: "head")
        htmlElement.append(headElement, exception: &exception)
        
        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
        
        // 1. Create a title element in the HTML namespace, and append it to the
        // head element created in the previous step.
        let titleElement = Element(document: document, localName: "title")
        headElement.append(titleElement, exception: &exception)
        
        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
        
        // 2. Create a Text node, set its data to title (which could be the empty string),
        // and append it to the title element created in the previous step.
        let textNode = Text(document: document, data: "title")
        titleElement.append(textNode, exception: &exception)
        
        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
        
        // 7. Create a body element in the HTML namespace,
        // and append it to the html element created in the earlier step.
        let bodyElement = Element(document: document, localName: "body")
        htmlElement.append(bodyElement, exception: &exception)

        XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")

    }
    
    func testDocumentCreationFromDOMImplementation() {
        
        
        let document = Document()
        
        if let implementation = document.implementation {
            
            var exception = Exception()
            
            let htmlDocument = DOMImplementation.createHTMLDocument("Test Title", exception: &exception)
            
            XCTAssert(exception.code == ExceptionCode.noError, "Exception is \(exception.code)")
            
            
            
        }
        else {
            XCTAssert(false, "document.implementation is nil.")
        }
    }
    
    
}
