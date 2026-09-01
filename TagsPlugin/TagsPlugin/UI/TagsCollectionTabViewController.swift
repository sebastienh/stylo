//
//  TagsCollectionTabViewController.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-27.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common

class TagsCollectionTabViewController: NSTabViewController {
    
    enum Tab: Int {
        case tags
        case empty
    }
    
    private var initiated: Bool = false
    
    var tagsCollectionViewController: TagsCollectionViewController? {
        
        let tabViewItem = self.tabViewItems[§Tab.tags]
        return tabViewItem.viewController as? TagsCollectionViewController
    }
    
    var emptyTagsViewController: NSViewController? {
        
        let tabViewItem = self.tabViewItems[§Tab.empty]
        return tabViewItem.viewController
    }
    
    override func viewWillAppear() {
        if !self.initiated {
            initChildControllers()
        }
        super.viewWillAppear()
    }

    private func initChildControllers() {
        
        assert(self.representedObject != nil)
        
        assert(self.tagsCollectionViewController != nil)
        self.tagsCollectionViewController?.representedObject = self.representedObject
        self.initiated = true
    }
}
