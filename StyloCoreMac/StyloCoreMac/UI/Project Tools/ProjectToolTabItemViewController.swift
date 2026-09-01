//
//  ProjectToolTabItemViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

public protocol ProjectToolTabItemViewController {
    
    var representedFilesOutlineManager: FilesOutlineManager? { get }
    
}
