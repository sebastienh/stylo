//
//  VirtualElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-08-10.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

struct VirtualElement {
    
    let virtualElementId: UUID
    
    let elementRef: UUID
    
    let elementName: String
    
    let sourceStringFragment: SourceStringFragment
    
    let classNames: [String]
    
    let elementId: String
    
    let attributes: [String: String]
    
    let children: [UUID]
}
