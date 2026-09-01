//
//  EditorItemTableCellView.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

class EditorItemTableCellView: NSTableCellView {
    
    var editorViewItemViewController: EditorViewItemViewController?
    
    var projectTextEditorViewController: ProjectTextEditorViewController? {
        
        return editorViewItemViewController?.projectTextEditorViewController
    }
    
    var resourceEditorView: MarkdownResourceEditorView? {
        
        return editorViewItemViewController?.resourceEditorView
    }
    
    var leftView: EditorSideView? {
        
        return editorViewItemViewController?.leftView
    }

    var rightView: EditorSideView? {
        
        return editorViewItemViewController?.rightView
    }
    
    func desiredHeight(forWidth width: CGFloat) -> CGFloat? {
        
        return editorViewItemViewController?.desiredHeight(forWidth: width)
    }
    
    func collapse() {
        
        editorViewItemViewController?.collapse()
    }
    
    func expand() {
     
        editorViewItemViewController?.expand()
    }
    
}
