//
//  Autocompletable.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-03-18.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

public protocol Autocompletable: class {
    
    var isAutocompleteShown: Bool { get }
    
    var document: TextDocument? { get }
    
    var completionDelegate: AutocompleteDelegate? { get set }
    
    var WORD_BOUNDARY_CHARS: NSMutableCharacterSet { get }
    
    func closeAutocomplete()
    
    /// Add the autompletion support for a certain language
    func addAutocompletionSupport(for language: Language)
    
    /// Normally, when there is no completions we don't show the
    /// autocompletion window. But the user has the possibility
    /// to force the showing of the autocompletion window. In this case,
    /// we need to know it since if there is no completions we will still
    /// display the window bu with "No Completions" text.
    var shouldCompleteEmpty: Bool { get set }
    
    /// Method that returns the current writing string along with
    /// it's occupied range which could be of length 0 if the string
    /// is nil.
    func extractPartialWord() -> (String?, NSRange)
    
    /// Function that take the key event and manage the autompletion.
    func handleKeyDownAutocomplete(with theEvent: NSEvent) -> (Bool, Bool)
    
    /// Method called when we are asked to complete
    func handleComplete(_ sender: Any?)
    
    func insert(completion: String)
}

extension Autocompletable where Self: ResourceEditorView {
    
    public var isAutocompleteShown: Bool {
        
        if let completionDelegate = completionDelegate {
            
            return completionDelegate.isShown
        }
        return false
    }
    
    public func closeAutocomplete() {
        
        if isAutocompleteShown {
            completionDelegate?.close()
        }
    }
    
    public func handleComplete(_ sender: Any?) {
        
        if let completionDelegate = completionDelegate {
            
            let resourceEditorView = sender as! ResourceEditorView
            
            let (partialWord, substringRange) = extractPartialWord()
            
            if resourceEditorView.shouldCompleteEmpty || substringRange.length > 0 {
                
                if !completionDelegate.isShown {
                
                    let startOfWordRect = firstRect(forCharacterRange: substringRange, actualRange: nil)
                    
                    completionDelegate.showAutocompletionWindow(forPartialWord: partialWord, withStartOfWordOrigin: startOfWordRect.origin, forceDisplay: resourceEditorView.shouldCompleteEmpty, input: self)
                    
                    // reset the value to false in all cases
                    // false will have no effect but it's faster than
                    // checking with if shouldCompleteEmpty { ... }
                    self.shouldCompleteEmpty = false
                }
                else {
                    
                    completionDelegate.updateAutocompletions(forPartialWord: partialWord)
                }
            }
            else {
                
                completionDelegate.close()
            }
        }
    }
    
    /// Return true if it should be forwarded to super.
    /// shouldForwardKeyDownEventToSuper
    public func handleKeyDownAutocomplete(with theEvent: NSEvent) -> (Bool, Bool) {
        
        var shouldForwardKeyDownEventToSuper = true
        
        var shouldComplete = true
        
        // see http://stackoverflow.com/questions/20727185/how-to-implement-my-own-pop-up-control-in-cocoa
        if let completionDelegate = completionDelegate {
            
            let keyCode = theEvent.keyCode
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("keyCode: %d", log: Log.StyloCore.all, type: .info, keyCode)
            #endif
            
            switch keyCode {
                
            case 49:
                
                let ch = theEvent.charactersIgnoringModifiers
                
                if ch == " " && theEvent.modifierFlags.contains(.control) {
                    
                    // Control
                    if completionDelegate.isShown {
                        
                        completionDelegate.close()
                    }
                    
                    shouldForwardKeyDownEventToSuper = false
                    shouldCompleteEmpty = true
                    break
                }
                else {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("strange case...", log: Log.StyloCore.all, type: .debug)
                    #endif
                    if completionDelegate.isShown {
                        
                        completionDelegate.close()
                    }
                    
                    shouldComplete = false
                    break
                }
                
            case 51:
                
                // delete key: we don't have to do anything
                // NW-374
                if !completionDelegate.isShown {
                
                    shouldComplete = false
                }
                
                break
                
            case 53:
                
                // Esc
                if completionDelegate.isShown {
                    
                    completionDelegate.close()
                }
                
                return (false, false) // Skip default behavior
                
            case 123:
                
                // Left
                fallthrough
                
            case 124:
                
                // Right
                if completionDelegate.isShown {
                    
                    completionDelegate.close()
                }
                
                shouldComplete = false
                
                break
                
            case 125:
                
                // Down
                if completionDelegate.isShown {
                    
                    completionDelegate.moveSelectionDown()
                    
                    // Skip default behavior
                    return (false, false)
                }
                else {
                    
                    shouldComplete = false
                }
                
                break
                
            case 126:
                
                // Up
                if completionDelegate.isShown {
                    
                    completionDelegate.moveSelectionUp()
                    
                    // Skip default behavior
                    return (false, false)
                }
                else {
                    
                    shouldComplete = false
                }
                
                break
                
            case 36:
                
                // Return
                if completionDelegate.isShown {
                    
                    insert(self)
                    return (false, false) // Skip default behavior
                }
                else {
                    
                    shouldComplete = false
                }
                
                break
                
            case 48:
                
                if completionDelegate.isShown {
                    
                    insert(self)
                    return (false, false) // Skip default behavior
                }
                else {
                    
                    shouldComplete = false
                }
                
            default:
                
                if completionDelegate.isShown {
                    
                    shouldComplete = true
                }
                else {
                    shouldComplete = false
                }
                
            }
        }
        return (shouldForwardKeyDownEventToSuper, shouldComplete)
    }
    
    public func insert(_ sender: AnyObject?) {
        
        if let completionDelegate = completionDelegate {
            
            let string = completionDelegate.selectedCompletionValue()
            insert(completion: string)
            completionDelegate.close()
        }
    }
    
    public func insert(completion: String) {
        
        let (_, substringRange) = extractPartialWord()
        
        assert(self.textStorage != nil)
        if let textStorage = self.textStorage {
            
            if self.shouldChangeText(in: substringRange, replacementString: completion) {
            
                textStorage.beginEditing()
                textStorage.replaceCharacters(in: substringRange, with: completion)
                textStorage.endEditing()
                didChangeText()
            }
        }
    }
    
    public func addAutocompletionSupport(for language: Language) {
        
        // Autocompletion initialization
        let bundle = Bundle(for: MacStyloDocument.self)
        let storyboard = NSStoryboard(name: NSStoryboard.Name(string: "Autocomplete"), bundle: bundle)
        
        let autocompleteWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(string: "Autocomplete")) as! AutocompleteWindowController
        
        completionDelegate = autocompleteWindowController
        completionDelegate!.targetLanguage = language
        autocompleteWindowController.load()
        
        if let document = document {
        
            switch document.documentAppearanceMode! {
            case .dark:
                self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
            case .light:
                self.window!.appearance = NSAppearance(named: NSAppearance.Name.vibrantLight)
            }
        }
    }
    
    public func extractPartialWord() -> (String?, NSRange) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("self.selectedRange.location: %@", log: Log.StyloCore.all, type: .info, %%self.selectedRange.location)
        #endif
        var startOfWordPosition: Int = self.selectedRange.location
        var endOfWordPosition: Int = self.selectedRange.location
        
        while let character = self.string.charAt(endOfWordPosition) {
            
            if !WORD_BOUNDARY_CHARS.characterIsMember(character) {
                
                break
            }
            
            endOfWordPosition += 1
        }
        
        if startOfWordPosition > 0 {
            
            startOfWordPosition -= 1
            
            while let character = self.string.charAt(startOfWordPosition) {
                
                if startOfWordPosition == 0 {
                    
                    break
                }
                
                if !WORD_BOUNDARY_CHARS.characterIsMember(character) {
                    
                    startOfWordPosition += 1
                    break
                }
                
                startOfWordPosition -= 1
            }
        }
        
        let substringRange: NSRange = NSMakeRange(startOfWordPosition, endOfWordPosition - startOfWordPosition)
        
        if substringRange.length == 0 {
            return (nil, substringRange)
        }
        
        let substring = self.string.substring(startOfWordPosition, length: endOfWordPosition - startOfWordPosition)
        return (substring, substringRange)
    }
}
