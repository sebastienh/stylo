//
//  StylesheetTemplateReducer.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo


enum StylesheetTemplateAction: ActionType {
    
    case userUnselectedItem
    case userSelectedItem(id: String)
    case documentAudioExpanded(id: String)
    case documentAudioCollapsed(id: String)
    case updateSelectedFilesFilterActiveState(state: Bool)
}

class StylesheetTemplateReducer: NSObject, Reducer, SerialReducer {
    
    let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.StylesheetTemplatePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
        super.init()
    }
    
    func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
//        guard let audioFilesOutlineAction = action as? StylesheetTemplateAction else {
//            assertionFailure("Error: action is not of type AudioFilesOutlineAction")
//            return nil
//        }
//        
//        guard let stylesheetTemplateStore = store as? StylesheetTemplateStore else {
//            assertionFailure("Error: store is not an StylesheetTemplateStore")
//            return nil
//        }
//        
//        switch audioFilesOutlineAction {
//        case .userUnselectedItem:
//            audioFilesOutlineStore.selectedItem.setValue(nil, sameExecutionStack: true)
//        case .userSelectedItem(let id):
//            audioFilesOutlineStore.selectedItem.setValue(id)
//        case .documentAudioExpanded(let id):
//            audioFilesOutlineStore.expandedItems.insert(id)
//        case .documentAudioCollapsed(let id):
//            audioFilesOutlineStore.expandedItems.remove(id)
//        case .updateSelectedFilesFilterActiveState(let newState):
//            audioFilesOutlineStore.selectedFilesFilterActive.setValue(newState)
//        }
        return nil
    }
    

}
