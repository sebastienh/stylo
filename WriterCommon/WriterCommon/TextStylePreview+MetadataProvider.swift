//
//  TextStylePreview+Metadata.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2021-01-05.
//  Copyright © 2021 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

extension TextStylePreview {
    
    public typealias MetadataType = TextStylePreviewMetadata
    
    public var metadata: MetadataType {
        
        return TextStylePreviewMetadata.with {

            if let color = self.backgroundColor?.metadata {
                $0.body = color
            }

            if let color = foregroundColor(for: .h1)?.metadata {
                $0.h1 = color
            }
            
            if let color = foregroundColor(for: .h2)?.metadata {
                $0.h2 = color
            }
            
            if let color = foregroundColor(for: .h3)?.metadata {
                $0.h3 = color
            }
            
            if let color = foregroundColor(for: .h4)?.metadata {
                $0.h4 = color
            }
            
            if let color = foregroundColor(for: .h5)?.metadata {
                $0.h5 = color
            }
            
            if let color = foregroundColor(for: .h6)?.metadata {
                $0.h6 = color
            }

            if let color = foregroundColor(for: .h1Tag)?.metadata {
                $0.h1Tag = color
            }
            
            if let color = foregroundColor(for: .h2Tag)?.metadata {
                $0.h2Tag = color
            }
            
            if let color = foregroundColor(for: .h3Tag)?.metadata {
                $0.h3Tag = color
            }
            
            if let color = foregroundColor(for: .h4Tag)?.metadata {
                $0.h4Tag = color
            }
            
            if let color = foregroundColor(for: .h5Tag)?.metadata {
                $0.h5Tag = color
            }
            
            if let color = foregroundColor(for: .h6Tag)?.metadata {
                $0.h6Tag = color
            }
            
            if let color = foregroundColor(for: .code)?.metadata {
                $0.code = color
            }

            if let color = foregroundColor(for: .hr)?.metadata {
                $0.hr = color
            }

            if let color = foregroundColor(for: .blockquote)?.metadata {
                $0.blockquote = color
            }
            
            if let color = foregroundColor(for: .p)?.metadata {
                $0.p = color
            }
        }
    }
}

extension NSColor {
    
    public typealias MetadataType = Color
    
    public var metadata: MetadataType {
        
        var alphaValue = SwiftProtobuf.Google_Protobuf_FloatValue()
        alphaValue.value = Float(self.alphaComponent)
        
        return Color.with {
            $0.red = Float(self.redComponent)
            $0.green = Float(self.greenComponent)
            $0.blue = Float(self.blueComponent)
            $0.alpha = alphaValue
        }
    }
}
