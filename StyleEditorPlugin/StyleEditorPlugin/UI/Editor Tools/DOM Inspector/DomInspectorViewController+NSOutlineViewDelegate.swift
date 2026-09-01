//
//  DomInspectorViewController+NSOutlineViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web

extension DomInspectorViewController: NSOutlineViewDelegate {

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSOutlineViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DomElementCell"), owner: self) as! NSTableCellView
        
        if let textField = view.textField {
            
            textField.stringValue = domInspectorDelegate.objectValueForItem(document!, outlineView: outlineView, item: item as AnyObject?)! as String
        }
        
        return view
    }
    
    /// see http://stackoverflow.com/questions/11127764/how-to-customize-disclosure-cell-in-view-based-nsoutlineview
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        
        let tableRow = DomInspectorTableRowView()
        
        tableRow.domRenderable = domRenderable
        
        if let element = item as? Element {
            
            tableRow.item = element
        }
        
        return tableRow
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        let attributedStringValue = NSAttributedString(string: domInspectorDelegate.objectValueForItem(document!, outlineView: outlineView, item: item as AnyObject?)! as String, attributes:  [NSAttributedString.Key.font: NSFont.systemFont(ofSize: NSFont.systemFontSize)])
        
        let totalIdent = outlineView.indentationPerLevel * CGFloat(outlineView.level(forItem: item))
        
        let width = outlineView.tableColumns[0].width - totalIdent
        
        let rect = attributedStringValue.boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [NSString.DrawingOptions.usesLineFragmentOrigin, NSString.DrawingOptions.usesFontLeading, NSString.DrawingOptions.usesDeviceMetrics])
        
        // Magic number!!!
        return rect.height + 7
    }
    
    
    func outlineViewItemDidExpand(_ notification: Notification) {
        
        let item = notification.userInfo!["NSObject"] as! DomInspectable
        
        if !isExpanded(inspectable: item) {
            
            expandedItemsPaths.append(item.inspectablePath)
        }
    }
    
    func outlineViewItemDidCollapse(_ notification: Notification) {
        
        let item = notification.userInfo!["NSObject"] as! DomInspectable
        
        var collapsedItemIndex: Int?
        
        for (index, expandedItem) in expandedItemsPaths.enumerated() {
            
            if expandedItem == item.inspectablePath {
                
                collapsedItemIndex = index
            }
        }
        
        if let collapsedItemIndex = collapsedItemIndex {
            
            expandedItemsPaths.remove(at: collapsedItemIndex)
        }
    }

}
