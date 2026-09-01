//
//  StylesheetManager+Failable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-09.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web
import os

extension StylesheetManager: Failable {
    
    public var errors: [Message] {
        
        return cssFailableResourceModel.errors
    }
    
    public func messages(at textIndex: Int) -> [Message]? {
        
        return cssFailableResourceModel.messages(at: textIndex)
    }
    
    public var issuesCount: Int {
    
        return cssFailableResourceModel.issuesCount
    }
    
    public subscript(index: Int) -> Message {
    
        return cssFailableResourceModel[index]
    }
    
    public func highlightAllErrors(forEditorWithId editorId: EditorId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("highlightAllErrors(...)", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }
        
        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: [.errors])
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: [.errors])
            }
        }()

        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    public func clearErrorHighlight(forEditorWithId editorId: EditorId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("clearErrorHighlight()", log: Log.WriterCommon.all, type: .info)
        #endif
        
        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }
        
        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: [.source])
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: [.source])
            }
        }()

        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    public func highlightElementWithMessageId(_ messageId: String, forEditorWithId editorId: EditorId) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("highlightElementWithMessageId(...)", log: Log.WriterCommon.all, type: .info)
        #endif

        guard let computedAppearance = StyloApplication.shared.computedAppearance.value else {
            assertionFailure("Error: computedAppearcance is nil")
            return
        }

        let styleAssemblyDescriptor: StyleAssemblyDescriptor = {
            switch computedAppearance {
            case .dark:
                return StyleAssemblyDescriptor(appearance: .dark, traits: [.error(messageId: messageId)])
            case .light:
                return StyleAssemblyDescriptor(appearance: .light, traits: [.error(messageId: messageId)])
            }
        }()

        self.setStyleAssemblyDescriptor(styleAssemblyDescriptor, forEditorId: editorId)
    }
    
    
    public func subscribeToMessages(observer: Observer, closure: @escaping (DynamicArray<Message>.Change) -> Void)  {
        
        guard !self.stylesheetDocumentStore.errorMessages.subscribed(observer: observer) else {
            return
        }
        
        self.stylesheetDocumentStore.errorMessages.subscribe({ (change: DynamicArray<Message>.Change) in
            closure(change)
        }, observer: observer)
    }
    
    public func unsubscribeToMessages(observer: Observer) {
        
        if self.stylesheetDocumentStore.errorMessages.subscribed(observer: observer) {
            
            self.stylesheetDocumentStore.errorMessages.unsubscribe(observer: observer)
        }
    }
}
