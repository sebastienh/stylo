//
//  StylesManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-09.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public protocol StylesManager: class {
    
    var dispatcher: Dispatcher { get }
    
    var userAgentStyleSheetURL: URL { get }
    
    var selectedStyleManager: Dynamic<StyleManager?> { get }
    
    var styleManagers: DynamicArray<StyleManager> { get }
    
    var selectedStyleManagerIndex: Int? { get }
    
    var userAgentStyleSheetDocumentStore: StylesheetDocumentStore! { get set }
    
    var defaultStyleManager: StyleManager? { get }
    
    subscript(index: Int) -> StyleManager? { get set }
    
    func isSelected(styleManager: StyleManager) -> Bool
    
    func createEmptyStyleManager() -> StyleManager
    
    func deleteStyleManager(id: String)
    
    func index(of styleManager: StyleManager) -> Int?
    
    func createUserAgentDefaultStyle() -> StyleManager
    
    func selectSelectedStyle(styleManager: StyleManager)
    
    func updateSelectedStyle(to styleId: String)
    
    func loadUserAgentStyleSheet() -> ActionResult?
    
    func styleManagerByName(_ name: String) -> StyleManager?
        
    func styleManagerById(_ id: String) -> StyleManager? 
    
    func styleByName(_ name: String) -> StyleManager?
    
    func styleById(_ id: String) -> StyleManager?
    
//    func validateOnlyOneSelectedStyle()
    
    func selectStyle(atIndex index: Int)
        
    func selectStyle(withTitle title: String)
}

extension StylesManager {
    
    public subscript(index: Int) -> StyleManager? {
        get {
            if index < styleManagers.count {

                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
                os_log("Accessing index: %@ with count: %@, in array: %@", log: Log.WriterCommon.all, type: .info, %%index, %%styleManagers.count, %%styleManagers.values)
                #endif
                return styleManagers[safe: index]
            }
            else {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG_LOGS_ENABLED
                os_log("Index out of range: %@ with count: %@", log: Log.WriterCommon.all, type: .error, %%index, %%styleManagers.count)
                #endif
            }
            return nil
        }
        set(newValue) {
            
            assert(newValue != nil)
            if let styleManager = newValue {
                styleManagers.insert(styleManager, at: index)
            }
        }
    }
    
    public func selectStyle(atIndex index: Int) {
        
        guard index >= 0 && index < self.styleManagers.values.count else {
            assertionFailure("Error: index: \(index) out of range")
            return
        }
        
        let styleManager = self.styleManagers.values[index]
        setCurrentStyleManager(styleManager)
    }
    
    public func selectStyle(withTitle title: String) {
        
        guard let styleManager = self.styleManagerByName(title) else {
            assertionFailure("Error: no style with title: \(title)")
            return
        }
        
        setCurrentStyleManager(styleManager)
    }
    
    public func styleByName(_ name: String) -> StyleManager? {

        return styleManagerByName(name)
    }

    public func styleById(_ id: String) -> StyleManager? {

        return styleManagerById(id)
    }
    
    public func styleManagerByName(_ name: String) -> StyleManager? {
        
        for styleManager in styleManagers {
            if styleManager.title == name {
                return styleManager
            }
        }
        return  nil
    }
    
    public func styleManagerById(_ id: String) -> StyleManager? {
        for styleManager in styleManagers {
            if styleManager.id == id {
                return styleManager
            }
        }
        return  nil
    }
    
    /// Method that returns true if the styleManager parameter
    /// is the currently active one.
    public func isSelected(styleManager: StyleManager) -> Bool {
        
        if let selectedStyleManager = selectedStyleManager.value {
            if selectedStyleManager === styleManager {
                return true
            }
        }
        return  false
    }
    
    /// Method to be called to create an empty Source StyleSheet
    public func createEmptyStyleManager() -> StyleManager {
        
        assert(Thread.isMainThread)
        let id: String = UUID().uuidString
        
        let styleManager = StyleManager(id: id, order: 0, userAgentStyleSheetDocumentStore: self.userAgentStyleSheetDocumentStore, dispatcher: self.dispatcher, editedStyleLanguage: Language.CSS, styleManagerType: .style)
        
        var initialStringValue: String? = nil
        
        assert(self.selectedStyleManager.value != nil)
        if let selectedStyleManager = self.selectedStyleManager.value {
            
            // NW-1357 : we use the same string as the current style
            initialStringValue = "" // selectedStyleManager.currentAppearanceStylesheetManager!.string
        }
        
        styleManager.createEmptyStylesheetManager(with: initialStringValue)
        // stylo #46
        if let selectedStyleManagerIndex = self.selectedStyleManagerIndex {
            self.styleManagers.insert(styleManager, at: selectedStyleManagerIndex+1)
        }
        else {
            self.styleManagers.append(styleManager)
        }
        return styleManager
    }
    
    public func setCurrentStyleManager(_ styleManager: StyleManager) {
        
        selectSelectedStyle(styleManager: styleManager)
    }
    
    public func deleteStyleManager(id: String) {
        
        let styleManager = styleManagerById(id)
        
        assert(styleManager != nil)
        if let styleManager = styleManager {
            
            let index = self.index(of: styleManager)
            
            assert(index != nil)
            if let index = index {
                styleManagers.remove(atIndex: index)
            }
        }
    }
    
    public func index(of styleManager: StyleManager) -> Int? {
        
        for (index, _styleManager) in styleManagers.enumerated() {
            if _styleManager === styleManager {
                return index
            }
        }
        return nil
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
    
    public func selectSelectedStyle(styleManager: StyleManager) {
        
        selectedStyleManager.value?.unselect()
        styleManager.select()
        selectedStyleManager.setValue(styleManager)
        
        #if DEBUG
        validateOnlyOneSelectedStyle()
        #endif
    }
    
    func validateOnlyOneSelectedStyle() {
        
        var foundSelectedStyle = false
        for styleManager in styleManagers {
            if styleManager.selectedStyle.value {
                
                if foundSelectedStyle {
                    assert(false, "more than one selected style")
                }
                else {
                    foundSelectedStyle = true
                }
            }
        }
    }
}
