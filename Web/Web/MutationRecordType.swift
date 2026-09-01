//
//  MutationRecordType.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-02-11.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation
import Common

enum MutationRecordType : String {
    
    case Attributes = "attributes"
    case ChildList = "childList"
    case CharacterData = "characterData"
}
