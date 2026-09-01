//
//  StylesheetsTableView.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-08-17.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class StylesheetsTableView: NSTableView {
    
    var draggingOperationInProgress: Bool = false
    
    var totalHeight: CGFloat? {
         
        let rowHeight = self.rowHeight
        let height = (rowHeight + self.intercellSpacing.height) * CGFloat(self.numberOfRows)
        return height
    }
 
    override var intrinsicContentSize: NSSize {
        
        guard let totalHeight = self.totalHeight else {
            assertionFailure("Error: self.totalHeight is nil")
            return NSSize(width: NSView.noIntrinsicMetric, height: NSView.noIntrinsicMetric)
        }
        
        return NSSize(width: NSView.noIntrinsicMetric, height: totalHeight)
    }
    
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()
        self.setContentHuggingPriority(.required, for: .vertical)
        self.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
}
