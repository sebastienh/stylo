//
//  AssemblyMembershipMetadata+AssemblyMembership.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension AppearanceMetadata {
    
    var appearanceMode: AppearanceMode? {
        switch self {
        case .dark:
            return .dark
        case .light:
            return .light
        case .UNRECOGNIZED(_):
            return nil
        }
    }
}

extension StylesheetMetadata {
    
    var appearanceModesSet: Set<AppearanceMode> {
        var set = Set<AppearanceMode>()
        for appearance in self.appearances {
            guard let appearanceMode = appearance.appearanceMode else {
                assertionFailure("Error: appearanceMode is nil")
                continue
            }
            set.insert(appearanceMode)
        }
        return set
    }
}
