//
//  StyloAudioPlugin+MetadataProvider.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-03.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon

extension StyloAudioPlugin: MetadataProvider {
    
    typealias MetadataType = AudioFilesMetadata
    
    var metadata: AudioFilesMetadata? {
        
        return self.audioPluginManager?.metadata
    }
    
}
