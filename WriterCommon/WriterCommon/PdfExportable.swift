//
//  PdfExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

protocol PdfExportable {
    
    var pdfDocumentHtmlString: Promise<String?> { get }

}
