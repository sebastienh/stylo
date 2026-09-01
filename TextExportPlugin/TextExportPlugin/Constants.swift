//
//  Constants.swift
//  TextExportPlugin
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Sebastien Hamel. All rights reserved.
//

import Foundation
import Common
import WriterCommon

#if os(OSX)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

public struct Constants {
    
    public struct Plugin {
        public static let Name = §TextuallyPlugin.exportText
    }
    
    public struct Panel {
        
        public static let Name: String = "Text" //NSLocalizedString("panelName", comment: "Name of the panel")
    }
}

