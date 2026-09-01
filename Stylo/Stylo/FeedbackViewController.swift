//
//  FeedbackViewController.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os
import Common


class FeedbackViewController: NSViewController {
    
    @IBOutlet weak var nameTextField: NSTextField!

    @IBOutlet weak var emailAddressTextField: NSTextField!
    
    @IBOutlet weak var messageTextView: NSTextView!
    
    @IBAction func submitFeedback(_ sender: AnyObject? = nil) {
        
        sendMailcore()
        closeWindow()
    }

    @IBAction func closeWindow(_ sender: AnyObject? = nil) {
        
        closeWindow()
    }
    
    override func viewWillAppear() {
        
        clearForm()
        super.viewWillAppear()
        
    }
    
    private func clearForm() {
        
        nameTextField.stringValue = ""
        emailAddressTextField.stringValue = ""
        messageTextView.string = ""
    }

    private func sendEmail() {
        
        if !self.messageTextView.string.isEmpty && !emailAddressTextField.stringValue.isEmpty {
        
            let emailService = NSSharingService.init(named: NSSharingService.Name.composeEmail)
            
            assert(emailService != nil)
            if let emailService = emailService {
            
                let emailBody = self.messageTextView.string
                emailService.recipients = ["support@textually.net"]
                emailService.subject = "Stylo Feedback"
                
                if emailService.canPerform(withItems: [emailBody]) {
                    // email can be sent
                    emailService.perform(withItems: [emailBody])
                }
                else {
                    // email cannot be sent, perhaps no email client is set up
                    // Show alert with email address and instructions
                    assert(false, "email cannot be sent: canPerform returned false")
                    #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                    os_log("email cannot be sent: canPerform returned false", log: Log.Stylo.all, type: .error)
                    #endif
                }
            }
            else {
                
                assert(false, "email cannot be sent: emailService is nil")
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("email cannot be sent: emailService is nil", log: Log.Stylo.all, type: .error)
                #endif
            }
        }
        else {
            
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("messageTextView or emailAddressTextField is empty", log: Log.Stylo.all, type: .debug)
            #endif
        }
    }
    
    private func sendMailcore() {
        
//        if !self.messageTextView.string.isEmpty && !emailAddressTextField.stringValue.isEmpty {
//
//            let nameSource = nameTextField.stringValue
//            let name = nameSource.isEmpty ? "Stylo User" : nameSource
//            let emailAddress = emailAddressTextField.stringValue
//            var emailBody = self.messageTextView.string
//
//            let smtpSession = MCOSMTPSession()
//            smtpSession.hostname = "smtp.gmail.com"
//            // Configure SMTP credentials outside source control before sending.
//            smtpSession.port = 465
//            smtpSession.authType = MCOAuthType.saslPlain
//            smtpSession.connectionType = MCOConnectionType.TLS
//            smtpSession.connectionLogger = {(connectionID, type, data) in
//                if let data = data {
//                    if let string = String(data: data, encoding: String.Encoding.utf8){
//                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("Email connection logger: %@", log: Log.Stylo.all, type: .debug, %%string)
//                        #endif
//                    }
//                }
//            }
//
//            guard let destination = MCOAddress(displayName: "Stylo Support", mailbox: "support@textually.net") else {
//                assertionFailure("Error: destination is nil")
//                return
//            }
//
//            let builder = MCOMessageBuilder()
//            builder.header.to = [destination]
//            builder.header.from = MCOAddress(displayName: "\(name)(\(emailAddress))", mailbox: "support@example.com")
//            builder.header.subject = "Stylo Feedback"
//            buildEmailBody(using: &emailBody)
//            builder.htmlBody = emailBody
//
//            let rfc822Data = builder.data()
//            let sendOperation = smtpSession.sendOperation(with: rfc822Data)
//
//            assert(sendOperation != nil)
//            if let sendOperation = sendOperation {
//                sendOperation.start { (error) -> Void in
//                    if (error != nil) {
//                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("Error sending email: %@", log: Log.Stylo.all, type: .error, %%error)
//                        #endif
//                    } else {
//                        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
//                        os_log("Successfully sent email!", log: Log.Stylo.all, type: .debug)
//                        #endif
//                    }
//                }
//            }
//        }
    }
    
    private func closeWindow() {
        
        let feedbackWindow = self.view.window
        
        assert(feedbackWindow != nil)
        if let feedbackWindow = feedbackWindow {
            
            feedbackWindow.close()
        }
        else {
            
            assert(false, "feedbackWindow is nil in dismissFeedbackModalSheet(...)")
            #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            os_log("feedbackWindow is nil in dismissFeedbackModalSheet(...)", log: Log.Stylo.all, type: .error)
            #endif
        }
    }
    
    private func buildEmailBody(using userText: inout String) {
        
        addStyloVersionNumber(to: &userText)
    }
    
    private func addStyloVersionNumber(to string: inout String) {
        
        let infoDictionary = Bundle.main.infoDictionary
        
        assert(infoDictionary != nil)
        if let infoDictionary = infoDictionary {
            
            //First get the nsObject by defining as an optional anyObject
            let any: Any? = infoDictionary["CFBundleShortVersionString"]
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = any as? String
            
            assert(version != nil)
            if let version = version {
            
                string += """
                
                
                Stylo version: \(version)
                """
            }
        }
    }
    
}
