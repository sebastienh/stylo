//
//  StyloPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public typealias PluginName = String

public protocol StyloPlugin {
    
    var name: PluginName { get }
    
    func pluginDidLoad()
}
