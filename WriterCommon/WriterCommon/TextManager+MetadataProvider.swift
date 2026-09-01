//
//  TextManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation


extension TextManager: MetadataProvider {
    
    public typealias MetadataType = DirectoryItemMetadata
    
    public var metadata: DirectoryItemMetadata? {
        
        return DirectoryItemMetadata.with {
            
            $0.file = FileMetadata.with {
                $0.id = self.id
                
                /// the path of this element relative to the document
                /// it includes the file name
                $0.name = self.name.value + "." + self.ext.value
            }
        }
    }
}

