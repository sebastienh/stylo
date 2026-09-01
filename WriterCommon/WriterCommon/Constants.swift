//
//  Constants.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-03-04.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

public typealias EditorId = String
public typealias TextId = String
public typealias ContentId = String
public typealias DocumentAudioFilesId = String

public struct Constants {
    
    public struct Versions {
        
        public static let document = SemanticVersion.with {
            $0.major = 1
            $0.minor = 0
            $0.patch = 0
        }
        
        public static let project = SemanticVersion.with {
            $0.major = 2
            $0.minor = 0
            $0.patch = 0
        }
    }
    
    public struct Configuration {
        
        public static let LightDarkedAmount: CGFloat = 0.2
        public static let MaximumCharacterCountCompleteLayout = 20000
        public static let MaximumFilenameLength = 255
        public static let TextEditorControlRightPadding: CGFloat = 30
        public static let FlashDelaySeconds: Double = 5
        public static let ForceMarkdownSynchronousCompilation: Bool = false
        
        static let DocumentIgnoredItemsSet: Set<String> = Set<String>(arrayLiteral: ".git", ".styloproj")
    }
    
    
    public struct UserDefaults {
        
        public static let StyloSelectedPrintTheme = "StyloSelectedPrintTheme"
        public static let StyloSelectedCSSStyle = "StyloSelectedCSSStyle"
        public static let SelectedAppearanceMode = "StyloSelectedAppearanceMode"
        public static let SelectedFocusMode = "StyloSelectedFocusMode"
        public static let TextStatisticsSessionToolsEnabled = "TextStatisticsSessionToolsEnabled"
        public static let SelectedPreviewPluginName = "SelectedPreviewPluginName"
    }
    
    public struct ErrorDomain {
        
        public static let Stylo: String = "StyloErrorDomain"
        
    }
    
    struct Version {
        
        static let currentReleaseVersion = SemanticVersion.with {
            $0.major = 0
            $0.minor = 3
            $0.patch = 2
        }
    }
    
    struct Stylesheet {
        
        public static let HighlightSelectorName = "highlight"
    }
    
    public struct Colors {
        
        public static let GrayColor = NSColor(calibratedRed: 42/255, green: 41/255, blue: 40/255, alpha: 1)
        
    }
    
    public struct Paths {
        
        public static let CssTemplateLightPath = "/Contents/Resources/text-css-template-light.css"
        public static let CssTemplateDarkPath = "/Contents/Resources/text-css-template-dark.css"
        public static let TextUserAgentCssPath = "/user-agent/text-ua.css"
        public static let CssUserAgentCssPath = "/user-agent/css-ua.css"
        public static let DomUserAgentCssPath = "/user-agent/dom-ua.css"
    }
    
    public struct Notifications {
        
        public static let ChangeRequest = "ChangeRequest"
        public static let SourceStringChangeDescriptionString = "sourceStringChangeDescription"
        public static let ChangeRequestQueueString = "ChangeRequestQueue"
        public static let VisibleRectString = "VisibleRectString"
        public static let TextStorage = "TextStorage"
        public static let DocumentAttributes = "DocumentAttributes"
        public static let Message = "Message"
        public static let MessageArray = "MessageArray"
        public static let DomInspectableNode = "DomInspectableNode"
        public static let Event = "Event"
        public static let Appearance = "Appearance"
    }
    
    public struct Images {
        
        public static let EmergencyImageName = "emergency_image.png"
        public static let AlertImageName = "alert_image.png"
        public static let CriticalImageName = "critical_image.png"
        public static let ErrorImageName = "error_image.png"
        public static let WarningImageName = "warning_image.png"
        public static let NoticeImageName = "notice_image.png"
        public static let InformationalImageName = "info_image.png"
        public static let DebugImageName = "debug_image.png"
    }
    
    public struct Queues {
        
        public static let ApplicationQueue = "net.textually.application-"
        public static let DocumentStoreDocumentQueueNamePrefix = "net.textually.document-queue-"
        public static let JsonStoreDocumentQueueNamePrefix = "net.textually.document-queue-"
        public static let DocumentStoreAttributesStoreQueueNamePrefix = "net.textually.attributes-store-queue-"
        public static let StyloDocumentStoreStyloDocumentQueueNamePrefix = "net.textually.stylo-document-queue-"
        public static let MarkdownDocumentStoreCompilationQueueNamePrefix = "markdown.document.compilation-queue-"
        public static let CssDocumentStoreCompilationQueueNamePrefix = "css.document.compilation-queue-"
        public static let MarkdownStyleStoreCompilationQueueNamePrefix = "markdown.style.compilation-queue-"
        public static let CssStyleStoreCompilationQueueNamePrefix = "css.style.compilation-queue-"
        public static let JsonStyleCompilationQueueNamePrefix = "json.style.compilation-queue-"
        public static let DocumentStorePendingRequestsQueueNamePrefix = "media.pending-requests-queue-"
        public static let StyleStoreQueueNamePrefix = "net.textually.stylo.style-store-queue-"
        public static let StyleAssemblyStoreQueueNamePrefix = "net.textually.stylo.styleassembly-store-queue-"
        public static let TemplateStoreQueueNamePrefix = "net.textually.stylo.template-store-queue-"
        public static let JsonStoreQueueNamePrefix = "net.textually.stylo.template-context-store-queue-"
        public static let DocumentStoreAttributesCompilationSerialQueueNamePrefix = "net.textually.document-queue-attributes-serial-queue"
        public static let HtmlPreviewQueueNamePrefix = "net.textually.stylo.html-preview-queue-"
        public static let TextStatisticsQueueNamePrefix = "net.textually.stylo.text-statistics-queue-"
        public static let StylesheetTemplatePrefix = "net.textually.stylo.stylesheet-template-queue-"
    }
    
    public struct Markdown {
        
        public static let RecompileNumberOfTokens = 50
        public static let newTextStringContent: String = "\n\n\n\n"
        public static let TagsUpdateDelay: Double = 0.4
    }
    
    public struct CSS {
        
        public static let RecompileSourceStringLength = 50
    }
    
    public struct FileExtension {
        
        public static let html = "html"
        public static let word = "doc"
        public static let plainText = "txt"
        public static let markdown = "md"
        public static let pdf = "pdf"
        public static let css = "css"
        public static let stylo = "stylo"
        public static let history = "history"
    }
    
    public struct Filename {
        
        public static let DefaultFilesGroupName = "Untitled Group"
        public static let DefaultFilesOutlineName = "Untitled Pane"
        public static let DefaultDirectoryName = "Untitled Directory"
        public static let DefaultAudioFileName = "Untitled Audio"
        public static let DefaultTextName = "Untitled Text"
        public static let StylesDirectoryName = "styles"
        public static let DocumentStylesMetadataJsonName = "styles.json"
        public static let SourcesDirectoryName = "sources"
        public static let FilesDirectoryName = "Files"
        public static let RootDirectoryName = ""
        public static let ThemesDirectoryName = "themes"
        public static let StyloProjectDirectoryName = ".styloproj"
        public static let OldStyloProjectFileJsonName = "project.json"
        public static let StyloProjectFileJsonName = "stylo.json"
        public static let StyleFilesDescriptorBinaryName = "stylo.data"
        public static let DocumentAudioDirectoryName = "audio"
        public static let PluginsDataDirectoryFilename = "plugins"
        
    }
    
    public struct ViewingMode {
        
        public static let backgroundDarkColor =  NSColor(deviceRed: 0, green: 0, blue: 0, alpha: 1)
        public static let backgroundLightColor =  NSColor(deviceRed: 1, green: 1, blue: 1, alpha: 1)
        public static let foregroundDarkColor =  NSColor(deviceRed: 0.7, green: 0.7, blue: 0.7, alpha: 1)
        public static let foregroundLightColor =  NSColor(deviceRed: 0, green: 0, blue: 0, alpha: 1)
        public static let font = NSFont(name: "Menlo", size: 14.0)
    }
    
    public struct TextStatistics {
        
        public static let wordsPerPage: Double = 250
        public static let wordsPerMinuteSlow: Double = 150
        public static let wordsPerMinuteAverage: Double = 250
        public static let wordsPerMinuteFast: Double = 350
        public static let SessionToolsEnabledDefaultValue: Bool = false
    }
    
    public struct FilesOutline {
        public static let MaxHistorySize: Int = 1000
        public static let ScrollingEnablingDelay: Double = 0.4
    }
    
}
