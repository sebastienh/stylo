//
//  NSView+AmbiguousLayout.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-14.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

extension NSView {
    
    var selfIncludingAncestorsIdentifiers: String {
        var identifier: String = self.identifier!.rawValue
        var superview = self.superview
        while let _superview = superview {
            identifier = _superview.identifier!.rawValue + identifier
            superview = _superview.superview
        }
        return identifier
    }
    
    var selfIncludingSubtreeHasAmbiguousLayout: Bool {
        guard !self.hasAmbiguousLayout else {
            return true
        }
        for subview in self.subviews {
            if subview.selfIncludingSubtreeHasAmbiguousLayout {
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("ambiguous layout for view with selfIncludingAncestorsIdentifiers: %@", log: Log.StyloCore.all, type: .error, %%self.selfIncludingAncestorsIdentifiers)
                #endif
                return true
            }
        }
        return false
    }
    
    
}
