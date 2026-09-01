//
//  StylableStringContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-10-28.
//  Copyright © 2015 NM. All rights reserved.
//

import Foundation
import Common

public protocol StylableStringContainer: class {
    
    var stylableString: StylableString { get }
}
