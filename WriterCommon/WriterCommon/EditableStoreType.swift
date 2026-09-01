//
//  EditableStoreType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-13.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import Web
import os

enum EditableStoreAction: ActionType {

    case setString(string: String)
    
    // only load the sourceString into the store
    case loadString(url: URL)
    
    case sourceStringChanged(description: SourceStringChangeDescription)
    
    case resetPendingChanges
}

enum EditableActionResult: ActionResult {
    
    case sourceStringChanged
    case loadedString(string: String)
    
    public var loadedString: String? {
        
        switch self {
        case .loadedString(let string):
            return string
        default:
            return nil
        }
    }
}

public protocol EditableStoreType {
    
    var sourceString: Dynamic<String?> { get }
    
    var editHistoryData: Data? { get }
    
    var editingChanges: DynamicArray<SourceStringChangeDescription> { get set }
}

extension EditableStoreType where Self: Store, Self.ReducerType: EditableReducerType {

    public var editHistoryData: Data? {

        var editHistory = EditHistory()
        
        for editingChange in self.editingChanges {
            editHistory.edits.append(editingChange.edit)
        }

        do {
            return try editHistory.jsonUTF8Data()
        }
        catch let error {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error while generating editing history: %@", log: Log.WriterCommon.all, type: .error, %%error)
            #endif
            return nil
        }
    }
}
