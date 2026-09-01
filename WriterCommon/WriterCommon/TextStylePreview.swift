//
//  TextStylePreview.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-07-16.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Common


public struct TextStylePreview: StylePreview, Equatable {
    
    public enum Element: String, CaseIterable {
        
        case body
        case h1
        case h2
        case h3
        case h4
        case h5
        case h6
        case code
        case hr
        case blockquote
        case p
        case h1Tag
        case h2Tag
        case h3Tag
        case h4Tag
        case h5Tag
        case h6Tag
        
        var correspondingTagElement: Element? {
            
            switch self {
            case .h1:
                return Element.h1Tag
            case .h2:
                return Element.h2Tag
            case .h3:
                return Element.h3Tag
            case .h4:
                return Element.h4Tag
            case .h5:
                return Element.h5Tag
            case .h6:
                return Element.h6Tag
            default:
                return nil
            }
        }
        
        static func header(from number: Int) -> TextStylePreview.Element? {
            switch number {
            case 1: return .h1
            case 2: return .h2
            case 3: return .h3
            case 4: return .h4
            case 5: return .h5
            case 6: return .h6
            default: return nil
            }
        }
        
        static func headerTag(from number: Int) -> TextStylePreview.Element? {
            switch number {
            case 1: return .h1Tag
            case 2: return .h2Tag
            case 3: return .h3Tag
            case 4: return .h4Tag
            case 5: return .h5Tag
            case 6: return .h6Tag
            default: return nil
            }
        }
    }
    
    public static func ==(lhs: TextStylePreview, rhs: TextStylePreview) -> Bool {
        
        if lhs.attributesValue.count != rhs.attributesValue.count {
            return false
        }
        
        for (element, attributes) in lhs.attributesValue {
            
            let otherAttributes = rhs.attributesValue[element]
            
            if let otherAttributes = otherAttributes {
                if !attributes.equals(to: otherAttributes) {
                    return false
                }
            }
            else {
                return false
            }
        }
        return true 
    }
    
    public var backgroundColor: PlateformColorType? {
        
        if let attributes = attributesValue[.body] {
            if let color = attributes[.backgroundColor] as? PlateformColorType {
                return color.usingColorSpace(NSColorSpace.deviceRGB)
            }
        }
        return nil
    }
    
    public var h1TagColor: PlateformColorType? {
    
        return foregroundColor(for: .h1Tag)
    }
    
    public var h1Color: PlateformColorType? {
        
        return foregroundColor(for: .h1)
    }
    
    public var h2TagColor: PlateformColorType? {
        
        return foregroundColor(for: .h2Tag)
    }
    
    public var h2Color: PlateformColorType? {
        
        return foregroundColor(for: .h2)
    }
    
    public var h3TagColor: PlateformColorType? {
        
        return foregroundColor(for: .h3Tag)
    }
    
    public var h3Color: PlateformColorType? {
        
        return foregroundColor(for: .h3)
    }

    public var h4TagColor: PlateformColorType? {
        
        return foregroundColor(for: .h4Tag)
    }
    
    public var h4Color: PlateformColorType? {
        
        return foregroundColor(for: .h4)
    }

    public var h5TagColor: PlateformColorType? {
        
        return foregroundColor(for: .h5Tag)
    }
    
    public var h5Color: PlateformColorType? {
        
        return foregroundColor(for: .h5)
    }
    
    public var pColor: PlateformColorType? {
        
        return foregroundColor(for: .p)
    }
    
    public var pAttributes: [NSAttributedString.Key : Any]? {
        
        if let attributes = attributesValue[.p] {
            return attributes
        }
        return nil
    }

    public func foregroundColor(for element: TextStylePreview.Element) -> NSColor? {
        
        if let attributes = attributesValue[element] {
            if let color = attributes[NSAttributedString.Key.foregroundColor] as? PlateformColorType {
                return color.usingColorSpace(NSColorSpace.deviceRGB)
            }
        }
        return nil
    }
    
    public let attributesValue: [TextStylePreview.Element: [NSAttributedString.Key : Any]]
    
    init(attributesValue: [TextStylePreview.Element: [NSAttributedString.Key : Any]]) {
        
        self.attributesValue = attributesValue
    }
}
