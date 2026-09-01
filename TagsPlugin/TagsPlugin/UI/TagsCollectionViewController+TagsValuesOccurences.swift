//
//  FileOutlineTagsViewController+TagsValuesOccurences.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import WriterCommon
import Common

extension TagsCollectionViewController {
        
    @IBAction func scrollToPreviousTag(_ sender: AnyObject?) {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        filesOutlineTagsManager.scrollToPreviousTag()
    }
    
    @IBAction func scrollToNextTag(_ sender: AnyObject?) {
        
        guard let filesOutlineTagsManager = self.filesOutlineTagsManager else {
            assertionFailure("Error: self.filesOutlineTagsManager is nil")
            return
        }
        filesOutlineTagsManager.scrollToNextTag()
    }
}
