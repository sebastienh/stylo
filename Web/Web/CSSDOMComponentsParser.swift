//
//  CSSDOMComponentsParser.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-25.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

class CSSDOMComponentsParser: CSSComponentsParser {
    
    weak var document: CSSDOMDocument?
    
    init(componentValueArray: [CSComponentValue], document: CSSDOMDocument?) {
        
        self.document = document
        super.init(componentValueArray: componentValueArray)
    }
    
    func setErrorForElement(_ element: Element) {
        
        var exception = Exception()
        
        element.classList.add([§CSSElementType.Error], exception: &exception)
        
        if exception.isError() {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Exception while adding class : %@.", log: Log.Web.all, type: .error, %%exception)
            #endif
        }
    }
}
