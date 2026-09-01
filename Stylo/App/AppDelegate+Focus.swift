//
//  AppDelegate+Focus.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2020-07-29.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon
import StyloCoreMac

extension AppDelegate {

    @IBAction public func disableFocus(_ sender: Any) {
        
        StyloApplication.shared.disableFocus()
    }
    
    @IBAction public func selectSentenceFocus(_ sender: Any) {
        
        StyloApplication.shared.selectSentenceFocus()
    }
    
    @IBAction public func selectParagraphFocus(_ sender: Any) {
        
        StyloApplication.shared.selectParagraphFocus()
    }
    
    @IBAction public func selectBlocFocus(_ sender: Any) {
        
        StyloApplication.shared.selectBlocFocus()
    }
    
}
