//
//  StyleSheet.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-17.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import Common
import os

// http://dev.w3.org/csswg/cssom/#stylesheet
//interface StyleSheet {
//    readonly attribute DOMString type;
//    readonly attribute DOMString? href;
//    readonly attribute (Element or ProcessingInstruction)? ownerNode;
//    readonly attribute StyleSheet? parentStyleSheet;
//    readonly attribute DOMString? title;
//    [SameObject, PutForwards=mediaText] readonly attribute MediaList media;
//    attribute boolean disabled;
//};

open class StyleSheet: CSSOMLanguageObject {
    
    /// readonly attribute DOMString type;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-type
    public internal(set) var type: DOMString
    
    /// readonly attribute DOMString? href;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-href
    public internal(set) var href: DOMString?
    
    /// readonly attribute (Element or ProcessingInstruction)? ownerNode;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-ownernode
    public internal(set) weak var ownerNode: Node?
    
    /// readonly attribute StyleSheet? parentStyleSheet;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-parentstylesheet
    public internal(set) weak var parentStyleSheet: StyleSheet?
    
    /// readonly attribute DOMString? title;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-title
    public internal(set) var title: DOMString?
    
    /// [SameObject, PutForwards=mediaText] readonly attribute MediaList media;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-media
    var media: MediaList
    
    /// attribute boolean disabled;
    /// see http://dev.w3.org/csswg/cssom/#dom-stylesheet-disabled
    var disabled: Bool
    
    init(type: DOMString, href: DOMString?, ownerNode: Element, parentStyleSheet: StyleSheet, title: DOMString, disabled: Bool) {
        
        self.type = type
        self.disabled = false
        media = MediaList()
        self.href = href
        self.ownerNode = ownerNode
        self.parentStyleSheet = parentStyleSheet
        self.title = title
        super.init(sourceStringSegment: nil)
    }
    
    init(type: DOMString, href: DOMString?) {
        self.type = type
        self.disabled = false
        self.href = href
        media = MediaList()
        super.init(sourceStringSegment: nil)
    }
    
    open override func equals(to other: Any?, comparePositions: Bool = false) -> Bool {
        
        if let other = other {
        
            if let other = other as? StyleSheet {
                
                if !super.equals(to: other, comparePositions: comparePositions) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: super are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.type != other.type {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: stylesheet type are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.href != other.href {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: href are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if let title = self.title {
                    
                    if let otherTitle = other.title {
                        
                        if title != otherTitle {
                            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                            os_log("Not equals: title are different.", log: Log.Web.all, type: .debug)
                            #endif
                            return false
                        }
                    }
                    else {
                        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                        os_log("Not equals: other title is nil.", log: Log.Web.all, type: .debug)
                        #endif
                        return false
                    }
                }
                
                if !self.media.equals(other.media) {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: media are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
                
                if self.disabled != other.disabled {
                    #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                    os_log("Not equals: disabled are different.", log: Log.Web.all, type: .debug)
                    #endif
                    return false
                }
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("Not equals: other is not StyleSheet.", log: Log.Web.all, type: .debug)
                #endif
                return false
            }
        }
        else {
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("Not equals: other is nil.", log: Log.Web.all, type: .debug)
            #endif
            return false
        }
        return true
    }
    
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override open func accept(_ visitor: CSSVisitor) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("missing implementation", log: Log.Web.all, type: .error)
        #endif
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: StyleSheet, rhs: StyleSheet) -> Bool {

    return lhs.equals(to: rhs)
}
