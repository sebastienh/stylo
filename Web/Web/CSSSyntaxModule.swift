//
//  CSSSyntaxModule.swift
//  CSSKit
//
//  Created by Sébastien Hamel on 2015-02-23.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

public final class CSSSyntaxModule : CSSModule {
    
    /// Singleton instance.
    static var shared = CSSSyntaxModule()
    
    fileprivate init() {
        
    }
    
    func parseStyleSheet(_ sourceString: NSString) -> CSStyleSheet? {
        
        let reader = CSSReader(sourceString: sourceString )
        
        let parser = CSParser(reader: reader, currentInputTokenIndex: 0 )
        
        let styleSheet = parser.parseStyleSheet()
        
        return styleSheet
    }
}
