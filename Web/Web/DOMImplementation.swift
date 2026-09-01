//
//  DOMImplementation.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// https://dom.spec.whatwg.org/#domimplementation
//interface DOMImplementation {
//    [NewObject] DocumentType createDocumentType(DOMString qualifiedName, DOMString publicId, DOMString systemId);
//    [NewObject] XMLDocument createDocument(DOMString? namespace, [TreatNullAs=EmptyString] DOMString qualifiedName, optional DocumentType? doctype = null);
//    [NewObject] Document createHTMLDocument(optional DOMString title);
//    
//    boolean hasFeature(); // useless; always returns true
//};

final class DOMImplementation {
    
    weak var document: Document?
    
    init(_ document: Document? = nil) {

        self.document = document
    }
    
    /// Returns a doctype, with the given qualifiedName, publicId, and systemId. 
    /// If qualifiedName does not match the Name production, an InvalidCharacterError exception is thrown, 
    /// and if it does not match the QName production, a NamespaceError exception is thrown.
    ///
    /// [NewObject] DocumentType createDocumentType(DOMString qualifiedName, DOMString publicId, DOMString systemId);
    /// see https://dom.spec.whatwg.org/#dom-domimplementation-createdocumenttype
    func createDocumentType(_ namespace: DOMString, qualifiedName: DOMString, publicId: DOMString,
        systemId: DOMString, exception: inout Exception) -> DocumentType {
        
        // 1. [Validate](https://dom.spec.whatwg.org/#validate) qualifiedName. 
        // Rethrow any exceptions.
        Namespace.validateQualifiedName(qualifiedName, exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("An exception occured : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
            assert(false, "An exception occured : \(exception).")
        }

        // 2. Return a new doctype, with 
        // qualifiedName as its name,
        // publicId as its public ID,
        // and systemId as its system ID, 
        // and with its node document set to the associated document of the context object.
        let documentType = DocumentType(document: document!, name: qualifiedName,
            publicId: publicId, systemId: systemId)
        
        return documentType
    }
    
    /// Returns an XMLDocument, with a document element whose local name is qualifiedName 
    /// and whose namespace is namespace (unless qualifiedName is the empty string), and with doctype, 
    /// if it is given, as its doctype.
    ///
    /// This method throws the same exceptions as the createElementNS method, when invoked with the same arguments.
    ///
    /// [NewObject] XMLDocument createDocument(DOMString? namespace, 
    ///     [TreatNullAs=EmptyString] DOMString qualifiedName, optional DocumentType? doctype = null);
    /// see https://dom.spec.whatwg.org/#dom-domimplementation-createdocument
    func createDocument(_ namespace: DOMString, qualifiedName: DOMString, doctype: DocumentType) -> XMLDocument {

        // FIXME: we don't need yet to implement this fucntion 
        // since we don't want to create XMLDocument 
        // Basically, XML document are not supported.
        fatalError("Missing implementation")
    }
    
    /// Returns a document, with a basic tree already constructed including a title element, 
    /// unless the title argument is omitted.
    ///
    /// [NewObject] Document createHTMLDocument(optional DOMString title);
    /// see https://dom.spec.whatwg.org/#dom-domimplementation-createhtmldocument
    class func createHTMLDocument(_ title: DOMString?, exception: inout Exception) -> HtmlDocument {

        // 1. Let doc be a new document that is an HTML document.
        let document = HtmlDocument()
        
        // 2. Set doc's content type to "text/html".
        document.contentType = §Language.HTML
        
        // 3. Create a doctype, with "html" as its name and with its node document set to doc. 
        // Append the newly created node to doc.
        let documentType = DocumentType(document: document, name: "html")
        document.append(documentType, exception: &exception)  
        
        // 4. Create an html element in the HTML namespace, 
        // and append it to doc.
        let htmlElement = HTMLHtmlElement(document: document)
        document.append(htmlElement, exception: &exception)
        document._documentElement = htmlElement
        
        // 5. Create a head element in the HTML namespace, 
        // and append it to the html element created in the previous step.
        let headElement = HTMLHeadElement(document: document)
        htmlElement.append(headElement, exception: &exception)
        document.head = headElement
        
        // 6. If the title argument is not omitted:
        if let title = title {
            
            // 1. Create a title element in the HTML namespace, and append it to the 
            // head element created in the previous step.
            let titleElement = HTMLTitleElement(document: document)
            headElement.append(titleElement, exception: &exception)
            
            // 2. Create a Text node, set its data to title (which could be the empty string), 
            // and append it to the title element created in the previous step.
            let textNode = Text(document: document, data: title)
            titleElement.append(textNode, exception: &exception)
        }
        
        // By default, we add the meta charset to utf-8
        let charsetMeta = HTMLMetaElement(document: document, charset: "utf-8")
        headElement.append(charsetMeta, exception: &exception)
        
        // 7. Create a body element in the HTML namespace, 
        // and append it to the html element created in the earlier step.
        let bodyElement = HTMLBodyElement(document: document)
        htmlElement.append(bodyElement, exception: &exception)
        document.body = bodyElement
        
        // 8. doc's origin is an alias to the origin of the context object's associated document, 
        // and doc's effective script origin is an alias to the effective script origin of 
        // the context object's associated document. [HTML]
        // FIXME: should handled the document origin. 
//        LogWarning("Missing implementation: HTML document origin is not handled in \(#function)")
        
        // 9. Return doc.
        return document
    }
    
    /// Must return true
    /// boolean hasFeature(); // useless; always returns true
    /// see https://dom.spec.whatwg.org/#dom-domimplementation-hasfeature
    func hasFeature() -> Bool {

        return true
    }
}

