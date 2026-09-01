import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

#if os(OSX)
    public typealias PlateformColorType = NSColor
#else
    public typealias PlateformColorType = UIColor
#endif

#if os(OSX)
public typealias PlateformFontType = NSFont
#else
public typealias PlateformFontType = UIFont
#endif

@objc public class DocumentAttributes: NSObject {
    
    public var backgroundColor: PlateformColorType?
    
    public var font: PlateformFontType?
    
    public var caretColor: PlateformColorType?
    
    public init(attrs: [NSAttributedString.Key : Any]?) {
        
        if let attrs = attrs {
            
            for (attrName, value) in attrs {
                
                switch attrName {
                    
                case .backgroundColor:
                    self.backgroundColor = (value as! PlateformColorType)
                case .font:
                    self.font = (value as! PlateformFontType)
                case StyloAttribute.caretColor.key :
                    self.caretColor = (value as! PlateformColorType)
                default:
                    break
                }
            }
        }
    }
}

