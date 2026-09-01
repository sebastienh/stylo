//
//  StyleManager+Loading_1.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-09-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common
import PromiseKit
import Igloo
import Web
import os

extension StyleManager {
    
    // load all presenter model, each document will need
    // to register their own AuthorCCSSResourcePresenter with the following
    // CCSSStringResourceModel.
    // validated sync
    func load1(from stylesheetsFileWrapper: FileWrapper, stylingManager: StyleManager?, styleMetadata: StyleMetadata_1?) {
        
        self.loadStylesheets1(from: stylesheetsFileWrapper, stylingManager: stylingManager, styleMetadata: styleMetadata)
        self.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: self.otherAppearanceSourceDescriptor)
        self.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: self.currentAppearanceSourceDescriptor)
    }
    
    private func loadStylesheets1(from stylesheetsFileWrapper: FileWrapper, stylingManager: StyleManager?, styleMetadata: StyleMetadata_1?) {
        
        let stylesheetsFileWrapper = stylesheetsFileWrapper.fileWrappers
        
        assert(stylesheetsFileWrapper != nil)
        if let stylesheetsFileWrapper = stylesheetsFileWrapper {
        
            // load all resources
            for (stylesheetName, stylesheetFileWrapper) in stylesheetsFileWrapper {
                
                if stylesheetName.endsWith("css") {
                    
                    let stylesheetContent = stylesheetFileWrapper.regularFileContents
                    
                    assert(stylesheetContent != nil)
                    if let stylesheetContent = stylesheetContent {
                        
                        let stringContent = String(data: stylesheetContent, encoding: String.Encoding.utf8)
                        
                        assert(stringContent != nil)
                        if let stringContent = stringContent {
                        
                            let filename = stylesheetName.substringWithoutFileExtension
                            
                            self.addStylesheet(filename: filename, content: stringContent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark), stylingManager: stylingManager)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    private func loadStylesheet(stylesheetManager: StylesheetManager, title: String, url: URL, stylingManager: StyleManager?, withEncoding encoding: Encoding = String.Encoding.utf8.rawValue) {
        
        if let string = stylesheetManager.createStringResourceModel(from: url, withEncoding: encoding) {

            stylesheetManager.setText(string: string)
        }
        else {
            assertionFailure("Error in loadStylesheet: string is nil")
        }
    }
    
    private func resourceUrls(fromResourcesDirectoryURL resourcesDirectoryURL: URL) -> [URL]? {
        
        let resourcesURLs = try! FileManager.default.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsPackageDescendants).filter({ (url) -> Bool in
            return url.pathExtension == "css"
        })
        assertionFailure("resourcesURLs are nil")
        return resourcesURLs
    }
}
