//
//  ThemeSetViewController+NSTableViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

extension ThemeSetViewController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        let tableView = tableView as? ThemesTableView
        
        assert(tableView != nil)
        if let tableView = tableView {
            
            tableView.selectedTableRowView = row
            StyloApplication.shared.selectTheme(at: row)
        }
        return true
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    /// FIXME: This method should not be needed fot an ordinary array
    /// but there seem to have a problem with framework.
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        return 44.0
    }
    
    
}
