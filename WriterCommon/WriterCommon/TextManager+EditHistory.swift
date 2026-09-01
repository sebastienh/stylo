//
//  TextManager+EditHistory.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-12-02.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension TextManager {
    
    public var editHistoryData: Data? {
        
        return self.markdownDocumentStore.editHistoryData
    }
    
}
