//
//  ProjectTextEditorsTableViewController+NSTableViewDelegate.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension ProjectTextEditorsTableViewController: NSTableViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////
    //              MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////

    func tableView(_ tableView: NSTableView, isGroupRow row: Int) -> Bool {
        
        return row%2 == 0
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        return false
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        
        let textIndex = row/2
        
        guard let textItemId = self.textItemId(at: textIndex) else {
            assertionFailure("Error: self.textItemId(at: \(row)) is nil")
            return nil
        }
        
        guard let sourceSetManager = self.sourceSetManager else {
            assertionFailure("Error: self.sourceSetManager is nil")
            return nil
        }
        
        guard let textManager = sourceSetManager.directoryItemManager(withId: textItemId) as? TextManager else {
            assertionFailure("Error: no text manager with id: \(textItemId)")
            return nil
        }
    
        guard let filesOutlineManager = self.filesOutlineManager else {
            assertionFailure("Error: self.filesOutlineManager is nil")
            return nil
        }
    
        let editorId = filesOutlineManager.createOrGetEditorId(forTextId: textManager.id)
        
        return ProjectTextEditorsOutlineRowView(textManager: textManager, editorId: editorId)
    }
    
    func tableView(_ tableView: NSTableView, viewFor viewForTableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let textIndex = row/2
        
        guard let textItemId = self.textItemId(at: textIndex) else {
            assertionFailure("Error: textItemId is nil")
            return nil
        }
        
        if row%2 == 0 {
            let titleView = titleOutlineCellView(for: textItemId)
            if row == 0 {
                self.firstTitleView?.isFirstTitle = false
                titleView?.isFirstTitle = true
                self.firstTitleView = titleView
            }
            assert(titleView != nil)
            return titleView
        }
        else {
            let editorCellView = self.editorItemCellView(forId: textItemId)
            assert(editorCellView != nil)
            return editorCellView
        }
    }

    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("tableView(%@, heightOfRow: %@)", log: Log.StyloCore.all, type: .debug, %%tableView, %%row)
        #endif
        
        if row%2 == 0 {
            return 28.5
        }
        else {
            
            let defaultHeight: CGFloat = 55.0

            let textIndex = row/2

            guard let textItemId = self.textItemId(at: textIndex) else {
                assertionFailure("Error: self.textItemId(at: \(row)) is nil")
                return defaultHeight
            }

            // note: the loading here of the cell is necessary to have smooth scrolling.
            // we may be tempted to remove it and calculate the height based on the
            // string in the text manager but... it doesn't work for an obscure reason.
            // So... leave it here!!!!
            guard let editorItemCellView = self.editorItemCellView(forId: textItemId) else {
                assertionFailure("Error: editorItemCellView is nil")
                return defaultHeight
            }
            
            let width = self.projectTextEditorsTableView.frame.width
            
            guard let desiredHeight = editorItemCellView.desiredHeight(forWidth: width) else {
                assertionFailure("Error: editorItemCellView.desiredHeight is nil")
                return defaultHeight
            }

            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("returning heightOfRow: %@)", log: Log.StyloCore.all, type: .debug, %%desiredHeight)
            #endif

            return desiredHeight
        }
    }
}
