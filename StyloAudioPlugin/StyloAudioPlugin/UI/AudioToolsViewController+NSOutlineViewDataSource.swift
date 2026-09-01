//
//  AudioToolsViewController+NSOutlineViewDataSource.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import os
import Common

extension AudioToolsViewController: NSOutlineViewDataSource {
    
    ////////////////////////////////////////////////////////////////////////////////
    //                  MARK: NSOutlineViewDataSource protocol
    ////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return false
        }
        
        return audioOutlineItem.type == .title
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("Request for item at index: %@", log: Log.Audio.all, type: .info, %%index)
        #endif
        
        guard let audioOutlineItem = self.audioOutlineItem(child: index, ofItem: item) else {
            assertionFailure("Error: audioOutlineItem is nil")
            return false
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("Returning item with id: %@", log: Log.Audio.all, type: .info, %%audioOutlineItem.id)
        #endif
        
        return audioOutlineItem
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        let numberOfChildren = self.numberOfChildren(ofItem: item)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
        os_log("Request for number of children: %@", log: Log.Audio.all, type: .info, %%numberOfChildren)
        #endif
        
        return numberOfChildren
    }
    
}
