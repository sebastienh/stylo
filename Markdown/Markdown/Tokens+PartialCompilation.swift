//
//  Tokens+PartialCompilation.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-02-20.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

extension Tokens {
    
    public func computeOptimisticStopRange(originalTokenRange: Range<Int>, description: SourceStringChangeDescription) -> NSRange? {
        
        // we get the next start token and we will try to stop when we start compiling this token.
        // as soon as we know we start compiling this start token again.
        let nextStartTokenIndex = originalTokenRange.upperBound
        let optimisticOpenToken = self[nextStartTokenIndex]
        
        if let optimisticOpenToken = optimisticOpenToken {
            
            let sourceStringFragment = optimisticOpenToken.sourceStringFragment
            
            assert(sourceStringFragment != nil)
            if var sourceStringFragment = sourceStringFragment {
                
                // the openToken range reference is in the complete string
                // we should put it in the extra reference mode if the first token is not
                // globally the first token
                if originalTokenRange.lowerBound != 0 {
                    let startBlock = self[originalTokenRange.lowerBound]!
                    sourceStringFragment.move(-startBlock.startStringIndex)
                }
                
                // apply the change in length also to the openToken which is after
                // the change in fact...
                sourceStringFragment.move(description.changeLength)
                
                // get the range from it
                // this is the range we should try to stop to
                // and will in most cases.
                return sourceStringFragment.range
            }
        }
        return nil
    }
    
    public func pessimisticStringExtract(originalTokenRange: Range<Int>, description: SourceStringChangeDescription) -> String {
        
        let stringContainer = description.targetString
        // use the blocks range to delete to get the
        // string range to parse.
        
        let stringRange = self.pessimisticStringRange(originalTokenRange: originalTokenRange, description: description)
        
        // extract the string to parse from the source string
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("stringExtractRange: %@", log: Log.Markdown.all, type: .debug, %%NSStringFromRange(stringRange))
        #endif
        
        let string = stringContainer.string as NSString
        
        if string.length <= stringRange.upperBound {
            return string.substring(with: stringRange)
        }
        return string.substring(from: stringRange.lowerBound)
    }
    
    public func optimisticStringExtract(optimisticTokenRange: Range<Int>, description: SourceStringChangeDescription) -> String? {
        
        let stringContainer = description.targetString
        // use the blocks range to delete to get the
        // string range to parse.
        
        let stringRange = self.optimisticStringRange(optimisticTokenRange: optimisticTokenRange, description: description)
        
        // extract the string to parse from the source string
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("stringExtractRange: %@", log: Log.Markdown.all, type: .debug, %%NSStringFromRange(stringRange))
        #endif
        
        let string = stringContainer.string as NSString
        if stringRange.upperBound <= string.length {
            
            return string.substring(with: stringRange)
        }
        return nil
    }
    
    public func pessimisticStringRange(originalTokenRange: Range<Int>, description: SourceStringChangeDescription) -> NSRange {
        
        if originalTokenRange.lowerBound == 0 {
            
            // return the complete string
            return NSMakeRange(0, description.targetString.length)
        }
        else {
            
            let startBlock = self[originalTokenRange.lowerBound]!
            return NSMakeRange(startBlock.startStringIndex, description.targetString.length - startBlock.startStringIndex)
        }
    }
    
    public func optimisticStringRange(optimisticTokenRange: Range<Int>, description: SourceStringChangeDescription) -> NSRange {
        
        if optimisticTokenRange.upperBound == self.length {
            
            if optimisticTokenRange.lowerBound == 0 {
                
                // return the complete string
                return NSMakeRange(0, description.targetString.string.length)
            }
            else {
                let startBlock = self[optimisticTokenRange.lowerBound]!
                return NSMakeRange(startBlock.startStringIndex, description.targetString.string.length - startBlock.startStringIndex)
            }
        }
        else {
            
            // the block after the last one
            let nextStartBlock = self[optimisticTokenRange.upperBound]!
            
            if optimisticTokenRange.lowerBound == 0 {
                
                return NSMakeRange(0, nextStartBlock.endStringIndex! + description.changeLength)
            }
            else {
                let startBlock = self[optimisticTokenRange.lowerBound]!
                return NSMakeRange(startBlock.startStringIndex, nextStartBlock.endStringIndex! + description.changeLength - startBlock.startStringIndex)
            }
        }
    }
    
}
