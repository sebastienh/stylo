//
//  ThemeSetViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-10-18.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import os
import Common
import StyloCoreMac

final class ThemeSetViewController: NSViewController, HorizontallyCollapsableViewController {
    
    var themeSetManager: ThemeSetManager!
    
    @IBOutlet var viewWidth: NSLayoutConstraint?
    
    @IBOutlet var themesTableView: NSTableView!
    
    @IBOutlet var themesTitles: NSTextField!
    
    @IBOutlet var addThemeButton: StyloButton!
    
    @IBOutlet var panelTitleView: ThemeTitlePanelView!
    
    @IBOutlet var backgroundContentView: NSView!
    
    
    /// This is the only place we are garateed that the view has been added
    /// to the window.
    /// see: https://forums.xamarin.com/discussion/17262/when-is-superview-available-in-an-ios-uiviewcontroller
    override func viewDidAppear() {
        
        if let styloDocument = styloDocument {
            
            self.themeSetManager = styloDocument.themeSetManager
            themesTableView.reloadData()
        }
        else {   
            debugPrint("Document is nil.")
        }
        super.viewDidAppear()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Preparing for segue: %@", log: Log.ThemeEditor.all, type: .info, %%segue)
        #endif
        
        let themeViewController = segue.destinationController as! ThemeViewController
        let arrayIndex = arrayIndexFromSender(sender! as AnyObject)
        let themeManager: ThemeManager? = self.themeSetManager[arrayIndex]
        
        assert(themeManager != nil)
        if let themeManager = themeManager {
            themeViewController.themeManager =  themeManager
        }
    }
    
    @IBAction func addTheme(_ sender: AnyObject?) {
        
        self.themeSetManager.addTheme()
    
        // FIXME: could use the more optimized version of reload data
        themesTableView.reloadData()
    }
    
    @IBAction func deleteTheme(_ sender: AnyObject?) {
        
//        let cssStyleTableCellView = sender?.superview as! CSSStyleTableCellView
//        let associatedStyleManager = cssStyleTableCellView.associatedStyleManager!
//        self.deleteStyleManager(associatedStyleManager)
    }
    
    public func deleteStyleManager(_ styleManager: StyleManager) {
        
//        assert(styloDocument != nil)
//        styloDocument?.delete(styleManager: styleManager)
        themesTableView.reloadData()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBOutlet var contentView: NSView!
    
    fileprivate func arrayIndexFromSender(_ sender: AnyObject) -> Int {
        
        let button = sender as! NSButton
        let buttonPosition = CGPoint(x: button.frame.midX, y: button.frame.midY)
        let localLocation: NSPoint = button.superview!.convert(buttonPosition, to: themesTableView)
        
        // we use the button center position to know which row we are in
        return  self.themesTableView.row(at: localLocation)
    }
    
    
    
}
