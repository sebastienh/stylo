////
////  StaticHtmlPreviewTabViewController.swift
////  Stylo Writer
////
////  Created by Sébastien Hamel on 2018-05-01.
////  Copyright © 2018 Textually Inc. All rights reserved.
////
//
//import Foundation
//import Cocoa
//import Common
//import WriterCommon
//
//class StaticHtmlPreviewTabViewController: NSTabViewController {
//
//    enum Tab: Int {
//
//        case text = 0
//        case preview = 1
//    }
//
//    var staticHtmlPreviewViewController: StaticHtmlPreviewViewController? {
//
//        return self.tabViewItems.last?.viewController as? StaticHtmlPreviewViewController
//    }
//
//    var textFactoryViewController: TextFactoryViewController? {
//
//        return self.tabViewItems.first?.viewController as? TextFactoryViewController
//    }
//
//    var selectedTab: Tab? {
//
//        let selectedTabViewItem = tabView.selectedTabViewItem
//
//        assert(selectedTabViewItem != nil)
//        if let selectedTabViewItem = selectedTabViewItem {
//
//            let selectedTabViewItemIndex = tabView.indexOfTabViewItem(selectedTabViewItem)
//            let selectedTab = Tab(rawValue: selectedTabViewItemIndex)
//
//            assert(selectedTab != nil)
//            return selectedTab
//        }
//        return nil
//    }
//
//    override func awakeFromNib() {
//
//        super.awakeFromNib()
//
//        #if ALPHA_COLOR_ENABLED
//        self.tabView.drawsBackground = false
//        #else
//        self.tabView.drawsBackground = true
//        #endif
//    }
//
//    func selectTextTab(_ sender: Any? = nil, transitionsAnimation: Bool = true) {
//
//        if transitionsAnimation {
//            self.tabView.selectTabViewItem(at: §Tab.text)
//        }
//        else {
//            let backup = self.transitionOptions
//            self.transitionOptions = TransitionOptions.allowUserInteraction
//            self.tabView.selectTabViewItem(at: §Tab.text)
//            self.transitionOptions = backup
//        }
//    }
//
//    func selectStaticHtmlPreviewTab(_ sender: Any? = nil, transitionsAnimation: Bool = true) {
//
//        if transitionsAnimation {
//            self.tabView.selectTabViewItem(at: §Tab.preview)
//        }
//        else {
//            let backup = self.transitionOptions
//            self.transitionOptions = TransitionOptions.allowUserInteraction
//            self.tabView.selectTabViewItem(at: §Tab.preview)
//            self.transitionOptions = backup
//        }
//    }
//
//}
//
