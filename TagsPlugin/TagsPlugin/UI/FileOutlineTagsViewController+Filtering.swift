//
//  FileOutlineTagsViewController+Filtering.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-21.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension FileOutlineTagsViewController {
    
    func subscribeToControlTextDidChange() {
        
        guard let filterTextField = self.filterTextField else {
            assertionFailure("Error: self.filterTextField is nil")
            return
        }
        
        NotificationCenter.default.addObserver(forName: NSControl.textDidChangeNotification, object: filterTextField, queue: nil) { [weak self](notification) in
            self?.controlTextDidChange(notification)
        }
    }
    
    @objc func controlTextDidChange(_ obj: Notification) {
        
        let textField: NSTextField = obj.object as! NSTextField
        
        if !textField.stringValue.isEmpty {
            self.filterString = textField.stringValue
        }
        else if self.filterString != nil {
            self.filterString = nil
        }
    }
}
