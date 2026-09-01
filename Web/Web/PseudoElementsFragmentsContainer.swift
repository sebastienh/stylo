//
//  PseudoElementsFragmentsContainer.swift
//  Web
//
//  Created by Sébastien Hamel on 2018-05-24.
//  Copyright © 2018 NM. All rights reserved.
//

import Foundation
import Common

protocol PseudoElementsFragmentsContainer {
    
    var pseudoElementsFragments: [String: SourceStringFragment] { get }
    
    var pseudoElementsString: String { get }
    
    func hasPseudoElement(with name: String) -> Bool
    
    func setPseudoElementSourceStringFragment(with name: String, to fragment: SourceStringFragment?)
    
    func pseudoElementSourceStringFragment(with name: String) -> SourceStringFragment?
}
