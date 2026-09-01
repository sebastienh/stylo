//
//  CSSPropertyDefinition.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-04-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common

final class CSSPropertyDefinition<T> : PropertyDefinition {
    
    let property: CSSProperty
    let initial: T
    let domain: [ElementType]
    let type: CSSValueType
    let inherited: Bool
    let media: Media
    
    init(property: CSSProperty, initial: T, domain: [ElementType], type: CSSValueType, inherited: Bool, media: Media) {
        self.property = property
        self.initial = initial
        self.domain = domain
        self.type = type
        self.inherited = inherited
        self.media = media
    }
}
