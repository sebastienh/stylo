//
//  HtmlElement.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-09.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// List of valid schemes of an URL.
enum HtmlElement: String {
    
    // 1
    case P =            "p"
    
    // 2
    case Dl             = "dl"
    case Dt             = "dt"
    case Dd             = "dd"
    case H1             = "h1"
    case Hr             = "hr"
    case Ol             = "ol"
    case Li             = "li"
    case Th             = "th"
    case Td             = "td"
    case Ul             = "ul"
    case Tr             = "tr"
    
    // 3
    case Dir            = "dir"
    case Div            = "div"
    case Col            = "col"
    case Nav            = "nav"
    
    // 4
    case Base           = "base"
    case Body           = "body"
    case Link           = "link"
    case Main           = "main"
    case Menu           = "menu"
    case Meta           = "meta"
    case Head           = "head"
    case Form           = "form"
    case Html           = "html"
    
    // 5
    case Aside          = "aside"
    case Table          = "table"
    case Tbody          = "tbody"
    case Tfoot          = "tfoot"
    case Thead          = "thead"
    case Title          = "title"
    case Track          = "track"
    case Frame          = "frame"
    case Param          = "param"
    
    // 6
    case Center         = "center"
    case Dialog         = "dialog"
    case Figure         = "figure"
    case Footer         = "footer"
    case Header         = "header"
    case Iframe         = "iframe"
    case Legend         = "legend"
    case Option         = "option"
    case Source         = "source"
    
    case Address        = "address"
    case Article        = "article"
    case Caption        = "caption"
    case Details        = "details"
    case Section        = "section"
    case Summary        = "summary"
    
    // 8
    case Fieldset       = "fieldset"
    case Basefont       = "basefont"
    case Colgroup       = "colgroup"
    case Frameset       = "frameset"
    case Menuitem       = "menuitem"
    case Noframes       = "noframes"
    case Optgroup       = "optgroup"
    
    // 10
    case Blockquote     = "blockquote"
    case Figcaption     = "figcaption"
    
    
    static var allValues = [
    
        HtmlElement.Address,
        HtmlElement.Article,
        HtmlElement.Aside,
        HtmlElement.Base,
        HtmlElement.Basefont,
        HtmlElement.Blockquote,
        HtmlElement.Body,
        HtmlElement.Caption,
        HtmlElement.Center,
        HtmlElement.Col,
        HtmlElement.Colgroup,
        HtmlElement.Dd,
        HtmlElement.Details,
        HtmlElement.Dialog,
        HtmlElement.Dir,
        HtmlElement.Div,
        HtmlElement.Dl,
        HtmlElement.Dt,
        HtmlElement.Fieldset,
        HtmlElement.Figcaption,
        HtmlElement.Figure,
        HtmlElement.Footer,
        HtmlElement.Form,
        HtmlElement.Frame,
        HtmlElement.Frameset,
        HtmlElement.H1,
        HtmlElement.Head,
        HtmlElement.Header,
        HtmlElement.Hr,
        HtmlElement.Html,
        HtmlElement.Iframe,
        HtmlElement.Legend,
        HtmlElement.Li,
        HtmlElement.Link,
        HtmlElement.Main,
        HtmlElement.Menu,
        HtmlElement.Menuitem,
        HtmlElement.Meta,
        HtmlElement.Nav,
        HtmlElement.Noframes,
        HtmlElement.Ol,
        HtmlElement.Optgroup,
        HtmlElement.Option,
        HtmlElement.P,
        HtmlElement.Param,
        HtmlElement.Section,
        HtmlElement.Source,
        HtmlElement.Summary,
        HtmlElement.Table,
        HtmlElement.Tbody,
        HtmlElement.Td,
        HtmlElement.Tfoot,
        HtmlElement.Th,
        HtmlElement.Thead,
        HtmlElement.Title,
        HtmlElement.Tr,
        HtmlElement.Track,
        HtmlElement.Ul,
    ]
}
