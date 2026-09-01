//
//  MarkdownStyleReducer+SelectionStatistics.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-09-15.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo

extension MarkdownStyleReducer {
    
    func selectionStatistics<S: Store & StylableStoreType>(fromSelectionRange selectionRange: NSRange?, in store: S) -> TextStatistics? {
        
        guard let selectionRange = selectionRange else {
            return nil
        }
        
        if let selectionString = store.attributesStore.substring(from: selectionRange) {
            return TextStatistics.from(selectionString)
        }
        
        return nil
    }
    
}
