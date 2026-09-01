//
//  CSSOMModule.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-30.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

public final class CSSOMModule {
    
    /// Singleton instance.
    static public var shared = CSSOMModule()
    
    fileprivate init() {
        
    }
 
    public func parseStyleSheet(_ sourceString: NSString, origin: CSSOrigin, computePropertyValues: Bool = false) -> CSSStyleSheet? {
        
        let syntaxModule = CSSSyntaxModule.shared
        
        let styleSheet = syntaxModule.parseStyleSheet(sourceString)
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: computePropertyValues, origin: origin, declarationStopIndex: nil)
        
        if let styleSheet = styleSheet {
        
            let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
            return cssStyleSheet
        }
        
        return nil
    }
    
    func parseStyleRules(_ sourceString: NSString, origin: CSSOrigin, computePropertyValues: Bool = false) -> [CSSStyleRule] {
        
        var styleRules = [CSSStyleRule]()
        
        let syntaxModule = CSSSyntaxModule.shared
        
        let styleSheet = syntaxModule.parseStyleSheet(sourceString )
        
        let cssOmCreatorVisitor = CSSOMCreatorVisitor(computePropertyValues: computePropertyValues, origin: origin, declarationStopIndex: nil)
        
        if let styleSheet = styleSheet {
        
            let cssStyleSheet = cssOmCreatorVisitor.process(styleSheet)
            
            let rules = cssStyleSheet.cssRules
        
            for cssRule in  rules {
            
                if let styleRule = cssRule as? CSSStyleRule {
                
                    styleRules.append(styleRule)
                }
                else {
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("Rule is not a style rule", log: Log.Web.all, type: .default)
                    #endif
                }
            }
        }
        
        return styleRules
    }
    
    
}
