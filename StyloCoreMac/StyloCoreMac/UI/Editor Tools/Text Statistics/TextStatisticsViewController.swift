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

class TextStatisticsViewController: NSViewController {

    enum State {
        
        case initial
        case sessionDisabled
        case sessionNotStarted
        case sessionHidden
        case sessionShown
    }
    
    @IBOutlet var horizontalControlsStackView: NSStackView!
    
    @IBOutlet var verticalControlsStackView: NSStackView!
    
    @IBOutlet weak var charactersCountLabel: NSTextField!
    
    @IBOutlet var sessionCharactersCountLabel: NSTextField!
    
    @IBOutlet weak var charactersStackView: NSStackView!
    
    @IBOutlet weak var wordsCountLabel: NSTextField!
    
    @IBOutlet var sessionWordsCountLabel: NSTextField!
    
    @IBOutlet weak var wordsStackView: NSStackView!
    
    @IBOutlet weak var sentencesCountLabel: NSTextField!
    
    @IBOutlet var sessionSentencesCountLabel: NSTextField!
    
    @IBOutlet weak var sentencesStackView: NSStackView!
    
    @IBOutlet weak var paragraphsCountLabel: NSTextField!
    
    @IBOutlet var sessionParagraphsCountLabel: NSTextField!
    
    @IBOutlet weak var paragraphsStackView: NSStackView!
    
    @IBOutlet weak var pagesCountLabel: NSTextField!
    
    @IBOutlet var sessionPagesCountLabel: NSTextField!
    
    @IBOutlet weak var pagesStackView: NSStackView!
    
    @IBOutlet weak var slowReadingTimeLabel: NSTextField!
    
    @IBOutlet weak var averageReadingTimeLabel: NSTextField!
    
    @IBOutlet weak var fastReadingTimeLabel: NSTextField!
    
    @IBOutlet var hideSessionButton: NSButton!
    
    @IBOutlet var restartSessionButton: NSButton!
    
    @IBOutlet var startedOnDateLabel: NSButton!
    
    @IBOutlet weak var progressIndicator: NSProgressIndicator!
    
    @IBOutlet weak var textStatisticsView: TextStatisticsView!
    
    @IBOutlet weak var startSessionButton: NSButton!
    
    @IBOutlet weak var showSessionButton: NSButton!
    
    weak var textManager: TextManager?
    
    weak var styloDocument: TextDocument?
    
    weak var parentPopover: NSPopover?
    
    // this is the state coming from the xib
    var currentUIState: State = .initial
    
    private var currentState: State? {
        
        if StyloApplication.shared.textStatisticsSessionToolsEnabled {
            
            assert(textManager != nil)
            if let textManager = textManager {

                if textManager.sessionStartDate.value != nil {
                
                    assert(textManager.sessionStatistics.value != nil)
                    if let hidden = textManager.writingSessionHidden.value, hidden {
                        return State.sessionHidden
                    }
                    else {
                        return State.sessionShown
                    }
                }
                else {
                    return State.sessionNotStarted
                }
            }
        }
        else {
            return State.sessionDisabled
        }
        return nil
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        startedOnDateLabel.state = .off
        self.textStatisticsView.textStatisticsViewController = self

        let color = nsColor(named: "SessionFullColor")
        let alphaColor = color.withAlphaComponent(0.5)
        let font = NSFont(name: "Helvetica Neue Bold", size: 12.0)!
        
        self.startSessionButton.attributedTitle = NSAttributedString(string: "Start Session", attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
            ])
        
        self.showSessionButton.attributedTitle = NSAttributedString(string: "Show Session", attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
            ])
        
        self.hideSessionButton.attributedTitle = NSAttributedString(string: "Hide", attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
            ])
        
        self.restartSessionButton.attributedTitle = NSAttributedString(string: "Restart", attributes: [
            NSAttributedString.Key.font : font,
            NSAttributedString.Key.foregroundColor : color
            ])
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: §StyloNotification.textStatisticsSessionEnabledStateChanged), object: nil, queue: nil) { [weak self](notification) -> Void in
            
            self?.updateUI()
        }
        
        assert(self.textStatisticsView != nil)
        if let textStatisticsView = self.textStatisticsView {
            
//            textStatisticsView.verticalStackView = self.verticalControlsStackView
            textStatisticsView.setContentHuggingPriority(NSLayoutConstraint.Priority.required, for: NSLayoutConstraint.Orientation.vertical)
        }
    }
    
    override func viewWillAppear() {
        
        ensureSessionStatistics()
        super.viewWillAppear()
    }
    
    override func viewWillDisappear() {
        
        super.viewWillDisappear()
        assert(self.textManager != nil)
        if let textManager = self.textManager {
            unregister(with: textManager)
        }
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
    
    private func ensureSessionStatistics() {
        
        assert(self.textManager != nil)
        if let textManager = self.textManager {
            
            register(with: textManager)
            
            self.displayProgress()
            firstly { () -> Promise<Void> in
                textManager.updateStatistics()
            }.then {
                self.hideProgress()
            }.then {
                self.updateUI()
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("error in viewWillAppear: %@", log: Log.StyloCore.all, type: .error, %%error)
                #endif
            }
        }
    }
    
    private func register(with textManager: TextManager) {
     
        // public let totalTextStatistics: Dynamic<TextStatistics?> =  Dynamic<TextStatistics?>(nil)
        if let textStatistics = textManager.totalTextStatistics.value {
            self.updateTextStatistics(from: textStatistics)
        }
        textManager.totalTextStatistics.subscribe({ [weak self](textStatistics) in
            self?.updateTextStatistics(from: textStatistics)
        }, observer: self)
    }

    private func unregister(with textManager: TextManager) {
    
        textManager.totalTextStatistics.unsubscribe(observer: self)
    }
    
    private func updateUI() {
        
        let currentState = self.currentState
        assert(currentState != nil)
        if let currentState = currentState {
            
            self.updateUI(to: currentState)
            
            assert(parentPopover != nil)
            self.verticalControlsStackView.invalidateIntrinsicContentSize()
            self.textStatisticsView.invalidateIntrinsicContentSize()
            self.textStatisticsView.needsUpdateConstraints = true
        }
    }
        
    private func updateSessionStatistics(from textStatistics: TextStatistics?) {
        
        if let textStatistics = textStatistics {
            
            self.sessionCharactersCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.charactersCountString)
            
            self.sessionWordsCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.wordsCountString)
            
            self.sessionSentencesCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.sentencesCountString)
            
            self.sessionParagraphsCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.paragraphsCountString)
            
            self.sessionPagesCountLabel.attributedStringValue = self.sessionNumberAttributedString(from: textStatistics.pagesCountString)
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
    
    private func updateUI(to state: State) {
    
        switch state {
            
        case .initial:
            assert(false, "programming error: we should not switch to the initial state")
            break
            
        case .sessionDisabled:
            self.updateUIForSessionDisabled()
         
        case .sessionNotStarted:
            self.updateUIForSessionNotStarted()
            
        case .sessionHidden:
            self.updateUIForSessionHidden()
            
        case .sessionShown:
            self.updateUIForSessionsShown()
        }
        
        self.currentUIState = state
    }
    
    private func updateUIForSessionsShown() {
        
        
        func animateShow() {
            
            self.hideSessionButton.isHidden = false
            self.restartSessionButton.isHidden = false
            self.startedOnDateLabel.isHidden = false
            
            self.textStatisticsView.layoutSubtreeIfNeeded()
            
            NSAnimationContext.runAnimationGroup({ context in
                
                // Customize the animation parameters.
                context.duration = 0.50
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                context.allowsImplicitAnimation = true
                
                self.sessionCharactersCountLabel.isHidden = false
                self.sessionWordsCountLabel.isHidden = false
                self.sessionSentencesCountLabel.isHidden = false
                self.sessionParagraphsCountLabel.isHidden = false
                self.sessionPagesCountLabel.isHidden = false
                
                self.textStatisticsView.layoutSubtreeIfNeeded()
            })
            
        }
        
        switch self.currentUIState {
        case .sessionDisabled:
            animateShow()
            break
            
        case .sessionNotStarted:
            
            self.startSessionButton.animator().isHidden = true
            animateShow()
            
        case .sessionHidden:
            self.showSessionButton.animator().isHidden = true
            animateShow()
            
        case .sessionShown:
            animateShow()
            break
            
        case .initial:
            self.startSessionButton.animator().isHidden = true
            self.showSessionButton.animator().isHidden = true
            self.hideSessionButton.isHidden = false
            self.restartSessionButton.isHidden = false
            self.startedOnDateLabel.isHidden = false
            self.sessionCharactersCountLabel.isHidden = false
            self.sessionWordsCountLabel.isHidden = false
            self.sessionSentencesCountLabel.isHidden = false
            self.sessionParagraphsCountLabel.isHidden = false
            self.sessionPagesCountLabel.isHidden = false
            self.textStatisticsView.layoutSubtreeIfNeeded()
        }
    }
    
    private func updateUIForSessionHidden() {
        
        switch self.currentUIState {
            
        case .sessionDisabled:
            
            self.showSessionButton.animator().isHidden = false
            
        case .sessionNotStarted:
            
            self.showSessionButton.animator().isHidden = false
            self.startSessionButton.animator().isHidden = true
            
        case .sessionHidden:
            
            break
            
        case .sessionShown:
            
            self.startedOnDateLabel.isHidden = true
            self.hideSessionButton.isHidden = true
            self.restartSessionButton.isHidden = true
            self.showSessionButton.isHidden = false
            self.textStatisticsView.layoutSubtreeIfNeeded()
            
            NSAnimationContext.runAnimationGroup({ context in
                
                // Customize the animation parameters.
                context.duration = 0.50
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                context.allowsImplicitAnimation = true
                
                self.sessionCharactersCountLabel.isHidden = true
                self.sessionWordsCountLabel.isHidden = true
                self.sessionSentencesCountLabel.isHidden = true
                self.sessionParagraphsCountLabel.isHidden = true
                self.sessionPagesCountLabel.isHidden = true

                self.textStatisticsView.layoutSubtreeIfNeeded()
                
            }, completionHandler: {
  
            })
                
        case .initial:

            self.sessionCharactersCountLabel.isHidden = true
            self.sessionWordsCountLabel.isHidden = true
            self.sessionSentencesCountLabel.isHidden = true
            self.sessionParagraphsCountLabel.isHidden = true
            self.sessionPagesCountLabel.isHidden = true
            
            self.startSessionButton.isHidden = true
            self.showSessionButton.isHidden = false
            self.restartSessionButton.isHidden = true
            self.hideSessionButton.isHidden = true
            self.startedOnDateLabel.isHidden = true
            
            self.textStatisticsView.layoutSubtreeIfNeeded()
        }
    }
    
    private func updateUIForSessionNotStarted() {
        
        self.startSessionButton.animator().isHidden = false
        
        switch self.currentUIState {
            
        case .sessionDisabled:
            
            break
            
        case .sessionNotStarted:
            
            break
            
        case .sessionHidden:
            
            assert(false, "A session can not be move to not started and since it is hidden and... started.")
            break
            
        case .sessionShown:
            
            assert(false, "A session can not be move to shown to not started...")
            break
            
        case .initial:
            
            self.sessionCharactersCountLabel.isHidden = true
            self.sessionWordsCountLabel.isHidden = true
            self.sessionSentencesCountLabel.isHidden = true
            self.sessionParagraphsCountLabel.isHidden = true
            self.sessionPagesCountLabel.isHidden = true
            
            self.showSessionButton.isHidden = true
            self.restartSessionButton.isHidden = true
            self.hideSessionButton.isHidden = true
            self.startedOnDateLabel.isHidden = true
            
            self.textStatisticsView.layoutSubtreeIfNeeded()
        }
    }
    
    private func updateUIForSessionDisabled() {
        
        switch self.currentUIState {
            
        case .sessionDisabled:
            break
            
        case .sessionNotStarted:
        
            self.startSessionButton.animator().isHidden = true
            
        case .sessionHidden:
            
            self.showSessionButton.animator().isHidden = true
            
        case .sessionShown:
            
            NSAnimationContext.runAnimationGroup({ context in
                
                // Customize the animation parameters.
                context.duration = 0.50
                context.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                context.allowsImplicitAnimation = true
                
                self.sessionCharactersCountLabel.isHidden = true
                self.sessionWordsCountLabel.isHidden = true
                self.sessionSentencesCountLabel.isHidden = true
                self.sessionParagraphsCountLabel.isHidden = true
                self.sessionPagesCountLabel.isHidden = true
                
                self.textStatisticsView.layoutSubtreeIfNeeded()
                
            }, completionHandler: {
                
            })
            
            self.startedOnDateLabel.animator().isHidden = true
            self.restartSessionButton.animator().isHidden = true
            self.hideSessionButton.animator().isHidden = true
            
        case .initial:
            
            self.sessionCharactersCountLabel.isHidden = true
            self.sessionWordsCountLabel.isHidden = true
            self.sessionSentencesCountLabel.isHidden = true
            self.sessionParagraphsCountLabel.isHidden = true
            self.sessionPagesCountLabel.isHidden = true
            
            self.startSessionButton.isHidden = true
            self.showSessionButton.isHidden = true
            self.restartSessionButton.isHidden = true
            self.hideSessionButton.isHidden = true
            self.startedOnDateLabel.isHidden = true
            
            self.textStatisticsView.layoutSubtreeIfNeeded()
        }
    }
    
    private func showSessionLabels() {
        
        NSAnimationContext.runAnimationGroup({ context in
            
            context.allowsImplicitAnimation = true
            context.duration = 0.25
            
            self.sessionCharactersCountLabel.isHidden = false
            self.sessionWordsCountLabel.isHidden = false
            self.sessionSentencesCountLabel.isHidden = false
            self.sessionParagraphsCountLabel.isHidden = false
            self.sessionPagesCountLabel.isHidden = false
            
            self.textStatisticsView.layoutSubtreeIfNeeded()
        })
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
    
    deinit {
        
        assert(self.textManager != nil)
        if let textManager = self.textManager {
            self.unregister(with: textManager)
        }
    }
    
}
