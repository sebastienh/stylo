//
//  StyloApplication+UserDefaults.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

extension StyloApplication {
    
    public var userDefaultsCSSStyleName: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaults.StyloSelectedCSSStyle)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.StyloSelectedCSSStyle)
        }
    }
    
    public var userDefaultsPrintThemeName: String? {
        get {
            return UserDefaults.standard.string(forKey: Constants.UserDefaults.StyloSelectedPrintTheme)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.StyloSelectedPrintTheme)
        }
    }
    
    public var textStatisticsSessionToolsEnabled: Bool {
        
        get {
            if UserDefaults.standard.object(forKey: Constants.UserDefaults.TextStatisticsSessionToolsEnabled) != nil {
                return UserDefaults.standard.bool(forKey: Constants.UserDefaults.TextStatisticsSessionToolsEnabled)
            }
            else {
                // by default we want this to be disabled
                UserDefaults.standard.set(
                    Constants.TextStatistics.SessionToolsEnabledDefaultValue, forKey: Constants.UserDefaults.TextStatisticsSessionToolsEnabled)
                return
                    Constants.TextStatistics.SessionToolsEnabledDefaultValue
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.UserDefaults.TextStatisticsSessionToolsEnabled)
        }
    }
    
    public func revertTextStatisticsSessionToolsEnabledValue() {
        
        self.textStatisticsSessionToolsEnabled = !self.textStatisticsSessionToolsEnabled
    }
}

