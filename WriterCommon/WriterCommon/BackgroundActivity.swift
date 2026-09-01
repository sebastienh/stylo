//
//  BackgroundActivity.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-11-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

public protocol BackgroundActivity {
    
    var name: String { get }
    
    var requiresEditorControlsDisplay: Bool { get }
    
}
