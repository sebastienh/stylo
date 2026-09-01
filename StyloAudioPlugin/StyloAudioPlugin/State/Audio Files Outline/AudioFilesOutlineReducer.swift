//
//  AudioFilesOutlineReducer.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-09-13.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Igloo


enum AudioFilesOutlineAction: ActionType {
    
    case userUnselectedItem
    case userSelectedItem(id: String)
    case documentAudioExpanded(id: String)
    case documentAudioCollapsed(id: String)
    case updateSelectedFilesFilterActiveState(state: Bool)
}

class AudioFilesOutlineReducer: NSObject, Reducer, SerialReducer {
    
    let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.AudioFilesOutlineQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        super.init()
    }
    
    func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        guard let audioFilesOutlineAction = action as? AudioFilesOutlineAction else {
            assertionFailure("Error: action is not of type AudioFilesOutlineAction")
            return nil
        }
        
        guard let audioFilesOutlineStore = store as? AudioFilesOutlineStore else {
            assertionFailure("Error: store is not an AudioFilesOutlineStore")
            return nil
        }
        
        switch audioFilesOutlineAction {
        case .userUnselectedItem:
            audioFilesOutlineStore.selectedItem.setValue(nil, sameExecutionStack: true)
        case .userSelectedItem(let id):
            audioFilesOutlineStore.selectedItem.setValue(id)
        case .documentAudioExpanded(let id):
            audioFilesOutlineStore.expandedItems.insert(id)
        case .documentAudioCollapsed(let id):
            audioFilesOutlineStore.expandedItems.remove(id)
        case .updateSelectedFilesFilterActiveState(let newState):
            audioFilesOutlineStore.selectedFilesFilterActive.setValue(newState)
        }
        return nil 
    }
    

}
