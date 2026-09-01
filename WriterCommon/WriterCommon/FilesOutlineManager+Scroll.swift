//
//  FilesOutlineManager+Scroll.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-29.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import os
import Common

extension FilesOutlineManager {
    
    public func handleScroll() {
        self.styleAssembliesSerialQueue.async { [weak self] in
            self?.handleDocumentClearFocusRequest(fromFilesOutlineWithId: nil)
            self?.requestClearFocus()
        }
    }
    
    public func handleSelectionChanged() {
        self.handleDocumentClearFocusRequest(fromFilesOutlineWithId: nil)
        self.requestClearFocus()
    }
    
}
