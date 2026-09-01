//
//  AutocompleteResult.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-03-09.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

enum AutocompleteResult {
    
    case emptyResult
    case emptyResultForSelectedLanguages
    case nonEmptyResult(keys: [AutocompleteEntry])
}
