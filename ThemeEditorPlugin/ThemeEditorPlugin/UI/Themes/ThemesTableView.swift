//
//  CSSStyleTableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-12-29.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import StyloCoreMac

final class ThemesTableView: ClickableRowTableView {
    
    var selectedTableRowView: Int?
    
    override func awakeFromNib() {
        
        intercellSpacing = NSMakeSize(0, 1)
        rowHeight = Constants.Themes.StylesListCell.CellHeight
        super.awakeFromNib()
    }
    
    func themesTableViewCell(at index: Int) -> ThemesTableCellView? {
        
        let rowView = self.view(atColumn: 0, row: index, makeIfNecessary: true) as? ThemesTableCellView
        
        assert(rowView != nil)
        return rowView
    }
    
    func disableAllTableCellViews() {
        
        for i in 0..<numberOfRows {
        
            if let rowView = self.view(atColumn: 0, row: i, makeIfNecessary: false) {
                
                assert(rowView is ThemesTableCellView)
                if let styletableRowView = rowView as? ThemesTableCellView {
                    
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
                
                assert(rowView is ThemesTableCellView)
                if let styletableRowView = rowView as? ThemesTableCellView {
                    styletableRowView.isEnabled = true
                }
            }
        }
        self.isEnabled = true
    }
}
