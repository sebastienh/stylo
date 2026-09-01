//
//  DataSavingPlugin.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-21.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

public protocol DataPlugin: Saving {
    
    /// New document.
    func initData()
    
    /// Reading existing document.
    func readData(from fileWrapper: FileWrapper?) throws
    
}


