//
//  HtmlStringExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

protocol HtmlStringExportable {
    
    /// Return a plain HTML string without style representing the document.
    var htmlString: Promise<String?> { get }
    
    var htmlBodyContentString: Promise<String?> { get }
}
