//
//  StylesheetDocumentReducer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public enum StylesheetDocumentResult: ActionResult {
    
    case createdStylesheet(stylesheet: CSSStyleSheet)
    
    case stylesheetCompiled(value: Bool)
    
    var stylesheet: CSSStyleSheet? {
        switch self {
        case .createdStylesheet(let stylesheet):
            return stylesheet
        case .stylesheetCompiled:
            return nil
        }
    }
}

public struct StylesheetDocumentReducer: Reducer, FailableReducerType, SerialReducer {
    
    public var serialQueue: DispatchQueue {
        return serialCompilationQueue
    }
    
    let serialCompilationQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialCompilationQueue = DispatchQueue(label: Constants.Queues.CssDocumentStoreCompilationQueueNamePrefix + storeIdentifier, qos: DispatchQoS.userInteractive)
    }
    
    public func handleAction<S>(store: S, action: ActionType) throws -> ActionResult? where S : Store {
        
        var result: ActionResult?
        
        if let stylesheetDocumentStore = store as? StylesheetDocumentStore {
            
            switch action {
                
            case let errorMessagesAction as FailableStoreAction:
                
                switch errorMessagesAction {
                case .updateErrorMessages:
                
                    // we read from the document
                    if let document = stylesheetDocumentStore.document.value {
                        
                        // we always get all the errors (in the background) because we don't
                        // want to manage the errors on a change basis... It's not too
                        // demanding since the bulk of the job is done in the background
                        let errors = self.allDocumentMessages(document: document)
                        stylesheetDocumentStore.errorMessages.removeAll(notify: false)
                        stylesheetDocumentStore.errorMessages.append(contentsOf: errors)
                    }
                    else {
                        stylesheetDocumentStore.errorMessages.removeAll(notify: true)
                    }
                    
                default:
                    
                    assertionFailure("Not handling FailableStoreAction: \(errorMessagesAction)")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Not handling FailableStoreAction: %@", log: Log.WriterCommon.all, type: .error, %%errorMessagesAction)
                    #endif
                    break
                }
                
            case let documentStoreAction as DocumentStoreAction:
                switch documentStoreAction {
            
                case .compileInitialDocument(let description):
                    
                    if let stylesheet = self.createStylesheet(description: description, store: stylesheetDocumentStore) {
                        self.updateLastAppliedStylesheet(stylesheetDocumentStore)
                        result = StylesheetDocumentResult.createdStylesheet(stylesheet: stylesheet)
                    }
                    else {
                        assertionFailure("stylesheet is nil")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("stylesheet is nil", log: Log.WriterCommon.all, type: .error)
                        #endif
                    }
                case .topElementsAroundRange:
                    assertionFailure("Error: topElementsAroundRange is not implemented")
                    break
                }
                
            case let stylesheetDocumentAction as StylesheetDocumentAction:
                
                switch stylesheetDocumentAction {
                case .stylesheetCompiled:
                    let compiled = stylesheetDocumentStore.stylesheet.value != nil
                    result = StylesheetDocumentResult.stylesheetCompiled(value: compiled)
                case .removeAppearance(let appearance):
                    stylesheetDocumentStore.appearances.remove(appearance)
                    
                case .addAppearance(let appearance):
                    stylesheetDocumentStore.appearances.insert(appearance)
                    
                case .createInitialStylesheet(let source):
                    
                    let description = SourceStringChangeDescription(string: source, originalString: nil)
                    if let stylesheet = self.createStylesheet(description: description, store: stylesheetDocumentStore) {
                        self.updateLastAppliedStylesheet(stylesheetDocumentStore)
                        result = StylesheetDocumentResult.createdStylesheet(stylesheet: stylesheet)
                    }
                    else {
                        assertionFailure("stylesheet is nil")
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("stylesheet is nil", log: Log.WriterCommon.all, type: .error)
                        #endif
                    }
                    
                case .loadStylesheet(let url):
                    
                    // We use this action when the stylesheet is not loaded
                    // from the UI, meaning this is a background load, for user agent
                    // stylesheets for example.
                    do {
                        
                        let contents = try String(contentsOf: url)
                        let sourceString = contents
                        
                        /// Take a copy of the string used to create this style sheet the goal is
                        /// to make the serialisation faster because we have the String.
                        stylesheetDocumentStore.sourceString.setValue(contents)
                            
                        // CREATE THE STYLESHEET
                        if let stylesheet = self.compileStylesheet(string: sourceString, origin: stylesheetDocumentStore.origin) {
                            
                            stylesheetDocumentStore.stylesheet.setValue(stylesheet)
                            self.updateLastAppliedStylesheet(stylesheetDocumentStore)
                            
                            // once the stylesheet is created, a user agent stylesheet
                            // is considered loaded.
                            result = StylesheetDocumentResult.createdStylesheet(stylesheet: stylesheet)
                        }
                        else {
                            let error = NWError.nilStylesheet
                            debugPrint("Error: \(error)")
                        }
                    }
                    catch {
                        let error = NWError.unableToLoad(url: url)
                        debugPrint("Error: \(error)")
                    }
                }
                
            case let editableStoreAction as EditableStoreAction:
                
                switch editableStoreAction {
                    
                case .sourceStringChanged(let description):
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("sourceStringChanged action handling with description: %@", log: Log.WriterCommon.all, type: .debug, %%description)
                    #endif
                    
                    stylesheetDocumentStore.sourceString.value?.update(withSourceStringChangeDescription: description)
                    
                    // We always compute the attributes even if:
                    // description.changeLength == 0 && description.stringReplacement.length == 0
                    // because we want to compute the document attributes even in the case a document
                    // is empty.
                    self.saveEditingChange(description: description, in: stylesheetDocumentStore)
                    if let updates = self.updateDocument(store: stylesheetDocumentStore, description: description, shouldUpdateAttributes: true) {
                        result = DocumentStoreActionResult.updated(updates: updates)
                    }
                    
                case .loadString(let url):
                    
                    do {
                        let contents = try String(contentsOf: url)
                        
                        /// Take a copy of the string used to create this style sheet the goal is
                        /// to make the serialisation faster because we have the String.
                        stylesheetDocumentStore.sourceString.setValue(contents)
                        result = EditableActionResult.loadedString(string: contents)
                    }
                    catch {
                        let error = NWError.unableToLoad(url: url)
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Error: %@", log: Log.WriterCommon.all, type: .error, %%error)
                        #endif
                    }
                    
                case .setString(let string):
                        
                    /// Take a copy of the string used to create this style sheet the goal is
                    /// to make the serialisation faster because we have the String.
                    stylesheetDocumentStore.sourceString.setValue(string)
                    self.saveEditingChange(string: string, in: stylesheetDocumentStore)
                    
                case .resetPendingChanges:
                    
                    self.serialCompilationQueue.async {
                        self.updateLastAppliedStylesheet(stylesheetDocumentStore)
                        stylesheetDocumentStore.hasPendingChanges.setValue(false)
                    }
                }

            default:
                assertionFailure("Not handling SyncAction type: \(action)")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Not handling SyncAction type: %@", log: Log.WriterCommon.all, type: .error, %%action)
                #endif
                break
            }
            
            recordNewPendingChangesIfNecesary(stylesheetDocumentStore)
        }

        return result
        
    }
    
    func updateLastAppliedStylesheet(_ stylesheetDocumentStore: StylesheetDocumentStore) {

//        assert(!stylesheetDocumentStore.hasPendingChanges.value)
        let stylesheet = stylesheetDocumentStore.stylesheet.value

        assert(stylesheet != nil)
        if let stylesheet = stylesheet {
            stylesheetDocumentStore.lastAppliedStylesheet = stylesheet.clone()
        }
    }

    func recordNewPendingChangesIfNecesary(_ stylesheetDocumentStore: StylesheetDocumentStore) {

        // update the pending changes if necessary
        self.serialCompilationQueue.async {

            if !stylesheetDocumentStore.hasPendingChanges.value {

                guard let stylesheet = stylesheetDocumentStore.stylesheet.value else {
                    // this one can possibly be false
//                    assert(false)
                    return
                }

                guard let lastAppliedStylesheet = stylesheetDocumentStore.lastAppliedStylesheet else {
                    assert(false)
                    return
                }

                if !lastAppliedStylesheet.equals(to: stylesheet) {
                    stylesheetDocumentStore.hasPendingChanges.setValue(true)
                }
            }
        }
    }

}
