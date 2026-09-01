//
//  TextManager+ContentManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension TextManager: ContentManager {

    public var contentName: Dynamic<String> {
        return self.name
    }
    
    public var pluginsBackgroundActivities: DynamicDictionary<String, BackgroundActivity> {
        return self._pluginsBackgroundActivities
    }
    
    public func isSelectedByPlugin(withName pluginName: String) {
        
        self.textDocument?.content(withId: self.id, wasSelectedByPluginWithName: pluginName)
    }
}
