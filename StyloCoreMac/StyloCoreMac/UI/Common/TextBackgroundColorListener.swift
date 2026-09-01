//
//  TextBackgroundColorListener.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2018-01-31.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import Common

public protocol TextBackgroundColorListener {
    
    var editorId: EditorId? { get }
    
    func startListening(to editable: AnyEditable)
    
    func stopListening(to editable: AnyEditable)
    
    func updateBackgroundColor(with color: NSColor)
}

extension TextBackgroundColorListener where Self: NSObject & Observer {
    
    public func startListening(to editable: AnyEditable) {
        
        guard let editorId = self.editorId else {
            assertionFailure("Error: editorId is nil")
            return
        }
        
        guard let editor = editable.editor(for: editorId) else {
            assertionFailure("Error: editor is nil")
            return
        }
        
        if !editor.globalAttributes.subscribed(observer: self) {
            
            guard let editorId = self.editorId else {
                assertionFailure("Error: self.editorId is nil")
                return
            }
            
            guard let editorManager = editable.editor(for: editorId) else {
                assertionFailure("Error: editorManager is nil")
                return
            }
            
            guard let globalAttributes = editorManager.globalAttributes.value else {
                assertionFailure("Error: globalAttributes is nil")
                return
            }
            
            handleColorChange(color: globalAttributes.backgroundColor)
            
            editorManager.globalAttributes.subscribe({ [weak self](change) in
                self?.handleColorChange(color: change?.backgroundColor)
            }, observer: self)
        }
    }
    
    public func stopListening(to editable: AnyEditable) {
        
        #if ALPHA_COLOR_ENABLED
        editable.backgroundColor.unsubscribe(observer: self)
        #endif
    }

    private func handleColorChange(color: NSColor?) {
        
        if let color = color {
            let acceptableColor = computeAcceptableColor(from: color)
            updateBackgroundColor(with: acceptableColor)
        }
    }
    
    private func computeAcceptableColor(from color: NSColor) -> NSColor {
        
        #if ALPHA_COLOR_ENABLED
        return color
        #else
        return NSColor(deviceRed: color.redComponent,
                   green: color.greenComponent,
                   blue: color.blueComponent,
                   alpha: 1)
        #endif
    }

    
}
