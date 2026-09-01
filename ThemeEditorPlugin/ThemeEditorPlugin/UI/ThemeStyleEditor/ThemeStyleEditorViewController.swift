//
//  ThemeStyleEditorViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-11-03.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import os
import StyloCoreMac

final class ThemeStyleEditorViewController: NSViewController {

    @objc dynamic var styleTitle: String {
        
        return styleManager.title
    }
    
    var styleManager: StyleManager!
    
    @IBOutlet var textContainerSplitViewController: TextContainerSplitViewController!
    
    @IBAction func goBack(_ sender: NSButton){
        
        if let presentingViewController = self.presentingViewController {
            
            presentingViewController.dismiss(self)
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        debugPrint("segue.destinationController: \((segue.destinationController as AnyObject).self)")
        
        if let destinationViewController = segue.destinationController as? EditorSplitViewController {
            
            destinationViewController.resourceModelManager = styleManager.firstStylesheetManager
        }
        else {
            assert(false, "cannot set stylesheetManager")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("cannot set stylesheetManager", log: Log.ThemeEditor.all, type: .error)
            #endif
        }
        super.prepare(for: segue, sender: sender)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Pushable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func completeAfterPush() {
        
    }
    
    func beforeDismissal() {
        
    }
}
