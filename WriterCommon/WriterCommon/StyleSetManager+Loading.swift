//
//  StyleSetManager+Loading.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-02-06.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import os

fileprivate enum IncludedTextStyletype: String {
    
    case styloDark = "stylo-dark"
    case styloLight = "stylo-light"
    case solarizedDark = "solarized-dark"
    case solarizedLight = "solarized-light"
}

extension StyleSetManager {
    
    ///
    /// This method use the styleSetDirectoryURL and iterate over all subdirectories
    /// and for each create a CCSSStyleManager.
    ///
    func loadAllStylesWithStyle(stylingManager: StyleManager?, from stylesFileWrapper: FileWrapper, styleSetMetadata: StyleSetMetadata?) {
        
        loadAllStyleManagersWithStyle(stylingManager: stylingManager, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        self.ensureStyleOrdering()
    }
    
    func loadAllStyleManagersWithStyle(stylingManager: StyleManager?, from stylesFileWrapper: FileWrapper, styleSetMetadata: StyleSetMetadata?) {
    
        var styleManagers = [StyleManager]()
        
        guard let styles = styleSetMetadata?.styles else {
            assertionFailure("Error: styleSetMetadata?.styles is nil")
            return
        }
        
        guard let stylesFileWrapper = stylesFileWrapper.fileWrappers else {
            assertionFailure("Error: stylesFileWrapper.fileWrappers is nil")
            return
        }
        
        for (index, style) in styles.enumerated() {
            
            guard let styleDirectory = stylesFileWrapper[style.id] else {
                assertionFailure("Error: styleDirectory for id: \(style.id) is nil")
                continue
            }
            
            let styleManager = self.loadStyleManager(from: styleDirectory, with: stylingManager, id: style.id, order: UInt32(index), styleMetadata: style)
            styleManagers.append(styleManager)
        }
        
        // sort them and add them to the local styleManagers property
        let _styleManagers = styleManagers.sorted(by: { (first, second) -> Bool in
            return first.order < second.order
        })

        self.styleManagers.append(contentsOf: _styleManagers)
    }
    
    ///
    /// This method use the styleSetDirectoryURL and iterate over all subdirectories
    /// and for each create a CCSSStyleManager.
    ///
    func loadAllCssStylesWithStyle(stylingManager: StyleManager?, from stylesFileWrapper: FileWrapper, styleSetMetadata: StyleSetMetadata?) {
        
        var styleManagers = [StyleManager]()
        
        guard let styles = styleSetMetadata?.styles else {
            assertionFailure("Error: styleSetMetadata?.styles is nil")
            return
        }
        
        guard let stylesFileWrapper = stylesFileWrapper.fileWrappers else {
            assertionFailure("Error: stylesFileWrapper.fileWrappers is nil")
            return
        }
        
        for (index, style) in styles.enumerated() {
            
            guard let styleDirectory = stylesFileWrapper[style.id] else {
                assertionFailure("Error: styleDirectory for id: \(style.id) is nil")
                continue
            }
            
            let styleManager = self.loadCssStyleManager(from: styleDirectory, with: stylingManager, id: style.id, order: UInt32(index), styleMetadata: style)
            styleManagers.append(styleManager)
        }
        
        // sort them and add them to the local styleManagers property
        let _styleManagers = styleManagers.sorted(by: { (first, second) -> Bool in
            return first.order < second.order
        })

        self.styleManagers.append(contentsOf: _styleManagers)
        self.ensureStyleOrdering()
    }
    
    private func loadCssStyleManager(from stylesheetsFileWrapper: FileWrapper, with stylingManager: StyleManager?, id: String, order: UInt32, styleMetadata: StyleMetadata?) -> StyleManager {
        
        let title = self.title(from: id, styleMetadata: styleMetadata)
        
        let styleManager = CSSStyleManager(title: title, id: id, order: order, userAgentStyleSheetDocumentStore: userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)

        styleManager.load(from: stylesheetsFileWrapper, stylingManager: stylingManager, styleMetadata: styleMetadata)
        return styleManager
    }
    
    private func loadStyleManager(from stylesheetsFileWrapper: FileWrapper, with stylingManager: StyleManager?, id: String, order: UInt32, styleMetadata: StyleMetadata?) -> StyleManager {
        
        let title = self.title(from: id, styleMetadata: styleMetadata)
        
        let styleManager = StyleManager(title: title, id: id, order: order, userAgentStyleSheetDocumentStore: userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)

        styleManager.load(from: stylesheetsFileWrapper, stylingManager: stylingManager, styleMetadata: styleMetadata)
        return styleManager
    }
    
    ///
    /// This method is used to order styles with their current order in the array
    /// if there wasn't any ordering it's here that we will update the order. We
    /// need to do this because styles may not have styleOrder in the style.json,
    /// it then means that they get the defautl ordering and all go at the end.
    /// By using this method we make sure the style.json will have the right
    /// ordering in the future.
    ///
    private func ensureStyleOrdering() {
        for (index, styleManager) in self.styleManagers.enumerated() {
            styleManager.order = UInt32(index)
        }
    }

    private func title(from id: String, styleMetadata: StyleMetadata?) -> String {
        
        if let styleMetadata = styleMetadata {
            
            return styleMetadata.title
        }
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while generating title from id: %@ and styleMetadata: %@", log: Log.WriterCommon.all, type: .error, %%id, %%styleMetadata)
        #endif
        return id
    }
}
