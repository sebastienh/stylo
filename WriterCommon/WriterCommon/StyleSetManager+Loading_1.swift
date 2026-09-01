//
//  StyleSetManager+Loading_1.swift
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
    func loadAllStylesWithStyle1(stylingManager: StyleManager?, from stylesFileWrapper: FileWrapper, styleSetMetadata: StyleSetMetadata_1?) {
        
        var styleManagers = [StyleManager]()

        let stylesFileWrapper = stylesFileWrapper.fileWrappers
        
        assert(stylesFileWrapper != nil)
        if let stylesFileWrapper = stylesFileWrapper {
            
            for (filename, styleFileWrapper) in stylesFileWrapper {
                
                let styleMetadata = styleSetMetadata?.styles[filename]
                let styleManager = loadStyleManager1(from: styleFileWrapper, with: stylingManager, id: filename, styleMetadata: styleMetadata)
                styleManagers.append(styleManager)
            }
        }
        
        // sort them and add them to the local styleManagers property
        let _styleManagers = styleManagers.sorted(by: { (first, second) -> Bool in
            return first.order < second.order
        })

        self.styleManagers.append(contentsOf: _styleManagers)
        let userStyleManagersCount = self.styleManagers.count
        self.loadApplicationStyles(stylingManager: stylingManager)
        for i in userStyleManagersCount..<self.styleManagers.count {
            guard let title = self.styleManagers[safe: i]?.title else {
                assertionFailure("Error: title is nil")
                continue
            }
            self.styleManagers[safe: i]?.updateTitle(title + " - New")
        }
        self.ensureStyleOrdering()
    }

    private func loadApplicationStyles(stylingManager: StyleManager?) {
        
        if let applicationDefaultStylesFileWrapper = StyloApplication.shared.applicationDefaultStylesFileWrapper, let applicationDefaultStyleSetMetadata = StyloApplication.shared.applicationDefaultStyleSetMetadata {
            
            loadAllStyleManagersWithStyle(stylingManager: stylingManager, from: applicationDefaultStylesFileWrapper, styleSetMetadata: applicationDefaultStyleSetMetadata)
        }
    }
    
    private func loadStyleManager1(from stylesheetsFileWrapper: FileWrapper, with stylingManager: StyleManager?, id: String, styleMetadata: StyleMetadata_1?) -> StyleManager {
        
        let order = self.order1(from: id, styleMetadata: styleMetadata)
        let title = self.title1(from: id, styleMetadata: styleMetadata)
        
        let styleManager = StyleManager(title: title, id: id, order: order, userAgentStyleSheetDocumentStore: userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)

        styleManager.load1(from: stylesheetsFileWrapper, stylingManager: stylingManager, styleMetadata: styleMetadata)
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
    
    private func order1(from id: String, styleMetadata: StyleMetadata_1?) -> UInt32 {
        
        if let styleMetadata = styleMetadata {
            
            return styleMetadata.order
        }
        else if let order = self.order(from: id) {
            
            return UInt32(order)
        }
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while generating order", log: Log.WriterCommon.all, type: .error)
        #endif
        return 0
    }
    
    private func title1(from id: String, styleMetadata: StyleMetadata_1?) -> String {
        
        if let styleMetadata = styleMetadata {
            
            return styleMetadata.title
        }
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Error while generating title from id: %@ and styleMetadata: %@", log: Log.WriterCommon.all, type: .error, %%id, %%styleMetadata)
        #endif
        return id
    }
}
