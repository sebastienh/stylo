//
//  StyloDocument+Printable.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-09-08.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Quartz
import PromiseKit
import Common
import os

extension TextDocument {

    public var printPdfData: Promise<Data> {
        
        let pdfUrl = createTemporaryPdfFileUrl()
        
        return Promise<Data> { fulfill, reject in
            
            firstly { () -> Promise<String?> in
                assert(self.textManager != nil)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("creating the html string", log: Log.WriterCommon.all, type: .info)
                #endif
                return self.textManager.pdfDocumentHtmlString
            }.then { htmlString in
                self.generatePdfData(from: htmlString, for: .print, to: pdfUrl)
            }.then { data in
                fulfill(data)
            }
        }
    }
}
