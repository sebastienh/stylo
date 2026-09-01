//
//  StylesheetManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-08-18.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension StylesheetManager: MetadataProvider {
    
    public typealias MetadataType = StylesheetMetadata
    
    public var metadata: MetadataType? {
        return StylesheetMetadata.with {
            $0.id = self.id
            $0.name = self.name.value
            $0.appearances = Array(self.appearances.values.map({ (appearanceMode) -> AppearanceMetadata in
                switch appearanceMode {
                case .dark:
                    return .dark
                case .light:
                    return .light
                }
            }))
        }
    }
}


