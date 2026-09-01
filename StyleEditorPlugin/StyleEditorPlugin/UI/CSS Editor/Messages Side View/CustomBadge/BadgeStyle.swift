/*
 
 ------------------------------------------------------------------------------------
 CustomBadge.m
 ------------------------------------------------------------------------------------
 CustomBadge is an UIView which draws a customizable badge on any other view.
 The latest version has separation between style and rendering.
 This class is the core of CustomBadge where the actual rendering happens.
 It recommended to use the convenient allocators instead of the init methods.
 ------------------------------------------------------------------------------------
 
 The MIT License (MIT)
 
 Copyright (c) 2014 Sascha Paulus
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 */

//
//  BadgeStyle.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

enum BadgeStyleFontType: Int {
    case BadgeStyleFontTypeHelveticaNeueMedium
    case BadgeStyleFontTypeHelveticaNeueLight
}

struct BadgeStyle {
    
    let badgeTextColor: NSColor
    let badgeInsetColor: NSColor
    let badgeFrameColor : NSColor?
    let badgeFrame: Bool
    let badgeShining: Bool
    let badgeShadow: Bool
    let badgeFontType: BadgeStyleFontType
    
    static var defaultStyle: BadgeStyle {
        
        return BadgeStyle(textColor: NSColor.white,
                          insetColor: NSColor.red,
                          frameColor: nil,
                          frame: false,
                          shadow: false,
                          shining: false,
                          fontType: .BadgeStyleFontTypeHelveticaNeueLight)
        
    }
    
    static var oldStyle: BadgeStyle {
        
        return BadgeStyle(textColor: NSColor.white,
                          insetColor: NSColor.red,
                          frameColor: NSColor.white,
                          frame: true,
                          shadow: true,
                          shining: true,
                          fontType: .BadgeStyleFontTypeHelveticaNeueMedium)
    }
    
    init(textColor: NSColor, insetColor: NSColor, frameColor: NSColor?, frame: Bool, shadow: Bool, shining: Bool, fontType: BadgeStyleFontType) {
        
        self.badgeTextColor = textColor
        self.badgeInsetColor = insetColor
        self.badgeFrameColor = frameColor
        self.badgeFrame = frame
        self.badgeShining = shining
        self.badgeShadow = shadow
        self.badgeFontType = fontType
    }
    

    
    static func freeStyleWithTextColor(textColor: NSColor, withInsetColor insetColor: NSColor, withFrameColor frameColor: NSColor,  withFrame frame: Bool, withShadow shadow: Bool, withShining shining: Bool, withFontType fontType: BadgeStyleFontType) -> BadgeStyle {
        
        return BadgeStyle(textColor: textColor,
                          insetColor: insetColor,
                          frameColor: frameColor,
                          frame: frame,
                          shadow: shadow,
                          shining: shining,
                          fontType: fontType)
        
    }

    
}
