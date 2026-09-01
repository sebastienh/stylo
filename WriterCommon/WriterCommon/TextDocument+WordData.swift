//
//  StyloDocument+WordData.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-19.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit

extension TextDocument {
    
    /// Return the word Data representing this document.
    public var wordDocumentData: Promise<Data> {
        
        return Promise<Data> { fulfill, reject in

            firstly {
                self.selectedTextManagersWordString
            }.then { styledHtmlString in
                
                return Promise<NSMutableAttributedString> { fulfill, reject in
                    if let attributedString = styledHtmlString.htmlToAttributedString {
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
    }
    
    private var selectedTextManagersWordString: Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            // get the body string
            firstly {
                self.selectedTextManagersHtmlString
            }.then { bodyString in
                self.htmlCompleteWordString(bodyString)
            }.then { completeString in
                fulfill(completeString)
            }.catch { error in
                reject(error)
            }
        }
    }
    
    private func htmlCompleteWordString(_ bodyString: String) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let wordStyle = self.wordDocumentStyle?.style.value {
                
                let styleString = wordStyle.serialize()
                
                fulfill("""
                    <html>
                        <head>
                            <style>
                                \(styleString)
                            </style>
                        </head>
                        <body>
                            \(bodyString)
                        </body>
                    </html>
                    """)
            }
            else {
                reject(NWError.custom(message: "Error: pdfStyleStore is nil"))
            }
        }
    }
    
    fileprivate func prepareAttributedStringForWordExport(mutableAttributedString: NSMutableAttributedString) {
        
        let totalRange = NSMakeRange(0, mutableAttributedString.length)
        mutableAttributedString.removeAttribute(NSAttributedString.Key.backgroundColor, range: totalRange)
    }
    
}
