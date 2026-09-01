//
//  SelectionFilter.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-07-27.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

struct SelectionFilterOptions: OptionSet {
    
    let rawValue: Int
    
    static let pendingFollowingSiblingSelector = SelectionFilterOptions(rawValue: 1)
    
    static let forceScoping = SelectionFilterOptions(rawValue: 2)
}

protocol SelectionFilter: class {
    
    var reverseFilter: ReverseFilter { get }
    
}
