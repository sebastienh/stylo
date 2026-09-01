//
//  DocumentManager+Focus.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-05.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import os
import Igloo
import Web

extension DocumentManager {
    
    public func temporaryDisableFocus() {
        
        self.clearFocus()
        self.disableFocus()
        self.focusTemporarlyDisabled = true 
    }

    public func restoreTemporaryDisabledFocusIfNecessary() {
        
        if self.focusTemporarlyDisabled {
            self.restoreApplicationFocusMode()
            self.focusTemporarlyDisabled = false
        }
    }
    
    public func restoreTemporaryDisabledFocus() {
        
        self.restoreApplicationFocusMode()
    }
    
    /// This method clear the focus on all files outline
    /// managers but leave the set focusMode as it is.
    public func clearFocus() {
        
        self.clearFocusRequested(fromFilesOutlineWithId: nil)
    }
    
    /// This method restore the application focus mode.
    public func disableFocus() {
        
        self.filesOutlineSetManager.value?.disableFocus()
    }
    
    /// Restore the application focus mode.
    public func restoreApplicationFocusMode() {
        
        self.filesOutlineSetManager.value?.setFocusMode(StyloApplication.shared.focusMode.value)
    }
    
    public func clearFocusedEditorId() {
        
        self.lastFocusedEditorChangeEvent.setValue(nil)
    }
    
    public func setEditorSelectionChangeEvent(_ focusedEditorChangeEvent: FocusedEditorChangeEvent) {
        
        self.lastFocusedEditorChangeEvent.setValue(focusedEditorChangeEvent)
    }
    
    public func clearFocusRequested(fromFilesOutlineWithId filesOutlineId: FilesOutlineManager.FileOutlineId?) {
        
        self.clearFocusRequest.setValue(filesOutlineId, sameExecutionStack: true)
    }
    
    func subscribeToFocusMode() {
        
        self.focusMode.setValue(StyloApplication.shared.focusMode.value, notify: false)
        StyloApplication.shared.focusMode.subscribe({ [weak self](focusMode) in
            self?.handleFocusModeChange(focusMode)
        }, observer: self)
    }
    
    func handleIsKeyDocumentChange(_ isKeyDocument: Bool) {
  
        // stylo #905: Removed because seems to cause
        // display problems and this feature is _far_ from essential.
        //        if isKeyDocument {
        //            if !self.isKeyDocument.value {
        //                if StyloApplication.shared.focusMode.value != .disabled {
        //                    self.focusMode.setValue(StyloApplication.shared.focusMode.value)
        //                }
        //            }
        //            else if self.focusMode.value == .disabled && StyloApplication.shared.focusMode.value != .disabled  {
        //                self.focusMode.setValue(StyloApplication.shared.focusMode.value)
        //            }
        //        }
        //        else {
        //            if self.focusMode.value != .disabled  {
        //                #if !DEBUG
        //                self.focusMode.setValue(.disabled)
        //                #endif
        //            }
        //        }
        //
        //        #if DEBUG
        //        if isKeyDocument {
        //            assert(self.focusMode.value == StyloApplication.shared.focusMode.value)
        //        }
//        #endif
    }
    
    private func handleFocusModeChange(_ focusMode: FocusMode) {
        if self.isKeyDocument.value {
            self.focusMode.setValue(focusMode)
        }
    }
    
    /// Method that allows to change the focus mode.
    /// It is called from the listener to the StyleApplication
    /// focus mode. We may want to handle key window vs not
    /// here.
    open func applyFocusMode(_ focusMode: FocusMode) {
        
        guard let sourceSetManager = self._sourceSetManager.value else {
            assertionFailure("Error: self._sourceSetManager is nil")
            return
        }
        
        for textManager in sourceSetManager.textManagersArray {
            textManager.applyFocusMode(focusMode)
        }
    }

}
