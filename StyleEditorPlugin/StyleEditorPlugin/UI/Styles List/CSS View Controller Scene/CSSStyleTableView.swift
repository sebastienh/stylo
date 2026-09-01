//
//  CSSStyleTableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-12-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa


final class CSSStyleTableView: NSTableView {
    
    var draggingOperationInProgress: Bool = false
    
    var selectedTableRowView: Int?
    
    override func awakeFromNib() {
        
        intercellSpacing = NSMakeSize(0, 0.5)
        rowHeight = Constants.CSS.StylesListCell.CellHeight
        super.awakeFromNib()
    }
    
    func cssStyleTableViewCell(at index: Int) -> CSSStyleTableCellView? {
        
        let rowView = self.view(atColumn: 0, row: index, makeIfNecessary: true) as? CSSStyleTableCellView
        
        assert(rowView != nil)
        return rowView
    }
    
    func disableAllTableCellViews() {
        
        for i in 0..<numberOfRows {
        
            if let rowView = self.view(atColumn: 0, row: i, makeIfNecessary: false) {
                
                assert(rowView is CSSStyleTableCellView)
                if let styletableRowView = rowView as? CSSStyleTableCellView {
                    
                    styletableRowView.isEnabled = false
                    let _rowView = self.view(atColumn: 0, row: i, makeIfNecessary: true)
                    assert(_rowView != nil)
                }
            }
        }
        self.isEnabled = false
    }
    
    func enableAllTableCellViews() {
        
        for i in 0..<numberOfRows {
            
            if let rowView = self.view(atColumn: 0, row: i, makeIfNecessary: true) {
                
                assert(rowView is CSSStyleTableCellView)
                if let styletableRowView = rowView as? CSSStyleTableCellView {
                    styletableRowView.isEnabled = true
                }
            }
        }
        self.isEnabled = true
    }
}

