//
//  StyloApplicationReducer.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-11-13.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common
import PromiseKit
import Igloo
import os

public enum StyloApplicationAction: ActionType {
    
    case selectSystemAppearanceMode(appearance: AppearanceMode)
    
    case selectUserAppearance(appearance: AppearanceMode?)
    
    case selectTheme(themeStore: ThemeStore)
    
    case selectFocusMode(focusMode: FocusMode)
}

public class StyloApplicationReducer: Reducer, SerialReducer {

    public let serialQueue: DispatchQueue
    
    init(storeIdentifier: String) {
        
        self.serialQueue = DispatchQueue(label: Constants.Queues.ApplicationQueue + storeIdentifier, qos: DispatchQoS.userInteractive)
    }
    
    public func handleAction<S: Store>(store: S, action: ActionType) throws -> ActionResult? {
        
        guard let styloApplicationAction = action as? StyloApplicationAction else {
            assertionFailure("Error: action is not of type StyloApplicationAction")
            return nil
        }
        
        guard let styloApplicationStore = store as? StyloApplicationStore else {
            assertionFailure("Error: store is not an StyloApplicationStore")
            return nil
        }
        
        switch styloApplicationAction {
                
        case .selectUserAppearance(let appearance):
            
            styloApplicationStore.userSelectedAppearance.setValue(appearance)
            updateAppearance(styloApplicationStore)
            updateApplicationThemeStylesAppearance(styloApplicationStore)
            
        case .selectSystemAppearanceMode(let appearance):
        
            styloApplicationStore.systemAppearance.setValue(appearance)
            updateAppearance(styloApplicationStore)
            updateApplicationThemeStylesAppearance(styloApplicationStore)
            
        case .selectTheme(let themeStore):
            
            styloApplicationStore.selectedPrintTheme.setValue(themeStore)
            updateApplicationThemeStylesAppearance(styloApplicationStore)
        case .selectFocusMode(let focusMode):
            styloApplicationStore.focusMode.setValue(focusMode)
        }
        return nil
    }
    
    private func updateAppearance(_ styloApplicationStore: StyloApplicationStore) {
     
        if let userSelectedAppearance = styloApplicationStore.userSelectedAppearance.value {
            styloApplicationStore.computedAppearance.setValue(userSelectedAppearance, sameExecutionStack: true)
        }
        else if let systemAppearance = styloApplicationStore.systemAppearance.value {
            styloApplicationStore.computedAppearance.setValue(systemAppearance, sameExecutionStack: true)
        }
    }
    
    private func updateApplicationThemeStylesAppearance(_ styloApplicationStore: StyloApplicationStore) {
//
//        let appearanceMode = styloApplicationStore.computedAppearance.value
//        if let theme = styloApplicationStore.selectedPrintTheme.value {
//
//            switch appearanceMode {
//            case .dark:
//
//                // preview style
//                let previewStyle = theme[.previewDark]
//                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
//                os_log("previewStyle.styleType: %@", log: Log.WriterCommon.all, type: .info, %%previewStyle.styleType)
//                #endif
//                assert(previewStyle.styleType == .preview)
//                styloApplicationStore.previewStyle.setValue(previewStyle)
//
//
//
//            case .light:
//
////                // css source style
////                let sourceStyle = theme[.sourceLight]
////                assert(sourceStyle.styleType == .source)
////                styloApplicationStore.sourceStyle.setValue(sourceStyle)
//
//                // preview style
//                let previewStyle = theme[.previewLight]
//                assert(previewStyle.styleType == .preview)
//                styloApplicationStore.previewStyle.setValue(previewStyle)
//
////                // errorsStyle
////                let errorsStyle = theme[.errorsLight]
////                assert(errorsStyle.styleType == .errors)
////                styloApplicationStore.errorsStyle.setValue(errorsStyle)
////
////                // errorStyle
////                let errorStyle = theme[.errorLight]
////                assert(errorStyle.styleType == .error)
////                styloApplicationStore.errorStyle.setValue(errorStyle)
//
//            }
//        }
    }
}
