//
//  DeterminateAnimation.swift
//  ProgressKit
//
//  Created by Kauntey Suryawanshi on 09/07/15.
//  Copyright (c) 2015 Kauntey Suryawanshi. All rights reserved.
//
import Foundation
import Cocoa
import os

protocol DeterminableAnimation {
    func updateProgress()
}

@IBDesignable
open class DeterminateAnimation: BaseView, DeterminableAnimation {
    
    @IBInspectable open var animated: Bool = true
    
    /// Value of progress now. Range 0..1
    @IBInspectable open var progress: CGFloat = 0 {
        didSet {
            updateProgress()
        }
    }
    
    /// This function will only be called by didSet of progress. Every subclass will have its own implementation
    func updateProgress() {
        assert(false, "Must be overriden in subclass")
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
        os_log("Must be overriden in subclass", log: Log.StyloCore.all, type: .error)
        #endif
    }
}
