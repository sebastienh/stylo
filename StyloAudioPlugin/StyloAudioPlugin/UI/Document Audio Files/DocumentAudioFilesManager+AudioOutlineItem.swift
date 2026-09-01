//
//  DocumentAudioFilesManager+AudioOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension DocumentAudioFilesManager: AudioOutlineItem {
    
    var id: String {
        return self.identifier
    }
    
    var type: AudioOutlineItemType {
        return  .title
    }
    
    var isGroup: Bool {
        return true
    }
    
    var isTop: Bool {
        return true
    }
    
    var isExpandable: Bool {
        return self.hasChildNodes
    }
    
    var hasChildNodes: Bool {
    
        return !self.isEmpty
    }
    
    var parent: AudioOutlineItem? {
        
        return nil
    }
    
    var childs: [AudioOutlineItem]? {
        
        return self.audioFiles
    }
    
    var numberOfChildren: Int {
        
        return self.audioFilesCount
    }
    
    func childAtIndex(_ index: Int) -> AudioOutlineItem {
        
        guard let audioFileManager = self.audioFileManager(atIndex: index) else {
            fatalError("Error: no audioFileManager at index: \(index)")
        }
        return audioFileManager
    }
    
}
