//
//  URL+Additions.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-03-16.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Common

extension URL {
    
    public func contentsUrls(withExtension pathExtension: String) -> [URL]? {
        
        let urls = try! FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: .skipsPackageDescendants).filter({ (url) -> Bool in
            return url.pathExtension == pathExtension
        })
        return urls
    }
}
