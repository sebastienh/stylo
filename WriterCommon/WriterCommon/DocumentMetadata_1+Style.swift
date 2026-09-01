//
//  DocumentMetadata_1+Style.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-10-07.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

extension DocumentMetadata_1 {
    
    var styleId: String? {
        
        guard let sourceMetadata = self.sourceSet.sources[self.sourceSet.selectedSourceID] else {
            assertionFailure("Error: no source for id: \(self.sourceSet.selectedSourceID)")
            return nil
        }
        return sourceMetadata.styleID
    }
}
