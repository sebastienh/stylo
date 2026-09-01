//
//  AutocompletionsArrayViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-03-08.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import Common
import WriterCommon
import os

let MinimumAutcompletionViewWidth: CGFloat = 180

final class AutocompletionsArrayViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    let Buffer: CGFloat = 2
    
    ///
    /// The containing AutocompleteView
    ///
    @IBOutlet var autocompleteView: NSView!
    
    ///
    /// The NSTableView used to display the autocompletions.
    ///
    @IBOutlet var completionsTableView: AutocompleteTableView!
    
    ///
    /// ScrollView outlet.
    ///
    @IBOutlet var scrollView: NSScrollView!
    
    ///
    ///
    ///
    @IBOutlet var completionTableColumn: NSTableColumn!
    
    ///
    ///
    ///
    @IBOutlet var languageTableColumn: NSTableColumn!
    
    ///
    ///
    ///
    @IBOutlet var scrollViewWidthConstraint: NSLayoutConstraint!
    
    ///
    ///
    ///
    @IBOutlet var scrollViewHeightConstraint: NSLayoutConstraint!
    
    ///
    /// Auocomplete message view text field reference.
    ///
    @IBOutlet weak var autocompleteMessageTextField: NSTextField!
    
    ///
    /// The TstDictionary for computing the autocomplete entries.
    ///
    var tstDictionary: TstDictionary<CompletionValue>!
    
    ///
    /// Dynamic variable holding the height of an array row.
    ///
    var rowHeight: CGFloat {
        
        return completionsTableView.rowHeight
    }
    
    ///
    /// Local reference to the current partial word used to filter the selection.
    ///
    var currentPartialWord: String?
    
    ///
    /// Variable to keep the last selected key in the
    /// autocompletion array. When the user selects a value in the
    /// autocompletion array we want to keep it selected even if the user
    /// continues to type and new autocompletions are shown. Also, we want
    /// to change the selected value to the first one if the value was autoselected.
    /// The last user selected key is only populated if it's the user selection...
    ///
    var lastUserSelectedKey: String?
    
    ///
    /// Alphabetically ordered array of autocompletions that is used as the
    /// backing for the NSTableView (completionsTableView).
    ///
    @objc dynamic var autocompleteEntriesArray: [AutocompleteEntry]!
    
    ///
    /// Dynamic property to contain the number of rows 
    /// in the autocomplete entries array.
    ///
    var rows: Int {
        
        return autocompleteEntriesArray.count
    }
    
    ///
    /// Computed property containing the autocompletions text fields 
    /// x origin position. 
    ///
    /// Note: Used to compute the autocomplete window
    /// according to a partial word to complete x position.
    ///
    var textFieldXOrigin: Int {
        
        return 0
    }
    
    ///
    /// Computed property containing the autocompletions icon width.
    ///
    /// Note: Used to compute the autocomplete window
    /// according to a partial word to complete x position.
    ///
    var iconWidth: CGFloat {
        
        return 0
    }
    
    ///
    /// Computed property containing the autocompletions type width.
    ///
    /// Note: Used to compute the autocomplete window
    /// according to a partial word to complete x position.
    ///
    var typeWidth: CGFloat {
        
        return 0
    }
    
    ///
    /// Array that contains all the extracted languages from the TstDictionary.
    ///
    var languages: [Language]!
    
    private var completionWidth: CGFloat = StyloConstants.Autocompletion.CompletionWidth
    
    private var languageWidth: CGFloat = StyloConstants.Autocompletion.LanguageWidth
    
    private var oldSelectedAutocompleteView: AutocompleteTableCellView?
    
    private var oldSelectedLanguageView: LanguageTableCellView?
    
    ///
    /// 
    ///
    required init?(coder: NSCoder) {
        
        self.autocompleteEntriesArray = [AutocompleteEntry]()
        super.init(coder: coder)
    }
    
    override func viewWillAppear() {
        
        self.view.needsLayout = true
        super.viewWillAppear()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        completionsTableView.doubleAction = #selector(handleDoubleClick(_:))
        completionsTableView.target = self
    }
    
    ///
    /// Method to set the table view height.
    ///
    func setTableViewHeight(_ tableHeight: CGFloat) {
        
        scrollViewHeightConstraint.constant = tableHeight
    }
    
    /// Reset the table view height using the containg scroll view 
    /// height constraint
    func resetTableViewHeight() {
        
        let constraint: NSLayoutConstraint = scrollView.constraintForAttribute(NSLayoutConstraint.Attribute.height)!
        constraint.constant = scrollView.documentView!.bounds.size.height
    }
    
    func sizeTableToFitContent() {
        
        let numberOfRowsShown = CGFloat(rows) > StyloConstants.Autocompletion.MaxSize ? StyloConstants.Autocompletion.MaxSize : CGFloat(rows)
        
        setTableViewHeight((rowHeight + completionsTableView.intercellSpacing.height) * CGFloat(numberOfRowsShown))

        os_log("desired completionWidth: %f", log: Log.StyloCore.all, type: .info, completionWidth)
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("desired languageWidth: %f", log: Log.StyloCore.all, type: .info, languageWidth)
        #endif
        
        let desiredWidth = completionWidth + languageWidth + completionsTableView.intercellSpacing.width
        
        if desiredWidth >= MinimumAutcompletionViewWidth {
            
            scrollViewWidthConstraint.constant = desiredWidth
            
            completionTableColumn.width = completionWidth
            completionTableColumn.minWidth = completionWidth
            languageTableColumn.width = languageWidth
            languageTableColumn.minWidth = languageWidth
        }
        else {
            
            scrollViewWidthConstraint.constant = MinimumAutcompletionViewWidth
            let completionTableColumnWidth = MinimumAutcompletionViewWidth - completionsTableView.intercellSpacing.width - languageWidth
            
            completionTableColumn.width = completionTableColumnWidth
            completionTableColumn.minWidth = completionTableColumnWidth
            languageTableColumn.width = languageWidth
            languageTableColumn.minWidth = languageWidth
        }
        self.completionsTableView.sizeLastColumnToFit()
    }
    
    var allKeys: [AutocompleteEntry]?
    
    func reloadData(forPartialWord partialWord: String? = nil, forSelectedLanguages selectedLanguages: [Language], allLanguagesSelected: Bool) -> AutocompleteResult {
        
        let result: AutocompleteResult
        if let allKeys = allKeys, partialWord == nil {
            
            if partialWord != self.currentPartialWord {
                result = updateCompletionsAndSelectionsForPartialWord(partialWord, forSelectedLanguages: selectedLanguages)
            }
            else {
                result = AutocompleteResult.nonEmptyResult(keys: allKeys)
            }
        }
        else {
            result = updateCompletionsAndSelectionsForPartialWord(partialWord, forSelectedLanguages: selectedLanguages)
            
            // cache the allKeys values
            if partialWord == nil {
                switch result {
                case .nonEmptyResult(let completions):
                    allKeys = completions
                default:
                    break
                }
            }
        }
        
        self.currentPartialWord = partialWord
        
        switch result {
        case .nonEmptyResult(_):
            
            sizeTableToFitContent()
            autocompleteView.needsLayout = true
            selectRowIndex(0, userInitiated: false)
            return result
        default:
            // there is no completions when
            lastUserSelectedKey = nil
        }
        return result
    }
    
    ///
    @IBAction func handleDoubleClick(_ sender: AnyObject?) {
        
        let autocompleWindowController = self.view.window!.windowController! as! AutocompleteWindowController
        
        StyloNotification.DoubleClickedAutocompletionItem.sendNotification(autocompleWindowController)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: AutocompleteDelegate supports method
    //                  implementation in order to act as the support for the AutocompleteWindowController
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    ///
    /// This method just use the TstDictionary to get the available completions
    /// for the passed partialWord.
    ///
    fileprivate func updateCompletionsAndSelectionsForPartialWord(_ partialWord: String?, forSelectedLanguages selectedLanguages: [Language]) -> AutocompleteResult {
        
        removeAllAutocompletionEntries()
        let completions = tstDictionary.prefixMatch(partialWord)
        return updateCompletionArrayWithCompletions(completions, forSelectedLanguages: selectedLanguages)
    }
    
    ///
    /// This method just update the NSTableView with the completions passed
    /// in parameter after having filered them according to the selected
    /// languages and ordered them alphabetically.
    ///
    fileprivate func updateCompletionArrayWithCompletions(_ completions: [TstDictionaryEntry<CompletionValue>], forSelectedLanguages selectedLanguages: [Language]) -> AutocompleteResult {
        
        if autocompleteEntriesArray.count == 0 {
            
            if completions.count == 0 {
                
                completionsTableView.reloadData()
                return .emptyResult
            }
            
            // filtered the available completions according to the selected languages
            let filteredCompletions = completions.filter({ (entry: TstDictionaryEntry<CompletionValue>) -> Bool in
                
                if selectedLanguages.contains(entry.data!.language) {
                    return true
                }
                return false
            })
            
            if filteredCompletions.isEmpty {
                
                completionsTableView.reloadData()
                return .emptyResultForSelectedLanguages
            }
            
            // create the autocompletions entries
            for entry in filteredCompletions {
                
                let automcompleteEntry = AutocompleteEntry(entry: entry, hidden: false, selected: false)
                autocompleteEntriesArray.append(automcompleteEntry)
            }
            
            // sort alphabetically
            autocompleteEntriesArray.sort(by: {
                
                (first: AutocompleteEntry, second: AutocompleteEntry) -> Bool in
                
                return first.entry.key! < second.entry.key!
            })
        }
        
        completionsTableView.reloadData()
        return .nonEmptyResult(keys: autocompleteEntriesArray)
    }
    
    ///
    /// Generic method that should be called to select a row in
    /// the table.
    ///
    func selectRowIndex(_ index: Int, scrollToMakeRowVisible: Bool = true, userInitiated: Bool = false) {
        
        var secureIndex = index
        
        if secureIndex >= rows {
            secureIndex = rows - 1
        }
        
        if secureIndex < 0 {
            secureIndex = 0
        }
        
        selectRow(index: secureIndex)
        
        if scrollToMakeRowVisible {
            
            completionsTableView.scrollRowToVisible(secureIndex)
        }
        
        let tableCellView = self.tableView(completionsTableView, viewFor: completionTableColumn, row: secureIndex) as! AutocompleteTableCellView
        
        if userInitiated {
            
            lastUserSelectedKey = tableCellView.key!
        }
    }
    
    private func selectRow(index: Int) {
        
        oldSelectedAutocompleteView?.selected = false
        oldSelectedLanguageView?.selected = false
        
        completionsTableView.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        
        let autocompleteCellView = completionsTableView.view(atColumn: 0, row: index, makeIfNecessary: true) as? AutocompleteTableCellView
        
        assert(autocompleteCellView != nil)
        autocompleteCellView?.selected = true
        oldSelectedAutocompleteView = autocompleteCellView
        
        let languageCellView = completionsTableView.view(atColumn: 1, row: index, makeIfNecessary: true) as? LanguageTableCellView
        
        assert(languageCellView != nil)
        languageCellView?.selected = true
        oldSelectedLanguageView = languageCellView
        
        autocompleteCellView?.selected = true
    }
    
    /// This method returns the selected completion value from
    /// the specified index
    func selectedCompletionValue() -> String {
        
        let selectedRow = completionsTableView.selectedRow
        let autocompleteEntry = autocompleteEntriesArray[selectedRow]
        
        return autocompleteEntry.entry.data!.completionValue
    }
    
    ///
    /// Method that removes all entries from the autocompletion array.
    /// This array is used to display the results in the NSTableView.
    ///
    fileprivate func removeAllAutocompletionEntries() {
        
        autocompleteEntriesArray.removeAll()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: NSTableViewDataSource protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func numberOfRows(in aTableView: NSTableView) -> Int {
        
        return autocompleteEntriesArray.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if row < autocompleteEntriesArray.count && row >= 0 {
            
            if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "CompletionTableColumn") {
                
                let cellView = completionsTableView.makeView(withIdentifier: completionTableColumn!.identifier, owner: self)  as! AutocompleteTableCellView
                assert(completionWidth >= cellView.desiredWidth, "Need to change the completionWidth value to: \(cellView.desiredWidth)")
                completionWidth = max(completionWidth, cellView.desiredWidth)
                
                let autocompleteEntry = autocompleteEntriesArray[row]
                
                // here we should put the reference to the selectable circle...
                //            cellView.imageView!.image =
                
                cellView.textField!.stringValue = trimSurroundingQuotationMarks(string: autocompleteEntry.entry.data!.completionDisplay)
                
                cellView.message = autocompleteEntry.entry.data?.desc
                cellView.key = autocompleteEntry.entry.key!
                
                return cellView
            }
            else if tableColumn?.identifier == NSUserInterfaceItemIdentifier(rawValue: "LanguageTableColumn") {
                
                let cellView = completionsTableView.makeView(withIdentifier: languageTableColumn!.identifier, owner: self)  as! LanguageTableCellView
                assert(languageWidth >= cellView.desiredWidth, "Need to change the languageWidth value to: \(cellView.desiredWidth)")
                languageWidth = max(languageWidth, cellView.desiredWidth)
                
                let autocompleteEntry = autocompleteEntriesArray[row]
                
                // here we should put the reference to the selectable circle...
                //            cellView.imageView!.image =
                cellView.textField!.stringValue = autocompleteEntry.entry.data!.shortDescription
                
                return cellView
            }
        }
        return nil
    }
    
    fileprivate func trimSurroundingQuotationMarks(string: String) -> String {
        
        var result = string
        
        if let first = string.charAt(0), first == §UnicodeCharacter.quotationMark {
            
            result = result.slice(1)!
        }
        
        if let end = result.charAt(result.length - 1), end == §UnicodeCharacter.quotationMark {
         
            result = result.slice(0, end: result.length - 1)!
        }
        
        return result
    }

}
