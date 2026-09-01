//
//  StyloDocument+ExportableDocument.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-04-27.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import os

extension TextDocument: ExportableDocument {
    
    public var wordData: Promise<Data> {
        
        return self.wordDocumentData
    }
    
    public var plainTextData: Promise<Data> {
        
        return firstly {
            self.selectedTextManagersPlainString
        }.then { plainTextString -> Promise<Data> in
            
            return Promise<Data> { fulfill, reject in
                if let data = plainTextString.data(using: .utf8) {
                    fulfill(data)
                }
                else {
                    reject(NWError.custom(message: "Error generating plain string data."))
                }
            }
        }
    }
    
    public var markdownData: Promise<Data> {
        
        return Promise<Data> { fulfill, reject in
            
            let plainMarkdownString = self.selectedTextManagersMarkdownString
            
            if let data = plainMarkdownString.data(using: .utf8) {
                fulfill(data)
            }
            else {
                reject(NWError.custom(message: "Error generating markdown data."))
            }
        }
    }
    
    var selectedTextManagers: [TextManager] {
        
        guard let selectedFilesOutlineManager = self.documentManager?.selectedFilesOutlineManager else {
            assertionFailure("Error: selectedFilesOutlineManager is nil")
            return []
        }
        
        return selectedFilesOutlineManager.selectedTextManagers
    }
    
    var selectedTextManagersHtmlString: Promise<String> {
        
        var textManagersHtmlStrings = [Promise<String?>]()
        
        for textManager in self.selectedTextManagers {
            textManagersHtmlStrings.append(textManager.htmlBodyContentString)
        }
        
        return when(fulfilled: textManagersHtmlStrings).then { bodyStrings -> Promise<String> in
            
            return Promise<String> { fulfill, reject -> Void in
                var bodyContentString = ""
                
                for bodyString in bodyStrings {
                    if let bodyString = bodyString {
                        bodyContentString += bodyString
                    }
                }
                
                fulfill("<html><body>\(bodyContentString)</body></html>")
            }
        }
    }
    
    var selectedTextManagersMarkdownString: String {
    
        var plainMarkdownString = ""
        
        var textManagersPlainStrings = [Promise<String?>]()
        
        for textManager in self.selectedTextManagers {
            plainMarkdownString += textManager.plainMarkdownString + "\n"
        }
        
        return plainMarkdownString
    }
        
    var selectedTextManagersPlainString: Promise<String> {
        
        var textManagersPlainStrings = [Promise<String?>]()
        
        for textManager in self.selectedTextManagers {
            textManagersPlainStrings.append(textManager.plainTextString)
        }
        
        return when(fulfilled: textManagersPlainStrings).then { plainStrings -> Promise<String> in
            
            return Promise<String> { fulfill, reject -> Void in
                var totalPlainString = ""
                
                for plainString in plainStrings {
                    if let plainString = plainString {
                        totalPlainString += plainString
                    }
                }
                fulfill(totalPlainString)
            }
        }
    }
}
