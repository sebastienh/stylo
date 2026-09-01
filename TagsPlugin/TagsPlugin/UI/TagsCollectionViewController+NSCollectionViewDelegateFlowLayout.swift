//
//  FileOtulineTagsViewController+NSCollectionViewDelegateFlowLayout.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

extension TagsCollectionViewController: NSCollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, insetForSectionAt section: Int) -> NSEdgeInsets {
        return NSEdgeInsets(top: InterfaceConstants.TagsView.topContentInset, left: InterfaceConstants.TagsView.leftContentInset, bottom: InterfaceConstants.TagsView.bottomContentInset, right: InterfaceConstants.TagsView.rightContentInset)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
      return NSSize(width: 1000, height: InterfaceConstants.TagsView.sectionHeight)
    }
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        let errorSize = NSMakeSize(100.0, InterfaceConstants.TagsView.cellHeight)
        
        guard let flowLayout = collectionViewLayout as? LeftAlignedFlowLayout else {
            assertionFailure("Error: collectionViewLayout is no LeftAlignedFlowLayout")
            return errorSize
        }
        
        guard let attributeTagOutputItem = self.dataSource?.itemIdentifier(for: indexPath) else {
            assertionFailure("Error: attributeTagOutputItem is nil")
            return errorSize
        }
        
        let attributedString = NSAttributedString(string: attributeTagOutputItem.stringValue, attributes: [
            NSAttributedString.Key.font: TagItem.font
        ])
        
        let bounds = attributedString.boundingRect(with: NSMakeSize(CGFloat.greatestFiniteMagnitude, InterfaceConstants.TagsView.cellHeight), options: .usesFontLeading)
        
        let contentAvailableWidth = collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right)
        
        // padding must be 5.0
        let itemDesiredWidth = bounds.size.width + 5.0 + InterfaceConstants.TagsView.textFieldLeading + InterfaceConstants.TagsView.textFieldTrailing
        
        let width: CGFloat = {
            if contentAvailableWidth < itemDesiredWidth {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("contentAvailableWidth < itemDesiredWidth (%@ < %@) for item: %@", log: Log.Tags.all, type: .info, %%contentAvailableWidth, %%itemDesiredWidth, %%attributeTagOutputItem.stringValue)
                os_log("NSCollectionViewDelegateFlowLayout.reloadItems at indexPath: %@", log: Log.Tags.all, type: .info, %%indexPath)
                os_log("NSCollectionViewDelegateFlowLayout.numberOfItems inSection %@: %@", log: Log.Tags.all, type: .info, %%indexPath.section, %%collectionView.numberOfItems(inSection: indexPath.section))
                os_log("NSCollectionViewDelegateFlowLayout.item at %@: %@", log: Log.Tags.all, type: .info, %%indexPath, %%collectionView.item(at: indexPath))
                #endif
                
                // stylo #684: crash when  reloading in .attributes mode, so we only do it
                // in .values mode. In section mode, the display of the ellipsis
                // is working without it anyway
                if self.attributesMode == .values && !collectionView.inLiveResize {
                    if collectionView.item(at: indexPath) != nil {
                        collectionView.reloadItems(at: Set<IndexPath>(arrayLiteral: indexPath))
                    }
                }
                return contentAvailableWidth
            }
            else {
                
                #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
                os_log("contentAvailableWidth >= itemDesiredWidth (%@ >= %@) for item: %@", log: Log.Tags.all, type: .info, %%contentAvailableWidth, %%itemDesiredWidth, %%attributeTagOutputItem.stringValue)
                #endif
                
                return itemDesiredWidth
            }
        }()
        
        let size = NSMakeSize(width, InterfaceConstants.TagsView.cellHeight)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("returning item size %@ for item: %@ at index path: %@", log: Log.Tags.all, type: .info, %%size, %%attributeTagOutputItem.stringValue, %%indexPath)
        #endif
        
        return size
    }
}


