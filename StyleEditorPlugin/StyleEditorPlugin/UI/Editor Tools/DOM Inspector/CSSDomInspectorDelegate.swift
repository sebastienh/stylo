//
//  CSSDomInspectorDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

final class CSSDomInspectorDelegate: DomInspectorDelegate {
    
    init() {
        // nothing to do
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSOutlineViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ document: Document?, outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        
        if document == nil {
            
            return 0
        }
        if let domInspectable = item as? DomInspectable{
            
            return domInspectable.numberOfChildren
        }
        else if item == nil {
            
            // we are at the start of the DOM tree a the document level. We want to show for HTML:
            // <!DOCTYPE html>
            // stylesheet
            return 1
        }
        assert(false, "item of type \(String(describing: type(of: item))) DomInspectable.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("item of type %@type DomInspectable.", log: Log.StyleEditor.all, type: .error, %%String(describing: type(of: item)))
        #endif
        return 0
    }
    
    func outlineView(_ document: Document?, domInspectorViewController: DomInspectorViewController, outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        
        if document == nil {
            
            assert(false, "Should not be called when there is no document since in func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int, we alwaus return 0 in this case.")
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Should not be called when there is no document since in func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int, we alwaus return 0 in this case.", log: Log.StyleEditor.all, type: .error)
            #endif
        }
        
        if let item = item {
            
            
            /// Use the DomInspectable protocol instead.
            switch item {
                
            case let element as Element:

                return element.childAtIndex(index)!
                
            default:
                
                assert(false, "unhandled item: \(item)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("unhandled root index: %@item", log: Log.StyleEditor.all, type: .error, %%item)
                #endif
            }
        }
        else {
            
            // item is nil
            switch index {
                
            case 0:
                
                return document!.documentElement as! CSSDOMStyleSheetElement
                
            default:
                
                assert(false, "unhandled root index: \(index)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("unhandled root index: %@index", log: Log.StyleEditor.all, type: .error, %%index)
                #endif
            }
        }
        
        return "Error!" as AnyObject
    }
    
    func outlineView(_ document: Document?, outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        
        return objectValueForItem(document, outlineView: outlineView, item: item)
    }
    
    func objectValueForItem(_ document: Document?, outlineView: NSOutlineView, item: AnyObject?) -> NSString? {
        
        if document == nil {
            
            return "Loading..."
        }
        
        switch item {
            
        case let domInspectableElement as DomInspectable:

            if outlineView.isItemExpanded(item) {
                
                return domInspectableElement.expandedOpenElementString as NSString?
            }
            else {
                
                return domInspectableElement.unexpandedElementString as NSString?
            }
            
        default:
            
            debugPrint("CSS DOM Inspector: \(String(describing: type(of: item!)))")
            
            return String(describing: type(of: item!)) as NSString?
        }
    }
    
}
