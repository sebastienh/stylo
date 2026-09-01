//
//  StyloPlugin.swift
//  CoreStylo
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation

public protocol StyloPlugin {
    
    var documentManager: DocumentManagerProtocol { get set }
    
    var name: String { get }
    
    init(documentManager: DocumentManagerProtocol)
    
    func pluginDidLoad()
    
}
