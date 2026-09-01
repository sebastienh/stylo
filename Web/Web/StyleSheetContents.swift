//
//  StyleSheetContents.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-01.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

final class StyleSheetContents {
    
    var stringContent: DOMString?
    let urlString: DOMString
    let ownerRule: CSSRule?
    
    init(urlString: DOMString, ownerRule: CSSRule?) {
        
        self.urlString = urlString
        self.ownerRule = ownerRule
    }
    
    /// The resolveURLContent method MUST be included in 
    /// as async block but the method itself will run 
    /// synchronously.
    func resolveURLContent(_ completionHandler: ((String?, NSError?) -> Void)?) {
        
        let urlLoader = URLLoader.shared
        
        urlLoader.loadStringContentFromURL(self.urlString, externalCompletionHandler: completionHandler)
    }
    
    
}
