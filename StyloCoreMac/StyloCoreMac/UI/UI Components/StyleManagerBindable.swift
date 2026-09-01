//
//  StyleManagerBindable.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-11-11.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Cocoa
import QuartzCore
import Common

extension CALayer {
    
    func animate(color: CGColor, keyPath: String, duration: Double) {
        
        if value(forKey: keyPath) as! CGColor? != color {
            
            let animation = CABasicAnimation(keyPath: keyPath)
            animation.toValue = color
            animation.fromValue = value(forKey: keyPath)
            animation.duration = duration
            animation.isRemovedOnCompletion = false
            animation.fillMode = CAMediaTimingFillMode.forwards
            add(animation, forKey: keyPath)
            setValue(color, forKey: keyPath)
        }
    }
}

public protocol StyleManagerBindable: class {
    
    var colors: [NSColor] { get set }
    
    var styleManager: StyleManager! { get set }
    
    var textStylePreview: TextStylePreview? { get set }
    
    func subscribe(to styleManager: StyleManager)
    
    func unsubscribe(to styleManager: StyleManager)
    
    func apply(textStylePreview: TextStylePreview)
    
    func updateAppearance()
}

extension StyleManagerBindable where Self: NSButton {
    
    public func subscribeToAppearanceChange() {
        
        if let computedAppearance = StyloApplication.shared.computedAppearance.value {
            self.update(forAppearance: computedAppearance)
        }
        StyloApplication.shared.computedAppearance.subscribe({ [weak self](appearance) in
            self?.update(forAppearance: appearance)
        }, observer: self)
    }
    
    private func update(forAppearance appearance: AppearanceMode?) {
     
        guard let appearance = appearance else {
            assertionFailure("Error: appearance is nil")
            return
        }
        
        assert(styleManager.currentAppearanceSourceDescriptor.appearance == appearance)
        guard let textStylePreview = styleManager.stylePreviews.values[styleManager.currentAppearanceSourceDescriptor] as? TextStylePreview else {
//            assertionFailure("Error: textStylePreview is nil")
            return
        }
            
        self.apply(textStylePreview: textStylePreview)
    }
    
    public func subscribe(to styleManager: StyleManager) {

        guard let textStylePreview = styleManager.stylePreviews.values[styleManager.currentAppearanceSourceDescriptor] as? TextStylePreview else {
//            assertionFailure("Error: textStylePreview is nil")
            return
        }

        self.apply(textStylePreview: textStylePreview)
        changeSelectedState(selected: styleManager.selectedStyle.value)
        updateAppearance()

        styleManager.stylePreviews.subscribe({ [weak self](change) in
            self?.handleStylePreviewsDictionaryChange(change)
        }, observer: self)

        styleManager.selectedStyle.subscribe({ [weak self] (selected: Bool) in

            self?.changeSelectedState(selected: selected)
            self?.updateAppearance()
        }, observer: self)
    }
    
    public func unsubscribe(to styleManager: StyleManager) {
        
        styleManager.stylePreviews.unsubscribe(observer: self)
        styleManager.selectedStyle.unsubscribe(observer: self)
    }
    
    public func changeSelectedState(selected: Bool) {
        
        if selected {
            self.state = NSControl.StateValue.on
        }
        else {
            self.state = NSControl.StateValue.off
        }
    }
    
    private func handleStylePreviewsDictionaryChange(_ change: DynamicDictionary<StyleAssemblyDescriptor, StylePreview>.DictionaryChange) {
        
        guard let stylePreview = change.udpatedValues[self.styleManager.currentAppearanceSourceDescriptor] else {
            assertionFailure("Error: stylePreview is nil")
            return
        }
    
        guard let textStylePreview = stylePreview as? TextStylePreview else {
            assertionFailure("Error: textStylePreview is nil")
            return
        }
        
        self.apply(textStylePreview: textStylePreview)
        self.changeSelectedState(selected: styleManager.selectedStyle.value)
        self.updateAppearance()
    }
    
}
