//
//  AppearanceMode.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public enum AppearanceMode: String {
    
    case dark
    case light
    
    var stringValue: String {
        return self.rawValue
    }
    
    public var appearance: NSAppearance? {
        switch self {
        case .dark:
            return NSAppearance(named: NSAppearance.Name.darkAqua)
        case .light:
            return NSAppearance(named: NSAppearance.Name.aqua)
        }
    }
    
    func isValidAppearanceMode(string: String) -> Bool {
        if string == AppearanceMode.dark.stringValue || string == AppearanceMode.light.stringValue {
            return true
        }
        return false
    }
    
}
