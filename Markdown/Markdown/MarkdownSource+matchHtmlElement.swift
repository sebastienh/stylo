//
//  String+matchHtmlElement.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-30.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    func matchHtmlElement(fromPosition position: Int = 0) -> [Match]? {
        
        func returnMatch(_ rawStringValue: String) -> [Match] {
            
            return [Match(start: position, end: rawStringValue.length)]
        }
        
        if let firstLetter = lowercaseCharAt(position) {
            
            switch firstLetter {
                
            case §UnicodeLetter.a:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Address, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Address)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Article, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Article)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Aside, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Aside)
                }
                
            case §UnicodeLetter.b:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Base, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Base)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Basefont, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Basefont)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Blockquote, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Blockquote)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Body, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Body)
                }
                
                
            case §UnicodeLetter.c:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Caption, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Caption)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Center, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Center)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Col, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Col)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Colgroup, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Colgroup)
                }
                
            case §UnicodeLetter.d:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Dd, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Dd)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Details, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Details)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Dialog, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Dialog)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Dir, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Dir)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Div, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Div)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Dl, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Dl)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Dt, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Dt)
                }
                
            case §UnicodeLetter.f:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Fieldset, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Fieldset)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Figcaption, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Figcaption)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Figure, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Figure)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Footer, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Footer)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Form, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Form)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Frame, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Frame)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Frameset, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Frameset)
                }
                
            case §UnicodeLetter.h:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.H1, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.H1)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Head, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Head)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Header, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Header)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Hr, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Hr)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Html, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Html)
                }
                
            case §UnicodeLetter.i:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Iframe, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Iframe)
                }
                
            case §UnicodeLetter.l:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Legend, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Legend)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Li, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Li)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Link, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Link)
                }
                
            case §UnicodeLetter.m:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Main, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Main)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Menu, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Menu)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Menuitem, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Menuitem)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Meta, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Meta)
                }
                
            case §UnicodeLetter.n:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Nav, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Nav)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Noframes, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Noframes)
                }
                
            case §UnicodeLetter.o:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Ol, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Ol)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Optgroup, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Optgroup)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Option, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Option)
                }
                
            case §UnicodeLetter.p:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.P, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.P)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Param, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Param)
                }
                
                
            case §UnicodeLetter.s:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Section, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Section)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Source, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Source)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Summary, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Summary)
                }
                
            case §UnicodeLetter.t:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Table, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Table)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Tbody, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Tbody)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Td, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Td)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Tfoot, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Tfoot)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Th, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Th)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Thead, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Thead)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Title, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Title)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Tr, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Tr)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Track, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Track)
                }
                
            case §UnicodeLetter.u:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlElement.Ul, fromPosition: position) {
                    
                    return returnMatch(§HtmlElement.Ul)
                }
                
            default:
                
                return nil
            }
        }
        return nil
    }
}
