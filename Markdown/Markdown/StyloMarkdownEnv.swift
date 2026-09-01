//
//  StyloMarkdownEnv.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-12-01.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common
import os

public final class StyloMarkdownEnv: Env {
    
    public var isEmpty: Bool {
        
        return references.isEmpty
    }
    
    public var referencingTokens: Set<Token>
    
    public private(set) var references: [String: [ReferenceEntry]]
    
    public var referencesSignature: String {
        
        let sortedReferences = references.sorted { (first, second) -> Bool in
            return first.key < second.key
        }
        
        var desc = ""
        for (_, references) in sortedReferences {

            for (index, referenceEntry) in references.enumerated() {
            
                if !desc.isEmpty {
                    desc += ";"
                }
                
                desc += "index:\(index)," + referenceEntry.signature
            }
        }
        return desc
    }
    
    public init() {
        
        self.references = [String: [ReferenceEntry]]()
        self.referencingTokens = Set<Token>()
    }
    
    public func updateReferenceEntryAttributes(with label: String, attrs: [AttributesBloc], in range: Range<Int>) {
        
        let index = referenceIndex(for: label, in: range)
        
        assert(index != nil)
        if let index = index {
        
            self.references[label]?[index].attrsBlocs = attrs
        }
    }
    
    public func clean() {
        
        cleanReferences()
        cleanReferencingTokens()
    }
    
    public func cleanReferencingTokens() {
        
        self.referencingTokens.removeAll(keepingCapacity: true)
    }
    
    /// Remove all the references.
    public func cleanReferences() {
        
        self.references.removeAll(keepingCapacity: true)
    }
    
    public func reference(for key: String) -> ReferenceEntry? {
        
        return references[key]?.first
    }
    
    
    ///
    /// @param reference: The reference to add.
    /// @param: globalOffset: The offset from the global start of the string
    ///         since partial compilation starts on some token that is itself
    ///         offset from the start.
    public func addReference(_ reference: inout ReferenceEntry) {
        
        // we erase only if there is no other (do not share the same range)
        // already existing (with the same label) reference later (which location is after)
        // in the envionment.
        let key = reference.label
        
        // get all the references using the label
        if let existingReferences = references[key] {
            
            // if there is already existing references
            if !existingReferences.isEmpty {
                
                var inserted = false
                
                // we should iterate over the existing references
                // and as soon as we find one that is after we insert it
                // before.
                for i in 0..<existingReferences.count {
                    
                    let existingReference = existingReferences[i]
                    let existingReferenceRange = existingReference.utf16Range
                    let newReferenceRange = reference.utf16Range
                    
                    assert(existingReferenceRange != nil)
                    assert(newReferenceRange != nil)
                    if let existingReferenceRange = existingReferenceRange, let newReferenceRange = newReferenceRange {
                        
                        #if DEBUG
                        // since we clean the environment, we should not have
                        // any existing reference sharing the same range...
                        assert(NSIntersectionRange(newReferenceRange, existingReferenceRange).isEmpty)
                        #endif
                        
                        // we place the new reference before and existing one...
                        if newReferenceRange.upperBound < existingReferenceRange.lowerBound {
                            
                            // if it is the first one is becomes active
                            if i == 0 {
                            
                                // the old one become inactive
                                self.references[key]![0].active = false
                                reference.active = true
                                self.references[key]!.insert(reference, at: i)
                            }
                            else {
                                self.references[key]!.insert(reference, at: i)
                            }
                            inserted = true
                        }
                    }
                    else {
                        
                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                        os_log("newReferenceRange, or existingReferenceRange is nil.", log: Log.Markdown.all, type: .error)
                        #endif
                    }
                }
                
                if !inserted {
                    reference.active = false
                    references[key]!.append(reference)
                }
            }
            else {
                reference.active = true
                references[key]!.append(reference)
            }
        }
        else {
            
            // if there is no existing reference we simply put the
            // new reference in the environment
            reference.active = true
            references[key] = [reference]
        }
    }
    
    public func cleanInformationRelated<T: Collection>(to tokens: T) where T.Iterator.Element == Token {
        
        for token in tokens {
            
            token.execute({ (token: Token) in
        
                if let referenceLabel = token.referenceLabel {
                    
                    self.references.removeValue(forKey: referenceLabel)
                }
                
                referencingTokens.remove(token)
            })
        }
    }
    
    public func clean(in range: NSRange) -> Set<String> {
        
        deleteReferencingTokens(in: range)
        return deleteReferences(in: range)
    }
    
    public func cleanReferences(range: NSRange, keys impactedReferencesKeys: [String]) {
        
        for keyToDelete in impactedReferencesKeys {
            
            let references = self.references[keyToDelete]
            
            if let references = references {
            
                var collectedIndexes = [Int]()
                
                for i in 0..<references.count {
                
                    let reference = references[i]
                    let referenceRange = reference.utf16Range
                    
                    assert(referenceRange != nil)
                    if let referenceRange = referenceRange, !NSIntersectionRange(range, referenceRange).isEmpty {
                        
                        collectedIndexes.append(i)
                    }
                }
                
                for i in collectedIndexes.reversed() {
                    
                    self.references[keyToDelete]!.remove(at: i)
                }
                
                if !self.references[keyToDelete]!.isEmpty {
                
                    self.references[keyToDelete]![0].active = true
                }
            }
        }
    }
    
    public func cleanReferencingTokens(_ tokens: [Token]) {
        
        for tokenToDelete in tokens {
            
            referencingTokens.remove(tokenToDelete)
        }
    }
    
    public func moveReferences(after index: Int, by count: Int) {
        
        if count != 0 {
            
            for key in self.references.keys {
            
                for i in 0..<self.references[key]!.count {
                
                    let reference = self.references[key]![i]
                    let referenceRange = reference.utf16Range
                    
                    assert(referenceRange != nil)
                    if let referenceRange = referenceRange, index <= referenceRange.lowerBound  {
                        
                        self.references[key]![i].move(count)
                    }
                }
            }
        }
    }
    
    public func deleteReferencingTokens(in range: NSRange) {
        
        var tokensToDelete = [Token]()
        
        for referencingToken in referencingTokens {
            
            let tokenRange = referencingToken.sourceStringFragment?.range
            
            assert(tokenRange != nil)
            if let tokenRange = tokenRange, !NSIntersectionRange(range, tokenRange).isEmpty  {
            
                tokensToDelete.append(referencingToken)
            }
        }
        
        for tokenToDelete in tokensToDelete {
            
            referencingTokens.remove(tokenToDelete)
        }
        
    }
    
    public func deleteReferences(in range: NSRange) -> Set<String> {
        
        var deletedReferencesLabel = Set<String>()
        
        if !self.references.isEmpty {
        
            for keyToDelete in self.references.keys {
                
                let references = self.references[keyToDelete]
                
                if let references = references {
                    
                    var collectedIndexes = [Int]()
                    
                    for i in 0..<references.count {
                        
                        let reference = references[i]
                        let referenceRange = reference.utf16Range
                        
                        assert(referenceRange != nil)
                        if let referenceRange = referenceRange, !NSIntersectionRange(range, referenceRange).isEmpty {
                            
                            collectedIndexes.append(i)
                            
                            if i == 0 {
                                deletedReferencesLabel.insert(keyToDelete)
                            }
                        }
                    }
                    
                    for i in collectedIndexes.reversed() {
                        
                        self.references[keyToDelete]!.remove(at: i)
                    }
                    
                    if !self.references[keyToDelete]!.isEmpty {
                        
                        self.references[keyToDelete]![0].active = true
                    }
                }
            }
        }
        return deletedReferencesLabel
    }
    
    private func referenceIndex(for key: String, in range: Range<Int>) -> Int? {
    
        let references = self.references[key]
        let range = NSMakeRange(range.lowerBound, range.count)
        
        assert(references != nil)
        if let references = references {
            for i in 0..<references.count {
             
                let reference = references[i]
                let referenceRange = reference.utf16Range
                
                assert(referenceRange != nil)
                if let referenceRange = referenceRange, !NSIntersectionRange(range, referenceRange).isEmpty {
                    return i
                }
            }
        }
        return nil
    }
    
    
}
