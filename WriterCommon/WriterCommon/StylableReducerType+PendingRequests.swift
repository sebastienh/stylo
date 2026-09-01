//
//  StylableReducerType+PendingRequests.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-05-30.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Igloo
import PromiseKit

extension StylableReducerType {

    private func updateAttributesRanges(_ attributesRanges: [([NSAttributedString.Key: Any], NSRange)], with request: SourceStringChangeDescription) -> [([NSAttributedString.Key: Any], NSRange)] {
        
        var result = [([NSAttributedString.Key: Any], NSRange)]()
        
        for attributesRange in attributesRanges {
            
            let _ranges = attributesRange.1.update(with: request)
            if let _ranges = _ranges {
                for _range in _ranges {
                    result.append((attributesRange.0, _range))
                }
            }
        }
        return result
    }
}
