//
//  DocumentPosition.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-06.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common 

//
//    const unsigned short DOCUMENT_POSITION_DISCONNECTED = 0x01;
//    const unsigned short DOCUMENT_POSITION_PRECEDING = 0x02;
//    const unsigned short DOCUMENT_POSITION_FOLLOWING = 0x04;
//    const unsigned short DOCUMENT_POSITION_CONTAINS = 0x08;
//    const unsigned short DOCUMENT_POSITION_CONTAINED_BY = 0x10;
//    const unsigned short DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC = 0x20;

enum DocumentPosition : UInt16 {
    case document_POSITION_EQUIVALENT = 0x00
    case document_POSITION_DISCONNECTED = 0x01
    case document_POSITION_PRECEDING = 0x02
    case document_POSITION_FOLLOWING = 0x04
    case document_POSITION_CONTAINS = 0x08
    case document_POSITION_CONTAINED_BY = 0x10
    case document_POSITION_IMPLEMENTATION_SPECIFIC = 0x20
}
