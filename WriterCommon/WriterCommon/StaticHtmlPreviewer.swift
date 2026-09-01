//
//  StaticHtmlPreviewer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-03.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

public protocol StaticHtmlPreviewer { //: WorkingOverlayController {
    
    var previewShown: Bool { get }
    
    func toggleHtmlPreview(_ sender: AnyObject?) 
    
//    func prepareHtmlPreview() -> Promise<Void>
}
