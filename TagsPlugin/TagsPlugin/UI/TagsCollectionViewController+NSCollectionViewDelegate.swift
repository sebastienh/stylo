//
//  FileOutlineTagsViewController+NSCollectionViewDelegate.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-01.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension TagsCollectionViewController: NSCollectionViewDelegate {
    
    public func collectionView(_ collectionView: NSCollectionView, shouldSelectItemsAt indexPaths: Set<IndexPath>) -> Set<IndexPath> {
        
        if allowsChangingSelection {
            
            self.selecting = true
            return indexPaths
        }
        else {
            // keep the current selection
            return self.tagsCollectionView.selectionIndexPaths
        }
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
    
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        
        filesOutlineTagsManager.updateSelectionIndexPaths(collectionView.selectionIndexPaths)
        self.tagsCollectionView.resetFlashedItems()
        self.selecting = false
    }
    
    public func collectionView(_ collectionView: NSCollectionView, didDeselectItemsAt indexPaths: Set<IndexPath>) {
        
        if !self.selecting {
            
            guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
                assertionFailure("Error: self.filesOutlineTagsManager is nil")
                return
            }
            
            filesOutlineTagsManager.updateSelectionIndexPaths(collectionView.selectionIndexPaths)
            self.tagsCollectionView.resetFlashedItems()
        }
    }
}
