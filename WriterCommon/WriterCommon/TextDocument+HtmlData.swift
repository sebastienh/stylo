//
//  StyloDocument+HtmlData.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-19.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

extension TextDocument {
    
    public var htmlData: Promise<Data> {
        
        return firstly {
            self.selectedTextManagersHtmlString
        }.then { htmlString -> Promise<Data> in

            return Promise<Data> { fulfill, reject in
                if let data = htmlString.data(using: .utf8) {
                    fulfill(data)
                }
                else {
                    reject(NWError.custom(message: "Error generating html string data."))
                }
            }
        }
    }
    
}
