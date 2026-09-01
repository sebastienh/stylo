//
//  MacOSProjectPanel.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public enum PanelOrder: Int {
    
    case files
    case tags
    case audio
    
}

public struct NavigatorTool {
    
    public let originPluginName: String
    public let title: String
    public let order: PanelOrder
    public let viewController: PlateformViewControllerType
    public let buttonImage: NSImage
    public let buttonTooltip: String?
    
    public init(originPluginName: String, title: String, order: PanelOrder, viewController: PlateformViewControllerType, buttonImage: NSImage, buttonTooltip: String?) {
        
        self.originPluginName = originPluginName
        self.title = title
        self.order = order
        self.viewController = viewController
        self.buttonImage = buttonImage
        self.buttonTooltip = buttonTooltip
    }
}


