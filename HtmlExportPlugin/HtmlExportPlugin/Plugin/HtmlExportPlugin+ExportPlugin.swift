//
//  HtmlExportPlugin+ExportPlugin.swift
//  HtmlExportPlugin
//
//  Created by Sebastien hamel on 2019-09-22.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit
import WebKit
import Common
import Quartz
import os

extension HtmlExportPlugin: ExportPlugin {
    
    public var uti: String {
        return "html"
    }
    
    public var previewData: Data? {
        return _previewData
    }
    
    public var exportPanel: ExportPanel? {
        
        let pluginBundle = Bundle(for: type(of: self))
        let storyboardStringName = "HtmlExportPanel"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        
        guard let htmlExportViewController = storyboard.instantiateInitialController() as? HtmlExportViewController else {
            assertionFailure("Error: storyboard initial controller is not HtmlExportViewController")
            return nil
        }
    
        htmlExportViewController.representedObject = self.documentManager
        
        _ = htmlExportViewController.view
        self.htmlExportViewController = htmlExportViewController
        return ExportPanel(name: Constants.Panel.Name, panelViewController: htmlExportViewController)
    }
    
    public func prepareData(for textManagers: [TextManager]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let htmlExportViewController = self.htmlExportViewController {
                
                firstly { () -> Promise<String> in
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("creating the html string", log: Log.HtmlExport.all, type: .info)
                    #endif
                    return self.selectedTextManagersHtmlString(from: textManagers)
                }.then { htmlString -> Void in
                    self.loadWebView(with: htmlString)
                }.then { () -> Void in
                    fulfill(self.name)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "htmlExportViewController is nil"))
            }
        }
    }
    
    func loadWebView(with string: String) -> Promise<Void> {
        
        let (webViewLoadedPromise, fulfill, reject) = Promise<Void>.pending()
        self.webViewLoadedPromise = webViewLoadedPromise
        self.fulfill = fulfill
        self.reject = reject
        
        self.loadHtml(htmlString: string)
        return webViewLoadedPromise
    }
    
    private func loadHtml(htmlString: String?) {
        
        assert(htmlString != nil)
        assert(htmlExportViewController?.webView != nil)
        if let htmlString = htmlString {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loading html string %@", log: Log.Stylo.all, type: .info, %%htmlString)
            #endif
            self.htmlExportViewController?.webView.mainFrame.loadHTMLString(htmlString, baseURL: nil)
        }
    }
    
    private func selectedTextManagersHtmlString(from textManagers: [TextManager]) -> Promise<String> {
        
        var textManagersHtmlStrings = [Promise<String?>]()
        
        for textManager in textManagers {
            textManagersHtmlStrings.append(textManager.htmlBodyContentString)
        }
        
        return when(fulfilled: textManagersHtmlStrings).then { bodyStrings -> Promise<String> in
            self.htmlBodyString(from: bodyStrings)
        }.then { bodyString in
            
            return Promise<String> { fulfill, reject in
                firstly {
                    self.unstyledHtmlCompleteString(bodyString)
                }.then { htmlString -> Void in
                    self._previewData = htmlString.data(using: String.Encoding.utf8)
                    // pass along the body string for the preview generation
                    fulfill(bodyString)
                }.catch { error in
                    reject(error)
                }
            }
        }.then { bodyString in
            self.styledHtmlCompleteString(bodyString)
        }
    }
    
    private func htmlBodyString(from strings: [String?]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            var bodyContentString = ""
            for string in strings {
                if let string = string {
                    bodyContentString += string
                }
            }
            fulfill(bodyContentString)
        }
    }

    private func unstyledHtmlCompleteString(_ bodyString: String) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            fulfill("""
                <html>
                    <head>
                        <meta charset="UTF-8">
                    </head>
                    <body>
                        \(bodyString)
                    </body>
                </html>
                """
            )
        }
    }
    
    private func styledHtmlCompleteString(_ bodyString: String) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let htmlStyle = self.htmlStyle {
                
                let styleString = htmlStyle.serialize()
                
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
    
//    private func htmlCompletePdfString(_ bodyString: String) -> Promise<String> {
//        
//        return Promise<String> { fulfill, reject in
//            
//            if let wordStyle = self.wordStyle {
//                
//                let styleString = wordStyle.serialize()
//                
//                fulfill("""
//                    <html>
//                    <head>
//                    <style>
//                    \(styleString)
//                    </style>
//                    </head>
//                    <body>
//                    \(bodyString)
//                    </body>
//                    </html>
//                    """)
//            }
//            else {
//                reject(NWError.custom(message: "Error: pdfStyleStore is nil"))
//            }
//        }
//    }
    
}
//
//
//class WebFrameLoaderDelegate: NSObject, WebFrameLoadDelegate {
//
//    let url: URL
//
//    let (promise, fulfill, reject) = Promise<Data>.pending()
//
//    var data: Data?
//
//    let printInfo: NSPrintInfo
//
//    init(url: URL, printInfo: NSPrintInfo) {
//        self.url = url
//        self.printInfo = printInfo
//        super.init()
//    }
//
//    func webView(_ sender: WebView!, didCommitLoadFor frame: WebFrame!) {
//
//        firstly {
//            savePdfTemporaryDocument(sender, printInfo: self.printInfo)
//            }.then {
//                self.loadData()
//            }.then {
//                self.deleteTemporaryFile()
//            }.then { () -> Void in
//                assert(self.data != nil)
//                self.fulfill(self.data!)
//            }.catch { error in
//                self.reject(error)
//        }
//    }
//
//    private func loadData() -> Promise<Void> {
//
//        return Promise<Void> { fulfill, reject in
//
//            do {
//                self.data = try Data(contentsOf: url)
//                fulfill(())
//            }
//            catch {
//                reject(NWError.custom(message: "Unable to load data from url: \(url)"))
//            }
//        }
//    }
//
//    private func deleteTemporaryFile() -> Promise<Void> {
//
//        return Promise<Void> { fulfill, reject in
//
//            do {
//                try FileManager.default.removeItem(at: url)
//                fulfill(())
//            }
//            catch let error as NSError {
//                reject(NWError.custom(message: "Unable to delete file at url: \(url): \(error)"))
//            }
//        }
//    }
//
//    private func savePdfTemporaryDocument(_ sender: WebView, printInfo: NSPrintInfo?) -> Promise<Void> {
//
//        assert(printInfo != nil)
//        return Promise<Void> { fulfill, reject in
//
//            DispatchQueue.main.async {
//
//                let printInfoParam = printInfo ?? NSPrintInfo.shared
//                var printOpts = printInfoParam.dictionary() as! [NSPrintInfo.AttributeKey : AnyObject]
//                printOpts[NSPrintInfo.AttributeKey.jobDisposition] = NSPrintInfo.JobDisposition.save as AnyObject
//                printOpts[NSPrintInfo.AttributeKey.jobSavingURL] = self.url as AnyObject
//
//                let printInfo = NSPrintInfo(dictionary: printOpts)
//
//                //#if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("print with print settings: %@", log: Log.WordExport.all, type: .info, %%printInfo)
//                os_log("shared print settings: %@", log: Log.WordExport.all, type: .info, %%NSPrintInfo.shared)
//                //#endif
//
//                let printOp: NSPrintOperation = NSPrintOperation(view: sender.mainFrame.frameView.documentView, printInfo: printInfo)
//                printOp.showsPrintPanel = false
//                printOp.showsProgressPanel = false
//                printOp.run()
//                fulfill(())
//            }
//        }
//    }
//
//
//
//}
