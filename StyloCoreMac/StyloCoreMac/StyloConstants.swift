//
//  Constants.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-05.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

public struct StyloConstants {
    
    public struct Configuration {
        
        public static let LightModeEnabled: Bool = true
        
        #if DEBUG
        public static let SaveEditHistoryButtonEnabled: Bool = true
        public static let ThemeChoosingEnabled: Bool = true
        public static let ThemeEditingEnabled: Bool = true
        public static let PageSetupButtonEnabled: Bool = false
        public static let CssDomToolsEnabled: Bool = true
        public static let CssHelpEnabled: Bool = true
        #else
        public static let SaveEditHistoryButtonEnabled: Bool = false
        public static let ThemeChoosingEnabled: Bool = false
        public static let ThemeEditingEnabled: Bool = false
        public static let PageSetupButtonEnabled: Bool = false
        public static let CssDomToolsEnabled: Bool = false
        public static let CssHelpEnabled: Bool = false
        #endif
    }
    
    public struct EditorsPane {
        public static let CollapseDelay = 0.3
        public static let CollapseAnimationTime = 0.3
        public static let UncollapseAnimationTime = 0.3
    }
    
    public struct StyleSplitView {
        
        public static let DividerDidMoveUpdateDelay = 0.1
    }
    
    public struct Tags {
        
        public static let TagsUpdateDelay = 0.4
        public static let FlashDelaySeconds: Double = 5
    }
    
    public struct Window {
        
        public static let PreferredWidth: CGFloat = 1100
        
        public static let PreferredHeight: CGFloat = 600
        
        public static var StandardsButtonsVerticalDeviation: CGFloat {
            if #available(OSX 11.0, *) {
                return 3
            }
            else {
                return 5
            }
        }
        public static var StandardsButtonsVerticalOriginalPosition: CGFloat {
            if #available(OSX 11.0, *) {
                return 6.0
            }
            else {
                return 3.0
            }
        }
    }
    
    public struct MessageTooltips {
        
        public static let MouseIdleShowTime = 0.8
        public static let MessageTooltipLifetime = 2.0
        public static let LastEditTimeIntervalAllowedMessageTooltipDisplay = 2.0
    }
    
    
    public struct DragTypes {
        
        public static let StylesheetType = NSPasteboard.PasteboardType(rawValue: "stylo.style.dragtype")
        public static let StyleType = NSPasteboard.PasteboardType(rawValue: "stylo.style.dragtype")
        public static let DirectoryItem = NSPasteboard.PasteboardType(rawValue: "stylo.style.dragtype")
    }
    
    public struct TextViewSidebar {
        
        public static let HeadersTagUpdateInterval = 0.00
    }
    
    public struct Autocompletion {
        
        public static let CompletionWidth: CGFloat = 170
        public static let LanguageWidth: CGFloat = 130
        public static let MaxSize: CGFloat = 12
    }
    
    public struct CSS {
        
        public enum EditorAnimationMode {
            
            case present
            case transition
        }
        
        public static let editorPresentationAnimationMode: EditorAnimationMode = .transition
    }
    
    public struct ViewIdentifiers {
        
        public static let ToolsPreviewButton: String = "tools-preview"
        public static let ToolsStatisticsButton: String = "tools-statistics"
        public static let ToolsStylesButton: String = "tools-styles"
        public static let ToolsBigStylesButton: String = "tools-big-styles"
    }
    
}
