//
//  FilesOutlineScrollPosition.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-09-29.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

public struct FilesOutlineScrollPosition {
    
    ///
    /// The position to which we want to scroll
    ///
    public let position: FilesOutlinePosition
    
    ///
    /// This Bool value indicates if we want to flash the text
    /// at position before scrolling.
    ///
    public let flash: Bool
    
    public init(position: FilesOutlinePosition, flash: Bool) {
        self.position = position
        self.flash = flash
    }
}
