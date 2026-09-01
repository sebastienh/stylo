//
//  CSSViewController+NSTableViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import os
import StyloCoreMac

extension CSSViewController: NSTableViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 66.0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        self.windowController?.selectStyle(at: row)
        prepareStyleViewController(at: row)
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    fileprivate func changeCurrentlySelectedStyle(_ styleIndex: NSInteger) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("start changing current selected style with index: %d", log: Log.StyleEditor.all, type: .info, styleIndex)
        #endif
        let styloWindowController = self.view.window?.windowController as? StyloWindowController
        
        assert(styloWindowController != nil)
        if let styloWindowController = styloWindowController {
            
            if let styleManager = styleSetManager[styleIndex] {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("update style with selected style manager: %@", log: Log.StyleEditor.all, type: .info, %%styleManager)
                #endif
                styloWindowController.applyStyle(from: styleManager)
            }
            else {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .error, %%styleIndex, %%styleSetManager.stylesCount)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("styloWindowController is nil", log: Log.StyleEditor.all, type: .error)
            #endif
        }
    }
    
}

