//
//  PseudoCSSStyleManager.swift
//  Web
//
//  Created by Sebastien hamel on 2015-05-13.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

class PseudoCSSStyle: Style {
 
    init(browser: BrowserEngine, userAgentStyleDataDocument: DataDocument, authorStyleSourceDocuments: [PseudoCSSSourceDocument], id: DOMString) {
        
        super.init(browser: browser, userAgentStyleDataDocument: userAgentStyleDataDocument, authorStyleSourceDocuments: authorStyleSourceDocuments, id: id)
    }
    
}