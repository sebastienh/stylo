//
//  TextManager+HtmlRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-22.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import PromiseKit
import Igloo

extension TextManager: HtmlRenderable {
    
    public func renderPlainHtml() -> Promise<String?> {
        
        assert(self.textDocument != nil)
        if let textDocument = self.textDocument {
        
            // this method will be disptached as a read method.
            return textDocument.documentDispatcher.readAsync(store: markdownDocumentStore, in: markdownDocumentStore.serialCompilationQueue) { [weak self] () throws -> String? in
                
                if let _self = self, let markdownDocumentStore = self?.markdownDocumentStore {
                
                    return try _self._renderPlainHtml(markdownDocumentStore: markdownDocumentStore)
                }
                return nil
            }
        }
        else {
            
            return Promise<String?> { fulfill, reject in
                reject(NWError.custom(message: "textDocument is nil"))
            }
        }
    }
    
    public func renderBodyContentPlainHtml() -> Promise<String?> {
        
        assert(self.textDocument != nil)
        if let textDocument = self.textDocument {
            
            // this method will be disptached as a read method.
            return textDocument.documentDispatcher.readAsync(store: markdownDocumentStore, in: markdownDocumentStore.serialCompilationQueue) { [weak self] () throws -> String? in
                
                if let _self = self, let markdownDocumentStore = self?.markdownDocumentStore {
                    return try _self._renderBodyContentPlainHtml(markdownDocumentStore: markdownDocumentStore)
                }
                return nil
            }
        }
        else {
            
            return Promise<String?> { fulfill, reject in
                reject(NWError.custom(message: "textDocument is nil"))
            }
        }
    }
    
    public func renderHtml(htmlStyle: CSSStyle?) -> Promise<String?> {
        
        return Promise<String?> { fulfill, reject in
        
            assert(self.textDocument != nil)
            if let textDocument = self.textDocument {
            
                textDocument.documentDispatcher.async(store: markdownDocumentStore, closure: { () -> Promise<ActionResult?> in

                    return Promise<ActionResult?> { fulfill, reject in
                    
                        self.markdownDocumentStore.serialCompilationQueue.async(flags: .barrier) {
                            do {
                                let string = try self._renderHtml(htmlStyle: htmlStyle)
                                let actionResult = StylableActionResult.serializedDocumentString(string: string)
                                fulfill(actionResult)
                            }
                            catch let error {
                                
                                reject(NWError.custom(message: error.localizedDescription))
                            }
                        }
                    }
                }).then { result -> Void in
                    
                    if let stylableActionResult = result as? StylableActionResult {
                        fulfill(stylableActionResult.documentString)
                    }
                    fulfill(nil)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "document is nil"))
            }
        }
    }
    
    private func _renderPlainHtml(markdownDocumentStore: MarkdownDocumentStore) throws -> String {
        
        
        if let document = markdownDocumentStore.document.value {
        
            // we strip all added div to contain custom html block
            let domParsing = HTMLSerializer.createFlat()
            return domParsing.serializeHTMLFragment(document)
        }
        throw NWError.nilDocument
    }

    private func _renderBodyContentPlainHtml(markdownDocumentStore: MarkdownDocumentStore) throws -> String {
        
        if let document = markdownDocumentStore.document.value as? HtmlDocument {
            
            // we strip all added div to contain custom html block
            let domParsing = HTMLSerializer.createFlat()
            return domParsing.serializeHTMLFragment(document.body)
        }
        throw NWError.nilDocument
    }
    
    private func _renderHtml(htmlStyle: CSSStyle?) throws -> String {

        var exception = Exception()

        let styleString = htmlStyle?.serialize()

        if let document = self.editableStore.document.value as? HtmlDocument {

            // we may not have the styleStringContainer value in the
            // case we dont need any style applied e.g. plain text export.
            document.head!.removeChilds(with: "style", &exception)

            if let styleString = styleString {

                let style = HTMLStyleElement(document: document)
                let text = Text(document: document, data: styleString)
                style.appendChild(text, exception: &exception)

                if exception.isError() {
                    assert(false, " Exception: \(exception.code)")
                }

                document.head!.appendChild(style, exception: &exception)


                if exception.isError() {
                    assert(false, " Exception: \(exception.code)")
                }
            }

            let domParsing = HTMLSerializer.createFlat()
            let result = domParsing.serializeHTMLFragment(document)
            document.head!.removeChilds(with: "style", &exception)
            return result
        }

        throw NWError.nilDocument
    }
    
}
