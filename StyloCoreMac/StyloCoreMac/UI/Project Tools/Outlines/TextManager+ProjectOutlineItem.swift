//
//  TextManager+ProjectOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension TextManager: ProjectOutlineItem {
    
    var isTop: Bool {
        
        return false 
    }
    
    var isGroup: Bool {
        return false
    }
    
    var isExpandable: Bool {
        return false
    }
    
    var parent: ProjectOutlineItem? {
        
        guard let parent = self.sourceSetManager?.directoryItemManager(withId: self.parentID.value) as? ProjectOutlineItem else {
            assertionFailure("Error: parent item is nil")
            return nil
        }
        return parent
    }
    
    var childs: [ProjectOutlineItem]? {
        return nil
    }
    
    var stringValue: String {
        return self.name.value
    }
    
    var numberOfChildren: Int {
        return 0
    }
    
    func hasChildNodes() -> Bool {
        return false
    }
    
    func childAtIndex(_ index: Int) -> ProjectOutlineItem {
        fatalError("Error: childAtIndex called on TextManager")
    }
}
