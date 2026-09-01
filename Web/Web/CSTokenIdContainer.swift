//
//  TokenIdContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-18.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

protocol CSTokenIdContainer: class {
    
    func isTokenId(_ tokenId: Int) -> Bool
}
