//
//  DocumentTitlePresenter.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-20.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

protocol DocumentTitlePresenter: class {
    
    var titleLabel: DocumentTitleTextField? { get set }
    
    var documentManager: DocumentManager? { get }
    
    func subscribeToDocumentManager()
    
    func unsubscribeToDocumentManager()
    
}

extension DocumentTitlePresenter where Self: NSObject & Observer {
    
    func subscribeToDocumentManager() {
        assert(self.documentManager != nil)
        if let documentManager = self.documentManager {
            self.titleLabel?.stringValue = documentManager.name.value
            documentManager.name.subscribe({ [weak self](newName) in
                self?.titleLabel?.stringValue = newName
            }, observer: self)
        }
    }
    
    func unsubscribeToDocumentManager() {
        
        documentManager?.name.unsubscribe(observer: self)
    }
}
