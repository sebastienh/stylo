//
//  AudioFileStore+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-27.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf
import WriterCommon

extension AudioFileStore: MetadataProvider {
    
    public typealias MetadataType = AudioFileMetadata
    
    public var metadata: AudioFileMetadata? {
        
        return AudioFileMetadata.with {
            
            $0.id = self.identifier
            $0.audioFormat = self.audioFormat
            $0.name = self.name.value
            $0.sampleRate = self.sampleRate
            $0.mode = self.channelsMode
            $0.audioQuality = self.audioQuality
            if let recordedDate = self.recordedDate.value {
                $0.recordedDate = SwiftProtobuf.Google_Protobuf_Timestamp(date: recordedDate)
            }
        }
    }
    
}
