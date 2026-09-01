//
//  HtmlBlock+RegularExpression.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-23.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension MarkdownSource {
    
    func matchHtmlBlock(fromPosition position: Int = 0) -> [Match]? {
        
        func returnMatch(_ rawStringValue: String) -> [Match] {
            
            return [Match(start: position, end: position + rawStringValue.length)]
        }
        
        if let firstLetter = lowercaseCharAt(position) {
            
            switch firstLetter {
                
            case §UnicodeLetter.a:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Address, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Address)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Article, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Article)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Aside, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Aside)
                }
                
            case §UnicodeLetter.b:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Base, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Base)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Basefont, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Basefont)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Blockquote, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Blockquote)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Body, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Body)
                }
                
                
            case §UnicodeLetter.c:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Caption, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Caption)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Center, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Center)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Col, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Col)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Colgroup, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Colgroup)
                }
                
            case §UnicodeLetter.d:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Dd, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Dd)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Details, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Details)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Dialog, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Dialog)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Dir, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Dir)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Div, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Div)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Dl, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Dl)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Dt, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Dt)
                }
                
            case §UnicodeLetter.f:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Fieldset, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Fieldset)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Figcaption, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Figcaption)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Figure, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Figure)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Footer, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Footer)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Form, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Form)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Frame, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Frame)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Frameset, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Frameset)
                }
                
            case §UnicodeLetter.h:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H1, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H1)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H2, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H2)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H3, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H3)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H4, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H4)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H5, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H5)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.H6, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.H6)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Head, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Head)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Header, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Header)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Hr, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Hr)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Html, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Html)
                }
                
            case §UnicodeLetter.i:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Iframe, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Iframe)
                }
                
            case §UnicodeLetter.l:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Legend, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Legend)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Li, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Li)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Link, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Link)
                }
                
            case §UnicodeLetter.m:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Main, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Main)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Menu, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Menu)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Menuitem, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Menuitem)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Meta, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Meta)
                }
                
            case §UnicodeLetter.n:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Nav, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Nav)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Noframes, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Noframes)
                }
                
            case §UnicodeLetter.o:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Ol, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Ol)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Optgroup, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Optgroup)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Option, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Option)
                }
                
            case §UnicodeLetter.p:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.P, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.P)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Param, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Param)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Pre, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Pre)
                }
                
            case §UnicodeLetter.s:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Section, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Section)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Source, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Source)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Summary, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Summary)
                }
                
            case §UnicodeLetter.t:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Table, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Table)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Tbody, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Tbody)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Td, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Td)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Tfoot, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Tfoot)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Th, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Th)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Thead, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Thead)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Title, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Title)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Tr, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Tr)
                }
                else if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Track, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Track)
                }
                
            case §UnicodeLetter.u:
                
                if hasPrefixFromPositionCaseInsensitive(§HtmlBlock.Ul, fromPosition: position) {
                    
                    return returnMatch(§HtmlBlock.Ul)
                }
                
            default:
                
                return nil
            }
        }
        return nil
    }
    
}
