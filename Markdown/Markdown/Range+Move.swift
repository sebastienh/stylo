//
//  Range+Move.swift
//  Markdown
//
//  Created by Sebastien hamel on 2019-05-03.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation

extension Range where Bound == Int {
    
    func moved(_ count: Int) -> Range<Int> {
        return self.lowerBound+count..<self.upperBound+count
    }
}
