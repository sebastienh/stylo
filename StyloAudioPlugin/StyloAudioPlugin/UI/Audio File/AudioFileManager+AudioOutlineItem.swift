//
//  AudioFileManager+AudioOutlineItem.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common

extension AudioFileManager: AudioOutlineItem {
    
    var id: String {
        return self.identifier
    }

    var type: AudioOutlineItemType {
        return  .file
    }
    
    var isGroup: Bool {
        return false
    }
    
    var isTop: Bool {
        return false
    }
    
    var isExpandable: Bool {
        return false
    }
    
    var hasChildNodes: Bool {
        return false
    }
    
    var childs: [AudioOutlineItem]? {
        return nil
    }
    
    var numberOfChildren: Int {
        return 0
    }
    
    func childAtIndex(_ index: Int) -> AudioOutlineItem {
        fatalError("Error: AudioFileManager has no child")
    }
    
}
