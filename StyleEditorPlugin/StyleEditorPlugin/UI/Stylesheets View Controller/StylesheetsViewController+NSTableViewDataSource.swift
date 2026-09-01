//
//  StylesheetsViewController+NSTableViewDataSource.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon
import StyloCoreMac
import os

extension StylesheetsViewController: NSTableViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        guard let styleManager = self.styleManager else {
            assertionFailure("Error: styleManager is nil")
            return 0
        }
        
        return styleManager.nonUserAgentStylesheetsCount
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        // we remove the user-agent stylesheet
        let nonUserAgentStylesheetRow = self.nonUserAgentStylesheetRow(forRow: row)
        return styleManager?.stylesheets[nonUserAgentStylesheetRow]
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        //            assert(tableColumn!.identifier == NSUserInterfaceItemIdentifier(rawValue: "CSSStyleList"))
        let nonUserAgentStylesheetRow = self.nonUserAgentStylesheetRow(forRow: row)
        return createStylesheetTableCellView(for: nonUserAgentStylesheetRow)
    }
    
    @discardableResult
    private func createStylesheetTableCellView(for nonUserAgentStylesheetRow: Int) -> StylesheetTableCellView? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("createStylesListTableCellView for row: %@", log: Log.StyleEditor.all, type: .info, %%row)
        #endif
        
        guard let styleManager = self.styleManager else {
            assertionFailure("Error: self.styleManager is nil")
            return nil
        }
        
        assert(self.stylesheetsTableView != nil)
        let stylesheetTableCellView = StylesheetTableCellView()
        
        let (key, stylesheetManager) = styleManager.stylesheets[nonUserAgentStylesheetRow]
            
        guard let stylesheetItemViewController = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "StylesheetItemViewController" )) as? StylesheetItemViewController else {
            assertionFailure("Error: stylesheetItemViewController is nil")
            return nil
        }
        
        stylesheetTableCellView.stylesheetManager = stylesheetManager
        stylesheetItemViewController.representedObject = stylesheetManager
        self.stylesheetViewControllers[key] = stylesheetItemViewController
        
        
        
        let stylesheetItemView = stylesheetItemViewController.view
        stylesheetItemView.translatesAutoresizingMaskIntoConstraints = false
        stylesheetTableCellView.addSubview(stylesheetItemView)
        stylesheetTableCellView.identifier = nil
        
        let bottomConstraint = NSLayoutConstraint(item: stylesheetItemView, attribute: .bottom, relatedBy: .equal, toItem: stylesheetTableCellView, attribute: .bottom, multiplier:1, constant:0)
        
        let topConstraint = NSLayoutConstraint(item: stylesheetItemView, attribute: .top, relatedBy: .equal, toItem: stylesheetTableCellView, attribute: .top, multiplier:1, constant:0)
        
        stylesheetTableCellView.addConstraint(bottomConstraint)
        stylesheetTableCellView.addConstraint(topConstraint)
        
        NSLayoutConstraint(item: stylesheetItemView, attribute: .leading, relatedBy: .equal, toItem: stylesheetTableCellView, attribute: .leading, multiplier:1, constant:0).isActive = true
        
        NSLayoutConstraint(item: stylesheetItemView, attribute: .trailing, relatedBy: .equal, toItem: stylesheetTableCellView, attribute: .trailing, multiplier:1, constant:0).isActive = true
        
        stylesheetTableCellView.identifier = nil
        
        //                cellView.resetState()
        //                cellView.associatedStyleManager = stylesheetManager
        //            cellView.stopToListenToDidUpdateErrorsArray(stylesheetManager: styleManager.currentAppearanceStylesheetManager!)
        //            cellView.setInitialNumberOfErrorsStringValue(failableManager: styleManager.currentAppearanceStylesheetManager!)
        //            cellView.listenToDidUpdateIssuesArray(failableManager: styleManager.currentAppearanceStylesheetManager!)
        //                cellView.layoutByApplyingConstraints()
        return stylesheetTableCellView
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forRowIndexes rowIndexes: IndexSet) {
        
        assert(self.stylesheetsTableView != nil)
        self.stylesheetsTableView?.draggingOperationInProgress = true
    }
    
    func tableView(_ tableView: NSTableView, draggingSession session: NSDraggingSession, endedAt screenPoint: NSPoint, operation: NSDragOperation) {
        
        assert(self.stylesheetsTableView != nil)
        self.stylesheetsTableView?.reloadData()
    }
    
    func tableView(_ tableView: NSTableView, writeRowsWith rowIndexes: IndexSet, to pboard: NSPasteboard) -> Bool {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: rowIndexes)
        let item = NSPasteboardItem()
        item.setData(data, forType: StyloConstants.DragTypes.StylesheetType)
        pboard.writeObjects([item])
        return true
    }
    
    func tableView(_ tableView: NSTableView, validateDrop info: NSDraggingInfo, proposedRow row: Int, proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation {
        
        guard let source = info.draggingSource as? NSTableView,
            source === stylesheetsTableView
            else { return [] }
        
        if dropOperation == .above {
            return .move
        }
        return []
    }
    
    func tableView(_ tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableView.DropOperation) -> Bool {
        
        let pb = info.draggingPasteboard
        guard let itemData = pb.pasteboardItems?.first?.data(forType: StyloConstants.DragTypes.StylesheetType) else {
            assertionFailure("Error: itemData is nil")
            return false
        }
        
        guard let indexes = NSKeyedUnarchiver.unarchiveObject(with: itemData) as? IndexSet else {
            assertionFailure("Error: indexes is nil")
            return false
        }
        
        dragOperationInProgress = true
        
        guard indexes.count == 1 else {
            assertionFailure("Error: indexes.count is not 1")
            dragOperationInProgress = false
            return false
        }
        
        guard let index = indexes.first else {
            assertionFailure("Error: index is nil")
            dragOperationInProgress = false
            return false
        }
        
        let nonUserAgentStylesheetRowIndex = self.nonUserAgentStylesheetRow(forRow: index)
        let nonUserAgentStylesheetRow = self.nonUserAgentStylesheetRow(forRow: row)
        
        self.styleManager?.stylesheets.move(elementAt: nonUserAgentStylesheetRowIndex, to: nonUserAgentStylesheetRow)
        let targetIndex = row - (indexes.filter{ $0 < row }.count)
        tableView.selectRowIndexes(IndexSet(targetIndex..<targetIndex+indexes.count), byExtendingSelection: false)
        dragOperationInProgress = false
        return true
    }
    
    func nonUserAgentStylesheetRow(forRow row: Int) -> Int {
        
        return row+1
    }
    
}
