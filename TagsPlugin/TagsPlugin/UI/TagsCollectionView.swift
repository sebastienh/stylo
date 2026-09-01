//
//  TagsCollectionView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-06.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon

class TagsCollectionView: NSCollectionView {
    
    private var previousFlashedTags: Set<Tag>?
    
    var allowUserInteractions: Bool = true
    
    override func viewDidEndLiveResize() {
        super.viewDidEndLiveResize()
        self.reloadData()
        self.needsDisplay = true
    }
    
    override func selectAll(_ sender: Any?) {
        if allowUserInteractions {
            super.selectAll(sender)
        }
    }
    
    override func deselectAll(_ sender: Any?) {
        if allowUserInteractions {
            super.deselectAll(sender)
        }
    }
    
    override func selectItems(at indexPaths: Set<IndexPath>, scrollPosition: NSCollectionView.ScrollPosition) {
        if allowUserInteractions {
            super.selectItems(at: indexPaths, scrollPosition: scrollPosition)
        }
    }
    
    override func deselectItems(at indexPaths: Set<IndexPath>) {
        if allowUserInteractions {
            super.deselectItems(at: indexPaths)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if allowUserInteractions {
            super.mouseDown(with: event)
        }
    }
    
    override func mouseMoved(with event: NSEvent) {
        if allowUserInteractions {
            super.mouseMoved(with: event)
        }
    }
    
    func resetFlashedItems() {
        
        guard let previousFlashedTags = self.previousFlashedTags else {
            return
        }
        
        for previousFlashedTag in previousFlashedTags {
            previousFlashedTag.removeFlash()
        }
        
        self.previousFlashedTags = nil
    }
    
    func flashOutputItems(_ outputItems: [AttributeTagOutputItemValue], inCollectionSorting collectionSorting: FilesOutlineTagsManager<TagsCollectionViewController.CollectionViewDiffableDataSourceType>.AttributesCollectionSorting) {
        
        if let previousFlashedTags = self.previousFlashedTags {
            for item in previousFlashedTags {
                item.removeFlash()
            }
            self.previousFlashedTags = nil
        }
        
        let outputItemsSet = Set<AttributeTagOutputItemValue>(outputItems)
        
        let indexPaths = collectionSorting.indexPaths(fromSelectedValues: outputItemsSet, originAttributesMode: collectionSorting.attributesSortingMode)
        
        var previousFlashedTags = Set<Tag>()
        
        for indexPath in indexPaths {
        
            guard let item = self.item(at: indexPath) as? Tag else {
                assertionFailure("Error: item is nil")
                continue
            }
            
            item.flash()
            previousFlashedTags.insert(item)
        }
        
        self.previousFlashedTags = previousFlashedTags
    }
    
}
