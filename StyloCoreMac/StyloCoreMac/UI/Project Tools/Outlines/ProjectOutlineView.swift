//
//  ProjectOutlineView.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import Common
import os

class ProjectOutlineView: NSOutlineView {
    
    enum EventSelectionType {
        
        /// happens when no key is used while selecting unselected and selected row
        case replaceSelection
        
        /// happens when shift or command key is used while selecting unselected row
        case extendSelection
        
        /// happens when shift or command key is used while selecting selected row
        case shrinkSelection
    }
    
    private var projectOutlineViewController: ProjectOutlineViewController? {
        
        return self.delegate as? ProjectOutlineViewController
    }
    
    private var filesOutlineManager: FilesOutlineManager? {
        
        return projectOutlineViewController?.representedFilesOutlineManager
    }
    
    private let leftMargin: CGFloat = 4.0
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
        self.floatsGroupRows = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.floatsGroupRows = false
    }
    
    override func collapseItem(_ item: Any?, collapseChildren: Bool) {
        
        assert(self.filesOutlineManager != nil)
        if let filesOutlineManager = self.filesOutlineManager {
           
            assert(item is ProjectOutlineItem)
            if let projectOutlineItem = item as? ProjectOutlineItem {
        
                // #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("outlineViewItemDidCollapse with name: %@", log: Log.StyloCore.all, type: .info, %%projectOutlineItem.name.value)
                // #endif
                
                assert(self.projectOutlineViewController != nil)
                if let projectOutlineViewController = self.projectOutlineViewController {
          
                    // if there is a selected item under the expanded item
                    // we should leave it selected
                    if filesOutlineManager.isDescendantPartOfSelection(ofItemWithId: projectOutlineItem.id) {
                    
                        // in this case we know we will get notified of selection change
                        // we should make sure the selection does not get changed.
                        projectOutlineViewController.selectionChangeCausedByCollapse = true
                    }
                    
                    filesOutlineManager.removeExpandedItem(with: projectOutlineItem.id)
                }
            }
        }
        
        super.collapseItem(item, collapseChildren: collapseChildren)
        
        assert(self.projectOutlineViewController != nil)
        self.projectOutlineViewController?.selectionChangeCausedByCollapse = false
    }
    
    func expandParents(of item: Any?) {
        var item = item
        while item != nil {
            if let parent = self.parent(forItem: item) {
                if !self.isExpandable(parent) {
                    break
                }
                if !self.isItemExpanded(parent) {
                    self.expandItem(parent)
                }
                item = parent
            }
            else {
                item = nil
            }
        }
    }
    
    func select(item: Any?) {

        var itemIndex = self.row(forItem: item)
        if itemIndex < 0 {
            expandParents(of: item)
        }
        itemIndex = self.row(forItem: item)
        if itemIndex < 0 {
            return
        }
        self.selectRowIndexes(IndexSet([itemIndex]), byExtendingSelection: true)
    }
    
    override func highlightSelection(inClipRect clipRect: NSRect) {
        
        // do nothing
    }
    
    override func drawRow(_ row: Int, clipRect: NSRect) {
        
        super.drawRow(row, clipRect: clipRect)
        let rowRect = rect(ofRow: row)
        if self.selectedRowIndexes.contains(row) {
            NSColor.gray.setFill()
            rowRect.fill()
        }
    }
    
    override func makeView(withIdentifier identifier: NSUserInterfaceItemIdentifier, owner: Any?) -> NSView? {
        
        let view = super.makeView(withIdentifier: identifier, owner: owner)
        
        if identifier == NSOutlineView.disclosureButtonIdentifier {
            
            guard let disclosureButton = view as? NSButton else {
                assertionFailure("Error: view is not a diclosure button ")
                return nil
            }
            
            transparentButton(disclosureButton: disclosureButton)
        }
        return view
    }
    
    override func mouseDown(with event: NSEvent) {
        
        let eventSelectionType = self.eventSelectionType(fromEvent: event)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("mouseDown start in project outline view", log: Log.StyloCore.all, type: .info)
        os_log("mouseDown in row %@", log: Log.StyloCore.all, type: .info, %%row)
        os_log("eventSelectionType: %@", log: Log.StyloCore.all, type: .info, %%eventSelectionType)
        #endif
        
        assert(self.projectOutlineViewController != nil)
        self.projectOutlineViewController?.lastEventSelectionType = eventSelectionType
        
        super.mouseDown(with: event)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("mouseDown end in project outline view", log: Log.StyloCore.all, type: .info)
        #endif
    }
    
    private func eventSelectionType(fromEvent event: NSEvent) -> EventSelectionType {
        
        let locationInOutlineView: NSPoint = self.convert(event.locationInWindow, to: nil)
        // We noticed that clicking at the end of the end of the row cause
        // the row to be returned to be -1. So we modify the position to be
        // at the start of the outline frame to make sure we are in a row. 
        let startOfOutlineViewLocation: NSPoint = NSMakePoint(20.0, locationInOutlineView.y)
        let row = self.row(at: startOfOutlineViewLocation)
        let rowWasAlreadySelected = self.selectedRowIndexes.contains(row)
        let shiftKeyPressed = event.modifierFlags.contains(.shift)
        let commandKeyPressed = event.modifierFlags.contains(.command)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("shiftKeyPressed: %@", log: Log.StyloCore.all, type: .info, %%shiftKeyPressed)
        os_log("commandKeyPressed: %@", log: Log.StyloCore.all, type: .info, %%commandKeyPressed)
        #endif
        
        if rowWasAlreadySelected {
            
            // event if both shift and command key are pressed
            // outline view will interpret it as if only command key was pressed
            // and ignore the shift key
            if commandKeyPressed || shiftKeyPressed {
                return .shrinkSelection
            }
            else {
                assert(!commandKeyPressed)
                assert(!shiftKeyPressed)
                return .replaceSelection
            }
        }
        else  {
            
            // event if both shift and command key are pressed
            // outline view will interpret it as if only command key was pressed
            // and ignore the shift key
            if commandKeyPressed || shiftKeyPressed {
                return .extendSelection
            }
            else {
                assert(!commandKeyPressed)
                assert(!shiftKeyPressed)
                return .replaceSelection
            }
        }
    }
    
    override func level(forRow row: Int) -> Int {
        
        guard let item = self.item(atRow: row) as? ProjectOutlineItem else {
            assert(false, "Error: item at row: \(row) is not ProjectOutlineItem")
            return super.level(forRow: row)-1
        }
        
        if item.isTop {
            return 0
        }
        return super.level(forRow: row)-1
    }
    
    override func frameOfOutlineCell(atRow row: Int) -> NSRect {
        
        guard let item = self.item(atRow: row) as? ProjectOutlineItem else {
            assert(false, "Error: item at row: \(row) is not ProjectOutlineItem")
            return super.frameOfOutlineCell(atRow: row)
        }
        
        if item.isTop {
            return NSRect.zero
        }
        
        let cellFrame = super.frameOfOutlineCell(atRow: row)
        
        return NSMakeRect(cellFrame.origin.x-self.indentationPerLevel+leftMargin, cellFrame.origin.y, 16.0 /* stylo #1213 */, cellFrame.height)
    }
    
    override func frameOfCell(atColumn column: Int, row: Int) -> NSRect {
        
        let cellFrame = super.frameOfCell(atColumn: column, row: row)
        
        guard let item = self.item(atRow: row) as? ProjectOutlineItem else {
            assert(false, "Error: item at row: \(row) is not ProjectOutlineItem")
            return super.frameOfOutlineCell(atRow: row)
        }
        
        if item.isTop {
            return NSMakeRect(0, cellFrame.origin.y, self.bounds.width, cellFrame.height)
        }
        
        return NSMakeRect(cellFrame.origin.x-self.indentationPerLevel+leftMargin, cellFrame.origin.y, self.bounds.width, cellFrame.height)
    }
    
    private func transparentButton(disclosureButton: NSButton) {

        // collapse
        disclosureButton.alternateImage = NSImage(named: NSImage.Name("chevron.down"))
        // expand
        disclosureButton.image = NSImage(named: NSImage.Name("chevron.right"))
    }
}
