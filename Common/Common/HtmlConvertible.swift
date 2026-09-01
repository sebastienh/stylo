//
//  HtmlConvertible.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-06-10.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#elseif os(iOS)
    import UIKit
#endif

protocol HtmlConvertible {
    
    var htmlToAttributedString: NSMutableAttributedString? { get }
    
    var htmlToString: String? { get }
}

extension String {
    
    public var htmlToAttributedString: NSMutableAttributedString? {
        
        do {
            
            return try NSMutableAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            
            print("error:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        
        return htmlToAttributedString?.string ?? ""
    }
}
