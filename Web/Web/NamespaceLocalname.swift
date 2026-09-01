//
//  NamespaceLocalname.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-05-27.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation


final class NamespaceLocalname: Hashable {
    
    let namespaceURI: String?
    
    let localname: String
    
    var hashValue: Int {
        
        if let namespaceURI = namespaceURI {
            
            return "\(namespaceURI)\(localname)".hashValue
        }
        
        return "\(localname)".hashValue
    }
    
    init(namespaceURI: String?, localname: String) {
        
        self.namespaceURI = namespaceURI
        self.localname = localname
    }
}

func ==(lhs: NamespaceLocalname, rhs: NamespaceLocalname) -> Bool {
    
    return lhs.hashValue == rhs.hashValue
}
