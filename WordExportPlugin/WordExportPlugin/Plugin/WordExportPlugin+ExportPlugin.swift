//
//  WordExportPlugin+ExportPlugin.swift
//  WordExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit
import WebKit
import Common
import Quartz
import os

extension WordExportPlugin: ExportPlugin {
    
    public var previewData: Data? {
        
        return self._previewData
    }
    
    public var uti: String {
        return "doc"
    }
    
    public var exportPanel: ExportPanel? {
        
        let pluginBundle = Bundle(for: type(of: self))
        let storyboardStringName = "WordExportPanel"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        
        guard let wordExportViewController = storyboard.instantiateInitialController() as? WordExportViewController else {
            assertionFailure("Error: storyboard initial controller is not WordExportViewController")
            return nil
        }
        
        _ = wordExportViewController.view
        debugPrint("pdfView.intrinsicContentSize: \(wordExportViewController.pdfView.intrinsicContentSize)")
        
        self.wordExportViewController = wordExportViewController
        
        return ExportPanel(name: Constants.Panel.Name, panelViewController: wordExportViewController)
    }
    
    public func prepareData(for textManagers: [TextManager]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let wordExportViewController = self.wordExportViewController {
                
                let pdfUrl = createTemporaryPdfFileUrl()
                
                firstly { () -> Promise<String> in
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("creating the html string", log: Log.WordExport.all, type: .info)
                    #endif
                    return self.selectedTextManagersWordString(from: textManagers)
                }.then { htmlString -> Promise<Data> in
                    self.generatePdfData(from: htmlString, for: .export, to: pdfUrl)
                }.then { data -> Promise<Void> in
                    return Promise<Void> { fulfill, reject in
                        // init the PDF View
                        let pdfDocument = PDFDocument(data: data)
                        wordExportViewController.pdfView.document = pdfDocument
                        fulfill(())
                    }
                }.then { () -> Promise<Data> in
                    self.wordDocumentData(from: textManagers)
                }.then { data -> Promise<Void> in
                    return Promise<Void> { fulfill, reject in
                        self._previewData = data
                        fulfill(())
                    }
                }.then { () -> Void in
                    fulfill(self.name)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "wordExportViewController is nil"))
            }
        }
    }
    
    public func createTemporaryPdfFileUrl() -> URL {
        
        return URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(UUID().uuidString + ".tmp")
    }
  
    /// This method generate pdf data for exporting and printing.
    /// Right now, we don't use the parameter pdfDataType
    /// but it should be used to determine if
    /// we want to use the document's printInfo or the shared one.
    /// If the user use the Page Setup menu he modifies the
    /// document printInfo value. The question comes down to do we want
    /// to use the same pdf generation parameters for printing and exporting.
    func generatePdfData(from htmlString: String?, for pdfDataType: PdfDataType, to pdfUrl: URL) -> Promise<Data> {
        
        return Promise<Data> { fulfill, reject in
            
            if let htmlString = htmlString {
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("creating the web view", log: Log.WordExport.all, type: .info)
                #endif
                let width = NSPrintInfo.shared.paperSize.width
                let webView = WebView(frame: NSMakeRect(0, 0, width, 0))
                
                // set the url
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("creating the WebFrameLoaderDelegate", log: Log.WordExport.all, type: .info)
                #endif
                
                let printInfo = self.printInfo ?? NSPrintInfo.shared
                
                let webFrameLoadDelegate = WebFrameLoaderDelegate(url: pdfUrl, printInfo: printInfo)
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("save the pdf create job", log: Log.WordExport.all, type: .info)
                #endif
                assert(Thread.current.isMainThread)
                self.pdfExportJobs.removeAll()
                self.pdfExportJobs[pdfUrl] = (webView, webFrameLoadDelegate)
                
                webView.frameLoadDelegate = webFrameLoadDelegate
                
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("web view loa the html string", log: Log.WordExport.all, type: .info)
                #endif
                webView.mainFrame.loadHTMLString(htmlString, baseURL: nil)
                webFrameLoadDelegate.promise.then { data in
                    fulfill(data)
                }
            }
            else {
                reject(NWError.custom(message: "html string is nil."))
            }
        }
    }
    
    private func htmlCompletePdfString(_ bodyString: String) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let wordStyle = self.wordStyle {
                
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
}


class WebFrameLoaderDelegate: NSObject, WebFrameLoadDelegate {
    
    let url: URL
    
    let (promise, fulfill, reject) = Promise<Data>.pending()
    
    var data: Data?
    
    let printInfo: NSPrintInfo
    
    init(url: URL, printInfo: NSPrintInfo) {
        self.url = url
        self.printInfo = printInfo
        super.init()
    }
    
    func webView(_ sender: WebView!, didCommitLoadFor frame: WebFrame!) {
        
        firstly {
            savePdfTemporaryDocument(sender, printInfo: self.printInfo)
            }.then {
                self.loadData()
            }.then {
                self.deleteTemporaryFile()
            }.then { () -> Void in
                assert(self.data != nil)
                self.fulfill(self.data!)
            }.catch { error in
                self.reject(error)
        }
    }
    
    private func loadData() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            do {
                self.data = try Data(contentsOf: url)
                fulfill(())
            }
            catch {
                reject(NWError.custom(message: "Unable to load data from url: \(url)"))
            }
        }
    }
    
    private func deleteTemporaryFile() -> Promise<Void> {
        
        return Promise<Void> { fulfill, reject in
            
            do {
                try FileManager.default.removeItem(at: url)
                fulfill(())
            }
            catch let error as NSError {
                reject(NWError.custom(message: "Unable to delete file at url: \(url): \(error)"))
            }
        }
    }
    
    private func savePdfTemporaryDocument(_ sender: WebView, printInfo: NSPrintInfo?) -> Promise<Void> {
        
        assert(printInfo != nil)
        return Promise<Void> { fulfill, reject in
            
            DispatchQueue.main.async {
                
                let printInfoParam = printInfo ?? NSPrintInfo.shared
                var printOpts = printInfoParam.dictionary() as! [NSPrintInfo.AttributeKey : AnyObject]
                printOpts[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save as AnyObject
                printOpts[NSPrintInfo.AttributeKey.jobSavingURL] = self.url as AnyObject
                
                let printInfo = NSPrintInfo(dictionary: printOpts)
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("print with print settings: %@", log: Log.WordExport.all, type: .info, %%printInfo)
                os_log("shared print settings: %@", log: Log.WordExport.all, type: .info, %%NSPrintInfo.shared)
                #endif
                
                let printOp: NSPrintOperation = NSPrintOperation(view: sender.mainFrame.frameView.documentView, printInfo: printInfo)
                printOp.showsPrintPanel = false
                printOp.showsProgressPanel = false
                printOp.run()
                fulfill(())
            }
        }
    }
}


