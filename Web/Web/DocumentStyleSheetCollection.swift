//
//  DocumentStyleSheetCollection.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-31.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import os

final class DocumentStyleSheetCollection : DocumentStyle {
    
    /// [SameObject] readonly attribute StyleSheetList styleSheets;
    var styleSheets: StyleSheetList
    
    ///  attribute DOMString? selectedStyleSheetSet;
    var selectedStyleSheetSet: DOMString?
    
    ///  readonly attribute DOMString? lastStyleSheetSet;
    var lastStyleSheetSet: DOMString?
    
    ///  readonly attribute DOMString? preferredStyleSheetSet;
    var preferredStyleSheetSet: DOMString?
    
    ///  readonly attribute DOMString[] styleSheetSets;
    var styleSheetSets: [DOMString]
    
    /// dictionary of sets indexed by their name
    var styleSheetSetsValues: [DOMString : CSSStyleSheetSet]
    
    /// Keep a global record of all pending sheets
    var pendingSheet: Int
    
    init() {
        
        self.styleSheets = StyleSheetList()
        self.styleSheetSets = [DOMString]()
        self.styleSheetSetsValues = [DOMString : CSSStyleSheetSet]()
        
        // at creation time there is no pending sheets
        self.pendingSheet = 0
    }
    
    func hasPendingSheets() -> Bool {
        
        assert(false, "Missing implementation.")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("hasPendingSheets() missing implementation.", log: Log.Web.all, type: .error)
        #endif
        return false
    }
    
    /// Create a CSS Style Sheet
    /// The url parameter is assumed to be the complete URL 
    /// to rewach the CSS style sheet source
    /// see http://dev.w3.org/csswg/cssom/#create-a-css-style-sheet
    func createStyleSheet(_ url: DOMString, title: DOMString, completionHandler: (() -> Void)?) {
        
        let styleSheetContents = StyleSheetContents(urlString: url, ownerRule: nil)
        
        var cssStyleSheet: CSSStyleSheet?
        
        pendingSheet += 1
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Pending sheets incremented : %d", log: Log.Web.all, type: .info, pendingSheet)
        #endif
        
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async(execute: {

            styleSheetContents.resolveURLContent( {
                
                (string: String?, error: NSError?) in
                
                if let content = string {
                    
                    let cssOmModule = CSSOMModule.shared
                    
                    cssStyleSheet = cssOmModule.parseStyleSheet(content as NSString, origin: .author)

                    DispatchQueue.main.async(execute: {
                        
                        if let cssStyleSheet = cssStyleSheet {
                            
                            // set Style Sheet title from the parameters
                            cssStyleSheet.title = title
                            
                            self.addCSSStyleSheet(cssStyleSheet)
                        }
                        
                        self.pendingSheet -= 1
                        
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("Pending sheets decremented : %d", log: Log.Web.all, type: .info, self.pendingSheet)
                        #endif
                        
                        if let completionHandler = completionHandler {
                            
                            completionHandler()
                        }
                    })
                }
                else {
                    
                    // FIXME: handle the error here
                    if let error = error {
                        
                        if error.domain == NSStyloErrorDomain {
                            
                            assert(false, "Missing implementation.")
                            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                            os_log("NSStyloErrorDomain missing implementation.", log: Log.Web.all, type: .error)
                            #endif
                            
//                            parserReport.messageHandler.addMessage(
//                                MessageCode.ErrorGettingStyleSheet,
//                                sourceStringSegment: nil,
//                                args: [styleSheetContents.urlString])
                        }
                    }
                    else {
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("both content and error is nil", log: Log.Web.all, type: .error)
                        #endif
                    }
                }
            })
        })
    }
    
    /// Add a CSS style sheet to the list of style sheets.
    /// see http://dev.w3.org/csswg/cssom/#add-a-css-style-sheet
    func addCSSStyleSheet(_ styleSheet: CSSStyleSheet) {
     
        // 1. Add the CSS style sheet to the list of document CSS style sheets at the appropriate location. 
        // The remainder of these steps deal with the disabled flag.
        styleSheets.addStyleSheet(styleSheet)
        
        // 2. If the disabled flag is set, terminate these steps.
        if styleSheet.disabled {
            
            return
        }
        
        // 3. If the title is not the empty string, the alternate flag is unset, 
        // and preferred CSS style sheet set name is the empty string change the preferred CSS style sheet 
        // set name to the title.
        if let title = styleSheet.title , !styleSheet.alternate {
            
            // FIXME: should be everything in one condition
            var setPrefered: Bool = false
            
            if let preferredStyleSheetSet = preferredStyleSheetSet , preferredStyleSheetSet.isEmpty {
                setPrefered = true
            }
            else if preferredStyleSheetSet == nil {
                setPrefered = true
            }
            
            if setPrefered {
            
                preferredStyleSheetSet = title
            }
        }
        
        // 4. If any of the following is true unset the disabled flag and terminate these steps:
        //      - The title is the empty string.
        //      - The last CSS style sheet set name is null and the title is a case-sensitive 
        //        match for the preferred CSS style sheet set name.
        //      - The title is a case-sensitive match for the last CSS style sheet set name.
        if styleSheet.title == nil {
            
            styleSheet.disabled = false
            return
        }
        else if let title = styleSheet.title, let preferredStyleSheetSet = preferredStyleSheetSet {

            if lastStyleSheetSet == nil && title == preferredStyleSheetSet {
                
                styleSheet.disabled = false
                return
            }
        }
        else if let title = styleSheet.title, let lastStyleSheetSet = lastStyleSheetSet {
            
            if title == lastStyleSheetSet {
                
                styleSheet.disabled = false
                return
            }
        }
        
        // 5. Set the disabled flag.
        styleSheet.disabled = true
    }
    
    /// Remove a CSS style sheet from the document style sheet collection.
    /// see http://dev.w3.org/csswg/cssom/#remove-a-css-style-sheet
    func removeStyleSheet(_ styleSheet: CSSStyleSheet) {
        
        // 1. Remove the CSS style sheet from the list of document CSS style sheets.
        styleSheets.removeStyleSheet(styleSheet)
        
        // 2. Set the CSS style sheet’s parent CSS style sheet, 
        // owner node and owner CSS rule to null.
        styleSheet.parentStyleSheet = nil
        styleSheet.ownerNode = nil
        styleSheet.ownerRule = nil
    }
    
    /// Enable a CSS style sheet set with name name.
    /// void enableStyleSheetsForSet(DOMString? name);
    /// see http://dev.w3.org/csswg/cssom/#enable-a-css-style-sheet-set
    func enableStyleSheetsForSet(_ name: DOMString?) {
        
        // 1. If name is the empty string, set the disabled flag for each CSS style sheet that 
        // is in a CSS style sheet set and terminate these steps.
        if name == nil {
            
            for styleSheet in styleSheets {
                
                if isStyleSheetPartOfASet(styleSheet) {
                    
                    styleSheet.disabled = true
                }
            }
            return
        }
        
        // 2. Unset the disabled flag for each CSS style sheet in a CSS style sheet set whose CSS style sheet
        // set name is a case-sensitive match for name and set it for all other CSS style sheets 
        // in a CSS style sheet set.
        if let name = name {
            
            for styleSheetSet in styleSheetSetsValues.values {
             
                for styleSheet in styleSheetSet {

                    styleSheet.disabled = true
                }
            }
            
            let styleSheetSet = styleSheetSetsValues[name]
        
            if let styleSheetSet = styleSheetSet {
            
                for styleSheet in styleSheetSet {
                    
                    styleSheet.disabled = false
                }
            }
        }
        else {
            // In fact, this should never happen, but we it here 
            // always better to be paranoid.
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("name is nil.", log: Log.Web.all, type: .error)
            #endif
        }
    }
    
    /// Select a CSSStyleSheetSet
    /// see http://dev.w3.org/csswg/cssom/#select-a-css-style-sheet-set
    func selectStyleSheetSetWithName(_ name: DOMString) {
        
        // 1. enable a CSS style sheet set with name name.
        enableStyleSheetsForSet(name)
        
        // 2. Set last CSS style sheet set name to name.
        lastStyleSheetSet = name
    }
    
    
    /// Method to determine if a style sheet is in a particular 
    /// CSS style sheet set
    func isStyleSheetPartOfSetWithName(_ styleSheet: CSSStyleSheet, name: DOMString) -> Bool {
        
        let styleSheetSet = styleSheetSetsValues[name]
        
        if let styleSheetSet = styleSheetSet {
            
            return styleSheetSet.isStyleSheetInSet(styleSheet)
        }
        
        return false
        
    }
    
    /// Change the preferred CSSStyleSheet set name.
    /// see http://dev.w3.org/csswg/cssom/#change-the-preferred-css-style-sheet-set-name
    func changePreferredStyleSheetSetName(_ name: DOMString) {
        
        // 1. Let current be the preferred CSS style sheet set name.
        let current = preferredStyleSheetSet
        
        // 2. Set preferred CSS style sheet set name to name.
        preferredStyleSheetSet = name
        
        // 3. If name is not a case-sensitive match for current and last CSS style sheet set 
        // name is null enable a CSS style sheet set with name name.
        if name != current && lastStyleSheetSet == nil {
            
            enableStyleSheetsForSet(name)
        }
    }
    
    /// Method to determine if a stylesheet is in a CSS style sheet set. 
    func isStyleSheetPartOfASet(_ styleSheet: StyleSheet) -> Bool {
        
        for styleSheetSet in styleSheetSets {
            
            if let title = styleSheet.title {
                
                if title == styleSheetSet {
                    
                    return true
                }
            }
        }
        return false
    }
    
    /// If there is a single enabled CSS style sheet set the method will return 
    /// it, otherwise it will return nil.
    func singleEnableStyleSheetSet() -> CSSStyleSheetSet? {
        
        var enabledStyleSheetSet: CSSStyleSheetSet?
        
        for styleSheetSet in styleSheetSetsValues.values {
            
            if styleSheetSet.isEnabled() {
                
                // if there is already a set enabled, we return 
                // nil since we want to know if there is a single 
                // style sheet.
                if let _ = enabledStyleSheetSet {
                    
                    return nil
                }
                
                enabledStyleSheetSet = styleSheetSet
            }
        }
        
        return enabledStyleSheetSet
    }
    
}
