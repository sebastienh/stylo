//
//  FilePathControl.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-04.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa
import Common
import os

fileprivate let separatorArrowFrontPadding: CGFloat = 1.0
fileprivate let itemTruncatedWitdh: CGFloat = 10.0
fileprivate let separatorArrowWidth: CGFloat = 4.0
fileprivate let interItemSpacing: CGFloat = 4.0

fileprivate let middleItemContentCompressionResistancePriority = NSLayoutConstraint.Priority(rawValue: 1000)
fileprivate let firstItemContentCompressionResistancePriority = NSLayoutConstraint.Priority(rawValue: 248)
fileprivate let lastItemContentCompressionResistancePriority = NSLayoutConstraint.Priority(rawValue: 249)

fileprivate protocol ItemWidthConstrained {
    
    var widthConstraint: NSLayoutConstraint! { get }
}

fileprivate protocol ItemView: class {
    
    var truncated: Bool { get set }
    
    var allowExpansion: Bool { get set }
}

fileprivate extension ItemView where Self: NSTextField {
    
    var isCompressed: Bool {
        
        guard let expansionRect = self.cell?.expansionFrame(withFrame: self.frame, in: self) else {
            assertionFailure("Error: expansionRect is nil")
            return false
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("expansionRect: %@", log: Log.StyloCore.all, type: .info, %%expansionRect)
        os_log("self.intrinsicContentSize.width: %@", log: Log.StyloCore.all, type: .info, %%self.intrinsicContentSize.width)
        os_log("self.frame.width: %@", log: Log.StyloCore.all, type: .info, %%self.frame.width)
        #endif
        
        if NSEqualRects(.zero, expansionRect) {
            return false
        }
        else if NSEqualRects(.zero, self.frame) {
            return false
        }
        else if expansionRect.width == self.frame.width {
            return false
        }
        else if self.intrinsicContentSize.width == self.frame.width {
            return false
        }
        return true
    }
}


fileprivate protocol ItemSeparatorView {
    
}

class PathItemView: NSTextField, ItemView {

    var truncated: Bool = true
    
    var allowExpansion: Bool = true
}

class FirstPathItemView: NSTextField, ItemView {
    
    unowned let filePathControl: FilePathControl
    
    var fullText: String = ""
    
    var truncated: Bool = true
    
    fileprivate var minimalWidthConstraint: NSLayoutConstraint?
    
    var allowsFrameChange: Bool = true {
        didSet {
            if allowsFrameChange {
                minimalWidthConstraint?.isActive = false
            }
            else {
                if minimalWidthConstraint == nil {
                    self.minimalWidthConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.frame.width)
                    self.filePathControl.addConstraint(minimalWidthConstraint!)
                }
                self.minimalWidthConstraint?.constant = self.frame.width
                self.minimalWidthConstraint?.isActive = true
            }
        }
    }
    
    var currentlyTruncated: Bool = false
    
    override var stringValue: String {
        didSet {
            if isEditable {
                self.fullText = stringValue
            }
        }
    }
        
    fileprivate var widthConstraint: NSLayoutConstraint!
    
    fileprivate var animate: Bool = true
    
    fileprivate var allowExpansion: Bool = true
    
    fileprivate var textPadding: CGFloat?
    
    fileprivate var forcedIntrinsicContentSize: NSSize?
    
    override var intrinsicContentSize: NSSize {
        
        if let forcedIntrinsicContentSize = forcedIntrinsicContentSize {
            return forcedIntrinsicContentSize
        }
        
        var size: NSSize
        let bounds = self.bounds
        
        if let _ = self.currentEditor() as? NSTextView {
            
            var atttributedStringSize = self.attributedStringValue.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height), options: [NSString.DrawingOptions.usesLineFragmentOrigin, NSString.DrawingOptions.usesFontLeading]).size
            
            atttributedStringSize.height = bounds.height
            
            if textPadding == nil {
                self.textPadding = self.bounds.width - atttributedStringSize.width
            }
            
            atttributedStringSize.width += self.textPadding!
            size = atttributedStringSize
        } else {
            
            let cell = self.cell as! NSTextFieldCell
            size = cell.cellSize(forBounds: NSMakeRect(0, 0, CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude))
            size.width = ceil(size.width)
            size.height = ceil(size.height)
            size.width += 4.0
        }

        return size
    }
    
    convenience init(string: String, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.stringValue = string
        self.fullText = string
    }
    
    convenience init(string: NSAttributedString, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.attributedStringValue = string
    }
    
    init(frame frameRect: NSRect, filePathControl: FilePathControl) {
        self.filePathControl = filePathControl
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        if allowExpansion && isCompressed {
            self.setContentCompressionResistancePriority(.required, for: .horizontal)
            self.needsUpdateConstraints = true
            self.filePathControl.animateTruncatedItemDisclosure()
        }
    }
    
    // In the textfield subclass:
    override func mouseExited(with event: NSEvent) {
        if allowExpansion {
            self.setContentCompressionResistancePriority(firstItemContentCompressionResistancePriority, for: .horizontal)
            self.needsUpdateConstraints = true
            self.filePathControl.animateTruncatedItemDisclosure()
        }
    }
    
    private func configure() {
        
        self.isBordered = false
        self.focusRingType = .none
        self.backgroundColor = NSColor.clear
        self.drawsBackground = true
        self.usesSingleLineMode = true
        self.cell?.truncatesLastVisibleLine = true
        self.usesSingleLineMode = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditable = false
        self.lineBreakMode = .byTruncatingTail
        self.alignment = .left
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
}

class LastPathItemView: NSTextField, ItemWidthConstrained, ItemView {
    
    unowned let filePathControl: FilePathControl
    
    var truncated: Bool = true

    override var isEditable: Bool {
        didSet {
            if isEditable {
                prepareForEditing()
            }
        }
    }
    
    fileprivate var widthConstraint: NSLayoutConstraint!
    
    fileprivate var animate: Bool = true
    
    fileprivate var allowExpansion: Bool = true
    
    fileprivate var textPadding: CGFloat?
    
    override var intrinsicContentSize: NSSize {
    
        var size: NSSize
        let bounds = self.bounds

        if let _ = self.currentEditor() as? NSTextView {
            
            var atttributedStringSize = self.attributedStringValue.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height), options: [NSString.DrawingOptions.usesLineFragmentOrigin, NSString.DrawingOptions.usesFontLeading]).size
            
            atttributedStringSize.height = bounds.height
            
            if textPadding == nil {
                self.textPadding = self.bounds.width - atttributedStringSize.width
            }
            
            atttributedStringSize.width += self.textPadding!
            size = atttributedStringSize
        } else {

            let cell = self.cell as! NSTextFieldCell
            size = cell.cellSize(forBounds: NSMakeRect(0, 0, CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude))
            size.width = ceil(size.width)
            size.width += 8.0
            size.height = ceil(size.height)
        }

        return size
    }

    convenience init(string: String, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.stringValue = string
    }
    
    convenience init(string: NSAttributedString, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.attributedStringValue = string
    }
    
    init(frame frameRect: NSRect, filePathControl: FilePathControl) {
        self.filePathControl = filePathControl
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    private func configure() {
        
        self.isBordered = false
        self.focusRingType = .none
        self.backgroundColor = NSColor.clear
        self.drawsBackground = true
        self.usesSingleLineMode = true
        self.cell?.truncatesLastVisibleLine = true
        self.usesSingleLineMode = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditable = false
        self.lineBreakMode = .byTruncatingTail
        self.alignment = .left
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
  
    
    private func prepareForEditing() {

//        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}


class MiddlePathItemView: NSTextField, ItemWidthConstrained, ItemView {
    
    unowned let filePathControl: FilePathControl
    
    var fullText: String = ""
    
    var truncated: Bool = true {
        didSet {
            self.animate = false
            self.currentlyTruncated = truncated
            self.animate = true
        }
    }
    
    var currentlyTruncated: Bool = true {
        didSet {
            updateWidthConstraintActiveState()
        }
    }
    
    override var stringValue: String {
        didSet {
            if isEditable {
                self.fullText = stringValue
            }
        }
    }
    
    fileprivate var widthConstraint: NSLayoutConstraint!
    
    fileprivate var animate: Bool = true
    
    fileprivate var allowExpansion: Bool = true
    
    fileprivate var textPadding: CGFloat?
    
    override var intrinsicContentSize: NSSize {
    
        var size: NSSize
        let bounds = self.bounds

        if let _ = self.currentEditor() as? NSTextView {
            
            var atttributedStringSize = self.attributedStringValue.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: bounds.height), options: [NSString.DrawingOptions.usesLineFragmentOrigin, NSString.DrawingOptions.usesFontLeading]).size
            
            atttributedStringSize.height = bounds.height
            
            if textPadding == nil {
                self.textPadding = self.bounds.width - atttributedStringSize.width
            }
            
            atttributedStringSize.width += self.textPadding!
            size = atttributedStringSize
        } else {

            let cell = self.cell as! NSTextFieldCell
            size = cell.cellSize(forBounds: NSMakeRect(0, 0, CGFloat.greatestFiniteMagnitude, CGFloat.greatestFiniteMagnitude))
            size.width = ceil(size.width)
            size.height = ceil(size.height)
        }
        return size
    }

    convenience init(string: String, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.stringValue = string
        self.fullText = string
    }
    
    convenience init(string: NSAttributedString, filePathControl: FilePathControl) {
        
        self.init(frame: .zero, filePathControl: filePathControl)
        self.attributedStringValue = string
    }
    
    init(frame frameRect: NSRect, filePathControl: FilePathControl) {
        self.filePathControl = filePathControl
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    // In the textfield subclass:
    override func mouseEntered(with event: NSEvent) {
        if allowExpansion {
            if truncated && currentlyTruncated {
                self.currentlyTruncated = false
            }
        }
    }
    
    // In the textfield subclass:
    override func mouseExited(with event: NSEvent) {
        if allowExpansion {
            if truncated && !currentlyTruncated {
                self.currentlyTruncated = true
            }
        }
    }
    
    private func configure() {
        
        self.isBordered = false
        self.focusRingType = .none
        self.backgroundColor = NSColor.clear
        self.drawsBackground = true
        self.usesSingleLineMode = true
        self.cell?.truncatesLastVisibleLine = true
        self.usesSingleLineMode = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.isEditable = false
        self.lineBreakMode = .byTruncatingTail
        self.alignment = .left
        self.addTrackingArea(NSTrackingArea(rect: NSZeroRect, options: NSTrackingArea.Options.inVisibleRect.union(NSTrackingArea.Options.activeInKeyWindow).union(NSTrackingArea.Options.mouseEnteredAndExited).union(NSTrackingArea.Options.mouseMoved), owner: self, userInfo: nil))
    }
    
    private func updateWidthConstraintActiveState() {
        
        if !self.isEditable {
            if currentlyTruncated {
                if self.animate {
                    animateTruncation(to: true)
                }
                else {
                    updateDisplayedString()
                }
            }
            else if truncated {
                if self.animate {
                    animateTruncation(to: false)
                }
                else {
                    updateDisplayedString()
                }
            }
        }
    }
    
    private func animateTruncation(to value: Bool) {
        
        updateDisplayedString()
        self.needsUpdateConstraints = true
        self.filePathControl.animateTruncatedItemDisclosure()
    }
    
    private func updateDisplayedString() {
        
        if currentlyTruncated {
            if let first = self.fullText.first {
                self.stringValue = String(first)
            }
            else {
                self.stringValue = ""
            }
            self.filePathControl.allowsFrameChange = true
        }
        else {
            self.filePathControl.allowsFrameChange = false
            self.stringValue = self.fullText
        }
        self.invalidateIntrinsicContentSize()
    }
}

fileprivate class PathSeparatorView: NSView, CALayerDelegate, ItemSeparatorView {
    
    override var intrinsicContentSize: NSSize {
        
        return NSMakeSize(separatorArrowWidth+separatorArrowFrontPadding, 21.0)
    }
    
    let color: NSColor?
    
    init(frame frameRect: NSRect, color: NSColor? = nil) {
        self.color = color
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("unsupported")
    }
    
    private func configure() {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        guard let context = NSGraphicsContext.current?.cgContext else{
            return
        }

        let verticalDeviation: CGFloat = -0.5
        let verticalPadding: CGFloat = 7.0
        let bottomOrigin = CGPoint(x: 0.0, y: verticalPadding+verticalDeviation)
        let middlePoint = CGPoint( x: self.frame.width-separatorArrowFrontPadding, y: self.frame.height/2+verticalDeviation)
        let upperEnd = CGPoint( x: 0.0, y: self.frame.height-verticalPadding+verticalDeviation)
        
        context.beginPath()
        context.setLineCap(.square)
        context.move(to: bottomOrigin)
        context.addLine(to: middlePoint)
        context.addLine(to: upperEnd)
        context.setStrokeColor(color?.cgColor ?? NSColor.tertiaryLabelColor.cgColor)
        context.setLineWidth(1.4)
        context.strokePath()
    }
}

class FilePathControl: NSView {
    
    let lastPathItemView: Dynamic<NSTextField?>
    
    var canHandleLastPathItemViewCompressed: Bool = true
    
    var firstPathItemView: FirstPathItemView? {
        
        return pathItemViews.first as? FirstPathItemView
    }
    
    var pathItems: [NSPathControlItem] {
        willSet {
            if let minimalWidthConstraint = firstPathItemView?.minimalWidthConstraint {
                self.removeConstraint(minimalWidthConstraint)
            }
            self.unregisterToLastPathItemView()
            self.toolTip = nil
        }
        didSet {
            if !pathItems.isEmpty {
                self.updateStackView()
                self.registerToLastPathItemView()
            }
            self.invalidateIntrinsicContentSize()
            self.needsUpdateConstraints = true
        }
    }
    
    override var intrinsicContentSize: NSSize {
        var width: CGFloat = 0.0
        for subview in self.subviews {
            width += subview.intrinsicContentSize.width + interItemSpacing
        }
        return NSMakeSize(width-interItemSpacing, 21.0)
    }
    
    var attributes: [NSAttributedString.Key: Any]?
    
    private var pathItemViews: [NSTextField]
    
    var allowsFrameChange = true {
        didSet {
            firstPathItemView?.allowsFrameChange = self.allowsFrameChange
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        self.pathItemViews = [PathItemView]()
        self.pathItems = [NSPathControlItem]()
        self.lastPathItemView = Dynamic<NSTextField?>(nil)
        super.init(frame: frameRect)
    }
    
    convenience init() {
        
        self.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        
        self.pathItemViews = [PathItemView]()
        self.pathItems = [NSPathControlItem]()
        self.lastPathItemView = Dynamic<NSTextField?>(nil)
        super.init(coder: coder)
    }
    
    func animateTruncatedItemDisclosure() {
        NSAnimationContext.runAnimationGroup({_ in
            NSAnimationContext.current.duration = 0.25
            NSAnimationContext.current.allowsImplicitAnimation = true
            self.invalidateIntrinsicContentSize()
            self.updateConstraints()
            self.layoutSubtreeIfNeeded()
        }, completionHandler: {})
    }
    
    private func updateStackView() {

        self.pathItemViews.removeAll()
        self.subviews.removeAll()
        var lastPathItem: NSView?
        
        let count = pathItems.count
        
        guard count > 0 else {
            return
        }
        
        var tooltipString = ""
        
        for (index, pathItem) in pathItems.enumerated() {
         
            // add separator
            if let _lastPathItem = lastPathItem {
                
                let pathSeparator = PathSeparatorView(frame: NSMakeRect(0, 0, separatorArrowWidth+separatorArrowFrontPadding, 21.0), color: (self.attributes?[NSAttributedString.Key.foregroundColor] as? NSColor) ?? NSColor.tertiaryLabelColor)
                self.addSubview(pathSeparator)
                addPathSeparatorConstraints(to: pathSeparator, lastPathItem: _lastPathItem)
                lastPathItem = pathSeparator
            }
            
            if let attributes = self.attributes {
                
                let attributedTitle = NSAttributedString(string: pathItem.title, attributes: attributes)
                let pathItem = itemView(withTitle: attributedTitle.string, for: index, count: count)
                pathItem.textColor = attributes[.foregroundColor] as? NSColor ?? NSColor.tertiaryLabelColor
                self.addSubview(pathItem)
                addPathItemConstraints(to: pathItem, lastPathItem: lastPathItem, first: index == 0, last: index == pathItems.count-1)
                lastPathItem = pathItem
            }
            else {
                
                let pathItemView = itemView(withTitle: pathItem.attributedTitle.string, for: index, count: count)
                pathItemView.textColor = pathItem.attributedTitle.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? NSColor ?? NSColor.tertiaryLabelColor
                self.addSubview(pathItemView)
                addPathItemConstraints(to: pathItemView, lastPathItem: lastPathItem, first: index == 0, last: index == pathItems.count-1)
                lastPathItem = pathItemView
            }
            
            guard let lastPathItemView = lastPathItem as? NSTextField else {
                assertionFailure("Error: lastPathItem is not NSTextField")
                continue
            }
            
            if index == 0 && pathItems.count > 1 {
                lastPathItemView.setContentCompressionResistancePriority(firstItemContentCompressionResistancePriority, for: .horizontal)
            }
            else if index == pathItems.count-1 {
                lastPathItemView.setContentCompressionResistancePriority(lastItemContentCompressionResistancePriority, for: .horizontal)
            }
            else {
                lastPathItemView.setContentCompressionResistancePriority(middleItemContentCompressionResistancePriority, for: .horizontal)
            }
                
            tooltipString += pathItem.title
            lastPathItemView.toolTip = tooltipString
            
            if index != pathItems.count-1 {
                tooltipString += "/"
            }
            
            self.pathItemViews.append(lastPathItemView)
        }
        
        guard let lastPathItemView = lastPathItem as? LastPathItemView else {
            assertionFailure("Error: lastPathItem is not LastPathItemView")
            self.lastPathItemView.setValue(nil)
            return
        }
        
        let lastPathItemTrailingConstraint = NSLayoutConstraint(item: lastPathItemView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        
        self.addConstraint(lastPathItemTrailingConstraint)
        self.needsUpdateConstraints = true
        self.lastPathItemView.setValue(lastPathItemView)
        lastPathItemView.isEditable = true
    }

    private func itemView(withTitle title: String, for index: Int, count: Int) -> NSTextField & ItemView {
        
        if index == 0 {
            return FirstPathItemView(string: title, filePathControl: self)
        }
        if index == count-1 {
            return LastPathItemView(string: title, filePathControl: self)
        }
        else {
            return MiddlePathItemView(string: title, filePathControl: self)
        }
    }
    
    private func addPathSeparatorConstraints(to itemView: PathSeparatorView, lastPathItem: NSView) {
        
        let leading: NSLayoutConstraint = NSLayoutConstraint(item: itemView, attribute: .leading, relatedBy: .equal, toItem: lastPathItem, attribute: .trailing, multiplier: 1, constant: interItemSpacing)
        
        let center = NSLayoutConstraint(item: itemView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraints([leading, center])
        self.needsUpdateConstraints = true
    }
    
    private func addPathItemConstraints(to itemView: ItemView & NSTextField, lastPathItem: NSView?, first: Bool, last: Bool) {

        itemView.truncated = !last && !first
        
        let leading: NSLayoutConstraint = {
            if let lastPathItem = lastPathItem {
                return NSLayoutConstraint(item: itemView, attribute: .leading, relatedBy: .equal, toItem: lastPathItem, attribute: .trailing, multiplier: 1, constant: interItemSpacing)
            }
            else {
                return NSLayoutConstraint(item: itemView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: interItemSpacing)
            }
        }()
        
        let center = NSLayoutConstraint(item: itemView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        let minimumWidth = NSLayoutConstraint(item: itemView, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 10)
        minimumWidth.priority = .defaultLow
        
        
        self.addConstraints([leading, center, minimumWidth])
        self.needsUpdateConstraints = true
    }
    
    private var textDidBeginEditingNotificationObserver: NSObjectProtocol?
    
    private var textDidChangeNotificationObserver: NSObjectProtocol?
    
    private var textDidEndEditingNotificationObserver: NSObjectProtocol?
    
    private func unregisterToLastPathItemView() {
 
        NotificationCenter.default.removeObserver(textDidBeginEditingNotificationObserver as Any)
        NotificationCenter.default.removeObserver(textDidChangeNotificationObserver as Any)
        NotificationCenter.default.removeObserver(textDidEndEditingNotificationObserver as Any)
    }
    
    private func registerToLastPathItemView() {
        
        guard let lastPathItemView = self.lastPathItemView.value as? LastPathItemView else {
            assertionFailure("Error: self.lastPathItemView is nil")
            return
        }
        
        self.textDidBeginEditingNotificationObserver = NotificationCenter.default.addObserver(forName: NSControl.textDidBeginEditingNotification, object: lastPathItemView, queue: nil) { [weak self](notification) in
            self?.handleTextDidBeginEditingNotification()
        }
        
        self.textDidChangeNotificationObserver = NotificationCenter.default.addObserver(forName: NSControl.textDidChangeNotification, object: lastPathItemView, queue: nil) { [weak self](notification) in
            self?.handleTextDidChangeNotification()
        }

        self.textDidEndEditingNotificationObserver = NotificationCenter.default.addObserver(forName: NSControl.textDidEndEditingNotification, object: lastPathItemView, queue: nil) { [weak self](notification) in
            self?.handleTextDidEndEditingNotification()
        }
    }
    
    private func handleTextDidBeginEditingNotification() {
        self.disallowPathExtension()
    }

    private func handleTextDidChangeNotification() {
        guard let lastPathItemView = self.lastPathItemView.value else {
            assertionFailure("Error: self.lastPathItemView is nil")
            return
        }
        lastPathItemView.invalidateIntrinsicContentSize()
        self.invalidateIntrinsicContentSize()
        self.superview?.needsDisplay = true
    }
    
    private func handleTextDidEndEditingNotification() {
        self.allowPathExtension()
    }
    
    private func allowPathExtension() {
        for pathItemView in self.pathItemViews {
            
            guard let itemView = pathItemView as? ItemView else {
                assertionFailure("Error: pathItemView is not ItemView")
                continue
            }
            
            itemView.allowExpansion = true
        }
    }
    
    private func disallowPathExtension() {
        for pathItemView in self.pathItemViews {
            
            guard let itemView = pathItemView as? ItemView else {
                assertionFailure("Error: pathItemView is not ItemView")
                continue
            }
            
            itemView.allowExpansion = false
        }
    }
}
