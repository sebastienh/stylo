//
//  EditorOutlineCellView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

class EditorOutlineCellView: TextEditorsOutlineCellView {
    
    var textEditor: ProjectTextEditor? {
        
        guard let textEditorViewControllerView = subviews.first else {
            assertionFailure("Error: subviews.first is nil")
            return nil
        }
        
        for subview in textEditorViewControllerView.subviews {
            if let textEditor = subview as? ProjectTextEditor {
                return textEditor
            }
        }
        return nil
    }
}


