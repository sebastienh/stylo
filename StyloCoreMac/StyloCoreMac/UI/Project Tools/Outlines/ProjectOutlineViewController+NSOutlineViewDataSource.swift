//
//  ProjectOutlineViewController+NSOutlineViewDataSource.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-07-25.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

extension ProjectOutlineViewController: NSOutlineViewDataSource {
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSOutlineViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let projectOutlineItem = item as? ProjectOutlineItem else {
            assertionFailure("Error: item is not a ProjectOutlineItem")
            return false
        }
        
        #if DEBUG && DEBUG_LOGS_ENABLED
        debugPrint("expandable: \(projectOutlineItem.isExpandable)")
        #endif
        
        return projectOutlineItem.isExpandable
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {

        if item == nil {
            
            guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
                assertionFailure("Error: nil sourceSetManager")
                return 0
            }
            guard let child = sourceSetManager.topLevelDirectory(at: index) else {
                assertionFailure("Error: no child at index: \(index)")
                return 0
            }
            return child
        }
        
        guard let projectOutlineItem = item as? ProjectOutlineItem else {
            assertionFailure("Error: item is not a ProjectOutlineItem")
            return "Error"
        }
        
        let child = projectOutlineItem.childAtIndex(index)
        
        #if DEBUG && DEBUG_LOGS_ENABLED
        debugPrint("child name: \(child.name.value)")
        #endif
        
        return child
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            
            guard let sourceSetManager = self.documentManager?._sourceSetManager.value else {
                assertionFailure("Error: nil sourceSetManager")
                return 0
            }
            
            guard let topDirectory = sourceSetManager.topDirectory else {
                assertionFailure("Error: sourceSetManager.topDirectory is nil")
                return 0
            }
            
            #if DEBUG && DEBUG_LOGS_ENABLED
            debugPrint("top directory")
            debugPrint("numberOfChildren: \(topDirectory.directoryItems.count)")
            #endif
            
            return topDirectory.directoryItems.count
        }
        
        guard let projectOutlineItem = item as? ProjectOutlineItem else {
            assertionFailure("Error: item is not a ProjectOutlineItem")
            return 0
        }
        
        #if DEBUG && DEBUG_LOGS_ENABLED
        debugPrint("item name: \(projectOutlineItem.name.value)")
        debugPrint("numberOfChildren: \(projectOutlineItem.numberOfChildren)")
        #endif
        
        return projectOutlineItem.numberOfChildren
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        
        guard let projectOutlineItem = item as? ProjectOutlineItem else {
            assertionFailure("Error: item is not a ProjectOutlineItem")
            return false
        }
        return projectOutlineItem.stringValue
    }
    
}
