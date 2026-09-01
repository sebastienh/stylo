//
//  SourceSetManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation


extension SourceSetManager: MetadataProvider {
    
    public typealias MetadataType = SourceSetMetadata
    
    public var metadata: SourceSetMetadata? {
        
        return SourceSetMetadata.with {
            
            guard let topDirectoryMetadata = self.topDirectory?.metadata?.directory else {
                assertionFailure("Error: self.topDirectory?.metadata?.directory is nil")
                return
            }
            $0.items = topDirectoryMetadata.items
        }
    }
}

