//
//  StyleMenuIdentifiersList.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-06.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon
import os

public struct StyleMenuIdentifiersList {
    
    public var stylesMenuIdentifiers: [String: StyleMenuIdentifier] = [:]
    
    init(stylesManagers: [StyleManager]) {
        for styleManager in stylesManagers {
            if stylesMenuIdentifiers[styleManager.title] != nil {
                stylesMenuIdentifiers[styleManager.title]!.updateWithStyleManager(styleManager)
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("adding style menu item with title: %@", log: Log.StyloCore.all, type: .info, %%styleManager.title)
                #endif
                stylesMenuIdentifiers[styleManager.title] = StyleMenuIdentifier(styleManager)
            }
        }
    }
}
