//
//  StylesheetManager+CssDomRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-17.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

extension StylesheetManager: CssDomRenderable {
    
    public func renderCssDom() {
        
        self.cssDomRenderingComponent.reload()
    }
}
