//
//  TextEditorsOutlineViewItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-24.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

class TextEditorsOutlineItem {
    
    enum ItemType: Int {
        
        case title
        case editor
        case add
        
        static func topLevelItem(from rowIndex: Int) -> ItemType? {
            
            let rowType = rowIndex%2
            
            switch rowType {
                
            case 0:
                return .title
            case 1:
                return .add
            default:
                assertionFailure("Error: unsupported ")
                return nil
            }
        }
    }
    
    let id: String
    
    let itemType: ItemType
    
    init(id: String, itemType: ItemType) {
        
        self.id = id
        self.itemType = itemType
    }
    
}
