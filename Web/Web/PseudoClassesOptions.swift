//
//  ContextualPseudoClassesArray.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-07-19.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Common

/// In this dictionary we keep each possible combination,
/// each pseudo-classe are ordered the way they appear for
/// this paticular item.
///
public struct PseudoClassesOptions: OptionSet, Hashable, CustomStringConvertible {

    static func from(name: String) -> PseudoClassesOptions? {
        
        guard let optionName = OptionName(rawValue: name) else {
            return nil
        }
        
        return PseudoClassesOptions(rawValue: §optionName.type)
    }
    
    private enum OptionName: String {
        case focus
        case fade
        case flash
        case highlight
        case root
        
        var type: OptionType {
            switch self {
            case .focus:
                return .focus
            case .fade:
                return .fade
            case .flash:
                return .flash
            case .highlight:
                return .highlight
            case .root:
                return .root
            }
        }
    }
    
    enum OptionType: Int {
        case focus = 1
        case fade = 2
        case flash = 4
        case highlight = 8
        case root = 16
    }
    
    private var isEphemeral: Bool {
        
        guard let optionType: OptionType = OptionType(rawValue: self.rawValue) else {
            assertionFailure("Error: optionType is nil")
            return false
        }
       
        switch optionType {
        case .focus: fallthrough
        case .fade: fallthrough
        case .flash:
            return true
        case .highlight:
            return false
        case .root:
            return false
        }
    }
    
    public static var all: PseudoClassesOptions {
        
        return [.focus, .fade, .flash, .highlight, .root]
    }
    
    /// These options are the ones that can only be known by the
    /// renderer because it knows the rendering context.
    public var ephemerals: PseudoClassesOptions {
        
        var ephemeralOptions = PseudoClassesOptions()
        
        for option in self.elements {
            if option.isEphemeral {
                ephemeralOptions.formUnion(option)
            }
        }
        return ephemeralOptions
    }
    
    public var description: String {
        
        var string = "options"
        
        if self.isEmpty {
            string += ":empty"
            return string
        }
        for option in self.elements {
            
            guard let optionType: OptionType = OptionType(rawValue: option.rawValue) else {
                assertionFailure("Error: unsupported option: \(option)")
                string += ":unsupported"
                continue
            }
            
            switch optionType {
            case .focus:
                string += ":focus"
            case .fade:
                string += ":fade"
            case .flash:
                string += ":flash"
            case .highlight:
                string += ":highlight"
            case .root:
                string += ":root"
            }
        }
        return string
    }
    
    public let rawValue: Int
    
    public static let focus = PseudoClassesOptions(rawValue: OptionType.focus.rawValue)
    
    public static let flash = PseudoClassesOptions(rawValue: OptionType.flash.rawValue)
    
    public static let fade = PseudoClassesOptions(rawValue: OptionType.fade.rawValue)
    
    public static let highlight = PseudoClassesOptions(rawValue: OptionType.highlight.rawValue)
    
    public static let root = PseudoClassesOptions(rawValue: OptionType.root.rawValue)
    
    public static let empty: PseudoClassesOptions = []
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

fileprivate extension OptionSet where RawValue: FixedWidthInteger {

    var elements: AnySequence<Self> {
        var remainingBits = rawValue
        var bitMask: RawValue = 1
        return AnySequence {
            return AnyIterator {
                while remainingBits != 0 {
                    defer { bitMask = bitMask &* 2 }
                    if remainingBits & bitMask != 0 {
                        remainingBits = remainingBits & ~bitMask
                        return Self(rawValue: bitMask)
                    }
                }
                return nil
            }
        }
    }
}
