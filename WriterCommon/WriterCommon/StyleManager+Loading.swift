//
//  StyleManager+Loading.swift
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
    func load(from stylesheetsFileWrapper: FileWrapper, stylingManager: StyleManager?, styleMetadata: StyleMetadata?) {
        
        self.loadStylesheets(from: stylesheetsFileWrapper, stylingManager: stylingManager, styleMetadata: styleMetadata)
        self.loadPreviewsIfNecessary(from: styleMetadata)
    }
    
    private func loadPreviewsIfNecessary(from styleMetadata: StyleMetadata?) {
        
        // no preview for CSS source styles...
        guard !(self is CSSStyleManager) else {
            return
        }
        
        if self.shouldCompileStylesheets(fromStyleMetadata: styleMetadata) {
        
            // added to make sure we have all the style previews.
            self.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: self.otherAppearanceSourceDescriptor)
            self.registerStyleAssemblyIfNecessary(forStyleAssemblyDescriptor: self.currentAppearanceSourceDescriptor)
        }
        else {
            
            guard let stylePreviews = styleMetadata?.stylePreviews else {
                assertionFailure("Error: stylePreviews is nil")
                return
            }
            
            for (key, stylePreviewMetadata) in stylePreviews {
                
                guard let styleAssemblyDescriptor = StyleAssemblyDescriptor.from(key) else {
                    assertionFailure("Error: styleAssemblyDescriptor is nil")
                    continue
                }
                
                guard let stylePreview = TextStylePreview.fromMetadata(stylePreviewMetadata) else {
                    assertionFailure("Error: stylePreview is nil")
                    continue
                }
                self.stylePreviews.updateValue(stylePreview, forKey: styleAssemblyDescriptor)
            }
        }
    }
    
    private func loadStylesheets(from stylesheetsFileWrapper: FileWrapper, stylingManager: StyleManager?, styleMetadata: StyleMetadata?) {
        
        let stylesheetsFileWrapper = stylesheetsFileWrapper.fileWrappers
        
        guard let stylesheets = styleMetadata?.stylesheets else {
           assertionFailure("Error: stylesheets is nil")
            return
        }
        
        let shouldCompileStylesheets = self.shouldCompileStylesheets(fromStyleMetadata: styleMetadata)
        
        assert(stylesheetsFileWrapper != nil)
        if let stylesheetsFileWrapper = stylesheetsFileWrapper {
            
            for stylesheet in stylesheets {
                
                guard let stylesheetFileWrapper = stylesheetsFileWrapper[stylesheet.id + ".css"] else {
                    assertionFailure("Error: no filewrapper for stylesheet with id: \(stylesheet.id)")
                    continue
                }
                
                let stylesheetContent = stylesheetFileWrapper.regularFileContents
                
                assert(stylesheetContent != nil)
                if let stylesheetContent = stylesheetContent {
                    
                    let stringContent = String(data: stylesheetContent, encoding: String.Encoding.utf8)
                    
                    assert(stringContent != nil)
                    if let stringContent = stringContent {
                        
                        let id: String = stylesheet.id
                        
                        // avoid loading any other file than css files
                        let stylesheetManager = StylesheetManager(title: stylesheet.name, id: id, dispatcher: self.dispatcher, editedStylesheetLanguage: editedStyleLanguage, origin: .author, appearances: stylesheet.appearanceModesSet)

                        if shouldCompileStylesheets {
                            compileStylesheet(stylesheetManager: stylesheetManager, title: title, string: stringContent, stylingManager: stylingManager)
                        }
                        else {
                            stylesheetManager.setText(string: stringContent)
                        }
                        addHandledStylesheetManager(stylesheetManager: stylesheetManager)
                    }
                }
            }
        }
    }
    
}
