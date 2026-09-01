//
//  StyleReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-06-19.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

enum StyleAction: ActionType {

    case select
    case unselect
    case registerStyleAssembly(descriptor: StyleAssemblyDescriptor, id: StyleAssembly.Id)
    case incrementRegistrantCount(descriptor: StyleAssemblyDescriptor)
    case decrementRegistrantCount(descriptor: StyleAssemblyDescriptor)
    case updateTitle(title: String)
}

enum StyleResult: ActionResult {
    
    case styleAssemblyStore(value: StyleAssemblyStore)
    
}

public struct StyleReducer: Reducer, SerialReducer {

    // strongly referenced by the StyleStore
    public let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.StyleStoreQueueNamePrefix + storeIdentifier)
    }

    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let styleStore = store as? StyleStore else {
            assertionFailure("Error: store is not StyleStore")
            return nil
        }
        
        guard let styleAction = action as? StyleAction else {
            assertionFailure("Error: action is not StyleAction")
            return nil
        }

        switch styleAction {
        case .incrementRegistrantCount(let descriptor):
            incrementAssemblyRegistrantCount(forStyleAssemblyDescriptor: descriptor, inStore: styleStore)
        case .decrementRegistrantCount(let descriptor):
            decrementAssemblyRegistrantCount(forStyleAssemblyDescriptor: descriptor, inStore: styleStore)
        case .select:
            styleStore.selectedStyle.setValue(true)
        case .unselect:
            styleStore.selectedStyle.setValue(false)
        case .registerStyleAssembly(descriptor: let descriptor, id: let id):
            styleStore.styleAssemblies.updateValue(id, forKey: descriptor)
        case .updateTitle(let title):
            styleStore.title.setValue(title)
        }
        return nil
    }
 
    ///
    /// This method decrement the number of registrers (editors) to a style temporary assembly
    /// we dont need this for permanent style assembly since we always keep
    ///
    private func decrementAssemblyRegistrantCount(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor, inStore styleStore: StyleStore) {
        
        guard let actual = styleStore.registrantCounts.values[descriptor] else {
            assertionFailure("Error: no actual registrer")
            return
        }
        
        if actual == 1 {
            styleStore.registrantCounts.removeValue(forKey: descriptor)
            return
        }
        styleStore.registrantCounts.updateValue(actual-1, forKey: descriptor)
    }
    
    private func incrementAssemblyRegistrantCount(forStyleAssemblyDescriptor descriptor: StyleAssemblyDescriptor, inStore styleStore: StyleStore) {
        
        let actual = styleStore.registrantCounts.values[descriptor] ?? 0
        styleStore.registrantCounts.updateValue(actual + 1, forKey: descriptor)
    }
    
}


