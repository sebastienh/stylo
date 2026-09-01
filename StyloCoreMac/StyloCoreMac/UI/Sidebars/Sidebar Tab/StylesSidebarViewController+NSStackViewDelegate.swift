//
//  StylesSidebarViewController+NSStackViewDelegate.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-19.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import AppKit
import Common
import os

extension StylesSidebarViewController: NSStackViewDelegate {
    
    func stackView(_ stackView: NSStackView, didReattach views: [NSView]) {
        
        if let styleStackView = stackView as? StylesStackView {
            
            styleStackView.didReattach(views: views)
        }
    }
    
    func stackView(_ stackView: NSStackView, willDetach views: [NSView]) {
        
        if let styleStackView = stackView as? StylesStackView {
            
            styleStackView.willDetach(views: views)
        }
    }
}

extension StylesSidebarViewController: StylesStackViewDelegate {
    
    func updatedVisibleIndexes(visibleIndexes: [Int], over count: Int) {
        
        if let firstVisibleIndex = visibleIndexes.first, let endVisibleIndex = visibleIndexes.last {
            
            let startPercent = computeStartPercent(from: firstVisibleIndex, count: count)
            let endPercent = computeEndPercent(from: endVisibleIndex, count: count)
            
            #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
            os_log("startPercent: %@", log: Log.StyloCore.all, type: .info, %%startPercent)
            os_log("endPercent: %@", log: Log.StyloCore.all, type: .info, %%endPercent)
            os_log("progressBar: %@", log: Log.StyloCore.all, type: .info, %%progressBar)
            #endif
            
            progressBar.percentRange = (lowerBound: startPercent, upperBound: endPercent)
        }
    }
    
    fileprivate func computeStartPercent(from startIndex: Int, count: Int) -> CGFloat {
        
        if startIndex == 0 {
            return 0.0
        }
        else if count != 0 && startIndex != 0 {
            
            return CGFloat(startIndex)/CGFloat(count - 1)
        }
        
        return 0.0
    }
    
    fileprivate func computeEndPercent(from endIndex: Int, count: Int) -> CGFloat {
        
        if count - 1 == endIndex {
            return 1.0
        }
        else if count > 0 && endIndex == 0 {
            
            return 0.0
        }
        else if count != 0 && endIndex != 0 {
            
            return CGFloat(endIndex)/CGFloat(count - 1)
        }
        
        return 1.0
    }
    
}
