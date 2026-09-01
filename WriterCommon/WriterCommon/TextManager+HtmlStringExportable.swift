//
//  TextManager+HtmlStringExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

extension TextManager: HtmlStringExportable {
    
    /// Return a plain HTML string without style representing the document.
    public var htmlString: Promise<String?> {
        
        return Promise<String?> { fulfill, reject in
        
            firstly {
                htmlRenderable.renderPlainHtml()
            }.then { htmlSerializedString in
                fulfill(htmlSerializedString)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    public var htmlBodyContentString: Promise<String?> {
        
        return Promise<String?> { fulfill, reject in
            
            firstly {
                htmlRenderable.renderBodyContentPlainHtml()
            }.then { htmlSerializedString in
                fulfill(htmlSerializedString)
            }.catch { error in
                reject(error)
            }
        }
        
        
    }
}
