//
//  StyloCoreNotification.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-28.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon

public enum StyloNotification: String, Notifications {
    
    // This is the notification sent when the user double click
    // an item in the autocompletion nsarray.
    case DoubleClickedAutocompletionItem
    
    // This is the notification sent whenever the mouse click
    // somewhere in the document window. Use primarily by the autocompletion
    // window to close itself when necessary.
    case WindowMouseDown
    
    
    case windowMouseMoved
    
    case windowTopMouseMoved
    
    // sometimes we want to know when a mouse moved inside
    // the editor (to unhide the statistics and tools bar
    // for example).
    case editorMouseMoved
    case editorMouseDown
    case editorKeyDown
    case ShowBottomBar
    case DidSelectMessageInIssuesReporter
    case DidClickDomInspectableNode
    
    case textStatisticsSessionEnabledStateChanged
    case editorIsSelecting
    case editorIsNotSelecting
    
    case willEnterFullScreen
    case didEnterFullScreen
    
    case willExitFullScreen
    case didExitFullScreen
    
    case willHideSidebars
    case willShowSidebars
    case showingSidebars
    case hidingSidebars
    case didHideSidebars
    case didShowSidebars
    
    case willHideNavigator
    case didHideNavigator
    case willShowNavigator
    case didShowNavigator
    
    case willHideTools
    case didHideTools
    case willShowTools
    case didShowTools
    
    case willShowLeftButtons
    case willHideLeftButtons
    case didShowLeftButtons
    case didHideLeftButtons
    
    case willNavigateInHistory
    case didNavigateInHistory
    
    case willMoveDivider
    case didMoveDivider
    
}
