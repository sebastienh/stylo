//
//  RenderLayer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-07.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import Web

/// A RenderParagraph is created when atributes are set 
/// that should apply to a complete paragraph instead of just 
/// text elements. Such CSS attributes includes, margin left and right
/// and every attributes that should apply to a complete paragraph.
final class RenderParagraph: RenderObject {
    
    override func paintTemporary(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        super.paintTemporary(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
    }
    
    override func paint(contentString: StylableString, resourceComputedStyle: ResourceComputedStyle) {
        
        super.paint(contentString: contentString, resourceComputedStyle: resourceComputedStyle)
    }

}
