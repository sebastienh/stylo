//
//  TextResourceEditorDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-06-05.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Cocoa
import Web
import WriterCommon
import os

fileprivate enum Direction {
    case left
    case up
    case right
    case down
}

class TextResourceEditorDelegate: ResourceEditorDelegate {
    
    public func textShouldBeginEditing(_ textObject: NSText) -> Bool {
        
        guard let resourceEditorView = textObject as? MarkdownResourceEditorView else {
            assertionFailure("Error: notification.object is not MarkdownResourceEditorView")
            return true
        }

        resourceEditorView.currentlyWritting = true
        return true
    }
    
    public func textShouldEndEditing(_ textObject: NSText) -> Bool {
        
        guard let resourceEditorView = textObject as? MarkdownResourceEditorView else {
            assertionFailure("Error: notification.object is not MarkdownResourceEditorView")
            return true
        }
        
        resourceEditorView.currentlyWritting = false
        return true
    }
    
    public func textDidBeginEditing(_ notification: Notification) {
        
        guard let resourceEditorView = notification.object as? MarkdownResourceEditorView else {
            assertionFailure("Error: notification.object is not MarkdownResourceEditorView")
            return
        }
        
        resourceEditorView.currentlyWritting = true
    }
    
    public func textDidEndEditing(_ notification: Notification) {
        
        guard let resourceEditorView = notification.object as? MarkdownResourceEditorView else {
            assertionFailure("Error: notification.object is not MarkdownResourceEditorView")
            return
        }
        
        resourceEditorView.currentlyWritting = false
    }
    
    public func textViewDidChange(_ notification: Notification) {
        
        guard let resourceEditorView = notification.object as? MarkdownResourceEditorView else {
            assertionFailure("Error: notification.object is not MarkdownResourceEditorView")
            return
        }
        
        resourceEditorView.currentlyWritting = true
    }
    
    public func textView(_ textView: NSTextView, shouldChangeTextIn affectedCharRange: NSRange, replacementString: String?) -> Bool {
        
        guard let resourceEditorView = textView as? MarkdownResourceEditorView else {
            assertionFailure("Error: textView is not MarkdownResourceEditorView")
            return true
        }
        
        if let formatter = resourceEditorView.editableManager as? TextFormatter, let replacementString = replacementString {
            
            let insertion = formatter.handleInsertion(ofString: replacementString, with: affectedCharRange, in: resourceEditorView)
            
            if let insertion = insertion {
                
                guard insertion.replacementRange.location >= 0 else {
                    assertionFailure("Error: insertion.replacementRange.location is smaller than 0")
                    return true
                }
                
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
    
    func textView(_ textView: NSTextView, shouldChangeTypingAttributes oldTypingAttributes: [String : Any] = [:], toAttributes newTypingAttributes: [NSAttributedString.Key : Any] = [:]) -> [NSAttributedString.Key : Any] {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("old typing attributes: %@", log: Log.StyloCore.all, type: .info, %%oldTypingAttributes)
        os_log("new typing attributes: %@", log: Log.StyloCore.all, type: .info, %%newTypingAttributes)
        #endif
        
        if let renderer = textView as? SourceStringAttributesRenderer, renderer.forceSetTypingAttributes {
            return newTypingAttributes
        }
        
        let selectedRange = textView.selectedRange()
        
        if let textStorage = textView.textStorage, selectedRange.location > 0 && selectedRange.location < textStorage.length {
            
            let attributesAtSelectedLocation = textStorage.attributes(at: selectedRange.location, effectiveRange: nil)
            let attributesBeforeSelectedLocation = textStorage.attributes(at: selectedRange.location-1, effectiveRange: nil)
                
            if !attributesAtSelectedLocation.sameValuesForSameKeys(as: newTypingAttributes) && !attributesBeforeSelectedLocation.sameValuesForSameKeys(as: newTypingAttributes) {
                
                let oldAttributes = oldTypingAttributes.map { (arg0) -> (NSAttributedString.Key, Any) in
                    let (key, value) = arg0
                    return (NSAttributedString.Key(key), value)
                }
                
                var attributesDictionnary = [NSAttributedString.Key: Any]()
                
                for (key, value) in oldAttributes {
                    attributesDictionnary[key] = value
                }
                
                return attributesDictionnary
            }
        }
        return newTypingAttributes
    }
    
    private func locationAfterHiddenHeaderTag(from location: Int, inTextView textView: NSTextView) -> Int {
        
        guard let textStorage = textView.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return location
        }
        
        let cursorInsideHeaderTag = textStorage.isCursorInsideHeaderTag(at: location)
        let cursorAtHeaderTagEnd = textStorage.isCursorAtHeaderTagEnd(at: location)
        let headerTagStart = textStorage.isHeaderTagStart(at: location)
        
        debugPrint("cursorInsideHeaderTag: \(cursorInsideHeaderTag) at location: \(location)")
        debugPrint("cursorAtHeaderTagEnd: \(cursorAtHeaderTagEnd) at location: \(location)")
        debugPrint("headerTagStart: \(headerTagStart) at location: \(location)")
        
        if cursorInsideHeaderTag {
            let headerTagStartLocation = textStorage.positionAtEndOfHiddenHeaderTag(from: location, in: textView)
            
            debugPrint("headerTagStartLocation: \(headerTagStartLocation)")
            
            assert(textStorage.isHeaderTagStart(at: headerTagStartLocation))
            return headerTagStartLocation
        }
        else if headerTagStart {
            
            return location
            
//            let headerTagStartLocation = textStorage.positionAtEndOfHiddenHeaderTag(from: location, in: textView)
//
////            BeforeHiddenHeaderTag(fromLocationAfterTag: location, in: textView) //positionAtEndOfHiddenHeaderTag(from: location, in: self)
//            debugPrint("headerTagStartLocation: \(headerTagStartLocation)")
//
////            let isHeaderTagStart = textStorage.isHeaderTagStart(at: headerTagStartLocation)
//
////            assert(isHeaderTagStart)
//            return headerTagStartLocation
            
        }
        else if cursorAtHeaderTagEnd {
            return location
        }
        
        return location
    }
    
    private func locationBeforeHiddenHeaderTag(from location: Int, inTextView textView: NSTextView) -> Int {
        
        guard let textStorage = textView.textStorage else {
            assertionFailure("Error: self.textStorage is nil")
            return location
        }
        
        let cursorInsideHeaderTag = textStorage.isCursorInsideHeaderTag(at: location)
        let cursorAtHeaderTagEnd = textStorage.isCursorAtHeaderTagEnd(at: location)
        let headerTagStart = textStorage.isHeaderTagStart(at: location)
        
        debugPrint("cursorInsideHeaderTag: \(cursorInsideHeaderTag) at location: \(location)")
        debugPrint("cursorAtHeaderTagEnd: \(cursorAtHeaderTagEnd) at location: \(location)")
        debugPrint("headerTagStart: \(headerTagStart) at location: \(location)")
        
        if cursorInsideHeaderTag {
            let headerTagStartLocation = textStorage.positionBeforeHiddenHeaderTag(from: location, in: textView) //positionAtEndOfHiddenHeaderTag(from: location, in: self)
            debugPrint("headerTagStartLocation: \(headerTagStartLocation)")
            
            assert(textStorage.isHeaderTagStart(at: headerTagStartLocation))
            return headerTagStartLocation
        }
        else if cursorAtHeaderTagEnd {
            
            let headerTagStartLocation = textStorage.positionBeforeHiddenHeaderTag(fromLocationAfterTag: location, in: textView) //positionAtEndOfHiddenHeaderTag(from: location, in: self)
            debugPrint("headerTagStartLocation: \(headerTagStartLocation)")
            
//            let isHeaderTagStart = textStorage.isHeaderTagStart(at: headerTagStartLocation)
            
//            assert(isHeaderTagStart)
            return headerTagStartLocation
            
        }
        else if headerTagStart {
            return location-1
        }
        
        return location
    }
    
    
//    func textView(_ view: NSTextView, write cell: NSTextAttachmentCellProtocol, at charIndex: Int, to pboard: NSPasteboard, type: NSPasteboard.PasteboardType) -> Bool {
//        
//        let updatedLocation = locationBeforeHiddenHeaderTag(from: charIndex, inTextView: view)
//        let selectedRange = view.selectedRange()
//        let safeStart = updatedLocation
//        let safeEnd = selectedRange.upperBound
////        let characterRange = NSMakeRange(safeStart, safeEnd - safeStart)
//        let string = view.string.slice(safeStart, end: safeEnd)
//        if let string = string {
//            pboard.writeObjects([NSString(string: string)])
//            return true
//        }
//        return false
//    }
//    
//    private func locationBeforeHiddenHeaderTag(from location: Int, inTextView textView: NSTextView) -> Int {
//        
//        guard let textStorage = textView.textStorage else {
//            assertionFailure("Error: textView.textStorage is nil")
//            return location
//        }
//        
//        let cursorInsideHeaderTag = textStorage.isCursorInsideHeaderTag(at: location)
//        let cursorAtHeaderTagEnd = textStorage.isCursorAtHeaderTagEnd(at: location)
//        let headerTagStart = textStorage.isHeaderTagStart(at: location)
//        
//        debugPrint("cursorInsideHeaderTag: \(cursorInsideHeaderTag) at location: \(location)")
//        debugPrint("cursorAtHeaderTagEnd: \(cursorAtHeaderTagEnd) at location: \(location)")
//        debugPrint("headerTagStart: \(headerTagStart) at location: \(location)")
//        
//        if cursorInsideHeaderTag || cursorAtHeaderTagEnd || headerTagStart {
//            return textStorage.positionBeforeHiddenHeaderTag(from: location, in: textView)
//        }
//
//        return location
//    }
    
    func textViewDidChangeTypingAttributes(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        let textView = notification.object as! NSTextView
        os_log("changed typing attributes to: %@", log: Log.StyloCore.all, type: .info, %%textView.typingAttributes)
        #endif
    }
    
    /// see http://www.cocoabuilder.com/archive/cocoa/282632-nstextview-attachments-and-context-menus.html
    func textView(_ view: NSTextView, menu: NSMenu, for event: NSEvent, at charIndex: Int) -> NSMenu? {
        
        guard let resourceEditorView = view as? MarkdownResourceEditorView else {
            assertionFailure("Error: view is not MarkdownResourceEditorView")
            return nil
        }
            
        if let node = resourceEditorView.node(at: charIndex) {
            
            if let menuItem = buildMenuItem(for: node, textView: resourceEditorView, sourceIndex: charIndex) {
            
                var copyIndex: Int?
                
                // remove Substitution submenu
                for (index, menuItem) in menu.items.enumerated() {

                    let identifierString = menuItem.identifier?.rawValue
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("identifierString for %@ menu item: %@", log: Log.StyloCore.all, type: .debug, %%menuItem.title, %%String(describing: identifierString))
                    #endif
                    
                    // remove Substitution submenu
                    for menuItem in menu.items {
                        
                        if let identifierString = menuItem.identifier?.rawValue,
                                identifierString == InterfaceConstants.MenuItems.Identifiers.LayoutOrientation {
                            menu.removeItem(menuItem)
                        }
                    }
                    
                    if let identifierString = identifierString, identifierString == InterfaceConstants.MenuItems.Identifiers.Copy {
                        copyIndex = index
                    }
                }
                
                assert(copyIndex != nil)
                if let copyIndex = copyIndex {
                    menu.insertItem(menuItem, at: copyIndex+1)
                }
                else {
                    menu.addItem(menuItem)
                }
            }
        }

        return menu
    }
    
    private func buildMenuItem(for node: Node, textView: MarkdownResourceEditorView, sourceIndex: Int) -> CopySelectorMenuItem? {
        
        if let element = node as? Element, !(element is HTMLBodyElement) {
            
            let menuItem = CopySelectorMenuItem(title: "Copy selector", action: #selector(copySelector(_:)), element: element, sourceIndex: sourceIndex)
            
            menuItem.target = self
            return menuItem
        }
        return nil
    }
    
    @objc fileprivate func copySelector(_ sender: AnyObject?) {
        
        if let copySelectorMenuItem = sender as? CopySelectorMenuItem {
            
            if let element = copySelectorMenuItem.element {
                
                let selectorString = element.selector(for: copySelectorMenuItem.sourceIndex)
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectorString: %@", log: Log.StyloCore.all, type: .debug, %%selectorString)
                #endif
                NSPasteboard.general.clearContents()
                NSPasteboard.general.writeObjects([NSString(string: selectorString)])
            }
        }
    }

}


