//
//  MenuItemTag.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-07-19.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public enum MenuItemTag: Int {
    
//    case application = 0
    case file = 1
    case edit = 2
    case format = 3
    case view = 4
    case window = 5
    case help = 6
    case copySelector = 7
    case showHideHtmlPreview = 8
    case showHideStylePicker = 9
    case showHideEditorSidebarTools = 10
    case editThemes = 18
//    case textStatisticsSessionEnabled = 19
    case styles = 20
    case lightMode = 21
    case darkMode = 22
    case systemMode = 23
    case preview = 24
    case stylesListChoice = 25
    case showHideNavigator = 27
    case addFile = 28
    case addDirectory = 29
    case addGroup = 30
    case closeCurrentEditorsPane = 31
    case addEditorsPane = 32
    case goBack = 33
    case goForward = 34
    case addTextInCurrentEditorsPane = 35
    
    case disableFocus = 36
    case sentenceFocus = 37
    case paragraphFocus = 38
    case blocFocus = 39
}
