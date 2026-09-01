//
//  AppDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2015-07-19.
//  Copyright (c) 2015 Textually Inc. All rights reserved.
//

import Foundation
import CoreFoundation
import CoreText
import Cocoa
import WriterCommon
import Common
import os
import StyloCoreMac

/// The AppDelegate is responsible for initializing all the resource that are shared
/// among all
@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate, Observer {
    
    public var priority: ObserverPriority {
        return .ui
    }
    
    @IBOutlet var themesMenu: NSMenu!
    
    @IBOutlet var lightModeMenuItem: NSMenuItem!
    
    @IBOutlet var darkModeMenuItem: NSMenuItem!
    
    @IBOutlet var systemModeMenuItem: NSMenuItem!
    
    @IBOutlet var appearanceView: NSView!
    
    weak var applicationStore: StyloApplicationStore!
    
    @objc dynamic var pageSetupButtonHidden: Bool {
        
        // should set to true to hide it in release mode
        return !StyloConstants.Configuration.PageSetupButtonEnabled
    }
    
    @objc dynamic var saveEditHistoryButtonHidden: Bool {
        
        // should set to true to hide it in release mode
        return !StyloConstants.Configuration.SaveEditHistoryButtonEnabled
    }
    
    @objc dynamic var editThemeButtonHidden: Bool {
        
        // should set to true to hide it in release mode
        return !StyloConstants.Configuration.ThemeEditingEnabled
    }
    
    @objc dynamic var chooseThemeButtonHidden: Bool {
        
        // should set to true to hide it in release mode
        return !StyloConstants.Configuration.ThemeChoosingEnabled
    }
    
    var feedbackWindowController: FeedbackWindowController? {
        
        let feedbackStoryboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(string: "Feedback"), bundle: nil)
        
        guard let feedbackWindowController = feedbackStoryboard.instantiateInitialController() as? FeedbackWindowController else {
            assert(false, "Feedback instantiateInitialController() returns nil.")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("feedbackWindowController is nil", log: Log.Stylo.all, type: .error)
            #endif
            return nil
        }
        
        let computedAppearance = StyloApplication.shared.computedAppearance.value
        feedbackWindowController.window?.appearance = computedAppearance?.appearance ?? AppearanceMode.dark.appearance
        return feedbackWindowController
    }
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applicationWillFinishLaunching", log: Log.Stylo.all, type: .info)
        #endif
        
        
        self.loadCustomFontFamilies()
        let styloApplication = StyloApplication.shared
        self.applicationStore = styloApplication.styloApplicationStore
        
        styloApplication.loadPrintThemeSetManager()
        styloApplication.loadCSSStylesSetManager()
        styloApplication.cssStyleSetManager.selectStyle(atIndex: 0)
        styloApplication.loadApplicationTextStyleSetManager()
        styloApplication.loadApplicationPlugins()
        listen(to: self.applicationStore)
        StyloDocumentController()
        
        self.loadApplicationMenuItems()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if StyloConstants.Configuration.LightModeEnabled {
            
            updateSystemAppearance(from: NSApp.effectiveAppearance)
            updateUserSelectedAppearanceFromDefaults()
            updateSelectedPrintTheme()
            updateSelectedCssStyles()
            observeApplicationEffectiveAppearance()
        }
        else {
            
            // NW-1100: we lock the appearance to dark mode for now
            NSApp.appearance = NSAppearance(named: .darkAqua)
        }
        
        self.removeUnwantedFileMenuItems()
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("applicationDidFinishLaunching", log: Log.Stylo.all, type: .info)
        #endif
    }
    
    private func loadApplicationMenuItems() {
        
        guard let mainMenu: NSMenu = NSApp.mainMenu else {
            assertionFailure("Error: mainMenu is nil")
            return
        }
        
        var index = mainMenu.indexOfItem(withTitle: "View") + 1
        
        if let PluginsClasses = PluginManager.PluginsClasses {
        
            for pluginClass in PluginsClasses {
                
                if let StyloApplicationMenuPluginPrincipalClass = pluginClass as? ApplicationMenuPlugin.Type {

                    if let applicationMenu = StyloApplicationMenuPluginPrincipalClass.applicationMenu {
                        
                        mainMenu.insertItem(applicationMenu, at: index)
                        index += 1
                    }
                }
            }
        }
    }
    
    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        
        StyloApplication.shared.saveUserSelectedAppearanceToDefaults()
        closeAllDocuments()
        return .terminateLater
    }
    
    @IBAction func copySelector(_ sender: AnyObject? = nil) {
        
        let styloWindowController = NSApplication.shared.keyWindow?.windowController as? StyloWindowController
        
        assert(styloWindowController != nil)
        if let styloWindowController = styloWindowController {
            
            let elementSelection = styloWindowController.elementSelection
            
            assert(elementSelection != nil, "menu item should be disabled if element selection is nil")
            if let elementSelection = elementSelection {
                
                styloWindowController.styloWindow.copySelector(from: elementSelection)
            }
        }
    }
    
    @IBAction func selectLightAppearance(_ sender: AnyObject? = nil) {
        
        StyloApplication.shared.selectUserAppearance(appearance: .light)
    }
    
    @IBAction func selectDarkAppearance(_ sender: AnyObject? = nil) {
        
        StyloApplication.shared.selectUserAppearance(appearance: .dark)
    }
    
    @IBAction func selectSystemAppearance(_ sender: AnyObject? = nil) {
        
        StyloApplication.shared.selectUserAppearance(appearance: nil)
    }
    
    private func updateCheckedAppearanceModeMenuItem() {
        
    }
    
    private func listen(to applicationStore: StyloApplicationStore) {
        
        applicationStore.selectedPrintTheme.subscribe({ [weak self] (theme: ThemeStore?) in
            
            if let theme = theme {
                
                let themeName = theme.name
                
                // unselect the previoulsy selected menu item
                if let selectedThemeName = StyloApplication.shared.userDefaultsPrintThemeName {
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("selectedThemeName: %@", log: Log.Stylo.all, type: .info, %%selectedThemeName)
                    #endif
                    self?.deselectAllThemes()
                    
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    // select the new menu item
                    os_log("themeName: %@", log: Log.Stylo.all, type: .info, %%themeName)
                    #endif
                    
                    self?.selectThemeName(name: themeName)
                }
            }
        }, observer: self)
    }
    
    private func observeApplicationEffectiveAppearance() {
        
        // old value:
        // NSApp.addObserver(self, forKeyPath: "effectiveAppearance", options: NSKeyValueObservingOptions.new, context: nil)
        
        NSApp.observe(\NSApplication.effectiveAppearance) { [weak self](app, value) in
            self?.updateSystemAppearance(from: NSApp.effectiveAppearance)
        }
        
//        NSApp.addObserver(self, forKeyPath: \NSApplication.effectiveAppearance, options: NSKeyValueObservingOptions.new, context: nil)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        updateSystemAppearance(from: NSApp.effectiveAppearance)
//    }
    
    private func updateUserSelectedAppearanceFromDefaults() {
        
        if let userSelectedAppearance = UserDefaults.standard.string(forKey: WriterCommon.Constants.UserDefaults.SelectedAppearanceMode) {
        
            guard let userDefaultsAppearanceMode = AppearanceMode(rawValue: userSelectedAppearance) else {
                assertionFailure("Error: no AppearanceMode for raw value: \(userSelectedAppearance)")
                return
            }
            
            StyloApplication.shared.selectUserAppearance(appearance: userDefaultsAppearanceMode)
        }
    }
    
    private func updateSystemAppearance(from appearance: NSAppearance) {
        
        guard let appearanceMode = appearance.appearanceMode else {
            assertionFailure("Error: appearanceMode is nil")
            return
        }
        
        StyloApplication.shared.selectSystemAppearance(appearance: appearanceMode)
    }
    
    private func updateSelectedPrintTheme() {
        
        assert(self.themesMenu != nil)
        if let themesMenu = self.themesMenu {
            
            let styloApplication = StyloApplication.shared
            styloApplication.populateThemesMenu(themesMenu: themesMenu)
            
            if let themeName = styloApplication.userDefaultsPrintThemeName {
                styloApplication.selectPrintTheme(with: themeName)
            }
            else {
                
                styloApplication.userDefaultsPrintThemeName = "Stylo"
                
                if let selectedThemeName = styloApplication.userDefaultsPrintThemeName {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("selectedThemeName: %@", log: Log.Stylo.all, type: .info, %%selectedThemeName)
                    #endif
                    styloApplication.selectPrintTheme(with: selectedThemeName)
                }
            }
        }
    }
    
    private func updateSelectedCssStyles() {
            
        let styloApplication = StyloApplication.shared
        
        if let styleName = styloApplication.userDefaultsCSSStyleName {
            styloApplication.selectCssTheme(with: styleName)
        }
        else {
            
            styloApplication.userDefaultsCSSStyleName = "Stylo"
            
            if let selectedCssStyleName = styloApplication.userDefaultsCSSStyleName {
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("selectedCssStyleName: %@", log: Log.Stylo.all, type: .info, %%selectedThemeName)
                #endif
                styloApplication.selectCssTheme(with: selectedCssStyleName)
            }
        }
//        assert(styloApplication.styloApplicationStore.selectedCssStyle.value != nil)
    }
    
    private func deselectAllThemes() {
        
        for item in themesMenu.items {
            item.state = NSControl.StateValue.off
        }
    }
    
    // select the new menu item
    private func selectThemeName(name: String) {
        
        for item in themesMenu.items {
            if item.title == name {
                item.state = NSControl.StateValue.on
            }
        }
    }
    
    private func removeUnwantedFileMenuItems() {
    
        guard let fileMenu: NSMenu = NSApp.mainMenu?.items[1].submenu else {
            assertionFailure("Error: fileMenu is nil")
            return
        }
        
        func removeItem(withSelector selector: Selector) {
            
            let index = fileMenu.indexOfItem(withTarget: nil, andAction: selector)
            guard index != -1 else {
                assertionFailure("Error: menu item index is -1")
                return
            }
            fileMenu.removeItem(at: index)
        }
        removeItem(withSelector: #selector(NSDocument.rename))
        removeItem(withSelector: #selector(NSDocument.duplicate(_:)))
    }
    
    private func loadCustomFontFamilies() {
        
        let bundledFonts: [String] = Bundle.main.infoDictionary!["UIAppFonts"] as! [String]
        
        for bundledFont in bundledFonts {
            
            let fontUrl = Bundle.main.url(forResource: bundledFont, withExtension: "") as CFURL?
            
            assert(fontUrl != nil)
            if let fontUrl = fontUrl {
                
                CTFontManagerRegisterFontsForURL(fontUrl, CTFontManagerScope.process, nil)
            }
        }
    }
    
    private func closeAllDocuments() {
        
        StyloDocumentController.shared.closeAllDocuments(withDelegate: self, didCloseAllSelector: #selector(AppDelegate.documentController(docController:didCloseAll:contextInfo:)), contextInfo: nil)
    }
    
    // - (void)documentController:(NSDocumentController *)docController  didCloseAll:(BOOL)didCloseAll contextInfo:(void *)contextInfo
    @objc func documentController(docController: NSDocumentController, didCloseAll: Bool, contextInfo: UnsafeMutableRawPointer?) {
        
        // see https://stackoverflow.com/questions/48165594/cannot-quit-the-app-if-i-cancel-the-save-operation-in-a-nsdocument
        NSApp.reply(toApplicationShouldTerminate: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

