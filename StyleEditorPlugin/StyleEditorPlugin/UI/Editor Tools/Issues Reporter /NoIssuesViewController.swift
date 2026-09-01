//
//  NoIssuesViewController.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-04-26.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa
import WriterCommon

class NoIssuesViewController: NSViewController {
    
    @IBOutlet weak var noErrorsView: NoIssuesView!
    
    private var textManager: TextManager? {
        
        return self.styloDocument?.textManager
    }
}
