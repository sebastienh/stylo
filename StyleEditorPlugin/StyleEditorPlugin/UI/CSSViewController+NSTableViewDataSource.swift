//
//  CSSViewController+NSTableViewDataSource.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import StyloCoreMac
import os
import Common

/// see https://gist.github.com/sooop/3c964900d429516ba48bd75050d0de0a
extension Array {
    
    mutating func move(from start: Index, to end: Index) {
        guard (0..<count) ~= start, (0...count) ~= end else { return }
        if start == end { return }
        let targetIndex = start < end ? end - 1 : end
        insert(remove(at: start), at: targetIndex)
    }
    
    mutating func move(with indexes: IndexSet, to toIndex: Index) {
        let movingData = indexes.map{ self[$0] }
        let targetIndex = toIndex - indexes.filter{ $0 < toIndex }.count
        for (i, e) in indexes.enumerated() {
            remove(at: e - i)
        }
        insert(contentsOf: movingData, at: targetIndex)
    }
}

extension CSSViewController: NSTableViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        if let styleSetManager = styleSetManager {
            
            return styleSetManager.stylesCount
        }
        return 0
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        return styleSetManager[row]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        assert(tableColumn!.identifier == NSUserInterfaceItemIdentifier(rawValue: "CSSStyleList"))
        return createStylesListTableCellView(for: row)
    }
    
    @discardableResult
    func createStylesListTableCellView(for row: Int) -> CSSStyleTableCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("createStylesListTableCellView for row: %@", log: Log.StyleEditor.all, type: .info, %%row)
        #endif
        
        let cellView = self.stylesTableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CSSStyleList"), owner: self) as! CSSStyleTableCellView
        if let styleManager = styleSetManager[row] {
        
            cellView.resetState()
            cellView.associatedStyleManager = styleManager
//            cellView.stopToListenToDidUpdateErrorsArray(stylesheetManager: styleManager.currentAppearanceStylesheetManager!)
//            cellView.setInitialNumberOfErrorsStringValue(failableManager: styleManager.currentAppearanceStylesheetManager!)
//            cellView.listenToDidUpdateIssuesArray(failableManager: styleManager.currentAppearanceStylesheetManager!)
            cellView.layoutByApplyingConstraints()
            return cellView
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Trying to access styleSetManager style at index: %@ with stylesCount: %@", log: Log.StyleEditor.all, type: .info, %%row, %%styleSetManager.stylesCount)
            #endif
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {

        self.stylesTableView.draggingOperationInProgress = true
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {

        self.stylesTableView.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        let item = NSPasteboardItem()
        item.setData(data, forType: StyloConstants.DragTypes.StyleType)
        pboard.writeObjects([item])
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        guard let source = info.draggingSource as? NSTableView,
            source === stylesTableView
            else { return [] }
        
        if dropOperation == .above {
            return .move
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        let pb = info.draggingPasteboard
        if let itemData = pb.pasteboardItems?.first?.data(forType: StyloConstants.DragTypes.StyleType),
            let indexes = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? IndexSet
        {
            dragOperationInProgress = true
            
            styleSetManager.styleManagers.values.move(with: indexes, to: row)
            let targetIndex = row - (indexes.filter{ $0 < row }.count)
            tableView.selectRowIndexes(IndexSet(targetIndex..<targetIndex+indexes.count), byExtendingSelection: false)
            dragOperationInProgress = false
            return true
        }
        return false
    }
    
}

