//
//  ThemeSetViewController+NSTableViewDataSource.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: NSTableViewDataSource protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////
extension ThemeSetViewController: NSTableViewDataSource {

    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        if let themeSetManager = themeSetManager {
            
            return themeSetManager.themesCount
        }
        
        return 0
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as! ThemesTableCellView
        let themeManager = themeSetManager[row]
        
        cellView.associatedThemeManager = themeManager
        let name = themeManager?.name
        
        assert(name != nil)
        cellView.textField!.stringValue = name?.value ?? "Untitled Theme"
        return cellView
    }

}
