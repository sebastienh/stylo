//
//  DocumentLoadingWindowController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-03-20.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

class DocumentLoadingWindowController: NSWindowController {
    
    var documentLoadViewController: DocumentLoadViewController? {
        
        let documentLoadViewController = self.contentViewController as? DocumentLoadViewController
        
        assert(documentLoadViewController != nil)
        return documentLoadViewController
    }
    
}
