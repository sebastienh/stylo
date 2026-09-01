//
//  StyleIdentifier.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-06.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon

public struct StyleMenuIdentifier {
    
    let title: String
    
    public weak var styleManager: StyleManager?
    
    init(_ styleManager: StyleManager) {
        self.title = styleManager.title
        self.styleManager = styleManager
    }
    
    mutating func updateWithStyleManager(_ styleManager: StyleManager) {
        
        self.styleManager = styleManager
    }
    
}
