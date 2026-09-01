//
//  StyloDocument+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension TextDocument: MetadataProvider {
    
    public typealias MetadataType = DocumentMetadata
    
    public var metadata: MetadataType? {
        
        assert(documentManager != nil)
        return documentManager?.metadata
    }
}

