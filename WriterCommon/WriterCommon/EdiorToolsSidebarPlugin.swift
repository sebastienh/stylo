//
//  EdiorToolsSidebarPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol EdiorToolsSidebarPlugin {
    
    var topToolsButtons: [DisableableButton]? { get }
    
    var middleToolsButtons: [DisableableButton]? { get }
}
