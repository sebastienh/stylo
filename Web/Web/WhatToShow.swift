//
//  WhatToShowFilterType.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2014-10-19.
//  Copyright (c) 2014 CM. All rights reserved.
//

import Foundation

//https://dom.spec.whatwg.org/#nodefilter
//    // Constants for whatToShow
//    const unsigned long SHOW_ALL = 0xFFFFFFFF;
//    const unsigned long SHOW_ELEMENT = 0x1;
//    const unsigned long SHOW_ATTRIBUTE = 0x2; // historical
//    const unsigned long SHOW_TEXT = 0x4;
//    const unsigned long SHOW_CDATA_SECTION = 0x8; // historical
//    const unsigned long SHOW_ENTITY_REFERENCE = 0x10; // historical
//    const unsigned long SHOW_ENTITY = 0x20; // historical
//    const unsigned long SHOW_PROCESSING_INSTRUCTION = 0x40;
//    const unsigned long SHOW_COMMENT = 0x80;
//    const unsigned long SHOW_DOCUMENT = 0x100;
//    const unsigned long SHOW_DOCUMENT_TYPE = 0x200;
//    const unsigned long SHOW_DOCUMENT_FRAGMENT = 0x400;
//    const unsigned long SHOW_NOTATION = 0x800; // historical

// Removed the historical elements
// since we are not going to implement anything
// that is historical.
enum WhatToShow : UInt64 {
    
    case show_ALL = 0xFFFFFFFF;
    case show_ELEMENT = 0x1;
    case show_TEXT = 0x4;
    case show_PROCESSING_INSTRUCTION = 0x40;
    case show_COMMENT = 0x80;
    case show_DOCUMENT = 0x100;
    case show_DOCUMENT_TYPE = 0x200;
    case show_DOCUMENT_FRAGMENT = 0x400;
    
}
