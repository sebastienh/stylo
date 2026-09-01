//
//  CSSToken.swift
//  Web
//
//  Created by Sébastien Hamel on 2016-09-24.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
import Common

struct CSSToken: Token, Equatable, Hashable, CustomStringConvertible {

    let tokenId: Int
    var rawStringValue: String
    var formattedStringValue: String?
    
    var stringRepresentation: String {
        return formattedStringValue ?? rawStringValue
    }
    
    var sourceStringSegment: SourceStringSegment? {
        get {
            return self.sourceStringFragment as? SourceStringSegment
        }
        set {
            self.sourceStringFragment = newValue
        }
    }
    
    var description: String {
        return "\n\(String(describing: sourceStringFragment))Token id: \(String(describing: CSTokenId(rawValue: tokenId)))\nString value: \(rawStringValue)\n"
    }
    
    static var ErrorToken = CSSToken(tokenId: §GenericTokenId.error, rawStringValue: "ERROR")
    
    init(tokenId: Int, rawStringValue: String) {
        self.tokenId = tokenId
        self.rawStringValue = rawStringValue
        self.messageHandler = MessageHandler()
    }
    
    init(sourceStringSegment: SourceStringSegment, tokenId: Int, rawStringValue: String, formattedStringValue: String?) {
        
        self.tokenId = tokenId
        self.rawStringValue = rawStringValue
        self.formattedStringValue = formattedStringValue
        self.sourceStringFragment = sourceStringSegment
        self.messageHandler = MessageHandler()
    }
    
    init(sourceStringSegment: SourceStringSegment, tokenId: Int, rawStringValue: String) {
        
        self.init(sourceStringSegment: sourceStringSegment, tokenId: tokenId, rawStringValue: rawStringValue, formattedStringValue: nil)
    }
        
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Hashable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.tokenId)
        hasher.combine(self.rawStringValue)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: Positionnable protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var sourceStringFragment: SourceStringFragment?
    
    /// This method translate the position of the fragment using
    // the count from which moving the fragment by adding this count
    // to the start and end index.
    public mutating func move(_ count: Int) {
        
        self.sourceStringSegment?.move(count)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //                                  MARK: MessageContainer protocol implementation
    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    var messageHandler: MessageHandler
    
}

func ==(lhs: CSSToken, rhs: CSSToken) -> Bool {
    
    return lhs.equals(to: rhs)
}

extension Token {
    
    /// We add this method as an extension to the protocol 
    /// because this method does not need more information 
    /// than there is available in the protocol Token.
    var cssTokenAdditionalApplicableDomClasses: [String] {
        
        // just making sure we don't do anything stupid in the code 
        // even if the Token type is not enfored at compile time.
        #if DEBUG
            assert(type(of: self) == CSSToken.self)
        #endif
        
        var applicableClasses = [String]()
        
        if self.tokenId == §CSTokenId.delimToken {
            
            if self.rawStringValue == "|" {
                
                applicableClasses.append(UnicodeCharacter.verticalLine.descriptionString())
            }
            else if self.rawStringValue == "~" {
                
                applicableClasses.append(UnicodeCharacter.tilde.descriptionString())
            }
            else if self.rawStringValue == ">" {
                
                applicableClasses.append(UnicodeCharacter.greaterThanSign.descriptionString())
            }
            else if self.rawStringValue == "+" {
                
                applicableClasses.append(UnicodeCharacter.plusSign.descriptionString())
            }
        }
        return applicableClasses
    }
    
}

