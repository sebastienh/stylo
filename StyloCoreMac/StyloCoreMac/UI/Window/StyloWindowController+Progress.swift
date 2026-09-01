//
//  StyloWindowController+Progress.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-01-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import WriterCommon
import os

extension StyloWindowController {
    
    func dismissProgressIndicator(data: Data) -> Promise<Data> {
        
        return Promise<Data> { fulfill, reject in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Dismissing progress sheet view controller", log: Log.StyloCore.all, type: .info)
            #endif
            assert(globalMenuPanelViewController != nil)
            self.globalMenuPanelViewController?.dismiss(self.progressViewController)
            self.activityCompletionBlock?()
            fulfill(data)
        }
    }
    
    
    func displayPrepareDocumentForPrintingProgressIndicator() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let document = self.styloDocument
            
            assert(document != nil)
            if let document = document {
                
                document.performActivity(withSynchronousWaiting: true, using: { (completionBlock) in
                    
                    self.activityCompletionBlock = completionBlock
                    assert(self.globalMenuPanelViewController != nil)
                    self.progressViewController.progressType = .printing
                    self.progressViewController.documentName = self.window?.title
                    self.globalMenuPanelViewController?.presentAsSheet(self.progressViewController)
                    fulfill(())
                })
            }
            else {
                
                assert(false, "document is nil in displayExportProgressIndicator(...)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("document is nil in displayExportProgressIndicator(...)", log: Log.StyloCore.all, type: .error)
                #endif
                reject(NWError.custom(message: "document is nil in displayExportProgressIndicator(...)"))
            }
        }
    }
    
    func displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType?) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let document = self.styloDocument
            
            assert(document != nil)
            if let document = document {
                
                document.performActivity(withSynchronousWaiting: true, using: { (completionBlock) in
                    
                    self.activityCompletionBlock = completionBlock
                    assert(self.globalMenuPanelViewController != nil)
                    self.progressViewController.progressType = .exporting
                    self.progressViewController.exportType = exportType
                    self.progressViewController.documentName = self.window?.title
                    self.globalMenuPanelViewController?.presentAsSheet(self.progressViewController)
                    fulfill(())
                })
            }
            else {
                
                assert(false, "document is nil in displayExportProgressIndicator(...)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("document is nil in displayExportProgressIndicator(...)", log: Log.StyloCore.all, type: .error)
                #endif
                reject(NWError.custom(message: "document is nil in displayExportProgressIndicator(...)"))
            }
        }
    }
    
}
