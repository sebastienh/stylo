//
//  AttributesSortingMode.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-03.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation


///
/// AttributesSortingMode:
///
/// Defined the way the attributes coming from all text managers should
/// be classified or sorted.
///
/// attributes: attributes are sorted by name and each named attribute
/// has an associated OrderedSet [String: DynamicOrderedSet] which
/// publishes the changes made for this particular attributes values.
///
/// values: attributes values are sorted in alphabetical order with no
/// reference to the attribute names. In that case we only need to publish the
/// changes in the form of a OrderedSet which contains all the values.
///
public enum AttributesSortingMode {
    
    case attributes
    case values
}
