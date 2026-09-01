//
//  MarkdownDomPostProcessor.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-28.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

final class MarkdownDomPostProcessor: HtmlDomVisitor {
    
    typealias NodeInfoType = MarkdownDomPostProcessorNodeInfo
    
    var parentStack: Stack<MarkdownDomPostProcessorNodeInfo>
    
    let htmlDocument: HtmlDocument
    
    var success: Bool = true
    
    ///
    /// We keep a local refrence to the original html document
    /// just for not loosing the reference over it while copying
    /// it.
    ///
    let originalHtmlDocument: HtmlDocument
    
    ///
    /// The source string from which we extracted this HtmlDocument.
    /// Used for string extracting since this should not have been done 
    /// so far.
    ///
    let src: String
    
    init(src: String, originalHtmlDocument: HtmlDocument) {
        
        self.parentStack = Stack<MarkdownDomPostProcessorNodeInfo>()
        self.htmlDocument = HtmlDocument.Create()!
        self.originalHtmlDocument = originalHtmlDocument
        self.src = src
    }
    
    func process() -> HtmlDocument {
        
        originalHtmlDocument.accept(self)
        return htmlDocument
    }
    
    func pop() {
        parentStack.pop()
    }
    
    func push(_ nodeInfo: MarkdownDomPostProcessorNodeInfo) {
        
        parentStack.push(nodeInfo)
    }
    
    fileprivate func top() -> MarkdownDomPostProcessorNodeInfo! {
        
        return parentStack.top
    }
    
    func visit(_ node: HtmlDocument) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        debugPrint("Visiting node: html document")
        
        // nohing to do on the document itself.
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
    func visit(_ node: HTMLPreElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        var exception = Exception()
        
        if let firstChild = node.firstChild , firstChild == node.lastChild! {
            
            if let codeElement = firstChild as? Element , codeElement.localName == "code" {
                
                var data = "<pre><code"
                
                if codeElement.classList.length != 0 {
                    
                    data += " class=\""
                    
                    for (index, classValue) in codeElement.classList.enumerated() {
                        
                        if index != 0 {
                            
                            data += " "
                        }
                        data += classValue
                    }
                    
                    data += "\">"
                }
                else {
                    
                    data += ">"
                }
                
                for child in codeElement.childNodes! {
                    
                    if let textElement = child as? Text {
                        
                        data += textElement.data
                    }
                }
                
                data += "</code></pre>"
                
                let preservedText = PreservedText(document: htmlDocument, data: data)
                
                assert(top().element != nil)
                top().element?.appendChild(preservedText, exception: &exception)
                
                return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: false)
            }
        }
        else {
            
            let preElement = HTMLPreElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(preElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: preElement)
        }
        
        return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: false)
    }
    
    func visit(_ node: HTMLElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        var exception = Exception()
        
        switch node {

        case let origBlockQuote as HTMLQuoteElement:
            
            let blockQuote = HTMLQuoteElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(blockQuote, exception: &exception)
            
            if origBlockQuote.childNodes!.length == 0 {

                // since there is no text node generated for this one we create one
                let text = Text(document: htmlDocument, data: "\n")
                    
                blockQuote.appendChild(text, exception: &exception)
            }
            
            return MarkdownDomPostProcessorNodeInfo(element: blockQuote)
            
        case _ as HTMLHRElement:
            
            let hrElement = HTMLHRElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(hrElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: hrElement)
            
        case _ as HTMLUListElement:
            
            let ulListElementCopy = HTMLUListElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(ulListElementCopy, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: ulListElementCopy)
            
        case _ as HTMLBRElement:
        
            let br = HTMLBRElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(br, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: br)
            
        case let origImageElement as HTMLImageElement:
            
            let image = HTMLImageElement(document: htmlDocument)
            
            image.src = origImageElement.src
            image.alt = origImageElement.alt
            
            if let src = origImageElement.getAttribute("src") {
                
                image.setAttribute("src", value: escapeHtml(src), exception: &exception)
            }
            
            if let alt = origImageElement.getAttribute("alt") {
                
                image.setAttribute("alt", value: escapeHtml(alt), exception: &exception)
            }
//
//            if let altRegion = origImageElement.altRegion {
//                
//                if let altText = src.stringFromRegion(altRegion) {
//                
//                    image.setAttribute("alt", value: escapeHtml(altText), exception: &exception)
//                }
//            }
            
            if let title = origImageElement.getAttribute("title") {
                
                image.setAttribute("title", value: escapeHtml(title), exception: &exception)
            }
            
            assert(top().element != nil)
            top().element?.appendChild(image, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: image)
            
        case let headingElement as HTMLHeadingElement:
            
            let headingElement = HTMLHeadingElement(document: htmlDocument, localName: headingElement.localName)
            
            assert(top().element != nil)
            top().element?.appendChild(headingElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: headingElement)
            
        case let origAnchorElement as HTMLAnchorElement:
            
            let link = HTMLAnchorElement(document: htmlDocument)
            
            link.href = origAnchorElement.href
            link.text = origAnchorElement.text
            
            if let href = origAnchorElement.getAttribute("href") {
                
                link.setAttribute("href", value: escapeHtml(href), exception: &exception)
            }
            
            if let title = origAnchorElement.getAttribute("title") {
                
                link.setAttribute("title", value: escapeHtml(title), exception: &exception)
            }
            
            assert(top().element != nil)
            top().element?.appendChild(link, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: link)
            
        case _ as HTMLLIElement:
            
            let listItemElement = HTMLLIElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(listItemElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: listItemElement)
            
        
        case let origOrderedListElement as HTMLOListElement:
            
            let olListElement = HTMLOListElement(document: htmlDocument)
            
            if let start = origOrderedListElement.getAttribute("start") {
                
                olListElement.setAttribute("start", value: escapeHtml(start), exception: &exception)
            }
            
            assert(top().element != nil)
            top().element?.appendChild(olListElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: olListElement)
        
        case _ as HTMLParagraphElement:
            
            let paragraphElement = HTMLParagraphElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(paragraphElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: paragraphElement)
            
        case _ as HTMLTableElement:
            
            let tableOpenElement = HTMLTableElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(tableOpenElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableOpenElement)
            
        case _ as HTMLTableSectionElement:
            
            let tableSectionElement = HTMLTableSectionElement(document: htmlDocument, type: TableSectionType.TBody)
            
            assert(top().element != nil)
            top().element?.appendChild(tableSectionElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableSectionElement)
            
        case _ as HTMLTableDataCellElement:
            
            let tableDataCellElement = HTMLTableDataCellElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(tableDataCellElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableDataCellElement)
            
        case _ as HTMLTableHeaderCellElement:
            
            let tableHeaderCellElement = HTMLTableHeaderCellElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(tableHeaderCellElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableHeaderCellElement)
            
        case _ as HTMLTableSectionElement:
            
            let tableSectionElement = HTMLTableSectionElement(document: htmlDocument, type: TableSectionType.THead)
            
            assert(top().element != nil)
            top().element?.appendChild(tableSectionElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableSectionElement)
           
        case _ as HTMLTableHeaderCellElement:
            
            let tableHeaderCellElement = HTMLTableHeaderCellElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(tableHeaderCellElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableHeaderCellElement)
            
        case _ as HTMLTableRowElement:
            
            let tableRowElement = HTMLTableRowElement(document: htmlDocument)
            
            assert(top().element != nil)
            top().element?.appendChild(tableRowElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: tableRowElement)
            
        default:
            
            // we are in front of an inline code element
            if node.localName == "code" {
                
                #if DEBUG
                assert(node.parentElement!.localName != "pre")
                #endif 
                    
                let textElement = node.firstChild! as! Text
                
                let data = "<code>\(textElement.data)</code>";
                
                let preservedText = PreservedText(document: htmlDocument, data: data)
                
                assert(top().element != nil)
                top().element?.appendChild(preservedText, exception: &exception)
                
                return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: false)
            }
            else if node.localName == "em" {
                
                let emOpen = HTMLElement(document: htmlDocument, localName: "em")
            
                assert(top().element != nil)
                top().element?.appendChild(emOpen, exception: &exception)
                
                return MarkdownDomPostProcessorNodeInfo(element: emOpen)
            }
            else if node.localName == "s" {
                
                let strikethrougElement = HTMLElement(document: htmlDocument, localName: "s")
                
                assert(top().element != nil)
                top().element?.appendChild(strikethrougElement, exception: &exception)
                
                return MarkdownDomPostProcessorNodeInfo(element: strikethrougElement)
            }
            else if node.localName == "strong" {
                
                let strongElement = HTMLElement(document: htmlDocument, localName: "strong")
                
                assert(top().element != nil)
                top().element?.appendChild(strongElement, exception: &exception)
                
                return MarkdownDomPostProcessorNodeInfo(element: strongElement)
            }
        }
        
        #if DEBUG
            fatalError("Returning ")
        #endif
        
        return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: false)
    }
    
    func visit(_ node: PseudoElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: false)
    }
    
    func visit(_ node: Text) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        var exception = Exception()
        
        let text = Text(document: htmlDocument, data: node.data)
        
        assert(top().element != nil)
        top().element?.appendChild(text, exception: &exception)
        
        return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: true)
    }
    
    func visit(_ node: PreservedText) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        var exception = Exception()
        
        let text = PreservedText(document: htmlDocument, data: node.data)
        
        assert(top().element != nil)
        top().element?.appendChild(text, exception: &exception)
        
        return MarkdownDomPostProcessorNodeInfo(element: nil, visitChildren: true)
    }
    
    func visit(_ node: HTMLHtmlElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
    func visit(_ node: HTMLBodyElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        let bodyElement = htmlDocument.getElementsByTagName("body").namedItem("body")
        
        return MarkdownDomPostProcessorNodeInfo(element: bodyElement)
    }
    
    func visit(_ node: HTMLHeadElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
    func visit(_ node: HTMLTitleElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
    func visit(_ node: HTMLStyleElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
    func visit(_ node: MarkdownElement) -> MarkdownDomPostProcessor.NodeInfoType? {
        
        var exception = Exception()
        
        if node.localName == "html-block" {
            
            let markdownElement = MarkdownElement(fragment: nil, document: htmlDocument, localName: "html-block")
            
            let origPreservedText = node.firstChild! as! PreservedText
            
            let preservedText = PreservedText(document: htmlDocument, data: origPreservedText.data)
            
            markdownElement.appendChild(preservedText, exception: &exception)
            
            assert(top().element != nil)
            top().element?.appendChild(markdownElement, exception: &exception)
            
            return MarkdownDomPostProcessorNodeInfo(element: markdownElement, visitChildren: false)
        }
        else if node.localName == §MarkdownElementType.Reference {
            
            // reference are not included in the final HTML serialisation
        }
        
        return MarkdownDomPostProcessorNodeInfo(element: nil)
    }
    
}
