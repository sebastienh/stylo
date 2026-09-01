//
//  TextManager+WordDocumentExportable.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit 

extension TextManager: WordDocumentExportable {
    
    /// Return the word Data representing this document.
    public var wordDocumentData: Promise<Data> {
        
        return Promise<Data> { fulfill, reject in
    
            assert(textDocument != nil)
            if let textDocument = textDocument {
            
                firstly {
                    self.renderHtml(htmlStyle: textDocument.wordDocumentStyle?.style.value)
                }.then { styledHtmlString in
                    
                    return Promise<NSMutableAttributedString> { fulfill, reject in
                        if let attributedString = styledHtmlString?.htmlToAttributedString {
                            fulfill(attributedString)
                        }
                        else {
                            reject(NWError.errorGeneratingAttributedString)
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
            else {
                
                reject(NWError.custom(message: "textDocument is nil"))
            }
        }
    }
    
    fileprivate func prepareAttributedStringForWordExport(mutableAttributedString: NSMutableAttributedString) {
        
        let totalRange = NSMakeRange(0, mutableAttributedString.length)
        mutableAttributedString.removeAttribute(NSAttributedString.Key.backgroundColor, range: totalRange)
    }
}
