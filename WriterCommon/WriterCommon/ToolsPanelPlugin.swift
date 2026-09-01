//
//  ToolsPanelPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-01-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public enum Mode {
    case read
    case write
}

public protocol ToolsPanelPlugin {
 
    var mode: Mode { get }
    
    var toolPanels: [ToolPanel]? { get }
    
    func toolsPanelDidCollapsed()
}
