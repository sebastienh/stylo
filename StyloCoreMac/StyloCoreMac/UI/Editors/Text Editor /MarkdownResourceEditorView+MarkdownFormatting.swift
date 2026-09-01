//
//  MarkdownResourceEditorView+MarkdownFormatting.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-21.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Markdown
import Common
import WriterCommon

extension MarkdownResourceEditorView: MarkdownFormatter {
    
    @IBAction func makeH1(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h1)
    }
    
    @IBAction func makeH2(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h2)
    }
    
    @IBAction func makeH3(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h3)
    }
    
    @IBAction func makeH4(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h4)
    }

    @IBAction func makeH5(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h5)
    }
    
    @IBAction func makeH6(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleHeading(heading: Heading.h6)
    }
    
    @IBAction func makeBlockQuote(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleBlockQuote()
    }
    
    @IBAction func makeBulletedList(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.self.handleBulletedList()
    }
    
    @IBAction func makeNumberedList(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleNumberedList()
    }
    
    ///
    /// Method to make a selection bold:
    ///
    /// Many cases (depending on selection)
    ///
    ///   1. Selection is not empty
    ///   2. Selection is empty 
    @IBAction func makeBold(_ sender: AnyObject?) {
        
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleBold()
    }
    
    @IBAction func makeItalic(_ sender: AnyObject?) {
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleItalic()
    }
    
    @IBAction func makeStrikethrough(_ sender: AnyObject?) {
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleStrikethrough()
    }
    
    @IBAction func makeLink(_ sender: AnyObject?) {
        self.documentManager?.temporaryDisableFocus()
        defer { self.documentManager?.restoreTemporaryDisabledFocus()}
        self.handleLink()
    }

 
}
