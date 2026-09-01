//
//  Metadata.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

public protocol MetadataProvider {
    
    associatedtype MetadataType: SwiftProtobuf.Message//, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding
    
    var metadata: MetadataType? { get }
    
}
