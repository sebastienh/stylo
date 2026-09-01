//
//  ExportableDocument.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import WebKit
import Quartz

public protocol ExportableDocument {
    
    func createTemporaryPdfFileUrl() -> URL
    
    var htmlData: Promise<Data> { get }
    
    var wordData: Promise<Data> { get }
    
    var plainTextData: Promise<Data> { get }
    
    var markdownData: Promise<Data> { get }
    
    var pdfData: Promise<Data> { get }
}
