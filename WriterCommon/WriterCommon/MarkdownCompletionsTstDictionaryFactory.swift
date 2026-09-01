//
//  MarkdownCompletionsTstDictionaryFactory.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-02-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import Common
import Markdown

public final class MarkdownCompletionsTstDictionaryFactory: CompletionsTstDictionaryFactory {
    
    public static func GetMarkdownTstDictionary() -> TstDictionary<CompletionValue> {
        
        let tstDictionary = TstDictionary<CompletionValue>()
        
        // temporarly we will just create a dictionary with strings,
        // a the value will the definition of the string key, an explanation
        // (localized) of the key and in which context it can be used.
        
//        try! tstDictionary.add(§CSSProperty.Color, value: "color")
        
//        try! tstDictionary.add(§CSSProperty.Color, value: NSLocalizedString(§CSSProperty.Color, comment: "CSS \"color\" property description for autocompletion."))
//        
//        try! tstDictionary.add(§CSSProperty.BackgroundColor, value: NSLocalizedString(§CSSProperty.BackgroundColor, comment: "CSS \"background-color\" property description for autocompletion."))
//        
//        try! tstDictionary.add(§CSSProperty.FontFamily, value: NSLocalizedString(§CSSProperty.FontFamily, comment: "CSS \"font-family\" property description for autocompletion."))
//        
//        try! tstDictionary.add(§CSSProperty.FontSize, value: NSLocalizedString(§CSSProperty.FontSize, comment: "CSS \"font-size\" property description for autocompletion."))
//        
//        try! tstDictionary.add(§CSSProperty.FontSize, value: NSLocalizedString(§CSSProperty.FontSize, comment: "CSS \"font-size\" property description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Address, value: NSLocalizedString(§HtmlBlock.Address, comment: "HTML \"address\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Article, value: NSLocalizedString(§HtmlBlock.Article, comment: "HTML \"article\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Aside, value: NSLocalizedString(§HtmlBlock.Aside, comment: "HTML \"aside\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Base, value: NSLocalizedString(§HtmlBlock.Base, comment: "HTML \"base\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Basefont, value: NSLocalizedString(§HtmlBlock.Basefont, comment: "HTML \"basefont\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Blockquote, value: NSLocalizedString(§HtmlBlock.Blockquote, comment: "HTML \"blockquote\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Body, value: NSLocalizedString(§HtmlBlock.Body, comment: "HTML \"body\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Caption, value: NSLocalizedString(§HtmlBlock.Caption, comment: "HTML \"caption\" element description for autocompletion."))
//        
//        try! tstDictionary.add(§HtmlBlock.Center, value: NSLocalizedString(§HtmlBlock.Center, comment: "HTML \"center\" element description for autocompletion."))
        
        //        case Col            = "col"
        //        case Colgroup       = "colgroup"
        //        case Dd             = "dd"
        //        case Details        = "details"
        //        case Dialog         = "dialog"
        //        case Dir            = "dir"
        //        case Div            = "div"
        //        case Dl             = "dl"
        //        case Dt             = "dt"
        //        case Fieldset       = "fieldset"
        //        case Figcaption     = "figcaption"
        //        case Figure         = "figure"
        //        case Footer         = "footer"
        //        case Form           = "form"
        //        case Frame          = "frame"
        //        case Frameset       = "frameset"
        //        case H1             = "h1"
        //        case Head           = "head"
        //        case Header         = "header"
        //        case Hr             = "hr"
        //        case Html           = "html"
        //        case Iframe         = "iframe"
        //        case Legend         = "legend"
        //        case Li             = "li"
        //        case Link           = "link"
        //        case Main           = "main"
        //        case Menu           = "menu"
        //        case Menuitem       = "menuitem"
        //        case Meta           = "meta"
        //        case Nav            = "nav"
        //        case Noframes       = "noframes"
        //        case Ol             = "ol"
        //        case Optgroup       = "optgroup"
        //        case Option         = "option"
        //        case P              = "p"
        //        case Param          = "param"
        //        case Pre            = "pre"
        //        case Section        = "section"
        //        case Source         = "source"
        //        case Summary        = "summary"
        //        case Table          = "table"
        //        case Tbody          = "tbody"
        //        case Td             = "td"
        //        case Tfoot          = "tfoot"
        //        case Th             = "th"
        //        case Thead          = "thead"
        //        case Title          = "title"
        //        case Tr             = "tr"
        //        case Track          = "track"
        //        case Ul             = "ul"
        
        return tstDictionary
    }
    
}
