//
//  AutocompleteWindowController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-11.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

public final class AutocompleteWindowController: NSWindowController, AutocompleteDelegate {
    
    /// Property that keeps if the current language selection points
    /// to a language that does not contain any result from the current
    /// partial word.
    var noSelectionsForCurrentLanguageViewDisplayed: Bool
    
    /// Computed access to the AutocompletionsArrayViewController which displays 
    /// the available autocompletions.
    var autocompletionsArrayViewController: AutocompletionsArrayViewController {
        
        return self.contentViewController as! AutocompletionsArrayViewController
    }
    
    /// Computed variable to get the seelcted row in the autocompletions array.
    /// Used to hide the view hierarchy.
    fileprivate var selectedRow: Int? {
        
        return autocompletionsArrayViewController.completionsTableView.selectedRow
    }
    
    /// Required initializer.
    required init?(coder: NSCoder) {

        self.isShown = false
        self.noSelectionsForCurrentLanguageViewDisplayed = false
        super.init(coder: coder)
    }
    
    public func load() {
        
        assert(contentViewController != nil)
        self.contentViewController?.loadView()
        autocompletionsArrayViewController.loadView()
    }
    
    
    /// Method to show he autocompletion window.
    func showAtAnchorPoint(_ anchorPoint: NSPoint) {
        
        // The origin should be calculated using this formula:
        // icon textTield.origin.x - displacement - icon.size.width - type.size.width
//        self.window!.layoutIfNeeded()
        
        // TODO: It we would use attributes in the autocompletion window we would
        // assign them here in order to be able to use the proper letter size for the
        // displacement calculation.
        //        let attrString = NSAttributedString(string: lettersDisplacement, attributes: attributes)
        //
        //        let boundingRect = attrString.boundingRectWithSize(NSSize(width: Int.max, height: Int.max), options: .UsesLineFragmentOrigin)
        //        let textFieldXOrigin = autocompleteViewController.textFieldXOrigin
        let iconWidth = autocompletionsArrayViewController.iconWidth
        let typeWidth = autocompletionsArrayViewController.typeWidth
        let requestedXPosition = anchorPoint.x - typeWidth - iconWidth
        let xPosition = requestedXPosition > 0 ? requestedXPosition : 0
        let finalPosition = NSMakePoint(xPosition, anchorPoint.y)
        
        self.window!.setFrameTopLeftPoint(finalPosition)
        self.window!.orderFrontRegardless()
        self.isShown = true
        self.autocompletionsArrayViewController.sizeTableToFitContent()
    }
    
    /// Method that extracts an array of languages from the TstDictionary parameter
    /// and return it.
    fileprivate func extractLanguagesFromTstDictionary(_ dictionary: TstDictionary<CompletionValue>) -> [Language] {
        
        var languages = [Language]()
        
        for entry in dictionary {
            
            if let data = entry.data {
                
                if !languages.contains(data.language) {
                    
                    languages.append(data.language)
                }
            }
        }
        return languages
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: AutocompleteDelegate protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////

    /// Property used by the TextView to know if the
    /// autocompletion window is showm.
    ///
    /// FIXME: the client should not no this, we should hide
    /// any logic involving the autocompletion window from the
    /// client.
    fileprivate(set) public var isShown: Bool
    
    /// Reference to the client window, we need a reference to it
    /// in order to set our own window as childWindow of this parent
    /// window.
    weak public var parentWindow: NSWindow? {
        
        didSet {
            
            assert(parentWindow != nil)
            parentWindow?.addChildWindow(self.window!, ordered: NSWindow.OrderingMode.above)
            
            let styloWindowController = parentWindow?.windowController as? StyloWindowController
            
            assert(styloWindowController != nil)
            if let styloWindowController = styloWindowController {
            
                // we listen this this view since it the one really
                // containing the real App appearance.
                self.window?.appearanceSource = styloWindowController.globalMenuPanelViewController?.view
            }
            
            let defaultCenter: NotificationCenter = NotificationCenter.default
            
            defaultCenter.addObserver(forName: NSNotification.Name(rawValue: §StyloNotification.WindowMouseDown), object: parentWindow!, queue: nil) { [weak self](notification) -> Void in
                
                // close the autocompletion window if it is shown
                if self?.isShown == true {
                    self?.close()
                }
            }
        }
    }
    
    /// The StyloDocument holds a TstDictionary for each language
    public var targetLanguage: Language? {
        
        didSet {
            
            if let targetLanguage = targetLanguage {
                
                var tstDictionary: TstDictionary<CompletionValue>?
                
                switch targetLanguage {
                case .CSS:
                    tstDictionary = CSSCompletionsTstDictionaryFactory.GetCssTstDictionary()
                case .CCSS:
                    tstDictionary = CCSSCompletionsTstDictionaryFactory.GetCcssTstDictionary()
                case .Markdown:
                    tstDictionary = MarkdownCompletionsTstDictionaryFactory.GetMarkdownTstDictionary()
                case .HTML: fallthrough
                case .None: fallthrough
                case .Stella: fallthrough
                case .json: fallthrough
                case .markdownHtml: fallthrough
                case .All:
                    
                    // FIXME: add support for those languages
                    //        case Markdown = "text/markdown"
                    //        case HTML = "text/html"
                    //        case Stella = "text/stella"
                    #if DEBUG
                        assert(false, "Unsupported completion language.")
                    #else
                        debugPrint("Unsupported completion language.")
                    #endif
                    
                    break
                }
                
                autocompletionsArrayViewController.tstDictionary = tstDictionary!
                autocompletionsArrayViewController.languages = extractLanguagesFromTstDictionary(tstDictionary!)
            }
        }
    }
    
    /// Move the selection down in the list of offered completions.
    public func moveSelectionDown() {
        
        selectRowIndex(selectedRow!+1, scrollToMakeRowVisible: true, userInitiated: true)
    }

    /// Move the selection up in the list of offered completions.
    public func moveSelectionUp() {
        
        selectRowIndex(selectedRow!-1, scrollToMakeRowVisible: true, userInitiated: true)
    }
    
    public func updateAutocompletions(forPartialWord partialWord: String?) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("update autocompletions with partial word: %@", log: Log.StyloCore.all, type: .info, %%String(describing: partialWord))
        #endif
        
        assert(self.isShown == true)
        let selectedLanguages = autocompletionsArrayViewController.languages
        
        let reloadResult = autocompletionsArrayViewController.reloadData(forPartialWord: partialWord?.lowercased(), forSelectedLanguages: selectedLanguages!, allLanguagesSelected: true)
        
        switch reloadResult {
        case .nonEmptyResult:
            autocompletionsArrayViewController.sizeTableToFitContent()
            break
        case .emptyResultForSelectedLanguages: fallthrough
        case .emptyResult:
            close()
        }
        
    }
    
    ///
    public func showAutocompletionWindow(forPartialWord partialWord: String?, withStartOfWordOrigin wordOrigin: NSPoint, forceDisplay: Bool = false, input: Autocompletable) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("show autocompletion for partial word: %@", log: Log.StyloCore.all, type: .info, %%String(describing: partialWord))
        #endif
        
        let selectedLanguages = autocompletionsArrayViewController.languages
        
        let reloadResult = autocompletionsArrayViewController.reloadData(forPartialWord: partialWord?.lowercased(), forSelectedLanguages: selectedLanguages!, allLanguagesSelected: true)
        
        switch reloadResult {
            
        case .nonEmptyResult(let autocompletions):
            
            if autocompletions.count > 1 {
                showAtAnchorPoint(NSMakePoint(wordOrigin.x, wordOrigin.y))
            }
            else if autocompletions.count == 1 {
                
                if let autocompletion = autocompletions.first {
                    
                    let completionValue = autocompletion.entry.data?.completionValue
                    
                    assert(completionValue != nil)
                    if let completionValue = completionValue {
                        input.insert(completion: completionValue)
                    }
                }
            }
            
        case .emptyResultForSelectedLanguages: fallthrough
        case .emptyResult:
            
            close()
        }
    }
    
    /// Method that allows to close ourself 
    /// (the window in which we are displayed)
    override public func close() {
        
        self.window!.close()
        self.isShown = false
    }
    
    /// This method reurn the selected completion value
    public func selectedCompletionValue() -> String {
        
        return autocompletionsArrayViewController.selectedCompletionValue()
    }
    
    /// Method to select a specific row index in th autocompletions array.
    fileprivate func selectRowIndex(_ index: Int, scrollToMakeRowVisible: Bool = true, userInitiated: Bool = true) {
        
        autocompletionsArrayViewController.selectRowIndex(index, scrollToMakeRowVisible: scrollToMakeRowVisible, userInitiated: userInitiated)
    }
}
