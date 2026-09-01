//
//  CssEditorToolsTabViewController.swift
//  StyleEditorPlugin
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import StyloCoreMac
import WriterCommon
import os

class CssEditorToolsTabViewController: EditorToolsTabViewController {
    
    override func initChildControllers() {
        
        for tabViewItem in tabViewItems {
            
            if let viewController = tabViewItem.viewController {
                
                switch viewController {
                                            
                case let domInspectorViewController as DomInspectorViewController:
                    
                    if let stylesheetManager = resourceModelManager as? StylesheetManager {
                        
                        domInspectorViewController.domRenderable = stylesheetManager
                        domInspectorViewController.domInspectorDelegate = CSSDomInspectorDelegate()
                    }     
                    
                case let tabViewIssuesReporterViewController as TabViewIssuesReporterViewController:
                    
                    if let stylesheetManager = resourceModelManager as? StylesheetManager {
                        
                        tabViewIssuesReporterViewController.representedObject = stylesheetManager
                        tabViewIssuesReporterViewController.documentManager = documentManager
                    }
                    
                case let issueReporterViewController as IssuesReporterViewController:
                    
                    if let _ = resourceModelManager as? TextManager {
                        
                        // nothing to do
                    }
                    else if let stylesheetManager = resourceModelManager as? StylesheetManager {
                        
                        issueReporterViewController.representedObject = stylesheetManager
                    }
                    
                default:
                    
                    break
                }
            }
            else {
                
                assert(false, "tabViewItem viewController is nil in HTMLPreviewToolsTabViewController")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("tabViewItem viewController is nil in HTMLPreviewToolsTabViewController", log: Log.StyleEditor.all, type: .error)
                #endif
            }
        }
    }
    
}
