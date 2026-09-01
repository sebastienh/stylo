//
//  CascadingOrigin.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-09-17.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation

/// This type defines where the property comes from in the
/// cascading process.
/// The possible values are:
/// cascaded: the property was cascaded from the rules that applies to the element
/// inherited: it's been derived from the inhering process
/// defaulted: it's been assigned a default value in abscence of specified and cascaded value
/// none: no cascading phase origin defined.
public enum CascadingPhaseOrigin {
    
    case cascaded
    case inherited
    case defaulted
    case none 
}
