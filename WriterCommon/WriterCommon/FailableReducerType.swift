//
//  FailableReducerType.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-01-01.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Web
import Common
import Igloo
import os

protocol FailableReducerType {

    func allDocumentMessages(document: Document) -> [Message]
}

extension FailableReducerType {
    
    func allDocumentMessages(document: Document) -> [Message] {
        
        // keep a local reference of the document we want to extract errors
        // from.
        let localDocument: CSSDOMDocument? = (document as! CSSDOMDocument)
        
        var messages = [Message]()
        
        if let localDocument = localDocument {
            
            let descendants = localDocument.inclusiveDescendants()
            
            for descendant in descendants {
                
                for var message in descendant.allMessages {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    if let element = descendant as? Element {
                        os_log("adding message %@ from node: %@, class: %@", log: Log.WriterCommon.all, type: .info, %%message.localizedMessage, %%element.localName, %%element.attributesListString)
                    }
                    else {
                        os_log("adding message %@ from node: %@", log: Log.WriterCommon.all, type: .info, %%message.localizedMessage, %%descendant.nodeType)
                    }
                    #endif
                    
                    message.fragment = descendant.sourceStringFragment
                    messages.append(message)
                }
            }
        }
        else {
            
            #if DEBUG
                debugPrint("localDocument is nil.")
            #endif
        }
        
        return messages
    }
    
}
