//
//  StyleSetManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension StyleSetManager {
    
    public typealias MetadataType = StyleSetMetadata
    
    private var stylesMetadata: [StyleMetadata] {
        return self.styleManagers.compactMap { (styleManager) -> StyleMetadata? in
            styleManager.metadata
        }
    }
    
    public var metadata: MetadataType {
        
        return StyleSetMetadata.with {
            
            $0.styles = stylesMetadata
        }
    }
}

