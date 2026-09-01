//
//  DirectoryManager+ProjectOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension DirectoryManager: ProjectOutlineItem {
    
    var isGroup: Bool {
        return false
    }
    
    var isExpandable: Bool {
        return true
    }
    
    var isTop: Bool {
        
        guard let topDirectory = self.sourceSetManager?.topDirectory else {
            assertionFailure("Error: sourceSetManager.topDirectory is nil")
            return false
        }
        
        if self.parentID.value == topDirectory.id {
            return true
        }
        return false
    }
    
    var parent: ProjectOutlineItem? {
        return self.sourceSetManager?.directoryItemManager(withId: self.parentID.value) as? ProjectOutlineItem
    }
    
    var childs: [ProjectOutlineItem]? {
        return self.directoryItems.compactMap({ (directoryItemManager) -> ProjectOutlineItem? in
            
            guard let item = directoryItemManager as? ProjectOutlineItem else {
                assertionFailure("Error: directory item: \(directoryItemManager) is not a ProjectOutlineItem")
                return nil
            }
            return item
        })
    }
    
    var stringValue: String {
        return self.name.value
    }
    
    var numberOfChildren: Int {
        return self.directoryItemsIds.count
    }
    
    func hasChildNodes() -> Bool {
        return !self.directoryItemsIds.isEmpty
    }
    
    func childAtIndex(_ index: Int) -> ProjectOutlineItem {
        
        return self.directoryItems[index] as! ProjectOutlineItem
    }
}
