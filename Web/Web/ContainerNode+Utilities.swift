//
//  ContainerNode+Utilities.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-21.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension ContainerNode {
    
    public var textValue: String? {
        
        guard let childNodes = self.childNodes else {
            return nil
        }
        
        var _textValue = ""
        for node in childNodes {
            if let childContainerNode = node as? ContainerNode {
                _textValue += childContainerNode.textValue ?? ""
            }
            else if let text = node as? CharacterData {
                _textValue += text.data
            }
        }
        return _textValue
    }
}
