//
//  MacOSPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

///
/// ProjectPanelPlugin manage everything for
/// the project panel: including the project sidebar
/// button.
public protocol ProjectPanelPlugin {
    
    var projectPanels: [NavigatorTool]? { get }
    
    func documentWillDisableProjectPanel()
    
    func documentWillEnableProjectPanel()
    
}
