//
//  AudioToolsViewController+NSOutlineViewDelegate.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa

extension AudioToolsViewController: NSOutlineViewDelegate {
    
    //////////////////////////////////////////////////////////////////////////////////
    //              MARK: NSOutlineViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return false
        }
        
        return audioOutlineItem.isGroup
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        
        assert(self.audioFilesManager?.audioPluginManager != nil)
        
        // reset the indicator because we cannot wait a recording
        // not from the editor since we can select things and we want
        // the editor to respond to these selections
        self.audioFilesManager?.audioPluginManager.notifyContentManager = true
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, rowViewForItem item: Any) -> NSTableRowView? {
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return nil
        }
        
        let audioFilesOutlineRowView = AudioFilesOutlineRowView()
        audioFilesOutlineRowView.audioOutlineItem = audioOutlineItem
        audioFilesOutlineRowView.audioFilesManager = self.audioFilesManager
        
        let selectionView = NSVisualEffectView(frame: .zero)
        audioFilesOutlineRowView.selectionView = selectionView
        audioFilesOutlineRowView.addSubview(selectionView)
        audioFilesOutlineRowView.selectionView?.autoresizingMask = [.width, .height]
        return audioFilesOutlineRowView
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor viewForTableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return nil
        }
        
        return self.view(for: audioOutlineItem)
    }
    
    func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
        
        guard let audioOutlineItem = item as? AudioOutlineItem else {
            assertionFailure("Error: item is not AudioOutlineItem")
            return 40
        }
        
        switch audioOutlineItem.type {
        case .title:
            return 24.5
        case .file:
            
            if outlineView.selectedRow != -1 {
                if let item = outlineView.item(atRow: outlineView.selectedRow) {
                    if let selectedAudioOutlineItem = item as? AudioFileManager {
                        if selectedAudioOutlineItem.id == audioOutlineItem.id {
                            return 126.0
                        }
                        else {
                            return 50.0
                        }
                    }
                    else {
                        return 50.0
                    }
                }
                else {
                    return 50.0
                }
            }
            else {
                return 50.0
            }
        }
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        
        guard let audioOutlineView = self.audioOutlineView else {
            assertionFailure("Error: self.audioOutlineView is nil")
            return
        }
        
        if audioOutlineView.selectedRow != -1 {
            
            guard let item = audioOutlineView.item(atRow: audioOutlineView.selectedRow) else {
                assertionFailure("Error: item at row: \(audioOutlineView.selectedRow) is nil")
                return
            }
            
            guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
                assertionFailure("Error: self.audioFilesOutlineManager is nil")
                return
            }
            guard let audioOutlineItem = item as? AudioOutlineItem else {
                assertionFailure("Error: item is not AudioOutlineItem")
                return
            }
            
            if shouldNotifySelectedItem {
                
                audioFilesOutlineManager.selectItem(withId: audioOutlineItem.id)
            }
        }
    }
    
    func outlineViewItemDidExpand(_ notification: Notification) {

        if shouldNotifyExpandedItem {
        
            let item = notification.userInfo!["NSObject"] as! AudioOutlineItem

            guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
                assertionFailure("Error: self.audioFilesOutlineManager is nil")
                return
            }
            
            audioFilesOutlineManager.addExpandedItem(withId: item.id)
        }
    }
    
    func outlineViewItemDidCollapse(_ notification: Notification) {
        
        if shouldNotifyExpandedItem {
        
            let item = notification.userInfo!["NSObject"] as! AudioOutlineItem
        
            guard let audioFilesOutlineManager = self.audioFilesOutlineManager else {
                assertionFailure("Error: self.audioFilesOutlineManager is nil")
                return
            }
            
            audioFilesOutlineManager.removeExpandedItem(withId: item.id)
        }
    }
    
}
