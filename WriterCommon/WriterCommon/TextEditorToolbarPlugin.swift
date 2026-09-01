//
//  TextEditorToolbarPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-10-02.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol TextEditorToolbarPlugin {
    
    func editorControlsForTextManager(withId textId: String, andEditorId editorId: String) -> [TextEditorControl]?
    
}
