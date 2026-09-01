//
//  DocumentStoreActionResult.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-16.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Web

enum DocumentStoreActionResult: ActionResult {

    case updated(updates: [UpdateDocumentResult])
    case topElementsAroundRange(elements: ContiguousArray<Element>?)
    
    var topElementsAroundRange: ContiguousArray<Element>? {
        switch self {
        case .topElementsAroundRange(let elements):
            return elements
        case .updated:
            assertionFailure("Error: updated document result does not contain topElementsAroundRange value")
            return nil
        }
    }
        
    var lastCompiledDocument: Document? {
        switch self {
        case .topElementsAroundRange:
            return nil
        case .updated(let updates):
            guard let lastUpdate = updates.last else {
                assertionFailure("Error: updates.last is nil")
                return nil
            }
            return lastUpdate.document
        }
    }
    
    var containsCompleteUpdate: Bool {
        
        guard let updateDocumentResults = self.updateDocumentResults else {
            assertionFailure("Error: updateDocumentResults is nil")
            return false
        }
    
        for updateDocumentResult in updateDocumentResults {
            switch updateDocumentResult.type {
            case .complete:
                return true
            case .partial:
                break
            }
        }
        return false
    }
    
    var updateDocumentResults: [UpdateDocumentResult]? {
        switch self {
        case .topElementsAroundRange:
            return nil
        case .updated(let updates):
            return updates
        }
    }
    
}
    
