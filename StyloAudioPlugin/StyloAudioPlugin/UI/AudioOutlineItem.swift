//
//  AudioOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

enum AudioOutlineItemType {
    
    case title
    case file
}

protocol AudioOutlineItem {

    var id: String { get }
    
    var type: AudioOutlineItemType { get }
    
    var isGroup: Bool { get }
    
    var isTop: Bool { get }
    
    var isExpandable: Bool { get }
    
    var hasChildNodes: Bool { get }
    
    var childs: [AudioOutlineItem]? { get }
    
    var numberOfChildren: Int { get }
    
    func childAtIndex(_ index: Int) -> AudioOutlineItem
    
}
