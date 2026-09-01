//
//  PositionableState.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

protocol PositionableState: class {
    
    var posMax: Int { get }
    
    var pos: Int { get set }
}
