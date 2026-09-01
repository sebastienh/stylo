//
//  CSSThemable.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-12.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol CSSThemable {
    
    func startListeningToCSSThemeChange()
    func stopListeningToCSSThemeChange()
    
    func handleCSSThemeChange(forced: Bool)
    
}
