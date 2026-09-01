//
//  DomPathable.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-07-08.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public protocol DomPathable {
    
    var path: [Int] { get }
    
    var pathableParent: DomPathable? { get }
    
    var pathableChilds: [DomPathable]? { get }
    
    func pathable(at path: [Int]) -> DomInspectable?
}
