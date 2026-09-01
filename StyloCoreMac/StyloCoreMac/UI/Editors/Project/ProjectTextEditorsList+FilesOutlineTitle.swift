//
//  ProjectTextEditorsList+FilesOutlineTitle.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-26.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

extension ProjectTextEditorsList {
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        textField.invalidateIntrinsicContentSize()
    }
    
    @objc func controlTextDidEndEditing(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return
        }
        
        do {
            try filesOutlineManager.rename(to: textField.stringValue)
        }
        catch let error {
            
            switch error {
            case let renameError as RenameError:
                
                let windowController = self.view.window?.windowController as? StyloWindowController
                windowController?.notifyRenameError(error: renameError) {
                    textField.stringValue = filesOutlineManager.name.value
                }
                
            default:
                assertionFailure("Error: unhandled error type: \(error)")
            }
        }
    }
}
