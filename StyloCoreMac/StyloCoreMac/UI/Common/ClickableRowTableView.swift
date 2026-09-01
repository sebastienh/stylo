//
//  ClickableRowTableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

open class ClickableRowTableView: NSTableView {
    
    var draggingOperationInProgress: Bool = false
    
    override init(frame frameRect: NSRect) {
        
        super.init(frame: frameRect)
    }

    required public init?(coder: NSCoder) {

        super.init(coder: coder)
    }
    
    override public func mouseDown(with theEvent: NSEvent) {
        
        let globalLocation: NSPoint = theEvent.locationInWindow
        let localLocation: NSPoint = convert(globalLocation, from: nil)
        let clickedRow: NSInteger = row(at: localLocation)
        
        super.mouseDown(with: theEvent)
    
        if !draggingOperationInProgress {
            if (clickedRow != -1) {
                if let extendedDelegate = delegate as? ExtendedTableViewDelegate {
                    extendedDelegate.tableView(self, didClickedRow: clickedRow)
                }
            }
        }
        else {
            draggingOperationInProgress = false
        }
    }
}
