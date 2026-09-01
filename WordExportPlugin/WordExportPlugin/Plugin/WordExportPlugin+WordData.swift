//
//  WordExportPlugin+WordData.swift
//  WordExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import PromiseKit
import WriterCommon

extension WordExportPlugin {
    
    /// Return the word Data representing this document.
    public func wordDocumentData(from textManagers: [TextManager]) -> Promise<Data> {
        
        return Promise<Data> { fulfill, reject in
            
            firstly {
                self.selectedTextManagersWordString(from: textManagers)
            }.then { styledHtmlString in
                
                return Promise<NSMutableAttributedString> { fulfill, reject in
                    if let attributedString = styledHtmlString.htmlToAttributedString {
                        fulfill(attributedString)
                    }
                    else {
                        reject(NWError.custom(message: "Error generating custom string"))
                    }
                }
            }.then { mutableAttributedString -> Promise<Data> in
                
                return Promise<Data> { fulfill, reject in
                    
                    self.prepareAttributedStringForWordExport(mutableAttributedString: mutableAttributedString)
                    
                    let documentAttributes = [
                        NSAttributedString.DocumentAttributeKey.documentType: NSAttributedString.DocumentType.docFormat
                        ] as [NSAttributedString.DocumentAttributeKey : Any]
                    
                    // finally convert the string into the docx data
                    let data = try mutableAttributedString.data(from: NSMakeRange(0, mutableAttributedString.length), documentAttributes: documentAttributes)
                    
                    fulfill(data)
                }
                
            }.then { data in
                fulfill(data)
            }.catch { error in
                // TODO: display the error in a popup
                //                debugPrint("Error: \(error)")
                reject(error)
            }
        }
    }
    
    fileprivate func prepareAttributedStringForWordExport(mutableAttributedString: NSMutableAttributedString) {
        
        let totalRange = NSMakeRange(0, mutableAttributedString.length)
        mutableAttributedString.removeAttribute(NSAttributedString.Key.backgroundColor, range: totalRange)
    }
    
    
}
