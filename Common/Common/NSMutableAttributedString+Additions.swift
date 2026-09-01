//
//  NSMutableAttributedString+Additions.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-01-10.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation
import os

extension NSMutableAttributedString {
    
    public func update(withSourceStringChangeDescription sourceStringChangeDescription: SourceStringChangeDescription) {
        
        let stringReplacement = sourceStringChangeDescription.stringReplacement
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("stringReplacement: %@", log: Log.Common.all, type: .debug, describing: stringReplacement)
        os_log("self.string.utf16.count: %d", log: Log.Common.all, type: .debug, self.string.utf16.count)
        os_log("sourceStringChangeDescription.range.upperBound: %d", log: Log.Common.all, type: .debug, sourceStringChangeDescription.range.upperBound)
        os_log("actual string: %@", log: Log.Common.all, type: .debug, %%self.string)
        #endif
        
        assert(sourceStringChangeDescription.range.upperBound <= self.string.utf16.count)
        assert(stringReplacement != nil)
        if let stringReplacement = stringReplacement {
            
            // the range in the SourceStringChangeDescription describe a utf16 range
            self.update(range: sourceStringChangeDescription.range, withString: stringReplacement)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            
            let attributesRecorderString = self.string
            let changedString = sourceStringChangeDescription.targetString.string
            
            os_log("ChangedString: \n\"%@\"", log: Log.Common.all, type: .error, changedString)
            if attributesRecorderString != changedString {
                
                os_log("attributesRecorderString: \n\"%@\" is different from...", log: Log.Common.all, type: .error, attributesRecorderString)
                os_log("...is different from changedString: \n\"%@\"", log: Log.Common.all, type: .error, changedString)
                assert(false, "strings not in sync")
            }
            else {
                os_log("attributesRecorderString: \n\"%@\" is same as changedString: \n\"%@\"", log: Log.Common.all, type: .info, attributesRecorderString, changedString)
            }
            #endif
        }
        else {
            assert(false)
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("stringReplacement replacement was nil.", log: Log.Common.all, type: .error)
            #endif
        }
    }
    
    public func update(range: NSRange, withAttributedString string: NSAttributedString) {
        
        assert(range.upperBound <= self.string.utf16.count)
        
        // the range in the SourceStringChangeDescription describe a utf16 range
        self.replaceCharacters(in: range, with: string)
    }
    
    public func update(range: NSRange, withString string: String) {
        
        assert(range.upperBound <= self.string.utf16.count)
        
        // the range in the SourceStringChangeDescription describe a utf16 range
        self.replaceCharacters(in: range, with: string)
    }
    
    /// This method iterates through an array of tuples 
    /// of type ([String: AnyObject], NSRange) all containing 
    /// the range to which apply the attributes. 
    public func apply(attributesRanges differentAttributesRanges: [([NSAttributedString.Key: Any], NSRange)]) {
        
        beginEditing()
        
        for (attributes, range) in differentAttributesRanges {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("attribute: %@ , range: %@", log: Log.Common.all, type: .info, %%attributes, %%range)
            #endif
            setAttributes(attributes, range: range)
        }
        
        endEditing()
    }
    
    fileprivate func printDebugInfo(_ textAttributes: [NSAttributedString.Key : Any]?, range: NSRange) {
        
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Painting range: %@", log: Log.Common.all, type: .info, NSStringFromRange(range))
        #endif
        if let textAttributes = textAttributes {
            
            for (name, value) in textAttributes {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Applying attribute: %@ with value: %@", log: Log.Common.all, type: .info, %%name, %%value)
                #endif
            }
        }
    }
    
}
