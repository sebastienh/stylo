//
//  ExportPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-20.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

public protocol ExportPlugin {
    
    var uti: String { get }
    
    var previewData: Data? { get }
    
    var exportPanel: ExportPanel? { get }
    
    /// Method to prepare the view controller with the data
    /// and when ready should return the name of the plugin... 
    func prepareData(for textManagers: [TextManager]) -> Promise<String>
}
