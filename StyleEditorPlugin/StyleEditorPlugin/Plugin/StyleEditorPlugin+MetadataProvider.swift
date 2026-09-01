//
//  StyleEditorPlugin+MetadataProvider.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2019-12-31.
//  Copyright © 2019 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension StyleEditorPlugin: MetadataProvider {
    
    typealias MetadataType = StyleSetMetadata
    
    var metadata: StyleSetMetadata? {
        
        return self.styleSetManager?.metadata
    }
    
}
