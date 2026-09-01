//
//  ProtoBufMessageProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-09-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

public protocol AnyMessageProvider {
    
    var anyMetadata: Google_Protobuf_Any? { get }
}
