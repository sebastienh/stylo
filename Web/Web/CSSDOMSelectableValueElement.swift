//
//  CSSDOMSelectableValueElement.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-05-15.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public protocol CSSDOMSelectableValueElement {
    
    /// NW-160 : selected-value
    /// This property value container is used to keep a reference to the value
    /// that this element express e.g.
    ///
    /// font-family : "arial";
    ///
    /// This container would contain
    /// CSSPropertyValueContainer.FontFamily(CSSFontFamily.Custom("arial"))
    var propertyValue: CSSPropertyValueContainer? { get set }
    
}
