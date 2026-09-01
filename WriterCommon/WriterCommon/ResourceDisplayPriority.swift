//
//  ResourceDisplayPriority.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-06-10.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public enum ResourceDisplayPriority {
    
    case interactive // this document is currently displayed
    case reactive // the document is not displayed but must react rapidly to it's display
    case background // the document is not displayed and we can tolerate some layout delay
}
