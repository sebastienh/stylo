//
//  StyleEditorPlugin.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import SwiftProtobuf
import StyloCoreMac

class StyleEditorPlugin: NSResponder, StyloPlugin, DataPlugin {
    
    var name: String {
        return  Constants.Plugin.Name
    }
    
    var isEdited: Bool = false
    
    var isDraft: Bool {
        return false
    }
    
    var mode: Mode = .read
    
    var cssViewController: CSSViewController?
    
    var styleSetManager: StyleSetManager? {
        
        return documentManager.styleSetManager
    }
    
    let documentManager: DocumentManager
    
    var windowController: StyloWindowController? {
        
        return styloDocument?.windowControllers.first as? StyloWindowController
    }
    
    var styloDocument: TextDocument? {
        
        return documentManager.document
    }
    
    /// This variable should go in the StyloDocument since
    /// This value holds the currently edited StyleManager
    /// OSX: It is updated by the UI (CSSViewController in prepareForSegue)
    public var editedStyleManager: StyleManager? {
        
        didSet {
            
            if let editedStyleManager = editedStyleManager {
            
                // Update the currently active StyleManager
                assert(styleSetManager != nil)
                if let selectedStyleManager = styleSetManager?.selectedStyleManager, selectedStyleManager != editedStyleManager {
                    styleSetManager?.setCurrentStyleManager(editedStyleManager)
                }
                else if styleSetManager?.selectedStyleManager == nil {
                    assert(styleSetManager != nil)
                    styleSetManager?.setCurrentStyleManager(editedStyleManager)
                }
            }
        }
    }
    
    required init(documentManager: DocumentManager) {
        
        self.documentManager = documentManager
        
        if StyloApplication.shared.styleEditorPluginCanWrite {
            self.mode = .write
        }
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initData() {
        
        
    }
    
    func readData(from fileWrapper: FileWrapper?) throws {
        
    }
    

    
}

