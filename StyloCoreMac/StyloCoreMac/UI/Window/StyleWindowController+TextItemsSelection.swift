//
//  StyleWindowController+TextItemsSelection.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-06-29.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

extension StyloWindowController {
    
    func applySelectionChangesToTextItems(withIds textIds: [TextId], closure: @escaping () -> ()) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applySelectionChangesToTextItems(withTextIds: %@, closure: %@)", log: Log.StyloCore.all, type: .info, %%textIds, %%closure)
        #endif
        
        guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
            assertionFailure("Error: sourceSetManager is nil")
            return
        }
        
        if sourceSetManager.needsToDisplayWorkingOverlay(forTextWithIds: textIds) {
            
            self.displayWorkingOverlayWindow(delay: 0, disableCondition: { () -> Bool in
                return true
            })
            
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in
                        
                        //        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("applySelectionChangesToTextItems -> running closure", log: Log.StyloCore.all, type: .info, %%textIds, %%closure)
                        //        #endif
                        
                        closure()
                        self?.windowController?.removeDocumentWorkingOverlay()
                    }
                }
            }
        }
        else {
            closure()
        }
    }
    
}
