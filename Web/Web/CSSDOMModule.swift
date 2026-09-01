//
//  CSSDOMModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public final class CSSDOMModule : CSSModule {
    
    typealias Module = CSSDOMModule
    
    /// Singleton instance.
    static var shared = CSSDOMModule()
    
    fileprivate init() {
        
    }
    
    /// Method to create a CSS DOM Document from a CSSOM document tree.
    func domFromCSSOM(_ cssStyleSheet: CSSStyleSheet) -> CSSDOMDocument {
        
        let cssDomRenderer = CSSDOMRenderer(document: CSSDOMDocument.Create())
        
        return cssDomRenderer.renderStylesheet(cssStyleSheet)!
    }
    
    /// Method to get the CSS DOM from a css source string.
    func domFromCSSString(_ sourceString: NSString, origin: CSSOrigin) -> CSSDOMDocument? {
    
        let cssOmModule = CSSOMModule.shared
    
        let styleSheet = cssOmModule.parseStyleSheet(sourceString, origin: origin)
        
        if let styleSheet = styleSheet {
        
            return domFromCSSOM(styleSheet )
        }
        return nil
    }
}


