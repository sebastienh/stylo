//
//  CSSResourceEditorDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Web
import Common
import StyloCoreMac

class CSSResourceEditorDelegate: ResourceEditorDelegate {
    
    @objc public func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        
        let resourceEditorView = textObject as? ResourceEditorView
        
        assert(resourceEditorView != nil)
        if let resourceEditorView = resourceEditorView {
            
            resourceEditorView.currentlyWritting = true
        }
        return true
    }
    
    public func textShouldEndEditing(_ textObject: NSText) -> Bool {
        
        let resourceEditorView = textObject as? ResourceEditorView
        
        assert(resourceEditorView != nil)
        if let resourceEditorView = resourceEditorView {
            
            resourceEditorView.currentlyWritting = false
        }
        return true
    }
    
    public func textDidBeginEditing(_ notification: Notification) {
        
        let resourceEditorView = notification.object as? ResourceEditorView
        
        assert(resourceEditorView != nil)
        if let resourceEditorView = resourceEditorView {
            
            resourceEditorView.currentlyWritting = true
        }
    }
    
    public func textDidEndEditing(_ notification: Notification) {
        
        let resourceEditorView = notification.object as? ResourceEditorView
        
        assert(resourceEditorView != nil)
        if let resourceEditorView = resourceEditorView {
            
            resourceEditorView.currentlyWritting = false
        }
    }
    
    public func textViewDidChange(_ notification: Notification) {
        
        let resourceEditorView = notification.object as? ResourceEditorView
        
        assert(resourceEditorView != nil)
        if let resourceEditorView = resourceEditorView {
            
            resourceEditorView.currentlyWritting = true
        }
    }
    
    
    /// see http://www.cocoabuilder.com/archive/cocoa/282632-nstextview-attachments-and-context-menus.html
    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        
        // remove Substitution submenu
        for menuItem in menu.items {
            
            if let identifierString = menuItem.identifier?.rawValue,
                identifierString == InterfaceConstants.MenuItems.Identifiers.Substitutions ||
                    identifierString == InterfaceConstants.MenuItems.Identifiers.SpellingAndGrammar ||
                    identifierString == InterfaceConstants.MenuItems.Identifiers.LayoutOrientation {
                    menu.removeItem(menuItem)
            }
        }
        
        #if DEBUG
        if let resourceEditorView = view as? ResourceEditorView {
            
            if let node = resourceEditorView.node(at: charIndex) {
                
                if let menuItem = buildMenuItem(for: node, textView: resourceEditorView) {
                    
                    menu.addItem(menuItem)
                }
            }
        }
        #endif
        
        return menu
    }
    
    // NSTextViewDelegate
    // - (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        let resourceEditorView = textView as! ResourceEditorView
        
        if let formatter = resourceEditorView.editableManager as? TextFormatter, let replacementString = replacementString {

            let insertion = formatter.handleInsertion(ofString: replacementString, with: affectedCharRange, in: resourceEditorView)

            if let insertion = insertion {

                let selectedRange = resourceEditorView.selectedRange
                resourceEditorView.insertText(insertion.replacementString, replacementRange: insertion.replacementRange)
                
                let desiredNewSelectedRange = NSMakeRange(selectedRange.location+insertion.locationVariation, 0)
                
                if let stringCount = textView.textStorage?.string.utf16.count {
                
                    // simple validatation to avoid overflows
                    if desiredNewSelectedRange.lowerBound >= 0 && desiredNewSelectedRange.upperBound <= stringCount {
                        resourceEditorView.selectedRange = NSMakeRange(selectedRange.location+insertion.locationVariation, 0)
                    }
                }
                return false
            }
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    private func buildMenuItem(for node: Node, textView: ResourceEditorView) -> RevealInDomInspectorMenuItem? {
        
        if let domRenderable = textView.editableManager as? DomRenderable {
            
            let menuItem = RevealInDomInspectorMenuItem(title: "Reveal in DOM Inspector", action: #selector(revealInDomInspector(_:)), keyEquivalent: "", node: node, domRenderable: domRenderable)
            
            menuItem.target = self
            
            return menuItem
        }
        
        return nil
    }
    
    @objc private func revealInDomInspector(_ sender: AnyObject?) {
        
        if let revealInDomInspectorMenuItem = sender as? RevealInDomInspectorMenuItem {
            
            let domRenderable = revealInDomInspectorMenuItem.domRenderable
            let node = revealInDomInspectorMenuItem.node
            
            // should make sure the dom inspector is open here
            NSApp.sendAction(#selector(TextFactoryViewController.showDomTool(_ :)), to: nil, from: nil)
            
            // after we proceed with revealing the item in the DOM inspector
            domRenderable?.revealInDomInspector(node: node)
        }
    }
    
    
}
