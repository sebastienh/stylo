//
//  JsonManager.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

protocol JsonManager: NSObjectProtocol, Failable, EditorToolsPresenter, ResourceModelManager {
    
    var dispatcher: Dispatcher { get }
    
    var jsonStore: JsonStore { get }
    
}

