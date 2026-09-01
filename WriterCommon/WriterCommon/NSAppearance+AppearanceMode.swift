//
//  NSAppearance+AppearanceMode.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-10-04.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension NSAppearance {
    
    public var appearanceMode: AppearanceMode? {
        
        let appearanceName = self.bestMatch(from: [.darkAqua, .aqua])
        switch appearanceName {
        case .darkAqua?:
            return .dark
        case .aqua?:
            return .light
        default:
            assert(false)
            return nil
        }
    }
    
}
