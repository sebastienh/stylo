//
//  HTMLHeadingElement+TagSegments.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-07-11.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Web
import Common

extension HTMLHeadingElement {
    
    public var beforeTagSegment: SourceStringSegment? {
        
        guard let sourceStringFragment = self.sourceStringFragment as? SourceStringRegion else {
            return nil
        }
        
        assert(tagRegionFragment != nil)
        if let tagRegionFragment = tagRegionFragment {
        
            for tagSourceStringSegment in tagRegionFragment.sourceStringSegments {
            
                if tagSourceStringSegment.startIndex == sourceStringFragment.startIndex {
                    return tagSourceStringSegment
                }
            }
        }
        return nil
    }
    
    private var tagRegionFragment: SourceStringRegion? {
        
        let tagFragment = pseudoElementSourceStringFragment(with: §MarkdownSourceFragmentType.Tag)
        return tagFragment as? SourceStringRegion
    }
    
    
}
