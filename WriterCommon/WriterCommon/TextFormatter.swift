//
//  TextFormatter .swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-05-24.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common

public protocol TextFormatter {
    
    func handleInsertion(ofString string: String, with replacementRange: NSRange, in input: FormattableInput) -> Insertion?
    
    func handleOneCharacterInsertion(ofString string: String, with replacementRange: NSRange, in input: FormattableInput) -> Insertion?
    
    func handleOneCharacterDeletion(with replacementRange: NSRange, in input: FormattableInput) -> Insertion?
    
    func handleInsert(ofString string: String, in input: FormattableInput, withSelection range: NSRange) -> Insertion?
}

extension TextFormatter {
    
    func nextNonWhitespaceInputCharacter(from actualIndex: Int, in input: FormattableInput) -> UInt16? {
                    
        return nextNonWhitespaceInputCharacter(from: actualIndex, in: input.string)
    }
    
    func nextNonWhitespaceInputCharacter(from actualIndex: Int, in inputString: String) -> UInt16? {
        
        let numberOfWhitespaces = inputString.skipAllWhitespaces(fromPosition: actualIndex)
        
        let currentPosition = actualIndex + numberOfWhitespaces
        
        if currentPosition < inputString.length {
            
            return inputString.charAt(currentPosition)!
        }
        
        return nil
    }
}
