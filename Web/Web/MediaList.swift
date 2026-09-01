//
//  MediaList.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-18.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation
import os

//http://dev.w3.org/csswg/cssom/#medialist
//interface MediaList {
//    [TreatNullAs=EmptyString] stringifier attribute DOMString mediaText;
//    readonly attribute unsigned long length;
//    getter DOMString? item(unsigned long index);
//    void appendMedium(DOMString medium);
//    void deleteMedium(DOMString medium);
//};

private protocol IMediaList {
    
    // [TreatNullAs=EmptyString]
    var mediaText: DOMString { get }
    
    var length: Int { get }
    
    // functions
    
    func item(_ index: Int) -> DOMString?
    func appendMedium(_ medium: DOMString)
    func deleteMedium(_ medium: DOMString)
}

final class MediaList : CSSOMLanguageObject, IMediaList, CustomStringConvertible {
    
    var mediaList = [DOMString]()
    
    /// [TreatNullAs=EmptyString] stringifier attribute DOMString mediaText;
    /// see http://dev.w3.org/csswg/cssom/#dom-medialist-mediatext
    var mediaText: DOMString {
        
        return String()
    }
    
    /// readonly attribute unsigned long length;
    /// see http://dev.w3.org/csswg/cssom/#dom-medialist-length
    var length: Int {
        
        return mediaList.count
    }
    
    /// Printable protocol requirement
    var description: String {
        
        // FIXME: see http://dev.w3.org/csswg/cssom/#serialize-a-media-query-list
        assert(false, "Revise implementation according to : http://dev.w3.org/csswg/cssom/#serialize-a-media-query-list")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Revise implementation according to : http://dev.w3.org/csswg/cssom/#serialize-a-media-query-list", log: Log.Web.all, type: .error)
        #endif
        
        var result = DOMString("")
        
        if mediaList.count > 0 {
            result = mediaList[0]
        }
        
        for index in 1..<mediaList.count {
            result = result + ",\(mediaList[index])"
        }
        
        return result
    }
    
    /// getter DOMString? item(unsigned long index);
    /// see http://dev.w3.org/csswg/cssom/#dom-medialist-itemindex
    func item(_ index: Int) -> DOMString? {
        
        if index < length {
    
            return mediaList[index]
        }
        return nil
    }
    
    /// void appendMedium(DOMString medium);
    /// see http://dev.w3.org/csswg/cssom/#dom-medialist-appendmediummedium
    func appendMedium(_ medium: DOMString) {
        mediaList.append(medium)
    }
    
    /// void deleteMedium(DOMString medium);
    /// see http://dev.w3.org/csswg/cssom/#dom-medialist-deletemediummedium
    func deleteMedium(_ medium: DOMString) {
        
        for index in 0..<mediaList.count {
            
            let media = mediaList[index]
            
            if media == medium {
                
                mediaList.remove(at: index)
                break
            }
        }
    }
    
    public func equals(_ other: MediaList) -> Bool {
        
        if self.length != other.length {
            return false
        }
        
        for index in 0..<other.length {
            
            let selfMedia = self.mediaList[index]
            let otherMedia = other.mediaList[index]
            
            if selfMedia != otherMedia {
                return false
            }
        }
        return true
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: CSSVisitable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    override func accept(_ visitor: CSSVisitor) {
        assert(false, "accept not implemented")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("accept not implemented", log: Log.Web.all, type: .error)
        #endif
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                  MARK: Equatable protocol implementation
//////////////////////////////////////////////////////////////////////////////////////////////////////////

/// Implementation of == required by Equatable
func ==(lhs: MediaList, rhs: MediaList) -> Bool {

    return lhs.equals(rhs)
}
