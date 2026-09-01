//
//  DeclarationStop.swift
//  Web
//
//  Created by Sebastien Hamel on 2021-01-11.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation

struct StopParsingRequest {
    
    enum StopType {
        
        // define a stop index inside the style declaration
        // to parse only some declarations. In this case the
        // index is the index of the last semicolon to be parsed
        case declaration
        case selectorList
        case rule
    }

    let index: Int

    let type: StopType
}
