//
//  Presets.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation

public struct Presets {
    
    /// Commonmark default options
    /// Singleton instance CommonMark Presets.
    static var commonMarkPresetsInstance: Presets?
    
    /// Singleton instance Default Presets.
    /// markdown-it default options
    static var defaultPresetsInstance: Presets?
    
    /// Singleton instance Default Presets.
    /// "Zero" preset, with nothing enabled. Useful for manual configuring of simple
    /// modes. For example, to parse bold/italic only.
    static var zeroPresetsInstance: Presets?
    
    /// Used during developpement to only include what is developped
    /// not less, not more.
    static var everythingAvailableInstance: Presets?
    
    ///
    /// Used for the rendering of the HTMLDocument DOM in order 
    /// to include all Markdown elements also : markdownOut = true
    ///
    static var markdownDomPresetsInstance: Presets?
    
    public let options: Options?
    let components: Components?
    
    init(options: Options? = nil, components: Components? = nil) {
        
        self.options = options
        self.components = components
    }

}
