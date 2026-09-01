//
//  MarkdownDomElementsRenderer.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-05-21.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web



//final class MarkdownDomElementsRenderer : Renderer {
//
//    typealias ReturnType = [Element]
//
//    let markdownDomRenderer: MarkdownDomRenderer
//    
//    init() {
//        
//        self.markdownDomRenderer = MarkdownDomRenderer()
//    }
//    
//    func render(tokens: Tokens, options: Options? = nil, env: Env? = nil) -> [Element] {
//        
//        var elements = [Element]()
//        
//        let htmlDocument = markdownDomRenderer.render(tokens, options: options, env: env)
//        
//        let bodyElementCollection = htmlDocument.getElementsByTagName("body")
//        
//        let bodyElement = bodyElementCollection.namedItem("body")!
//        
//        // iterate through the children of body and add
//        let children = bodyElement.children
//        
//        for child in children {
//            
//            elements.append(child as! Element)
//        }
//        
//        return elements
//    }
//    
//}
