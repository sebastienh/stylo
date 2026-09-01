//
//  HtmlDomInspectorDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import os

final class HtmlDomInspectorDelegate: DomInspectorDelegate {
    
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
        if let domInspectable = item as? DomInspectable {
            
            return domInspectable.numberOfChildren
        }
        else if item == nil {
            
            // we are at the start of the DOM tree a the document level. We want to show for HTML:
            // doctype html
            // html
            //  head
            //  body
            return 4
        }
        
        assert(false, "item of type \(String(describing: type(of: item))) DomInspectable.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Unsupported item type in Dom inspector: %@", log: Log.StyleEditor.all, type: .error, %%String(describing: type(of: item)))
        #endif
        
        return 0
    }
        
    func outlineView(_ document: Document?, domInspectorViewController: DomInspectorViewController, outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        
        let htmlDocument = document as! HtmlDocument
        
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
                
                if element.hasChildNodes() {

                    return element.childAtIndex(index)!
                }
                else {
                    
                    assert(false, "Error: we ask for a absent children index.")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Error: we ask for a absent children index.", log: Log.StyleEditor.all, type: .error)
                    #endif
                }
                
            default:
                
                assert(false, "Unhandled item: \(item)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Unhandled item: %@", log: Log.StyleEditor.all, type: .error, %%item)
                #endif
            }
        }
        else {
            
            // item is nil
            switch index {
                
            case 0:
                
                // return the DocumentType
                return document!.doctype!
                
            case 1:
                
                // return the document html end tag
                return document!.documentElement as! HTMLHtmlElement
                
            case 2:
                
                // return the document head HTMLHeadElement
                return htmlDocument.head!
                
            case 3:
                
                // return the document body HTMLBodyElement
                return htmlDocument.body
                
            case 4:
                
                // return the document html end tag
                return document!.documentElement
                
            default:
                
                assert(false, "unhandled root index: \(index)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Unhandled root item: %@", log: Log.StyleEditor.all, type: .error, %%index)
                #endif
            }
        }
        return htmlDocument.body
    }
    
    func outlineView(_ document: Document?, outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        
        return objectValueForItem(document, outlineView: outlineView, item: item)
    }
    
    func objectValueForItem(_ document: Document?, outlineView: NSOutlineView, item: AnyObject?) -> NSString? {
        
        if document == nil {
            
            return "Loading..."
        }
        
        if let domInspectableElement = item as? DomInspectable {
            
            if outlineView.isItemExpanded(item) {
                
                return domInspectableElement.expandedOpenElementString as NSString?
            }
            else {
                return domInspectableElement.unexpandedElementString as NSString?
            }
        }
        return nil
    }
    
    
}
