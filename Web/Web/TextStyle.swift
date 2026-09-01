//
//  TextStyleManager.swift
//  Web
//
//  Created by Sebastien hamel on 2015-05-16.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

class TextStyle: Style {
    
    init(browser: BrowserEngine, userAgentStyleDataDocument: DataDocument, authorStyleSourceDocuments: [CSSSourceDocument], id: DOMString){
        
        super.init(browser: browser, userAgentStyleDataDocument: userAgentStyleDataDocument, authorStyleSourceDocuments: authorStyleSourceDocuments, id: id)
    }
    
}