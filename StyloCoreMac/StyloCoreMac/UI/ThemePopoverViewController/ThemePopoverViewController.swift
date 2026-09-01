////
////  ThemePopoverViewController.swift
////  Stylo Writer
////
////  Created by Sébastien Hamel on 2015-10-30.
////  Copyright © 2015 Textually Inc. All rights reserved.
////
//
//import Foundation
//import Cocoa
//import WriterCommon
//
//final class ThemePopoverViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, ExtendedTableViewDelegate {
//    
//    weak var privateStyloDocument: TextDocument!
//    
//    @IBOutlet var pseudoStyleTableView: NSTableView!
//    
//    @IBOutlet var ccssStylePopoverBackgroundView: NSVisualEffectView!
//    
//    @IBOutlet var ccssStylePopoverTitleView: ColoredView!
//    
//    @IBOutlet var ccssStylePopoverTitleViewTitle: NSTextField!
//    
//    var themeBackgroundColor: NSColor?
//    
//    var themeTitleColor: NSColor?
//        
//    var themeTitleFont: NSFont?
//    
//    required init?(coder: NSCoder) {
//        
//        super.init(coder: coder)
//    }
//    
//    // see http://stackoverflow.com/questions/26657711/change-appearance-of-a-popover-created-using-a-popover-segue-in-os-x
//    override func viewDidAppear() {
//        
//        super.viewDidAppear()
//        
//        switch privateStyloDocument.documentAppearanceMode! {
//        
//        case .dark:
//            
//            ccssStylePopoverBackgroundView.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
//            ccssStylePopoverTitleView.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
//            
//        case .light:
//            
//            ccssStylePopoverBackgroundView.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
//            ccssStylePopoverTitleView.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
//        }
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: NSTableViewDataSource protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    func numberOfRows(in aTableView: NSTableView) -> Int {
//        
//        if let _ = privateStyloDocument {
//            
//            return privateStyloDocument.themeSetManager.themesCount
//        }
//        return 0
//    }
//
//    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
//        
//        var cellView = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self)  as! ThemePopoverTableCellView
//        
//        if let themeBackgroundColor = themeBackgroundColor {
//            cellView.backgroundColor = themeBackgroundColor.cgColor
//        }
//        
//        if let themeTitleColor = themeTitleColor {
//            cellView.textField?.textColor = themeTitleColor
//        }
//        
//        if let themeTitleFont = themeTitleFont {
//            cellView.textField?.font = themeTitleFont
//        }
//        
//        let theme = privateStyloDocument.themeSetManager[row]
//        
//        // here we should put the reference to the selectable circle...
//        //            cellView.imageView!.image =
//        let name = theme?.name
//        
//        assert(name != nil)
//        cellView.textField!.stringValue = name?.value ?? "Untitled"
//        
//        if selectedRow == nil {
//               
//            if cellView.textField!.stringValue == StyloApplication.shared.userDefaultsThemeName! {
//                
//                cellView.selected = true
//                selectedRow = cellView
//            }
//        }
//        
//        return cellView
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: NSTableViewDelegate protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    var selectedRow: ThemePopoverTableCellView!
//    
//    /// FIXME: This method should not be needed fot an ordinary array
//    /// but there seem to have a problem with framework.
//    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
//        
//        return 26.0
//    }
//    
//    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
//        
//        let cellView = tableView.view(atColumn: 0, row: row, makeIfNecessary: false) as! ThemePopoverTableCellView
//        cellView.selected = true
//        selectedRow?.selected = false
//        selectedRow = cellView
//        return true
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: ExtendedTableViewDelegate protocol implementation
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    
//    func tableView(_ tableView: NSTableView, didClickedRow row: NSInteger) {
//        
//        changeCurrentlySelectedStyle(row)
//    }
//    
//    //////////////////////////////////////////////////////////////////////////////////////////////////////////
//    //                                  MARK: Private implementation
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////// 
//    
//    func changeCurrentlySelectedStyle(_ styleIndex: NSInteger) {
//        
//        let themeManager = privateStyloDocument.themeSetManager[styleIndex]
//        
//        assert(themeManager != nil)
//        if let themeManager = themeManager {
//            privateStyloDocument.themeSetManager.setCurrentThemeManager(themeManager)
//        }
//    }
//    
//    fileprivate func arrayIndexFromSender(_ sender: AnyObject) -> Int {
//        
//        let button = sender as! NSButton
//        let buttonPosition = CGPoint(x: button.frame.midX, y: button.frame.midY)
//        let localLocation: NSPoint = button.superview!.convert(buttonPosition, to: pseudoStyleTableView)
//        
//        // we use the button center position to know which row we are in
//        return  self.pseudoStyleTableView.row(at: localLocation)
//    }
//    
//}
