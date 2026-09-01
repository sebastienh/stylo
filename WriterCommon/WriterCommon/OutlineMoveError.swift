//
//  OutlineMoveError.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-13.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

enum OutlineMoveError: Error {
    
    case criticalError
    case destinationDoesNotExist
    case onlyDirectoryCanBecomeGroup
    case canNotMoveDirectoryUnderItself
    case itemWithSameNameAlreadyExist(name: String)
}

extension OutlineMoveError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        default:
            return NSLocalizedString("File move error:", comment: "")
        }
    }
    
    var failureReason: String? {
        switch self {
        case .destinationDoesNotExist: fallthrough
        case .criticalError:
            return NSLocalizedString("An error occured while moving items.", comment: "")
        case .onlyDirectoryCanBecomeGroup:
            return NSLocalizedString("Only directories can become group.", comment: "")
        case .canNotMoveDirectoryUnderItself:
            return NSLocalizedString("Cannot move a directory under itself.", comment: "")
        case .itemWithSameNameAlreadyExist(let name):
            return NSLocalizedString("A file with name: \"\(name)\" already exists in the target directory.", comment: "")
        }
    }
}
