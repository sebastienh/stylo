//
//  TextuallyPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-07.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum TextuallyPlugin: String {
    
    case exportHtml = "net.textually.stylo.plugin.export.html"
    case exportText = "net.textually.stylo.plugin.export.text"
    case exportPdf = "net.textually.stylo.plugin.export.pdf"
    case exportMarkdown = "net.textually.stylo.plugin.export.markdown"
    case editorTheme = "net.textually.stylo.plugin.editor.theme"
    case exportWord = "net.textually.stylo.plugin.export.word"
    case editorStyle = "net.textually.stylo.plugin.editor.style"
    case audio = "net.textually.stylo.plugin.audio"
    case tags = "net.textually.stylo.plugin.tags"
    
}
