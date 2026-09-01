//
//  DomInspectorDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-12.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web

protocol DomInspectorDelegate: class {
    
    func outlineView(_ document: Document?, outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int
    
    func outlineView(_ document: Document?, domInspectorViewController: DomInspectorViewController, outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject
    
    func outlineView(_ document: Document?, outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject?
    
    func objectValueForItem(_ document: Document?, outlineView: NSOutlineView, item: AnyObject?) -> NSString?
    
}
