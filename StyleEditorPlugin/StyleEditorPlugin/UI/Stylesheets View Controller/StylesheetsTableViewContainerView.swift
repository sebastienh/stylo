//
//  StylesheetsTableViewContainerView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

class StylesheetsTableViewContainerView: NSView {
    
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint?
    
    @IBOutlet var stylesheetsTableView: StylesheetsTableView?
    
    override var intrinsicContentSize: NSSize {
        
        guard let stylesheetsTableView = self.stylesheetsTableView else {
            assertionFailure("Error: stylesheetsTableView is nil")
            return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
        }
        
        guard let tableViewTopConstraint = self.tableViewTopConstraint else {
            assertionFailure("Error: stylesheetsTableView is nil")
            return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
        }
        
        guard let tableTotalHeight = stylesheetsTableView.totalHeight else {
            assertionFailure("Error: tableTotalHeight is nil")
            return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
        }
        
        let height = tableTotalHeight + tableViewTopConstraint.constant
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("table height: %!", log: Log.StyleEditor.all, type: .info, %%height)
        #endif
        
        return NSSize(width: NSView.noIntrinsicMetric, height: height)
    }
    
}
