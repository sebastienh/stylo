//
//  TextStatisticsViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-07-03.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon
import PromiseKit
import Common
import os

class FileInfoViewController: NSViewController {

    enum TextSelectionState {
        
//        case initial
        case none
//        case sessionNotStarted
//        case sessionHidden
        case some(range: NSRange)
    }
    
    // General
    @IBOutlet weak var fileNameLabel: NSTextField!
    
    @IBOutlet weak var fileNameValueLabel: NSTextField! {
        didSet {
            self.fileNameValueLabel.isBordered = false
            self.fileNameValueLabel.focusRingType = .none
            self.fileNameValueLabel.backgroundColor = NSColor.clear
            self.fileNameValueLabel.drawsBackground = true
        }
    }
    
    @IBOutlet var filePathLabel: NSTextField!
    
    @IBOutlet var filePathValueLabel: NSTextField!
    
    // Statistics
    @IBOutlet weak var charactersCountLabel: NSTextField!
    
    @IBOutlet var selectionCharactersCountLabel: NSTextField!
    
    @IBOutlet weak var charactersStackView: NSStackView!
    
    @IBOutlet weak var wordsCountLabel: NSTextField!
    
    @IBOutlet var selectionWordsCountLabel: NSTextField!
    
    @IBOutlet weak var wordsStackView: NSStackView!
    
    @IBOutlet weak var sentencesCountLabel: NSTextField!
    
    @IBOutlet var selectionSentencesCountLabel: NSTextField!
    
    @IBOutlet weak var sentencesStackView: NSStackView!
    
    @IBOutlet weak var paragraphsCountLabel: NSTextField!
    
    @IBOutlet var selectionParagraphsCountLabel: NSTextField!
    
    @IBOutlet weak var paragraphsStackView: NSStackView!
    
    @IBOutlet weak var pagesCountLabel: NSTextField!
    
    @IBOutlet var selectionPagesCountLabel: NSTextField!
    
    @IBOutlet weak var pagesStackView: NSStackView!
    
    // Reading time
    
    @IBOutlet weak var slowReadingTimeLabel: NSTextField!
    
    @IBOutlet weak var averageReadingTimeLabel: NSTextField!
    
    @IBOutlet weak var fastReadingTimeLabel: NSTextField!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var fileInfoView: FileInfoView!
    
    weak var textManager: TextManager?
    
    weak var editor: AnyEditor?
    
    weak var styloDocument: TextDocument?
    
    weak var parentPopover: NSPopover?
    
    // this is the state coming from the xib
    var currentUIState: TextSelectionState = .none
    
    private var currentState: TextSelectionState? {
        
        guard let editor = self.editor else {
            assertionFailure("Error: self.editor is nil")
            return nil
        }
        
        if let selectedRange = editor.selectedRange, selectedRange.length != 0 {
            return TextSelectionState.some(range: selectedRange)
        }
        return TextSelectionState.none
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.fileInfoView.fileInfoViewController = self

        let color = nsColor(named: "SessionFullColor")
        let alphaColor = color.withAlphaComponent(0.5)
        let font = NSFont(name: "Helvetica Neue Bold", size: 12.0)!
        
        assert(self.fileInfoView != nil)
        if let fileInfoView = self.fileInfoView {
            
            fileInfoView.setContentHuggingPriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.vertical)
        }
    }
    
    override func viewWillAppear() {
        
        ensureStatistics()
        super.viewWillAppear()
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        self.unregister()
    }
    
    @IBAction func startWritingSession(_ sender: AnyObject?) {
        
        assert(textManager != nil)
        if let textManager = textManager {
        
            firstly {
                textManager.startWritingSession()
            }.then { () -> Void in
                self.updateUI()
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error startWritingSession: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    @IBAction func showWritingSession(_ sender: AnyObject?) {
        
        assert(textManager != nil)
        if let textManager = textManager {
            firstly {
                textManager.showWritingSession()
            }.then { () -> Void in
                self.updateUI()
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error showWritingSession: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    @IBAction func hideWritingSession(_ sender: AnyObject?) {
        
        assert(textManager != nil)
        if let textManager = textManager {
            
            firstly {
                textManager.hideWritingSession()
            }.then { () -> Void in
                self.updateUI()
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error hideWritingSession: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    private func ensureStatistics() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        guard let editor = self.editor else {
            assertionFailure("Error: self.editorManager is nil")
            return
        }
            
        register(withTextManager: textManager)

        self.displayProgress()
        
        when(resolved: [textManager.updateStatistics(), editor.updateSelectionStatistics()]).then { _ -> Void in
            self.hideProgress()
        }.then {
            self.updateUI()
        }.catch { error in
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("error in viewWillAppear: %@", log: Log.StyloCore.all, type: .error, %%error)
            #endif
        }
    }
    
    private func register(withTextManager textManager: TextManager) {
     
        // public let totalTextStatistics: Dynamic<TextStatistics?> =  Dynamic<TextStatistics?>(nil)
        if let textStatistics = textManager.totalTextStatistics.value {
            self.updateTextStatistics(from: textStatistics)
        }
        textManager.totalTextStatistics.subscribe({ [weak self](textStatistics) in
            self?.updateTextStatistics(from: textStatistics)
        }, observer: self)
    }

    private func register(withEditorManager editorManager: AnyEditor) {
    
        // we may not need this
    }
    
    private func unregister(fromTextManager textManager: TextManager) {
    
        textManager.totalTextStatistics.unsubscribe(observer: self)
    }
    
    private func unregister(fromEditor editor: AnyEditor) {
    
        editor.selectionStatistics.unsubscribe(observer: self)
    }
    
    private func updateUI() {
        
        guard let currentState = self.currentState else {
            assertionFailure("Error: self.currentState is nil")
            return
        }
         
        // update general info
        self.updateGeneralInfo()

        self.updateDisplayedStatistics(to: currentState)
        self.fileInfoView.invalidateIntrinsicContentSize()
        self.fileInfoView.needsUpdateConstraints = true
    }
        
    private func updateGeneralInfo() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
        
        self.fileNameValueLabel.stringValue = textManager.name.value
        self.fileNameValueLabel.invalidateIntrinsicContentSize()
        
        let pathComponents = textManager.pathComponents.values
        
        var pathString = ""
        for pathComponent in pathComponents {
            pathString.append(contentsOf: "/")
            pathString.append(contentsOf: pathComponent)
        }
        self.filePathValueLabel.stringValue = pathString
        self.filePathValueLabel.invalidateIntrinsicContentSize()
        self.fileInfoView.invalidateIntrinsicContentSize()
    }
    
    private func updateSelectionStatistics(from textStatistics: TextStatistics?) {
        
        if let textStatistics = textStatistics {
            
            self.selectionCharactersCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.charactersCountString)
            
            self.selectionWordsCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.wordsCountString)
            
            self.selectionSentencesCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.sentencesCountString)
            
            self.selectionParagraphsCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.paragraphsCountString)
            
            self.selectionPagesCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.pagesCountString)
        }
    }
    
    private func updateTextStatistics(from textStatistics: TextStatistics?) {
        
        if let textStatistics = textStatistics {
            
            self.charactersCountLabel.stringValue = textStatistics.charactersCountString
            self.wordsCountLabel.stringValue = textStatistics.wordsCountString
            self.sentencesCountLabel.stringValue = textStatistics.sentencesCountString
            self.paragraphsCountLabel.stringValue = textStatistics.paragraphsCountString
            self.pagesCountLabel.stringValue = textStatistics.pagesCountString
            self.slowReadingTimeLabel.stringValue = textStatistics.slowReadingTimeString
            self.averageReadingTimeLabel.stringValue = textStatistics.averageReadingTimeString
            self.fastReadingTimeLabel.stringValue = textStatistics.fastReadingTimeString
        }
    }
    
    private func updateDisplayedStatistics(to state: TextSelectionState) {
    
        switch state {
        case .none:
            self.updateUIWithoutSelectedText()
        case .some:
            self.updateUIWhenSelectedText()
        }
        
        self.currentUIState = state
    }
    
    private func updateUIWhenSelectedText() {
        
        self.fileInfoView.layoutSubtreeIfNeeded()
        
        guard let selectionStatistics = self.editor?.selectionStatistics.value else {
            assertionFailure("Error: selectionStatistics is nil")
            return
        }
        
        self.updateSelectionStatistics(from: selectionStatistics)
        
//        NSAnimationContext.runAnimationGroup({ context in
//
//            // Customize the animation parameters.
//            context.duration = 0.50
//            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//            context.allowsImplicitAnimation = true
            
            self.selectionCharactersCountLabel.isHidden = false
            self.selectionWordsCountLabel.isHidden = false
            self.selectionSentencesCountLabel.isHidden = false
            self.selectionParagraphsCountLabel.isHidden = false
            self.selectionPagesCountLabel.isHidden = false
            
            self.fileInfoView.layoutSubtreeIfNeeded()
//        })
    }
    
    private func updateUIWithoutSelectedText() {
    
//        NSAnimationContext.runAnimationGroup({ context in
//
//            // Customize the animation parameters.
//            context.duration = 0.50
//            context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
//            context.allowsImplicitAnimation = true
            
            self.selectionCharactersCountLabel.isHidden = true
            self.selectionWordsCountLabel.isHidden = true
            self.selectionSentencesCountLabel.isHidden = true
            self.selectionParagraphsCountLabel.isHidden = true
            self.selectionPagesCountLabel.isHidden = true

            self.fileInfoView.layoutSubtreeIfNeeded()
//
//        }, completionHandler: {
//
//        })
    }
    
    private func showSessionLabels() {
        
//        NSAnimationContext.runAnimationGroup({ context in
//
//            context.allowsImplicitAnimation = true
//            context.duration = 0.25
            
            self.selectionCharactersCountLabel.isHidden = false
            self.selectionWordsCountLabel.isHidden = false
            self.selectionSentencesCountLabel.isHidden = false
            self.selectionParagraphsCountLabel.isHidden = false
            self.selectionPagesCountLabel.isHidden = false
            
            self.fileInfoView.layoutSubtreeIfNeeded()
//        })
    }
    
    private func displayProgress() {
        
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimation(self)
    }
    
    private func hideProgress() {
        
        self.progressIndicator.stopAnimation(self)
        self.progressIndicator.isHidden = true
    }
    
    private func dateAttributedString(from date: Date) -> NSAttributedString {
        
        var dateString = DateFormatter.localizedString(from: date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.short)
        
        dateString = "Started on \(dateString)"
        
        let color = nsColor(named: "SessionFullColor")
        let alphaColor = color.withAlphaComponent(0.5)

        let attributedDateString = NSAttributedString(string: dateString, attributes: [
            NSAttributedString.Key.foregroundColor : alphaColor,
            NSAttributedString.Key.font : NSFont(name: "Helvetica Neue", size: 12.0)
            ])
        return attributedDateString
    }
    
    private func sessionNumberAttributedString(from string: String) -> NSAttributedString {
        
        let attributedString  = NSMutableAttributedString(string: string + " /")
        
        let numberRange = NSMakeRange(0, attributedString.length-1)
        attributedString.addAttributes([
            NSAttributedString.Key.font : NSFont(name: "Helvetica Neue", size: 14.0),
            NSAttributedString.Key.foregroundColor : nsColor(named: "SessionFullColor")
            ], range: numberRange)
        
        let slashRange = NSMakeRange(attributedString.length-1, 1)
        attributedString.addAttributes([
            NSAttributedString.Key.font : NSFont(name: "Helvetica Neue", size: 14.0),
            NSAttributedString.Key.foregroundColor : nsColor(named: "TertiaryTextColor")
            ], range: slashRange)
        return attributedString
    }
    
    private func unregister() {
        
        guard let textManager = self.textManager else {
            assertionFailure("Error: self.textManager is nil")
            return
        }
    
        unregister(fromTextManager: textManager)
        
        guard let editor = self.editor else {
            assertionFailure("Error: self.editorManager is nil")
            return
        }
        
        unregister(fromEditor: editor)
    }
    
    deinit {
        
        self.unregister()
    }
    
}
