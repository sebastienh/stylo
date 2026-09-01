//
//  RandomlyAccessibleCharacters.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-08-22.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol RandomlyAccessibleCharacters {

    var length: Int { get }
    
    func charAt(_ index: Int) -> UTF16.CodeUnit?
}
