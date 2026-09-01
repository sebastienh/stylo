//
//  DomRenderingComponent.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-01-07.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Web

public protocol DomRenderingComponent {
    
    func reveal(node: DomInspectable)
    
    func reload()
}
