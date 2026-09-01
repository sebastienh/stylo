//
//  TextManager+PdfExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import WebKit
import Quartz
import PromiseKit

extension TextManager: PdfExportable {
    
    public var pdfDocumentHtmlString: Promise<String?> {
        
        return Promise<String?> { fulfill, reject in
        
            assert(textDocument != nil)
            if let textDocument = textDocument {
        
                let pdfStyleStore = textDocument.pdfDocumentStyle?.style.value
            
                assert(pdfStyleStore != nil)
                firstly {
                    self.renderHtml(htmlStyle: pdfStyleStore)
                }.then { string in
                    fulfill(string)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "textDocument is nil"))
            }
        }
    }

}



