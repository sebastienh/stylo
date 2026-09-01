//
//  AttributesSerializer.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-28.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation

public protocol AttributesSerializer {
    
    func serializeXMLAttributes(_ element: Element, namespacePrefixMap: inout [String: String], generatedNamespacePrefixIndex prefixIndex: inout Int, ignoreNamespaceDefinitionAttribute: Bool, duplicatePrefixDefinition: String?, requireWellFormed: Bool) throws -> String
}
