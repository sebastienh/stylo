//
//  TextManager+DirectoryItemManager.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-26.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension TextManager: DirectoryItemManager {
    public var isExpandable: Bool {
        return false
    }
}
