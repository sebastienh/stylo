//
//  StyloWindowController+UserConfirmations.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-08-07.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

extension StyloWindowController {
    
    func notifyRenameError(error: RenameError, completion: (() -> ())? = nil) {
        
        notifyUserInformation(with: error, completion: completion)
    }
    
    func notifyUserInformation(with error: LocalizedError, completion: (() -> ())? = nil) {
        
        let alert = NSAlert()
        guard let errorDescription = error.errorDescription else {
            assertionFailure("Error: missing errorDescription in error: \(error)")
            return
        }
        alert.messageText = errorDescription
        
        if let failureReason = error.failureReason {
            alert.informativeText = failureReason
        }
        alert.alertStyle = .informational
        alert.beginSheetModal(for: self.window!) { (response) in
            completion?()
        }
    }
    
    func notifyUserCritical(with error: LocalizedError) {
        
        print("error.errorDescription: \(String(describing: error.errorDescription))")
        
        let alert = NSAlert()
        
        if let errorDescription = error.errorDescription {
            alert.messageText = errorDescription
        }
        if let failureReason = error.failureReason {
            alert.informativeText = failureReason
        }
        alert.alertStyle = .critical
        alert.beginSheetModal(for: self.window!) { (response) in
            // nothing to do
        }
    }
    
    func notifyUserWarning(with error: LocalizedError) {
        
        let alert = NSAlert()

        if let errorDescription = error.errorDescription {
            alert.messageText = errorDescription
        }
        if let failureReason = error.failureReason {
            alert.informativeText = failureReason
        }
        alert.alertStyle = .warning
        alert.beginSheetModal(for: self.window!) { (response) in
            // nothing to do
        }
    }
}
