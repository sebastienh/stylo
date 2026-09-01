//
//  StylesheetsViewController+NSTableViewDelegate.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import WriterCommon
import StyloCoreMac
import os

extension StylesheetsViewController: NSTableViewDelegate {

    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 76.0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
        self.stylesheetsTableViewContainerView?.invalidateIntrinsicContentSize()
    }
    
}
