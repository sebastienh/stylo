//
//  MacUITransientState.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-01-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import WriterCommon
import Common

struct MacUITransientState: UITransientState {
    
    let sidebarsShow = Dynamic<Bool>(false)
    
}
