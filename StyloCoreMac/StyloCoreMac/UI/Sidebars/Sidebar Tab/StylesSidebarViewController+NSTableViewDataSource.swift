//
//  StylesSidebarViewController+NSTableViewDataSource.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import os

extension StylesSidebarViewController: NSTableViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        assert(self.styleSetManager != nil)
        if let styleSetManager = styleSetManager {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("returning %d rows", styleSetManager.stylesCount)
            #endif 
            return styleSetManager.stylesCount
        }
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returning 0 rows")
        #endif
        
        assert(false, "should not happen")
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        assert(self.styleSetManager != nil)
        return styleSetManager?.styleManagers.values[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        guard let styleSetManager = self.styleSetManager else {
            assertionFailure("Error: self.styleSetManager is nil")
            return nil
        }
        
        guard row >= 0 && row < styleSetManager.styleManagers.values.count else {
            assertionFailure("Error: row: \(row) is out of range.")
            return nil
        }
        
        let styleManager = styleSetManager.styleManagers.values[row]
        return sidebarStyleTableCellView(for: styleManager.title, tableColumn: tableColumn)
    }
    
    fileprivate func createStyleManagerView(with styleManager: StyleManager) -> SmallConicalStyleButton {
        
        let styleIcon = SmallConicalStyleButton(frame: NSRect(x: 0, y: 0, width: 26, height: 26))
        styleIcon.action = #selector(styleButtonClicked(_:))
        styleIcon.target = self
        styleIcon.title = ""
        styleIcon.styleManager = styleManager
        return styleIcon
    }
    
}
