//
//  ThemeSetManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-08-29.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public final class StyleSetManager: NSObject, StylesManager, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    // userAgentStyleSheetURL is the particular css.css when creating 
    // pseudo css styles,  text.css when creating a new css source style 
    // sheet or html.css for the basic preview stylesheet.
    public let userAgentStyleSheetURL: URL
    
    /// This is the user-agent style sheet resource created from userAgentStyleSheetURL 
    /// that participates in the pseudo css styles as the user-agent style sheet.
    weak public var userAgentStyleSheetDocumentStore: StylesheetDocumentStore!
    
    var userAgentDefaultStyleManager: StyleManager!
    
    public let dispatcher: Dispatcher
    
    /// This variable contains the
    public var selectedStyleManager = Dynamic<StyleManager?>(nil)
    
    public var selectedOrDefaultStyleManager: StyleManager? {
        
        if let selectedStyleManager = self.selectedStyleManager.value {
            return selectedStyleManager
        }
        return self.defaultStyleManager
    }
    
    public var stylesCount: Int {
        
        return styleManagers.count
    }
    
    public var styleManagers: DynamicArray<StyleManager>
    
    public var selectedStyleManagerIndex: Int? {
        
        guard let selectedStyleManager = self.selectedStyleManager.value else {
            assertionFailure("Error: selectedStyleManager is nil")
            return nil
        }
        
        for (index, styleManager) in styleManagers.enumerated() {
            if styleManager.id == selectedStyleManager.id {
                return index
            }
        }
        return nil
    }
    
    var styleIds: [String] {
        return styleManagers.map { (styleManager) -> String in
            return styleManager.id
        }
    }
    
    public var defaultStyleId: String? {
        
        return self.styleManagers.values[defaultStyleIndex].id
    }
    
    public var defaultStyleIndex: Int {
        return 2
    }
    
    public var defaultStyleStore: StyleAssemblyStore? {
        
        return self.styleManagers.first?.styleAssemblies.first?.value.styleAssemblyStore //first?.styleAssemblyStore
    }

    public var defaultStyleManager: StyleManager? {
        
        return self.styleManagers.first
    }
    
    class func Create(document: TextDocument) -> StyleSetManager {
        
        let url = StyloApplication.shared.textUserAgentCssURL
        return StyleSetManager(userAgentStyleSheetURL: url, dispatcher: document.documentDispatcher)
    }
    
    private var userAgentStylesheetLoad: Promise<Void>!
    
    // ccssStyle: style to apply to all pseudo-css files.
    // userAgentStyleSheetURL is css.css
    init(userAgentStyleSheetURL: URL, dispatcher: Dispatcher) {
        
        self.userAgentStyleSheetURL = userAgentStyleSheetURL
        self.dispatcher = dispatcher
        
        // StyleSetManager property
        self.styleManagers = DynamicArray<StyleManager>()
        super.init()
        loadUserAgentStylesheet()
    }
    
    private func loadUserAgentStylesheet() {
        
        loadUserAgentStyleSheet()
        self.userAgentDefaultStyleManager = self.createUserAgentDefaultStyle()
    }
    
    public func setCurrentStyleManager(_ styleManager: StyleManager) {
        
        selectSelectedStyle(styleManager: styleManager)
    }
    
    public func addStyleManager() -> StyleManager {
        
        let styleManager = createEmptyStyleManager()
        self.setCurrentStyleManager(styleManager)
        return styleManager 
    }

    public func deleteStyleManager(styleManager: StyleManager) -> StyleManager? {

        deleteStyleManager(id: styleManager.id)
        return nil
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: IdGenerator implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var _hashids: Hashids?
    
    public var nextIntegerSeed: Int {
        
        var currentMaximumOrder = 0
        
        for styleManager in self.styleManagers {
            
            let id = styleManager.id
            let order = self.order(from: id)
            
            assert(order != nil)
            if let order = order {
                currentMaximumOrder = max(currentMaximumOrder, order)
            }
        }
        return currentMaximumOrder + 1
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: private implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    /// Method to be called to create an empty Source StyleSheet
    public func createEmptyStyleManager() -> StyleManager {
        
        assert(Thread.isMainThread)
        let styleManager = StyleManager(id: UUID().uuidString, order: 0, userAgentStyleSheetDocumentStore: self.userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)
        
        guard let selectedStyleManager = self.selectedStyleManager.value else {
            assertionFailure("Error: selectedStyleManager is nil")
            self.styleManagers.append(styleManager)
            return styleManager
        }
                    
        for (id, stylesheetManager) in selectedStyleManager.stylesheets {
            
            guard id != "useragent" else {
                continue
            }
            
            guard let content = stylesheetManager.stylesheetDocumentStore.sourceString.value else {
                assertionFailure("Error: sourceString is nil")
                continue
            }
            
            styleManager.addStylesheet(filename: stylesheetManager.name.value, content: content, appearances: stylesheetManager.appearances.values, stylingManager: StyloApplication.shared.cssStyleSetManager.selectedStyleManager.value)
        }
        
        // stylo #46
        if let selectedStyleManagerIndex = self.selectedStyleManagerIndex {
            self.styleManagers.insert(styleManager, at: selectedStyleManagerIndex+1)
        }
        else {
            assertionFailure("Error: selectedStyleManagerIndex is nil")
            self.styleManagers.append(styleManager)
        }
        return styleManager
    }
    
    /// This method creates a style from the user agent stylesheet only.
    /// This is the style that is applied when there is no style
    /// anymore in the style.
    public func createUserAgentDefaultStyle() -> StyleManager {
        
        let styleManager = StyleManager(id: "user-agent-style", order: 0, userAgentStyleSheetDocumentStore: self.userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)

        return styleManager
    }
    
    /// This method load the user-agent pseudo css style sheet that
    /// is used to style the pseudo css source files.
    @discardableResult
    public func loadUserAgentStyleSheet() -> ActionResult? {
        
        let stylesheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark))
        self.dispatcher.register(store: stylesheetDocumentStore)
        self.userAgentStyleSheetDocumentStore = stylesheetDocumentStore
        
        let action = StylesheetDocumentActionsFactory.loadStylesheetAction(url: userAgentStyleSheetURL)
        return self.dispatcher.sync(store: userAgentStyleSheetDocumentStore, action: action)
    }
    
    public func updateSelectedStyle(to styleId: String) {

        guard let styleManager = self.styleManagerById(styleId) else {
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
            os_log("Error: no style with id: %@", log: Log.WriterCommon.all, type: .error, %%styleId)
            #endif

            guard let defaultStyleManager = self.defaultStyleManager else {
                assertionFailure("Error: self.defaultStyleManager is nil")
                return
            }
            self.setCurrentStyleManager(defaultStyleManager)
            return
        }
        setCurrentStyleManager(styleManager)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: deinit implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    deinit {

    }
    
}
