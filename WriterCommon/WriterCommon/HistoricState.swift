//
//  HistoricState.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct HistoricState: Equatable, CustomDebugStringConvertible {

    public var debugDescription: String {
    
        var string = ""
        string += "Historic State\n:"
        string += " - userSelectedItems\n:"
        for userSelectedItem in userSelectedItems {
            string += "   \(userSelectedItem)\n:"
        }
        string += " - expandedItems\n:"
        for expandedItem in expandedItems {
            string += "   \(expandedItem)\n:"
        }
        string += "\n"
        return string
    }
        
    public let userSelectedItems: Array<String>
    
    public let expandedItems: Set<String>
    
    public static var empty: HistoricState {
        
        return HistoricState(userSelectedItems: [], expandedItems: [])
    }
    
    init(filesOutlineStore: FilesOutlineStore) {
     
        self.init(userSelectedItems: filesOutlineStore.userSelectedItems.values.contents, expandedItems: Set<String>(filesOutlineStore.expandedItems.values))
    }
    
    init(userSelectedItems: Array<String>, expandedItems: Set<String>) {
        
        self.userSelectedItems = userSelectedItems
        self.expandedItems = expandedItems
    }
    
    public static func ==(lhs: HistoricState, rhs: HistoricState) -> Bool {
        
        if lhs.userSelectedItems != rhs.userSelectedItems {
            return false
        }
        if lhs.expandedItems != rhs.expandedItems {
            return false
        }
        return true
    }
}
