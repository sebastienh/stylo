//
//  LeftAlignedFlowLayout.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-05.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa


class LeftAlignedFlowLayout: NSCollectionViewFlowLayout {
    
    override var sectionHeadersPinToVisibleBounds: Bool {
        get {return true}
        set {}
    }
    
    override var sectionInset: NSEdgeInsets {
        get {
            return NSEdgeInsets(top: InterfaceConstants.TagsView.topContentInset, left: InterfaceConstants.TagsView.leftContentInset, bottom: InterfaceConstants.TagsView.bottomContentInset, right: InterfaceConstants.TagsView.rightContentInset)
        }
        set {}
    }
    
    /// see (answer)[https://stackoverflow.com/questions/22539979/left-align-cells-in-uicollectionview]
    override func layoutAttributesForElements(in rect: NSRect) -> [NSCollectionViewLayoutAttributes] {
        
        let attributes = super.layoutAttributesForElements(in: rect).map {
            $0.copy() as! NSCollectionViewLayoutAttributes
        }

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes.forEach { layoutAttribute in
            
            guard layoutAttribute.representedElementCategory == .item else {
                return
            }
            
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }
        return attributes
    }
}

