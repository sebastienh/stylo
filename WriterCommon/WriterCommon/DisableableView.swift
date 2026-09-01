//
//  DisableableView.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-01.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public protocol DisableableView {
    
    var wasEnabled: Bool { get set }
    
    var isEnabled: Bool { get set }
    
    func disableUserInteractions()
    
    func enableUserInteractions()
}
