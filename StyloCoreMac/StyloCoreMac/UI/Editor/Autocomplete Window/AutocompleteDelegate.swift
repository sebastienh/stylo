//
//  AutocompleteDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-02-11.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Cocoa
import WriterCommon

public protocol AutocompleteDelegate: class {
    
    /// The StyloDocument holds a TstDictionary for each language
    var targetLanguage: Language? { get set }
    
    var isShown: Bool { get }
    
    var parentWindow: NSWindow? { get set }
    
    func updateAutocompletions(forPartialWord partialWord: String?)
    
    func showAutocompletionWindow(forPartialWord partialWord: String?, withStartOfWordOrigin wordOrigin: NSPoint, forceDisplay: Bool, input: Autocompletable)
    
    /// Method that allows to close ourself
    /// (the window in which we are displayed)
    func close()
    
    /// Move the selection down in the list of offered completions.
    func moveSelectionDown()
    
    /// Move the selection up in the list of offered completions.
    func moveSelectionUp()
    
    /// This method return the selected completion value
    func selectedCompletionValue() -> String
}
