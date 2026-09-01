//
//  StyloWindowController+Revert.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-03-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import PromiseKit
import Common
import WriterCommon
import os

extension StyloWindowController {

    
//    private func removeNonTextViews() -> Promise<Void> {
//        
//        return Promise<Void> { fulfill, reject in
//        
//            if self.stylesListShown && !self.toolsCollapsed {
//                
//                // if a style editor is present we should discard it.
//                if let editedStylesheetViewController = self.editedStylesheetViewController {
//                    editedStylesheetViewController.goBack()
//                }
//                firstly {
//                    self.animateCloseStylesList()
//                }.then {
//                    fulfill(())
//                }.catch { error in
//                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                    os_log("error: %@", log: Log.StyloCore.all, type: .error, %%error)
//                    #endif
//                    reject(error)
//                }
//            }
//            else {
//                fulfill(())
//            }
//        }
//    }
    
    
}
