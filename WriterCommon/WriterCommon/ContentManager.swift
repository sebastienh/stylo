//
//  ContentManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-05.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common


/// This is mainly for futur support if images and drawings.
/// At this point we only have text content (TextManager)
public protocol ContentManager {
    
    var contentName: Dynamic<String> { get }
    
    /// This value is used by plugins to tell the stylo app that
    /// there is background activity happening. Stylo could react
    /// the way it wants depending on the context.
    ///
    /// Note: for now, this is used by the StyloAudioPlugin to tell
    /// Stylo that there is recording going on and that it should display
    /// the project editor text editor right controls for the user
    /// to be able to see the recording button flashing. 
    var pluginsBackgroundActivities: DynamicDictionary<String, BackgroundActivity> { get }
    
    /// This method is called when a plugin selects an item
    /// related to this content manager. The content manager
    /// can decide what to do based on the plugin that selected
    /// it. 
    func isSelectedByPlugin(withName pluginName: String)
    
}
