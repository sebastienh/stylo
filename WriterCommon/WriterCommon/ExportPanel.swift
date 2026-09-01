//
//  ExportPanel.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-20.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public struct ExportPanel {
    
    public let name: String

    public let panelViewController: PlateformViewControllerType
    
    public init(name: String, panelViewController: PlateformViewControllerType) {

        self.name = name
        self.panelViewController = panelViewController
    }
    
    
}
