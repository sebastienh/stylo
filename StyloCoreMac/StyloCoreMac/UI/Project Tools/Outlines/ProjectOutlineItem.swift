//
//  ProjectOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

protocol ProjectOutlineItem {
    
    var id: String { get }
    
    var name: Dynamic<String> { get }
    
    var isGroup: Bool { get }
    
    var isTop: Bool { get }
    
    var isExpandable: Bool { get }
    
    var parent: ProjectOutlineItem? { get }
    
    var childs: [ProjectOutlineItem]? { get }
    
    var stringValue: String { get }
    
    var numberOfChildren: Int { get }
    
    func hasChildNodes() -> Bool
    
    func childAtIndex(_ index: Int) -> ProjectOutlineItem
    
    func rename(to newName: String) throws
}
