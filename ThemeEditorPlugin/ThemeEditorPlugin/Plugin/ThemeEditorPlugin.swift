//
//  ThemeEditorPlugin.swift
//  ThemeEditorPlugin
//
//  Created by Sebastien Hamel on 2020-01-02.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import SwiftProtobuf
import StyloCoreMac

class ThemeEditorPlugin: StyloPlugin {
    
    var name: String {
        return  Constants.Plugin.Name
    }
    
    let themeSetManager: ThemeSetManager
    
    required init?(styloApplication: StyloApplication) {
        
        guard let themeSetManager = styloApplication.themeSetManager else {
            assertionFailure("Error: themeSetManager is nil")
            return nil
        }
        
        self.themeSetManager = themeSetManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pluginDidLoad() {
        
        
    }
}
