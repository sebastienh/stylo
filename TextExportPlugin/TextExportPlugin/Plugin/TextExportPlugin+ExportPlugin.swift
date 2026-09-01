//
//  TextExportPlugin+ExportPlugin.swift
//  TextExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit

extension TextExportPlugin: ExportPlugin {

    var previewData: Data? {
        return self._previewData
    }
    
    public var uti: String {
        return "txt"
    }
    
    var exportPanel: ExportPanel? {
        
        let pluginBundle = Bundle(for: type(of: self))
        let storyboardStringName = "TextExportPanel"
        let storyboardName = NSStoryboard.Name(string: storyboardStringName)
        let storyboard = NSStoryboard(name: storyboardName, bundle: pluginBundle)
        
        guard let textExportPanelViewController = storyboard.instantiateInitialController() as? TextExportViewController else {
            assertionFailure("Error: storyboard initial controller is not TextExportViewController")
            return nil
        }
        
        _ = textExportPanelViewController.view
        self.textExportPanelViewController = textExportPanelViewController
        
        return ExportPanel(name: Constants.Panel.Name, panelViewController: textExportPanelViewController)
    }
    
    func prepareData(for textManagers: [TextManager]) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            if let textExportPanelViewController = self.textExportPanelViewController {
                
                if textManagers.isEmpty {
                    fulfill(self.name)
                }
                
                var promises = [Promise<String?>]()
                
                for textManager in textManagers {
                    promises.append(textManager.plainTextString)
                }
                
                when(fulfilled: promises).then { plainTextStrings -> Promise<String> in
                    self.completeString(from: plainTextStrings)
                }.then { completeString -> Void in
                    DispatchQueue.main.async {
                        textExportPanelViewController.textView.string = completeString
                        autoreleasepool { [weak self] in
                            self?._previewData = completeString.data(using: String.Encoding.utf8)
                        }
                        if let textStorage = textExportPanelViewController.textView.textStorage {
                            textExportPanelViewController.textView.setFont(NSFont.systemFont(ofSize: 16.0), range: NSMakeRange(0, textStorage.length))
                        }
                    }
                    fulfill(self.name)
                }.catch { error in
                    reject(error)
                }
            }
            else {
                reject(NWError.custom(message: "textExportPanelViewController is nil"))
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
