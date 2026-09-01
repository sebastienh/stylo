//
//  Renderable.swift
//  Web
//
//  Created by Sébastien Hamel on 2017-08-18.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import Common

public protocol Renderable {
    
    func render(attributesRecorder: AttributesRecorder)
    
}

//extension Renderable {
//    
//    func render(attributesRecorder: AttributesRecorder) {
//        
//        if documentAttributesElement {
//            
//            layoutDocumentAttributes()
//        }
//        else {
//            
//            let textStylizer = TextStylizer.shared
//            
//            textAttributes = textStylizer.blockStyle(from: computedStyle, element: element)
//        }
//        
//    }
//    
//    func layoutDocumentAttributes() {
//        
//        if let element = element {
//            
//            let textStylizer = TextStylizer.shared
//            documentAttributes = textStylizer.textStyle(from: computedStyle, element: element)
//            
//            
//            
//            if documentAttributes == nil {
//                
//                documentAttributes = textStylizer.textStyle(from: computedStyle, element: element)
//            }
//            
//            assert(documentAttributes != nil)
//        }
//        else {
//            
//            debugPrint("Dealocated element : no layout performed.")
//        }
//    }
//    
//    func paintDocumentAttributes() {
//        
//        // just making sure
//        if let _ = element, let documentAttributes = documentAttributes, documentAttributes.count > 0 {
//            
//            self.contentString.documentAttributes = DocumentAttributes(attrs: documentAttributes)
//        }
//        else {
//            
//            debugPrint("Didn't assigned any document attributes")
//        }
//    }
//    
//}

