//
//  Themable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-02-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol Themable {
    
    func startListeningToThemeChange()
    func stopListeningToThemeChange()
    
    func handleThemeChange(forced: Bool)
    
}
