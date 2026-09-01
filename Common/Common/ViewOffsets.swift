//
//  ViewOffsets.swift
//  Common
//
//  Created by Sébastien Hamel on 2017-12-17.
//  Copyright © 2017 NM. All rights reserved.
//

import Foundation

public class ViewOffsets {
    
    /// Base offsets are the indexes calculated for height/srollingGranularity
    /// coming from the original (origins) view to the target views (offset)
    var baseOffsets: [CGFloat]
    
    let scrollingGranularity: Int
    
    let sectionLength: Int
    
    var offsetsSections: [Int: OffsetsSection]
    
    public let viewHeight: CGFloat
    
    public init(viewHeight: CGFloat, scrollingGranularity: Int, sectionLength: Int, endOffset: CGFloat) {
        
        assert(viewHeight != 0)
        
        self.viewHeight = viewHeight
        self.sectionLength = sectionLength
        self.scrollingGranularity = scrollingGranularity
        
        // we add one more element to contain the end value
        let count = Int(viewHeight)/scrollingGranularity + 1
        self.baseOffsets = [CGFloat](repeating: CGFloat.nan, count: count)
        self.offsetsSections = [Int: OffsetsSection]()
        self.baseOffsets[self.baseOffsets.count - 1] = endOffset
    }
    
    
    ///
    /// The last value contains both viewHeight in order
    /// to scroll completely over them.
    ///
    public func setEndOffset(_ offset: CGFloat) {
        
        self.baseOffsets[self.baseOffsets.count - 1] = offset
    }
    
    public func updateBaseOffset(offset value: CGFloat, at index: Int) {
        
        baseOffsets[index] = value
    }
    
    ///
    ///
    public func offset(at origin: CGFloat) -> (CGFloat?, [Int]?) {
        
        let _offsetIndex = offsetIndex(from: origin)
        
        if let _queryIndex = queryIndex(for: _offsetIndex) {
            
            if offsetsSections.index(forKey: _queryIndex) != nil {
                
                let offset = offsetsSections[_queryIndex]!.offset(at: origin)
                return (offset, nil)
            }
            else {
                
                let _baseOffsetsIndexes = baseOffsetsIndexes(for: _queryIndex)
                let neededIndexes = neededBaseOffsetsIndexes(from: _baseOffsetsIndexes)
                
                if neededIndexes.isEmpty {
                    
                    let (origins, offsets) = constructOriginsAndOffsets(from: _baseOffsetsIndexes)
                    let offsetSection = OffsetsSection(origins: origins, offsets: offsets)
                    insertOffsetsSection(value: offsetSection, at: _queryIndex)
                    let computedOffset = offsetSection.offset(at: origin)
                    return (computedOffset, nil)
                }
                else {
                    
                    /// ask to compute the needed baseOffset indexes
                    return (nil, neededIndexes)
                }
            }
        }
//        debugPrint("queryIndex returned is nil")
        return (nil, nil)
    }
    
    private func neededBaseOffsetsIndexes(from baseOffsetsIndexes: [Int]) -> [Int] {
        
        var neededIndexes = [Int]()
        for index in baseOffsetsIndexes {
            if !baseOffsetDefined(at: index) {
                neededIndexes.append(index)
            }
        }
        return neededIndexes
    }
    
    ///
    /// Method that construct an the origins and offsets used in the
    /// SplineInterpolator.
    ///
    private func constructOriginsAndOffsets(from baseOffsetsIndexes: [Int]) -> ([CGFloat], [CGFloat]) {
        
        var origins = [CGFloat]()
        var offsets = [CGFloat]()
        
        for baseOffsetsIndex in baseOffsetsIndexes {
            origins.append(CGFloat(baseOffsetsIndex*scrollingGranularity))
            offsets.append(baseOffsets[baseOffsetsIndex])
        }
        
        // if it is the last we replace the
        if baseOffsetsIndexes.last! == (baseOffsets.count - 1) {
            
            // the last element is the viewHeight
            origins[origins.count - 1] = self.viewHeight
        }
        
        return (origins, offsets)
    }
    
    ///
    /// Method that computes all base offsets indexes necessary
    /// to create an OffsetsSection.
    ///
    private func baseOffsetsIndexes(for offsetsSectionIndex: Int) -> [Int] {
        
        let halfSectionLength = sectionLength/2
        let startIndex = offsetsSectionIndex - halfSectionLength
        let endIndex = offsetsSectionIndex + halfSectionLength
        return Array(startIndex...endIndex)
    }
    
    ///
    /// Method that return the OffsetsSection index responsible
    /// for computing the offsets for a certain index in the
    /// base offsets array.
    ///
    private func queryIndex(for index: Int) -> Int? {
        
        let halfSectionLength = sectionLength/2
        assert(sectionLength%2 == 1)
        
        // we use webViewOffsets!.count but we could use also textViewOffsets!.count
        // that's what we make sure in the assertion after...
        let sectionsCount = baseOffsets.count
        
        if sectionsCount < index {
            return nil
        }
        
        let firstInterpolationSectionIndex = halfSectionLength
        let lastInterpolationSectionIndex = sectionsCount - sectionLength + halfSectionLength
        
        if index <= firstInterpolationSectionIndex {
            return firstInterpolationSectionIndex
        }
        else if index >= lastInterpolationSectionIndex {
            return lastInterpolationSectionIndex
        }
        else {
            return index
        }
    }
    
    private func offsetIndex(from offset: CGFloat) -> Int {
        
        return Int(offset)/scrollingGranularity
    }
    
    private func insertOffsetsSection(value: OffsetsSection, at index: Int) {
        
        offsetsSections[index] = value
    }
    
    private func offsetSectionDefined(at index: Int) -> Bool {
        
        if offsetsSections.index(forKey: index) != nil {
            return true
        }
        return false
    }
    
    private func baseOffsetDefined(at index: Int) -> Bool {
        
        if !baseOffsets[index].isNaN {
            return true
        }
        return false
    }
}

