//
//  ToolPanel.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct ToolPanel {
    
    public let name: String
    public let viewController: PlateformViewControllerType
    public let buttonImage: NSImage
    public let buttonTooltip: String?
    
    public init(name: String, viewController: PlateformViewControllerType, buttonImage: NSImage, buttonTooltip: String?) {
        
        self.name = name
        self.viewController = viewController
        self.buttonImage = buttonImage
        self.buttonTooltip = buttonTooltip
    }
}
