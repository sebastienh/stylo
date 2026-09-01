//
//  StylableReducerType+Highlight.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-07-30.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import Web
import PromiseKit

extension StylableReducerType {

    func selectorList(from selectorsString: String) -> SelectorList? {

        return CSSSelectorsModule.shared.parse(selectorsString as NSString)
    }

}
