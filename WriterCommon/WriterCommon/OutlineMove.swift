//
//  OutlineMove.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public enum OutlineMove {
    
    case horizontal(id: String, oldIndex: Int, newIndex: Int)
    case vertical(id: String, oldIndex: Int, oldParent: String, newIndex: Int, newParent: String)
    
    var reversed: OutlineMove {
        switch self {
        case .horizontal(let id, let oldIndex, let newIndex):
            return .horizontal(id: id, oldIndex: newIndex, newIndex: oldIndex)
        case .vertical(let id, let oldIndex, let oldParent, let newIndex, let newParent):
            return .vertical(id: id, oldIndex: newIndex, oldParent: newParent, newIndex: oldIndex, newParent: oldParent)
        }
    }
    
}
