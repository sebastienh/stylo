//
//  StylesheetManager+Editable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import PromiseKit
import Igloo
import os

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

extension StylesheetManager: Editable, Observer {
    
    public typealias EditableStore = StylesheetDocumentStore
    
    public typealias StylableStore = StylesheetStyleStore
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public var editedLanguage: Language {
        
        return self.editedStylesheetLanguage
    }
    
    public func executeCompilation(withChangeDescription changeDescription: SourceStringChangeDescription) {
        
        self.compileAsync(changeDescription: changeDescription)
    }
    
    private func compileAsync(changeDescription: SourceStringChangeDescription) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("requested async compilation", log: Log.WriterCommon.textStorage, type: .info)
        #endif
        
        self.pendingRequests.enqueue(changeDescription)
        let visibleRanges = self.visibleRanges
        compilationQueue.async {
            self.compile(changeDescription: changeDescription, visibleRanges: visibleRanges)
        }
    }
    
    private func compile(changeDescription: SourceStringChangeDescription, visibleRanges: [EditorId: NSRange?]) {
        
        do {
            
            let action = EditableStoreAction.sourceStringChanged(description: changeDescription)
            let result = try self.dispatcher.online(store: self.stylesheetDocumentStore, action: action)
            
            guard let documentStoreActionResult = result as? DocumentStoreActionResult else {
                
                let errorString = "Invalid action result expecting DocumentStoreActionResult received: \(String(describing: result))."
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("%@", log: Log.WriterCommon.all, type: .error, %%errorString)
                #endif
                return
            }
            
            if documentStoreActionResult.containsCompleteUpdate {
                
                guard let lastCompiledDocument = documentStoreActionResult.lastCompiledDocument else {
                    assertionFailure("Error: lastCompiledDocument is nil")
                    return
                }
                
                let stylableActionResults = try self.compileCompleteAttributes(withDocument: lastCompiledDocument, withSourceStringChangeDescription: changeDescription, visibleRanges: visibleRanges)
                
                DispatchQueue.asyncOnMain {
                    
                    // remove the one that was used for this styles computations
                    // this has to be done on the main thread like all
                    // pendingRequests manipulations
                    assert(Thread.isMainThread)
                    guard let change = self.pendingRequests.dequeue() else {
                        assertionFailure("Error: pendingRequest is nil")
                        return
                    }
                    
                    self.updateAllAttributesForAllRenderers(stylableActionResults, change: change, pendingRequests: self.pendingRequests)
                    let updateErrorMessagesAction = FailableActionsFactory.updateErrorMessagesAsyncAction()
                    self.dispatcher.async(store: self.stylesheetDocumentStore, action: updateErrorMessagesAction)
                }
            }
            else {
                
                let stylableActionResults = self.compilePartialAttributes(using: documentStoreActionResult, change: changeDescription, visibleRanges: visibleRanges)
                
                DispatchQueue.asyncOnMain {
                    
                    // remove the one that was used for this styles computations
                    // this has to be done on the main thread like all
                    // pendingRequests manipulations
                    assert(Thread.isMainThread)
                    guard let change = self.pendingRequests.dequeue() else {
                        assertionFailure("Error: pendingRequest is nil")
                        return
                    }
                    
                    self.updateDifferentAttributesForAllRenderers(stylableActionResults, change: change, pendingRequests: self.pendingRequests)
                    let updateErrorMessagesAction = FailableActionsFactory.updateErrorMessagesAsyncAction()
                    self.dispatcher.async(store: self.stylesheetDocumentStore, action: updateErrorMessagesAction)
                }
            }
        }
        catch let error {
            assertionFailure("Error: \(error)")
        }
    }
}
