//
//  HtmlRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-12-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import PromiseKit

/// Protocol that defines all the methods and properties which 
/// must be implemented by a resource who can be serialized/rendered in HTML.
/// Only MarkdownTextResource satisfied this need for now, but other resources
/// may support it in the futur.
public protocol HtmlRenderable: class {
    
    func renderPlainHtml() -> Promise<String?>
    
    func renderBodyContentPlainHtml() -> Promise<String?>
    
    func renderHtml(htmlStyle: CSSStyle?) -> Promise<String?>

}
