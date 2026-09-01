//
//  AudioFileManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon

extension AudioFileManager: MetadataProvider {
    
    public typealias MetadataType = AudioFileMetadata
    
    public var metadata: AudioFileMetadata? {
        
        return self.audioFileStore.metadata
    }
}
