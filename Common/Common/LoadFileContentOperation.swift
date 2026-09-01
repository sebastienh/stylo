//
//  LoadStringOperation.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-08-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public final class LoadFileContentOperation: Operation, StringContainer {
    
    /// Output NSString property
    public var loadedContent: NSString?
    
    /// href: URL to get the content from
    let href: URL
    
    /// Specified encoding
    var encoding: Encoding?
    
    /// Initialiser
    public init(href: URL, encoding: Encoding? = nil) {
        
        self.encoding = encoding
        self.href = href
    }
    
    override public func main() {
        
        let errorPointer: NSErrorPointer? = nil
        
        if let encoding = encoding {
            
            do {
                self.loadedContent = try NSString(contentsOf:href, encoding:encoding)
            } catch let error as NSError {
                errorPointer??.pointee = error
                self.loadedContent = nil
            }
        }
        else {
            
            let encodingPointer: UnsafeMutablePointer<UInt>? = nil
            
            do {
                self.loadedContent = try NSString(contentsOf:href, usedEncoding:encodingPointer)
            }
            catch let error as NSError {
                debugPrint("Error occured while loading content of url: \(href)")
                errorPointer??.pointee = error
                self.loadedContent = nil
            }
            
            // get the memory content of the pointer
//            self.encoding = encodingPointer.memory
        }
        #if DEBUG
        assert(errorPointer == nil, "Error while loading content at url: \(href)")
        #endif 
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: StringContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public var resultString: NSString {
        
        return loadedContent!
    }
}
