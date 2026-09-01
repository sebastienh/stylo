//
//  DocumentManagerProtocol.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-08-31.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import Common
import Web

public protocol DocumentManagerProtocol: class {
    
    var baseUrl: URL? { get }
    
    var printInfo: NSPrintInfo? { get }
    
    var pdfStyle: CSSStyle? { get }
    
    var wordStyle: CSSStyle? { get }
    
    var htmlStyle: CSSStyle? { get }
    
    var sourceSetManager: SourceSetManagerProtocol? { get }
    
    var editedTextManager: Dynamic<TextManager?> { get }
    
    /// This value present the selected items of the current
    /// selected files outline in one unified dynamic value which
    /// takes into account the selected outline change and
    /// the selected files change inside that selected outline.
    var selectedFilesOutlineSelectedTextItems: DynamicOrderedSet<String> { get }
    
    func pluginUrl(withName name: String) -> URL
    
}

extension DocumentManager: DocumentManagerProtocol {
    
    public var baseUrl: URL? {
        
        return self.documentUrl
    }
    
    public var printInfo: NSPrintInfo? {
        
        return self.document?.printInfo
    }
    
    public var pdfStyle: CSSStyle? {
        
        return self.document?.pdfDocumentStyle?.style.value
    }
    
    public var wordStyle: CSSStyle? {
        
        return self.document?.wordDocumentStyle?.style.value
    }

    public var htmlStyle: CSSStyle? {
        
        return self.document?.currentHTMLPreviewStyle?.style.value
    }
    
    public var sourceSetManager: SourceSetManagerProtocol? {
        return _sourceSetManager.value
    }
    
    public var editedTextManager: Dynamic<TextManager?> {
        return _editedTextManager
    }
    
    public var selectedFilesOutlineSelectedTextItems: DynamicOrderedSet<String> {
        return _selectedFilesOutlineSelectedTextItems
    }
    
    public func pluginUrl(withName name: String) -> URL {
        
        if let documentUrl = self.documentUrl {
            return documentUrl.appendingPathComponent(Constants.Filename.StyloProjectDirectoryName).appendingPathComponent(Constants.Filename.PluginsDataDirectoryFilename + "/" + name, isDirectory: true)
        }
        else {
            return FileManager.default.temporaryDirectory.appendingPathComponent(self.id + "/" + Constants.Filename.PluginsDataDirectoryFilename + "/" + name, isDirectory: true)
        }
    }
}
