//
//  Swift+CVargArg.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-07-24.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

prefix operator %%
public prefix func %% <T>(item : T) -> String {
    return "\(item)"
}
