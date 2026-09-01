//
//  TextManager+TokenAttributes.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension TextManager {

    func updateTokenAttributes() {
        
        self.dispatcher.async(store: self.markdownDocumentStore, action: TextDocumentAction.updateTokenAttributes.asyncAction)
    }
    
    func restartTokenAttributesUpdateTimer() {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("delayedTokenAttributesUpdate()", log: Log.WriterCommon.all, type: .info)
        #endif
        
        self.updateTokenAttributesTimer?.invalidate()
        
        self.updateTokenAttributesTimer = Timer.scheduledTimer(withTimeInterval: Constants.Markdown.TagsUpdateDelay, repeats: false, block: { [weak self](_) in
            
            guard let markdownDocumentStore = self?.markdownDocumentStore else {
                assertionFailure("Error: self.markdownDocumentStore is nil")
                return
            }
            
            self?.dispatcher.async(store: markdownDocumentStore, action: TextDocumentAction.updateTokenAttributes.asyncAction)
        })
    }
    
}
