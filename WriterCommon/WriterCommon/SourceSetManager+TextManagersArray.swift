//
//  SourceSetManager+TextManagersArray.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-10-28.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension SourceSetManager {
    
    var textManagersIdsArray: [String] {
        
        var textManagersIdsArray = [String]()
        loadRootDirectoryTextManagersIds(in: &textManagersIdsArray)
        return textManagersIdsArray
    }
    
    func loadRootDirectoryTextManagersIds(in textManagersIdsArray: inout [String]) {
        
        guard let topDirectory = self.topDirectory else {
            assertionFailure("Error: self.topDirectory is nil")
            return
        }
        
        loadDirectoryTextManagersIds(topDirectory, in: &textManagersIdsArray)
    }
    
    private func loadDirectoryTextManagersIds(_ directoryManager: DirectoryManager, in textManagersIdsArray: inout [String]) {
        
        for directoryItem in directoryManager.directoryItems {
            switch directoryItem {
            case let directoryManager as DirectoryManager:
                loadDirectoryTextManagersIds(directoryManager, in: &textManagersIdsArray)
            case let textManager as TextManager:
                textManagersIdsArray.append(textManager.id)
            default:
                assertionFailure("Error: unhandled directory item type: \(type(of: directoryItem))")
                continue
            }
        }
    }
}
