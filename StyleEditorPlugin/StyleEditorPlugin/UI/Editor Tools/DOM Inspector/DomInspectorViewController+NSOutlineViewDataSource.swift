//
//  DomInspectorViewController+NSOutlineViewDataSource.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-02-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web

extension DomInspectorViewController: NSOutlineViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSOutlineViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        if document == nil {
            
            return false
        }
        else if let domInspectable = item as? DomInspectable {
            
            return domInspectable.expandable
        }
        
        #if DEBUG
            debugPrint("item of type \(String(describing: type(of: item))) DomInspectable.")
        #endif
        
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        return domInspectorDelegate.outlineView(document, domInspectorViewController: self, outlineView: outlineView, child: index, ofItem: item as AnyObject?)
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if let domInspectorDelegate = domInspectorDelegate {
            
            return domInspectorDelegate.outlineView(document, outlineView: outlineView, numberOfChildrenOfItem: item as AnyObject?)
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        return domInspectorDelegate.outlineView(document, outlineView: outlineView, objectValueForTableColumn: tableColumn, byItem: item as AnyObject?)
    }
    
}
