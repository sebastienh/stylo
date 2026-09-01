//
//  ApplicationMenuPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-12-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol ApplicationMenuPlugin {
    
    static var applicationMenu: NSMenuItem? { get }
    
}
