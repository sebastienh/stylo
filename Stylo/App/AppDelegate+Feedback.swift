//
//  AppDelegate+Feedback.swift
//  Stylo
//
//  Created by Sebastien hamel on 2018-12-25.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import os

extension AppDelegate {
    
    @IBAction public func openFeedbackPanel(_ sender: Any) {
        
        guard let url = URL(string: "https://www.textually.net/contact") else {
            assertionFailure("Error: url is nil")
            return
        }
        
        NSWorkspace.shared.open(url)
    }
    
}
