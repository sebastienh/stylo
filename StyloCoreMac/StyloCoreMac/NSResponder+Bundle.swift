//
//  Any+Bundle.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-29.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

extension NSResponder {
    
    public var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
}
