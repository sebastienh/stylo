//
//  Sidebar.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

@objc public protocol Sidebar {
    
    var stylePickerShown: Bool { get }
    
    var markdownToolsShown: Bool { get }
    
    @objc func selectStylesSidebarViewTab(_ sender: AnyObject?)
}
