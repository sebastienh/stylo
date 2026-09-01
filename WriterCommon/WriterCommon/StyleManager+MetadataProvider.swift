//
//  StyleManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-10-12.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation


extension StyleManager: MetadataProvider {
    
    public typealias MetadataType = StyleMetadata
    
    private var stylePreviewsMetadata: [String: TextStylePreviewMetadata]? {
        
        guard !self.stylePreviews.values.isEmpty else {
            return nil
        }
        
        var stylePreviewsMetadata: [String: TextStylePreviewMetadata] = [:]
        
        for (appearanceDescriptor, stylePreview) in self.stylePreviews.values {
            
            guard let textStylePreview = stylePreview as? TextStylePreview else {
                continue
            }
            
            stylePreviewsMetadata[appearanceDescriptor.key] = textStylePreview.metadata
        }
        
        if !stylePreviewsMetadata.isEmpty {
            return stylePreviewsMetadata
        }
        
        return nil
    }
    
    public var metadata: MetadataType? {
        return StyleMetadata.with {
            $0.id = self.id
            $0.title = self.title
            $0.stylesheets = self.stylesheets.compactMap({ (arg) -> StylesheetMetadata? in
                let (_, stylesheetManager) = arg
                // we dont save the user agent stylesheet
                if stylesheetManager.stylesheet?.origin != .userAgent {
                    return arg.value.metadata
                }
                return nil
            })
            if let stylePreviewsMetadata = stylePreviewsMetadata {
                $0.stylePreviews = stylePreviewsMetadata
            }
        }
    }
}

