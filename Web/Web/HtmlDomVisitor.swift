//
//  HtmlDomVisitor.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-12-08.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public protocol HtmlDomVisitor: DOMVisitor {
    
    func visit(_ node: HtmlDocument) -> NodeInfoType?
    func visit(_ node: HTMLElement) -> NodeInfoType?
    func visit(_ node: HTMLPreElement) -> NodeInfoType?
    func visit(_ node: Text) -> NodeInfoType?
    func visit(_ node: HTMLHtmlElement) -> NodeInfoType?
    func visit(_ node: HTMLBodyElement) -> NodeInfoType?
    func visit(_ node: HTMLHeadElement) -> NodeInfoType?
    func visit(_ node: HTMLTitleElement) -> NodeInfoType?
    func visit(_ node: HTMLStyleElement) -> NodeInfoType?
    func visit(_ node: MarkdownElement) -> NodeInfoType?
}
