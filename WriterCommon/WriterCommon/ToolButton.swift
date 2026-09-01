//
//  ToolButton.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-17.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public struct ToolButton {

    public typealias ButtonAction = (AnyObject?) -> ()
    
    public let name: String
    public let action: ButtonAction
    public let buttonImage: NSImage?
    
    public init(name: String, action: @escaping ButtonAction, buttonImage: NSImage? = nil) {
        
        self.name = name
        self.action = action
        self.buttonImage = buttonImage
    }
    
}
