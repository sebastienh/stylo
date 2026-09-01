//
//  DocumentAudioFilesViewController+DocumentAudioFilesViewDelegate.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-02.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation

extension DocumentAudioFilesViewController: DocumentAudioFilesViewDelegate {
    
    func hideRightButtonsIfNecessary() {
        if !self.selected {
            if let recordButton = recordButton, !recordButton.pulsating {
                showHideButton?.isHidden = true
                recordButton.isHidden = true
            }
        }
    }
    
    func showRightButtons() {
        showHideButton?.isHidden = false
        recordButton?.isHidden = false
    }
    
}
