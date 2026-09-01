//
//  ThemeSetManager.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-11-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

/// Class that manage all the themes in the application. 
///
/// Currently the theme has to be selected in order for it 
/// to be active. That means that when a user wants to edit 
/// a theme and see the change reflecte automatically in the
/// editor, he should select the theme he wants to edit first.
public final class ThemeSetManager: NSObject {
    
    public subscript(index: Int) -> ThemeManager? {
        
        get {
            return themeManagers[safe: index]
        }
        set(newValue) {
            
            assert(newValue != nil)
            if let newValue = newValue {
                themeManagers.insert(newValue, at: index)
            }
        }
    }
    
    weak var themeSetStore: ThemeSetStore!
    
    weak var themeTemplateStore: TemplateStore!
    
    unowned var applicationDispatcher: StyloApplicationDispatcher
    
    weak var selectedThemeManager: ThemeManager?
    
    public var themeManagers: DynamicArray<ThemeManager>
    
    // ccssStyle: style to apply to all pseudo-css files.
    // userAgentStyleSheetURL is css.css
    init(applicationDispatcher: StyloApplicationDispatcher) {
        
        self.applicationDispatcher = applicationDispatcher
        self.themeManagers = DynamicArray<ThemeManager>()
        
        // theme store
        let themeSetStore = ThemeSetStore()
        applicationDispatcher.register(store: themeSetStore)
        self.themeSetStore = themeSetStore
        
        // theme template store 
        let themeTemplateStore = TemplateStore()
        applicationDispatcher.register(store: themeTemplateStore)
        self.themeTemplateStore = themeTemplateStore
        
        super.init()
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StyleSetManager protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public func selectTheme(with identifier: String) {
        
        let themeManager = themeManagerById(identifier)
        
        assert(themeManager != nil)
        if let themeManager = themeManager {
            
            self.setCurrentThemeManager(themeManager)
        }
        else if let themeManager = self.themeManagers[safe: 0] {
            
            self.setCurrentThemeManager(themeManager)
        }
    }
    
    public func selectTheme(at index: Int) {
        
        let themeManager = themeManagers[safe: index]
        
        assert(themeManager != nil)
        if let themeManager = themeManager {
            self.setCurrentThemeManager(themeManager)
        }
    }
    
    public var themesCount: Int {
        
        return themeManagers.count
    }
    
    private func themeManagerById(_ id: String) -> ThemeManager? {
        
        for themeManager in themeManagers {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("themeManager name: %@", log: Log.WriterCommon.all, type: .info, %%themeManager.name)
            #endif
            
            if themeManager.name.value == id {
                return themeManager
            }
        }
        return  nil
    }
    
    func themeManagerIndex(forId id: String) -> Int? {
        
        for (index, themeManager) in themeManagers.enumerated() {
            if themeManager.name.value == id {
                return index
            }
        }
        return  nil
    }
    
    public func setCurrentThemeManager(_ themeManager: ThemeManager) {
        
        selectSelectedTheme(themeManager: themeManager)
    }
    
    private func indexOfThemeManager(_ themeManager: ThemeManager) -> Int? {
        
        for (index, _themeManager) in themeManagers.enumerated() {
            if _themeManager === themeManager {
                return index
            }
        }
        return nil
    }
    
    public func loadPrintTemplates(from url: URL?) {
        
        assert(url != nil)
        if let url = url {
        
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Theme templates directory url: %@", log: Log.WriterCommon.all, type: .info, %%url)
            #endif
        
            let bundle = Bundle(for: type(of: self))
            
            let bundlePath = bundle.bundlePath
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("bundlePath: %@", log: Log.WriterCommon.all, type: .info, %%bundlePath)
            #endif
            
            let environmentAction = TemplateActionFactory.createLoadTemplatesSyncAction(with: "\(bundlePath)/Resources/Resources/themes/print/templates/")
        
            self.applicationDispatcher.sync(store: self.themeTemplateStore, action: environmentAction)
        }
    }
    
    public func loadThemesContexts(fromURL themeContextsUrl: URL) {
        
        do {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Theme contexts directory url: %@", log: Log.WriterCommon.all, type: .info, %%themeContextsUrl)
            #endif
            
            let themeContextsUrls = try FileManager.default.contentsOfDirectory(at: themeContextsUrl, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        
            for themeContextUrl in themeContextsUrls {
                
                if themeContextUrl.lastPathComponent.endsWith("json") {
                    
                    let themeManager = ThemeManager(previewUserAgentStyleSheetResource: StyloApplication.shared.URLForUserAgentHTMLStylesheet, printUserAgentStyleSheetURL: StyloApplication.shared.URLForUserAgentPrintStylesheet, applicationDispatcher: applicationDispatcher, templateStore: self.themeTemplateStore)
                    themeManagers.append(themeManager)
                    
                    loadThemeContext(themeManager: themeManager, themeURL: themeContextUrl)
                }
            }
            assert(!themeManagers.isEmpty)
        }
        catch let error {
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("Error (%@ while calling contentsOfDirectoryAtURL with %@", log: Log.WriterCommon.all, type: .error, %%error, %%String(describing: themeContextsUrl))
            #endif
            assertionFailure("Error (\(error) while calling contentsOfDirectoryAtURL with \(String(describing: themeContextsUrl))")
        }
    }
    
    @discardableResult
    public func addTheme() -> ThemeManager? {
        
        let themeManager = ThemeManager(previewUserAgentStyleSheetResource: StyloApplication.shared.URLForUserAgentHTMLStylesheet, printUserAgentStyleSheetURL: StyloApplication.shared.URLForUserAgentPrintStylesheet, applicationDispatcher: applicationDispatcher, templateStore: self.themeTemplateStore)
        themeManagers.append(themeManager)
        
        loadThemeContext(themeManager: themeManager)
        
        setCurrentThemeManager(themeManager)
        
        return themeManager
    }
    
    private func loadThemeContext(themeManager: ThemeManager) {
        
        themeManager.load()
        let action = ThemeSetActionsFactory.addThemeAction(themeStore: themeManager.themeStore)
        self.applicationDispatcher.sync(store: self.themeSetStore, action: action)
    }
    
    private func loadThemeContext(themeManager: ThemeManager, themeURL: URL) {
        
        themeManager.load(fromURL: themeURL)
        let action = ThemeSetActionsFactory.addThemeAction(themeStore: themeManager.themeStore)
        self.applicationDispatcher.sync(store: self.themeSetStore, action: action)
    }
    
    private func selectSelectedTheme(themeManager: ThemeManager) {
        
        selectedThemeManager?.selectedTheme.setValue(false)
        themeManager.selectedTheme.setValue(true)
        selectTheme(themeStore: themeManager.themeStore)
        selectedThemeManager = themeManager
    }
    
    private func selectTheme(themeStore: ThemeStore) {
        
        let applicationState = applicationDispatcher.state as? ApplicationState
        let styloApplicationStore = applicationState?.styloApplicationStore
        
        assert(styloApplicationStore != nil)
        if let styloApplicationStore = styloApplicationStore {
        
            let action = StyloApplicationAction.selectTheme(themeStore: themeStore)
            self.applicationDispatcher.async(store: styloApplicationStore, action: action.asyncAction)
        }
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: FileWrapper implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func createFileWrapper() -> FileWrapper {
        
        var fileWrappersDictionary = [String: FileWrapper]()
        
        for themeManager in themeManagers {
            
            let themeManagerDirectoryFileWrapper = themeManager.createFileWrapper()
            
            fileWrappersDictionary[themeManagerDirectoryFileWrapper.preferredFilename!] = themeManagerDirectoryFileWrapper
        }
        
        let themeManagerSetFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappersDictionary)
        
        themeManagerSetFileWrapper.preferredFilename = "themes"
        
        return themeManagerSetFileWrapper
    }
}

//let uaCCSSTextStylesheetFileNameExtension = "css"
//
//let uaHtmlStylesheetFileName = "html-css-ua"
//let uaHtmlStylesheetFileNameExtension = "css"
//
//let uaPrintStylesheetFileName = "print-css-ua"
//let uaPrintStylesheetFileNameExtension = "css"
//
//let uaCssSourceStylesheetFileName = "css-css-ua"
//let uaCssSourceStylesheetFileNameExtension = "css"

extension Bundle {
    
//    class func URLForUserAgentCSSSourceStylesheet() -> URL {
//
//        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
//
//        return bundle.url(forResource: uaCssSourceStylesheetFileName,
//                          withExtension: uaCssSourceStylesheetFileNameExtension,
//                          subdirectory: UserAgentStylesheetSourceDirectoryPath)!
//    }
//
//    class func URLForUserAgentHTMLStylesheet() -> URL {
//
//        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
//
//        return bundle.url(forResource: uaHtmlStylesheetFileName,
//            withExtension: uaHtmlStylesheetFileNameExtension,
//            subdirectory: UserAgentStylesheetSourceDirectoryPath)!
//    }
//
//    class func URLForUserAgentPrintStylesheet() -> URL {
//
//        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
//
//        return bundle.url(forResource: uaPrintStylesheetFileName,
//                          withExtension: uaPrintStylesheetFileNameExtension,
//                          subdirectory: UserAgentStylesheetSourceDirectoryPath)!
//    }
}
