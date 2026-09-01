//
//  StyloWindowController+Export.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-09-04.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import WriterCommon
import Common
import os

extension StyloWindowController {
    
    @IBAction public func exportEditHistory(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        let data = self.styloDocument?.textManager.editHistoryData
        
        assert(data != nil)
        if let data = data {
            
            self.exportDocument(toType: Constants.FileExtension.history, content: data)
        }
    }
    
    @IBAction public func exportTextToHtml(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        firstly {
            displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType.html)
        }.then {
            self.styloDocument!.htmlData
        }.then { data in
            self.export(data: data, ofType: Constants.FileExtension.html)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    @IBAction public func exportTextToWord(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        firstly {
            displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType.word)
        }.then {
            self.styloDocument!.wordData
        }.then { data in
            self.export(data: data, ofType: Constants.FileExtension.word)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    @IBAction public func exportTextToPlainText(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        firstly {
            displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType.plainText)
        }.then {
            return self.styloDocument!.plainTextData
        }.then { data in
            self.export(data: data, ofType: Constants.FileExtension.plainText)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    @IBAction public func exportTextToPlainMarkdown(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        firstly {
            displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType.markdown)
        }.then {
            return self.styloDocument!.markdownData
        }.then { data in
            self.export(data: data, ofType: Constants.FileExtension.markdown)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    @IBAction public func exportTextToPdf(_ sender: Any) {
        
        assert(self.styloDocument != nil)
        firstly {
            displayExportProgressIndicator(exportType: ProgressIndicatorViewController.ExportType.pdf)
        }.then { () -> Promise<Data> in
            return self.styloDocument!.pdfData
        }.then { data -> Promise<Void> in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("exporting data", log: Log.StyloCore.all, type: .info)
            #endif
            return self.export(data: data, ofType: Constants.FileExtension.pdf)
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    private func export(data: Data, ofType type: String) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            firstly {
                self.dismissProgressIndicator(data: data)
            }.then { data in
                self.exportDocument(toType: type, content: data)
            }.catch { error in
                // error handling
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Export error: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    private func exportDocument(toType typeUTI: String, content: Data) -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            let name = self.styloDocument?.displayName
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("exporting document with name: %@", log: Log.StyloCore.all, type: .info, %%String(describing: name))
            #endif
            
            assert(name != nil)
            if let window = self.window {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("opening save panel for document type: %@.", log: Log.StyloCore.all, type: .info, %%typeUTI)
                #endif
                let panel = NSSavePanel()
                
                if let name = name {
                    
                    var newName = removeExtension(from: name)
                    newName = newName.appending(".").appending(typeUTI)
                    
                    panel.nameFieldStringValue = newName as String
                    panel.beginSheetModal(for: window, completionHandler: { (result) in
                        
                        if result == NSApplication.ModalResponse.OK, panel.url != nil {
                            
                            // The extension has to come from the user because we can't
                            // change the URL without getting an 513 error.
                            // NW-37
                            do {
                                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                                os_log("writing content to %@", log: Log.StyloCore.all, type: .info, %%String(describing: panel.url))
                                #endif
                                try content.write(to: panel.url!)
                                fulfill(())
                            }
                            catch let exception {
                                /* error handling here */
                                reject(NWError.custom(message: "error exporting file: \(String(describing: name)), exception: \(exception)"))
                            }
                        }
                        else {
                            reject(NWError.custom(message: "error exporting file: \(String(describing: name)), result is nil or not OK"))
                        }
                    })
                }
                else {
                    reject(NWError.custom(message: "error exporting file: \(String(describing: name)), name is nil."))
                }
            }
            else {
                reject(NWError.custom(message: "error exporting file: \(String(describing: name)), window is nil."))
            }
        }
    }
    
    private func removeExtension(from filename: String) -> String {
        
        if filename.endsWith(WriterCommon.Constants.FileExtension.stylo) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.stylo)
        }
        else if filename.endsWith(WriterCommon.Constants.FileExtension.markdown) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.markdown)
        }
        else if filename.endsWith(WriterCommon.Constants.FileExtension.plainText) {
            return filename.substringWithoutNamedFileExtension(WriterCommon.Constants.FileExtension.plainText)
        }
        return filename
    }
    
}

