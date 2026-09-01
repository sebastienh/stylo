//
//  StyloWindowController+StylesList.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os
import WriterCommon
import PromiseKit

extension StyloWindowController {
    
    public func selectStyle(at index: Int) {
        
        guard let styleSetManager = self.styloDocument?.styleSetManager else {
            assertionFailure("Error: self.styloDocument?.styleSetManager is nil")
            return
        }
        
        guard index >= 0 && index < styleSetManager.styleManagers.count else {
            assertionFailure("Error: index: \(index) out of range.")
            return
        }
        
        let styleManager = styleSetManager.styleManagers.values[index]
        applyStyle(from: styleManager)
    }
    
    public func applyAppearance(_ appearance: AppearanceMode) {
        
        guard let styloDocument = self.styloDocument else {
            assertionFailure("Error: self.styloDocument is nil")
            return
        }
        
        styleApplied = false
        self.displayWorkingOverlayWindow(delay: InterfaceConstants.Global.millisecondsWaitBeforeDisplayingWorkingWindow) { [weak self]() -> Bool in
            return self?.styleApplied == false
        }
        
        firstly {
            // we keep the promise even if it's not really necessary
            // to make sure we can easily switch back to displaying working overlay
            // in case even applying style assembly can take really long.
            
            styloDocument.applyAppearance(appearance)
            
        }.always { [weak self]() -> Void in
            self?.styleApplied = true
            self?.removeDocumentWorkingOverlay()
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error while updating style: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
        
    }
    
    public func reapplyCurrentStyle() {
        
        guard let styloDocument = self.styloDocument else {
            assertionFailure("Error: self.styloDocument is nil")
            return
        }
        
        guard let selectedStyleManager = styloDocument.styleSetManager?.selectedStyleManager.value else {
            assertionFailure("Error: selectedStyleManager is nil")
            return
        }
        
        self.applyStyle(from: selectedStyleManager)
    }
    
    public func applyStyle(from styleManager: StyleManager) {
        
        guard let styloDocument = self.styloDocument else {
            assertionFailure("Error: self.styloDocument is nil")
            return
        }
        
        styleApplied = false
        self.displayWorkingOverlayWindow(delay: InterfaceConstants.Global.millisecondsWaitBeforeDisplayingWorkingWindow) { [weak self]() -> Bool in
            return self?.styleApplied == false
        }
        
        firstly {
            
//            documentManager.applyGlobalStyleSync(styleId: styleAssemblyStore.id)
            // old version
            styloDocument.applyTextStyle(from: styleManager)

//            // Delayed version for testing purpose
//            return Promise<Void> { fulfill, reject in
//                DispatchQueue.default.asyncAfter(deadline: DispatchTime.now() + .seconds(10) , execute: {
//                    styloDocument.applyTextStyle(from: styleAssemblyStore)
//                    fulfill(())
//                })
//            }
        }.always { [weak self]() -> Void in
            self?.styleApplied = true
            self?.removeDocumentWorkingOverlay()
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error while updating style: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
        
    @IBAction public func openTools(_ sender: AnyObject? = nil) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("openStylesList", log: Log.StyloCore.all, type: .info)
        #endif
    
        if toolsCollapsed {

            // uncolapse the tools
            toggleTool(collapsed: toolsCollapsed)
        }

        styloWindow.toolsDisplayed = true
        toolsTabViewController?.transitionOptions = .crossfade
    }
    
    @discardableResult
    public func animateCloseEditorTools(_ sender: AnyObject? = nil) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            NSAnimationContext.runAnimationGroup({ context in
                // Customize the animation parameters.
                context.duration = 0.25
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
                hideTools()
            }, completionHandler: { [weak self] in
                // we don't hide the sidebar if it's the sidebar button
                // that sends the action
                self?.styloWindow.toolsDisplayed = false
                fulfill(())
            })
        }
    }
}
