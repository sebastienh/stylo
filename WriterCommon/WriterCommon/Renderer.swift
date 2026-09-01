//
//  Renderer.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-06-22.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

protocol Renderer: class {
    
    var contentString: StylableString { get }
    
    func process(elements: ContiguousArray<Element>, deletedNodes: ContiguousArray<Node>?) -> RenderingProcessingResult
    
    func totalRange(fromElement element: Element, range: NSRange, extendSpacesBefore: Bool, extendSpacesAfter: Bool, spacesCountAfter: Int?) -> NSRange
}

extension Renderer {
    
    
    func totalRange(fromElement element: Element, range: NSRange, extendSpacesBefore: Bool = true, extendSpacesAfter: Bool = true, spacesCountAfter: Int? = nil) -> NSRange {
            
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("totalRange(fromElement: %@, range: %@, extendSpacesBefore: %@, extendSpacesAfter: %@, spacesCountAfter: %@)", log: Log.WriterCommon.all, type: .info, %%element.localName, %%range, %%extendSpacesBefore, %%extendSpacesAfter, %%spacesCountAfter)
        #endif
        
        guard !(element is HTMLBodyElement) else {
            return range
        }
        
        var totalRange = range
        
        // avoiding to continue spaces
        if element.localName != "code" && element.localName != "em" && element.localName != "strong" && extendSpacesAfter {
            
            if let spacesCountAfter = spacesCountAfter {
                
                if range.location + range.length + spacesCountAfter <= contentString.length {
                    totalRange = NSMakeRange(range.location, range.length + spacesCountAfter)
                }
                else {
                    let extraLength = contentString.length - range.upperBound
                    totalRange = NSMakeRange(range.location, range.length + extraLength)
                }
            }
            else if let spacesCount = contentString.spacesCount(from: range.upperBound) {
                totalRange = NSMakeRange(range.location, range.length + spacesCount)
            }
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("totalRange -> computed totalRange value: %@)", log: Log.WriterCommon.all, type: .info, %%totalRange)
        #endif
        
        return totalRange
    }
    
}


