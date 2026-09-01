//
//  WorkingOverlayController.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public protocol WorkingOverlayController {
    
    var cancelWorkingOverlay: Bool { get }
    
    func cancelCurrentDocumentOverlay()
}
