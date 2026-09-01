//
//  DocumentAudioFilesViewDelegate.swift
//  StyloAudioPlugin
//
//  Created by Sebastien hamel on 2019-11-02.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation

protocol DocumentAudioFilesViewDelegate: class {
    
    func showRightButtons()
    
    func hideRightButtonsIfNecessary()
}
