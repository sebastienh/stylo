//
//  StyleSetManager+Templates.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-09.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common
import os

extension StyleSetManager {
    
    public func loadCssTemplates<S: Store>(from url: URL?, in store: S) {
        
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
            
            let environmentAction = TemplateActionFactory.createLoadTemplatesSyncAction(with: "\(bundlePath)/Resources/Resources/themes/css/templates/")
        
            StyloApplication.shared.applicationDispatcher.sync(store: store, action: environmentAction)
        }
    }
    
}
