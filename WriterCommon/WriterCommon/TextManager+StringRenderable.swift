//
//  TextManager+StringRenderable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-22.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

extension TextManager: StringRenderable {
    
    public func renderToPlainString() -> Promise<String?> {
        
        return Promise<String?> { fulfill, reject in
            
            firstly {
                self.renderPlainHtml()
            }.then { plainHtmlString in
                
                return Promise<NSMutableAttributedString> { fulfill, reject in
                    
                    if let plainHtmlString = plainHtmlString, let attributedString = plainHtmlString.htmlToAttributedString {
                        fulfill(attributedString)
                    }
                    else {
                        throw NWError.nilAttributedString
                    }
                }
            }.then { attributedString in
                fulfill(attributedString.string)
            }.catch { error in
                reject(error)
            }
        }
    }
    
}
