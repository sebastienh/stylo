//
//  StyloApplication.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2015-10-15.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public final class StyloApplication: NSObject, Observer {
    
    public var priority: ObserverPriority {
        return .background
    }
    
    public enum Product: String {
        case stylo
        case nodio
    }
    
    /// Singleton instance.
    public static var shared = StyloApplication()
    
    let uaCCSSTextStylesheetFileNameExtension = "css"
    
    let uaHtmlStylesheetFileName = "html-css-ua"
    let uaHtmlStylesheetFileNameExtension = "css"
    
    let uaPrintStylesheetFileName = "print-css-ua"
    let uaPrintStylesheetFileNameExtension = "css"
    
    let uaCssSourceStylesheetFileName = "css-css-ua"
    let uaCssSourceStylesheetFileNameExtension = "css"
    
    let stylesDirectoryName = "stylo-core"
    
    public var product: Product? {
        
        return Product(rawValue: self.productName ?? "")
    }
    
    public var productName: String? {
        
        guard let infoDictionary = Bundle.main.infoDictionary else {
            assertionFailure("Error: infoDictionary is nil")
            return nil
        }

        //First get the nsObject by defining as an optional anyObject
        let key = "CFBundleName"
        guard let name = infoDictionary[key] as? String else {
            assertionFailure("Error: infoDictionary[\"\(key)\"] returned nil")
            return nil
        }

        return name.lowercased()
    }
    
    public var selectedPreviewPluginName: String? {
        
        return UserDefaults.standard.value(forKey: Constants.UserDefaults.SelectedPreviewPluginName) as? String
    }
    
    var URLForTextSourceStylesDirectoryPath: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent(stylesDirectoryName, isDirectory: true).appendingPathComponent("/styles/", isDirectory: true)
    }
    
    var StyleSetMetadataDirectoryPath: URL {
        return ApplicationResourcesDirectory.appendingPathComponent(stylesDirectoryName, isDirectory: true).appendingPathComponent("/stylesetmetadata.json", isDirectory: false)
    }
    
    var CSSStyleSetMetadataDirectoryPath: URL {
        return ApplicationResourcesDirectory.appendingPathComponent("/themes/css/stylesetmetadata.json", isDirectory: false)
    }

    var ApplicationTextStyleSetMetadataDirectoryPath: URL {
        return ApplicationResourcesDirectory.appendingPathComponent("/stylo-core/stylesetmetadata.json", isDirectory: false)
    }
    
    private var applicationDefaultCssStylesFileWrapper: FileWrapper? {
        
        let url = ApplicationResourcesDirectory.appendingPathComponent("/themes/css/styles")
        return try? FileWrapper(url: url)
    }

    private var applicationDefaultTextStylesFileWrapper: FileWrapper? {
        
        let url = ApplicationResourcesDirectory.appendingPathComponent("/stylo-core/styles")
        return try? FileWrapper(url: url)
    }
    
    var PrintUserAgentStylesheetSourceDirectoryPath: String {
        
        return "Resources/themes/print/"
    }
    
    var CSSUserAgentStylesheetSourceDirectoryPath: String {
        
        return "Resources/themes/css/"
    }
    
    var ApplicationResourcesDirectory: URL {
        
        return URLForResourcesDirectoryPath(self)
    }
    
    /// This is the user-agent style sheet resource created from userAgentStyleSheetURL
    /// that participates in the pseudo css styles as the user-agent style sheet.
    public var userAgentStyleSheetDocumentStore: StylesheetDocumentStore!
    
    var URLForUserAgentCSSSourceStylesheet: URL {
        
        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
        
        return bundle.url(forResource: uaCssSourceStylesheetFileName,
                          withExtension: uaCssSourceStylesheetFileNameExtension,
                          subdirectory: CSSUserAgentStylesheetSourceDirectoryPath)!
    }
    
    var URLForUserAgentHTMLStylesheet: URL {
        
        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
        
        return bundle.url(forResource: uaHtmlStylesheetFileName,
                          withExtension: uaHtmlStylesheetFileNameExtension,
                          subdirectory: PrintUserAgentStylesheetSourceDirectoryPath)!
    }
    
    var URLForUserAgentPrintStylesheet: URL {
        
        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
        
        return bundle.url(forResource: uaPrintStylesheetFileName,
                          withExtension: uaPrintStylesheetFileNameExtension,
                          subdirectory: PrintUserAgentStylesheetSourceDirectoryPath)!
    }
    
    
    var userAgentPseudoStylesheetDarkUrl: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent("/core-themes/Stylo/dark/stylo.css")
    }
    
    var userAgentPseudoStylesheetLightUrl: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent("/core-themes/Stylo/light/stylo.css")
    }
    
    var themesDirectoryUrl: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent("themes", isDirectory: true)
    }
    
    var TemplatesDirectoryUrl: URL {
        
        return themesDirectoryUrl.appendingPathExtension("templates")
    }
    
    var debugThemesTemplatesDirectoryUrl: URL {
        
        return themesDirectoryUrl.appendingPathExtension("debugTemplates")
    }
    
    var cssThemesContextsDirectoryUrl: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent("themes/css/contexts", isDirectory: true)
    }
    
    var printThemesContextsDirectoryUrl: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent("themes/print/contexts", isDirectory: true)
    }
    
    public var applicationMode: StyloApplicationMode {
        
        // see http://stackoverflow.com/questions/24111854/in-absence-of-preprocessor-macros-is-there-a-way-to-define-practical-scheme-spe/24112024#24112024
        //        #if DEBUG
        return .advanced
        //        #else
        //            return .Default
        //        #endif
    }

    private var defaultCssStyleSetMetadata: StyleSetMetadata? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloApplication.shared.CSSStyleSetMetadataDirectoryPath: %@", log: Log.WriterCommon.all, type: .info, %%StyloApplication.shared.CSSStyleSetMetadataDirectoryPath.absoluteString)
        #endif
        
        do {
            let data = try! Data(contentsOf: StyloApplication.shared.CSSStyleSetMetadataDirectoryPath)
            let loadedMetadata = String(bytes: data, encoding: .utf8)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loadedMetadata: %@", log: Log.WriterCommon.all, type: .info, %%loadedMetadata)
            #endif
            
            return try StyleSetMetadata(jsonUTF8Data: data)
        }
        catch let error {
            assertionFailure("Error: error while loading application default style set metadata: \(error)")
            return nil
        }
    }
    
    private var defaultApplicationTextStyleSetMetadata: StyleSetMetadata? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloApplication.shared.ApplicationTextStyleSetMetadataDirectoryPath: %@", log: Log.WriterCommon.all, type: .info, %%StyloApplication.shared.ApplicationTextStyleSetMetadataDirectoryPath.absoluteString)
        #endif
        
        do {
            let data = try! Data(contentsOf: StyloApplication.shared.ApplicationTextStyleSetMetadataDirectoryPath)
            let loadedMetadata = String(bytes: data, encoding: .utf8)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loadedMetadata: %@", log: Log.WriterCommon.all, type: .info, %%loadedMetadata)
            #endif
            
            return try StyleSetMetadata(jsonUTF8Data: data)
        }
        catch let error {
            assertionFailure("Error: error while loading application default style set metadata: \(error)")
            return nil
        }
    }
    
    static var stylesheetTitleNumber = 0
    
    var defaultTitleForNewMarkdownText: String {
        
        return "Untitled"
    }
    
    var cssTemplateStringLight: String?
    var cssTemplateStringDark: String?
    
    /// This value contains the `application level` styles
    /// that can be used from any document
    public internal(set) var applicationTextStyleSetManager: StyleSetManager!
    
    public internal(set) var cssStyleSetManager: StyleSetManager!
    
    public internal(set) var printThemeSetManager: ThemeSetManager!
    
    public internal(set) var sharedStyleSetManager: StyleSetManager!
    
    public let applicationDispatcher: StyloApplicationDispatcher
    
    public weak var styloApplicationStore: StyloApplicationStore!
    
    /// User Agent Pseudo CSS created from ua-ccss.
    
    /// Directory:  ua-ccss/light
    /// We keep a strong reference because the StyleStore in not added
    /// to any state.
    public weak var userAgentDefaultThemeStyleLight: StyleAssemblyStore!
    
    /// Directory:  ua-ccss/dark
    /// We keep a strong reference because the StyleStore in not added
    /// to any state.
    public weak var userAgentDefaultThemeStyleDark: StyleAssemblyStore!
    
    
    /// This value contains the resulting appearance from using
    /// the user selected appearance and the system appearance
    /// with the user selected appearance always taking over
    /// the system one.
    ///
    /// Note: this value ca be nil because we want to account
    /// for the initialisation time when nothing is initialized.
    public let computedAppearance = Dynamic<AppearanceMode?>(nil)
    
    public var computedAppearanceOrDefault: AppearanceMode {
        
        guard let computedAppearance = self.computedAppearance.value else {
            return .dark
        }
        
        return computedAppearance
    }
    
    public let focusMode = Dynamic<FocusMode>(.disabled)
    
    public let userSelectedAppearance = Dynamic<AppearanceMode?>(nil)
    
    public let systemAppearance = Dynamic<AppearanceMode?>(nil)
    
    private let applicationPluginManager: ApplicationPluginManager
    
    var applicationDefaultStylesFileWrapper: FileWrapper? {
        
        let url = StyloApplication.shared.URLForTextSourceStylesDirectoryPath
        return try? FileWrapper(url: url)
    }
    
    var applicationDefaultStyleSetMetadata: StyleSetMetadata? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("StyloApplication.shared.StyleSetMetadataDirectoryPath: %@", log: Log.WriterCommon.all, type: .info, %%StyloApplication.shared.StyleSetMetadataDirectoryPath.absoluteString)
        #endif
        
        do {
            let data = try! Data(contentsOf: StyloApplication.shared.StyleSetMetadataDirectoryPath)
            let loadedMetadata = String(bytes: data, encoding: .utf8)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("loadedMetadata: %@", log: Log.WriterCommon.all, type: .info, %%loadedMetadata)
            #endif
            
            return try StyleSetMetadata(jsonUTF8Data: data)
        }
        catch let error {
            assertionFailure("Error: error while loading application default style set metadata: \(error)")
            return nil
        }
    }
    
    override fileprivate init() {
        
        self.applicationDispatcher = StyloApplicationDispatcher()
        let styloApplicationStore = StyloApplicationStore()
        applicationDispatcher.register(store: styloApplicationStore)
        self.styloApplicationStore = styloApplicationStore
        self.applicationPluginManager = ApplicationPluginManager()
        
        super.init()
        
        /// Load the css templates
        loadCssTemplateStrings()
        loadTextUserAgentStyleSheet()
        listen(to: styloApplicationStore)
    }
    
    /// TODO: When the plugin "in-app purchase" will be enabled
    /// we will need to look at if this plugin has been bought
    /// or not.
    public var styleEditorPluginCanWrite: Bool {
        
        guard let product = self.product else {
            assertionFailure("Error: product is nil")
            return false
        }
        
        switch product {
        case .nodio:
            return false
        case .stylo:
            return true
        }
    }
    
    public func isPluginEnabled(withName name: String) -> Bool {
        
        if let textuallyPlugin = TextuallyPlugin(rawValue: name) {
            switch textuallyPlugin {
            case .editorTheme:
                return false
            case .audio: fallthrough
            case .editorStyle: fallthrough
            case .exportHtml: fallthrough
            case .exportMarkdown: fallthrough
            case .exportPdf: fallthrough
            case .exportText: fallthrough
            case .exportWord:
                return true
            case .tags:
                return true
            }
        }
        
        // external plugins are always enabled if they are defined
        return true
    }
    
    public func disableFocus() {
        self.updateFocus(to: .disabled)
    }
    
    public func selectSentenceFocus() {
        self.updateFocus(to: .enabled(focusType: .sentence))
    }
    
    public func selectParagraphFocus() {
        self.updateFocus(to: .enabled(focusType: .paragraph))
    }
    
    public func selectBlocFocus() {
        self.updateFocus(to: .enabled(focusType: .bloc))
    }
    
    public func saveUserSelectedAppearanceToDefaults() {
        
        if let userSelectedAppearance = self.userSelectedAppearance.value {
            UserDefaults.standard.set(userSelectedAppearance.rawValue, forKey: Constants.UserDefaults.SelectedAppearanceMode)
        }
    }

    public func updateSelectedPreviewPluginName(to name: String) {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("updating selectedPreviewPluginName user defaults to: %@", log: Log.WriterCommon.all, type: .info, %%name)
        #endif
        
        UserDefaults.standard.set(name, forKey: Constants.UserDefaults.SelectedPreviewPluginName)
    }
    
    public func selectPrintTheme(at index: Int) {
        
        assert(printThemeSetManager != nil)
        printThemeSetManager.selectTheme(at: index)
    }
    
    public func selectPrintTheme(with title: String) {
        
        assert(printThemeSetManager != nil)
        printThemeSetManager.selectTheme(with: title)
    }
    
    public func selectCssStyle(at index: Int) {
        
        assert(cssStyleSetManager != nil)
        cssStyleSetManager.selectStyle(atIndex: index)
    }
    
    public func selectCssTheme(with title: String) {
        
        assert(cssStyleSetManager != nil)
        cssStyleSetManager.selectStyle(withTitle: title)
    }
    
    public func selectUserAppearance(appearance: AppearanceMode?) {
        
        let action = StyloApplicationAction.selectUserAppearance(appearance: appearance)
        self.applicationDispatcher.async(store: styloApplicationStore, action: action.asyncAction)
    }
    
    public func selectSystemAppearance(appearance: AppearanceMode) {
        
        let action = StyloApplicationAction.selectSystemAppearanceMode(appearance: appearance)
        self.applicationDispatcher.async(store: styloApplicationStore, action: action.asyncAction)
    }
    
    public func loadApplicationTextStyleSetManager() {
        
        assert(self.applicationTextStyleSetManager == nil)
        
        if let applicationDefaultStylesFileWrapper = self.applicationDefaultStylesFileWrapper, let applicationDefaultStyleSetMetadata = self.applicationDefaultStyleSetMetadata {
                
            self.applicationTextStyleSetManager = loadStyleSetFromStylesFileWrapper(fromStylesFileWrapper: applicationDefaultStylesFileWrapper, viewingMode: false, styleSetMetadata: applicationDefaultStyleSetMetadata)
        }
        assert(self.applicationTextStyleSetManager != nil)
    }
    
    private func loadStyleSetFromStylesFileWrapper(fromStylesFileWrapper stylesFileWrapper: FileWrapper, viewingMode: Bool = false, styleSetMetadata: StyleSetMetadata?) -> StyleSetManager {
        
        let styleSetManager = StyleSetManager(userAgentStyleSheetURL: self.textUserAgentCssURL, dispatcher: self.applicationDispatcher)
        
        styleSetManager.loadAllStylesWithStyle(stylingManager: StyloApplication.shared.cssStyleSetManager.defaultStyleManager, from: stylesFileWrapper, styleSetMetadata: styleSetMetadata)
        return styleSetManager
    }
    
    public func loadCSSStylesSetManager() {
        
        assert(self.cssStyleSetManager == nil)
        
        // there is no styles, we are opening a nodio document.
        guard let applicationDefaultCssStylesFileWrapper = self.applicationDefaultCssStylesFileWrapper else {
            assertionFailure("Error: applicationDefaultCssStylesFileWrapper is nil")
            return
        }
            
        guard let defaultCssStyleSetMetadata = self.defaultCssStyleSetMetadata else {
            assertionFailure("Error: defaultCssStyleSetMetadata is nil")
            return
        }
        
        let cssUserAgentStylesheet = ApplicationResourcesDirectory.appendingPathComponent("user-agent/css-ua.css", isDirectory: false)
        
        let styleSetManager = StyleSetManager(userAgentStyleSheetURL: cssUserAgentStylesheet, dispatcher: self.applicationDispatcher)

        styleSetManager.loadAllCssStylesWithStyle(stylingManager: nil, from: applicationDefaultCssStylesFileWrapper, styleSetMetadata: defaultCssStyleSetMetadata)
        
        self.cssStyleSetManager = styleSetManager
        
        assert(self.cssStyleSetManager != nil)
    }
    
    public func loadPrintThemeSetManager() {
        
        assert(printThemeSetManager == nil)
        assert(self.printThemeSetManager?.themeSetStore == nil)
        
        self.printThemeSetManager = ThemeSetManager(applicationDispatcher: self.applicationDispatcher)
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("Loading themes from: %@", log: Log.WriterCommon.all, type: .info, %%themesDirectoryUrl)
        #endif
            
        loadThemesUserAgentsStyles()
        self.printThemeSetManager.loadPrintTemplates(from: TemplatesDirectoryUrl)
        self.printThemeSetManager.loadThemesContexts(fromURL: printThemesContextsDirectoryUrl)
    }
    
    public func loadApplicationPlugins() {
        
        applicationPluginManager.loadApplicationPlugins(from: self)
    }
    
    public func templateString(for appearance: AppearanceMode) -> String {
        
        switch appearance {
        case .dark:
            return cssTemplateStringDark!
        case .light:
            return cssTemplateStringLight!
        }
    }
    
    /////////////////////////////////////////////////
    /// MARK: Private themes management methods
    /////////////////////////////////////////////////
    
    private func listen(to applicationStore: StyloApplicationStore) {

        applicationStore.selectedPrintTheme.subscribe({ [weak self] (theme: ThemeStore?) in
            self?.userDefaultsPrintThemeName = theme?.name
        }, observer: self)

        self.focusMode.setValue(applicationStore.focusMode.value)
        self.focusMode.bind(to: applicationStore.focusMode)
        
        self.initUserAppearance()
        self.computedAppearance.setValue(applicationStore.computedAppearance.value)
        self.handleAppearanceChange(applicationStore.computedAppearance.value)
        applicationStore.computedAppearance.subscribe({ [weak self](appearanceMode) in
            self?.handleAppearanceChange(appearanceMode)
        }, observer: self)
        self.userSelectedAppearance.setValue(applicationStore.userSelectedAppearance.value)
        self.userSelectedAppearance.bind(to: applicationStore.userSelectedAppearance)
        self.systemAppearance.bind(to: applicationStore.systemAppearance)
        
        initFocusMode()
    }
    
    private func handleAppearanceChange(_ appearanceMode: AppearanceMode?) {
        
        self.computedAppearance.setValue(appearanceMode)
        
        guard let appearanceMode = appearanceMode else {
            // could be nil in tests
            return
        }
        
        guard let selectedCssStyleManager = self.cssStyleSetManager?.selectedStyleManager.value else {
            return
        }
        
        selectedCssStyleManager.applyAppearanceMode(appearanceMode)
    }
    
    private func updateFocus(to focusMode: FocusMode) {
        
        UserDefaults.standard.set(focusMode.stringValue, forKey: Constants.UserDefaults.SelectedFocusMode)
        let selectFocusModeAction = StyloApplicationAction.selectFocusMode(focusMode: focusMode)
        self.applicationDispatcher.sync(store: self.styloApplicationStore, action: selectFocusModeAction.syncAction)
    }
    
    private func initFocusMode() {
        
        if let selectedFocusMode = UserDefaults.standard.value(forKey: Constants.UserDefaults.SelectedFocusMode) as? String {
            let selectFocusModeAction = StyloApplicationAction.selectFocusMode(focusMode: FocusMode.from(selectedFocusMode))
            self.applicationDispatcher.sync(store: self.styloApplicationStore, action: selectFocusModeAction.syncAction)
        }
    }
    
    private func initUserAppearance() {
        
        if let selectedAppearance = UserDefaults.standard.value(forKey: Constants.UserDefaults.SelectedAppearanceMode) as? String {
            
            let appearanceMode = AppearanceMode(rawValue: selectedAppearance)
            let selectApparanceAction = StyloApplicationAction.selectUserAppearance(appearance: appearanceMode)
            self.applicationDispatcher.sync(store: self.styloApplicationStore, action: selectApparanceAction.syncAction)
        }
    }
    
    fileprivate func loadCssTemplateStrings() {
        
        let urlLight = URL(fileURLWithPath: Bundle.main.bundlePath + Constants.Paths.CssTemplateLightPath)
        let urlDark = URL(fileURLWithPath: Bundle.main.bundlePath + Constants.Paths.CssTemplateDarkPath)
        let errorPointer: NSErrorPointer? = nil
        
        let encodingPointer: UnsafeMutablePointer<UInt>? = nil
        
        do {
            self.cssTemplateStringLight = try NSString(contentsOf: urlLight, usedEncoding: encodingPointer) as String
            self.cssTemplateStringDark = try NSString(contentsOf: urlDark, usedEncoding: encodingPointer) as String
        } catch let error as NSError {
            errorPointer??.pointee = error
        }
    }
    
    private func loadThemesUserAgentsStyles() {
        
        if userAgentDefaultThemeStyleLight == nil && userAgentDefaultThemeStyleDark == nil {
            
            /// Directory:  ua-ccss/light
            self.userAgentDefaultThemeStyleLight = createUserAgentDefaultLightPseudoCssStyle()
            self.userAgentDefaultThemeStyleDark = createUserAgentDefaultDarkPseudoCssStyle()
        }
    }
    
    ////////////////////////////////////////////////////////
    /// MARK: User Agent Pseudo CSS User Agent Default Style
    /// ua-ccss
    ////////////////////////////////////////////////////////
    
    private func createUserAgentDefaultDarkPseudoCssStyle() -> StyleAssemblyStore {
        
        return createStyleFromUniqueStyleSheet("ua-default-dark-pseudo-css",
            userAgentPseudoStyleSheetURL: userAgentPseudoStylesheetDarkUrl)
    }
    
    private func createUserAgentDefaultLightPseudoCssStyle() -> StyleAssemblyStore {
        
        return createStyleFromUniqueStyleSheet("ua-default-light-pseudo-css",
            userAgentPseudoStyleSheetURL: userAgentPseudoStylesheetLightUrl)
    }
    
    /// This method load the user-agent pseudo css style sheet (pseudo-css.css) that
    /// is used to style the pseudo css source files. It also creates
    /// the pseudo css style used to style all the pseudo css author resources.
    ///
    /// When loading user agent pseudo styles we don't want to create StyleManager as those 
    /// includes necessarly the possibility to edit them and style them. Since the User Agent
    /// Pseudo Style will never be edited we create this function that loads them according
    /// to a specific way.
    private func createStyleFromUniqueStyleSheet(_ title: String, userAgentPseudoStyleSheetURL: URL) -> StyleAssemblyStore {
        
        // for the moment we keep a reference in the ApplicationDelegate
        // for the stores that are not linked to a document.
        // FIXME: we must find a solution for this eventually
        let styleAssemblyStore = StyleAssemblyStore(editedLanguage: Language.CCSS, id: UUID().uuidString)
        applicationDispatcher.register(store: styleAssemblyStore)
        
        let stylesheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark))
        applicationDispatcher.register(store: stylesheetDocumentStore)
        
        // dispatch should take a trailing closure to run something
        // after, that's what we need here.
        let loadAction = StylesheetDocumentActionsFactory.loadStylesheetAction(url: userAgentPseudoStyleSheetURL)
        let result = self.applicationDispatcher.sync(store: stylesheetDocumentStore, action: loadAction)
        if let stylesheetDocumentResult = result as? StylesheetDocumentResult, let stylesheet = stylesheetDocumentResult.stylesheet {
            let styleAction = StyleAssemblyAction.createStyleWithStylesheets(stylesheets: [stylesheet], styleId: title)
            styleAssemblyStore.sync(action: styleAction.syncAction)
        }
        else {
            assertionFailure("stylesheet is nil")
        }
        return styleAssemblyStore
    }
    
    /// Method that returns the URL of the text-ua.css file
    /// which is the css user agent file for text document (Markdown)
    var textUserAgentCssURL: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent(Constants.Paths.TextUserAgentCssPath)
    }
    
    var cssUserAgentCssURL: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent(Constants.Paths.CssUserAgentCssPath)
    }
    
    var DomUserAgentCssURL: URL {
        
        return ApplicationResourcesDirectory.appendingPathComponent(Constants.Paths.DomUserAgentCssPath)
    }
    
    func URLForResourcesDirectoryPath(_ any: AnyObject) -> URL {
        
        let bundle = Bundle(for: type(of: CurrentBundleClass.shared))
        
        return bundle.url(forResource: "Resources",
            withExtension: nil,
            subdirectory: nil)!
    }
    
    /// This method load the user-agent pseudo css style sheet that
    /// is used to style the pseudo css source files.
    @discardableResult
    public func loadTextUserAgentStyleSheet() -> ActionResult? {
        
        let stylesheetDocumentStore = StylesheetDocumentStore(origin: .userAgent, appearances: Set<AppearanceMode>(arrayLiteral: .light, .dark))
        self.applicationDispatcher.register(store: stylesheetDocumentStore)
        self.userAgentStyleSheetDocumentStore = stylesheetDocumentStore
        
        let action = StylesheetDocumentActionsFactory.loadStylesheetAction(url: self.textUserAgentCssURL)
        return self.applicationDispatcher.sync(store: userAgentStyleSheetDocumentStore, action: action)
    }
    
}

