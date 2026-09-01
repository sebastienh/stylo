//
//  MarkdownExportPlugin+ExportPlugin.swift
//  MarkdownExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit

extension MarkdownExportPlugin: ExportPlugin {
    
    var previewData: Data? {
        
        return self._previewData
    }
    
    public var uti: String {
        return "md"
    }
    
    var exportPanel: ExportPanel? {
        
        let pluginBundle = Bundle(for: type(of: self))
        let storyboardStringName = "MarkdownExportPanel"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        
        guard let markdownExportViewController = storyboard.instantiateInitialController() as? MarkdownExportViewController else {
            assertionFailure("Error: storyboard initial controller is not TextExportViewController")
            return nil
        }
        
        _ = markdownExportViewController.view
        self.markdownExportViewController = markdownExportViewController
        
        return ExportPanel(name: Constants.Panel.Name, panelViewController: markdownExportViewController)
    }
    
    func prepareData(for textManagers: [TextManager]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let markdownExportViewController = self.markdownExportViewController {
                
                if textManagers.isEmpty {
                    fulfill(self.name)
                }
                
                var plainTextStrings = [String]()
                
                for textManager in textManagers {
                    plainTextStrings.append(textManager.plainMarkdownString)
                }
                
                firstly {
                    self.completeString(from: plainTextStrings)
                }.then { completeString -> Void in
                    DispatchQueue.main.async {
                        
                        self._previewData = completeString.data(using: String.Encoding.utf8)
                        markdownExportViewController.textView.string = completeString
                        if let textStorage = markdownExportViewController.textView.textStorage {
                            markdownExportViewController.textView.setFont(NSFont.systemFont(ofSize: 16.0), range: NSMakeRange(0, textStorage.length))
                        }
                    }
                    fulfill(self.name)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "mardkownExportViewController is nil"))
            }
        }
    }
    
    private func completeString(from plainTextStrings: [String?]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            var completeString = ""
            
            for plainTextString in plainTextStrings {
                if let plainTextString = plainTextString {
                    completeString += plainTextString
                }
            }
            fulfill(completeString)
        }
    }
}
