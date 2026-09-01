//
//  CopySelectorMenuItem.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-18.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Web
import WriterCommon

class CopySelectorMenuItem: NSMenuItem, ElementContainer {
    
    let element: Element?
    
    let sourceIndex: Int
    
    init(title string: String, action selector: ObjectiveC.Selector?, element: Element, sourceIndex: Int) {
        
        self.element = element
        self.sourceIndex = sourceIndex
        super.init(title: string, action: selector, keyEquivalent: "")
    }
    
    required init(coder decoder: NSCoder) {
        
        self.element = nil
        self.sourceIndex = 0
        super.init(coder: decoder)
    }
    
    
}
