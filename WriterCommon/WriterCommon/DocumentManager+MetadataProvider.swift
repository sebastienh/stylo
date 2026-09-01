//
//  DocumentManager+MetadataProvider.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2019-07-30.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation


extension DocumentManager: MetadataProvider {
    
    public typealias MetadataType = DocumentMetadata
    
    public var metadata: DocumentMetadata? {

//        let action = StatisticallyAnalysableStoreActionsFactory.writingSessionsMetadataSyncAction()
//        let result = self.dispatcher.sync(store: self.documentStore, action: action)
//
//        var writingSessionsMetadata: WritingSessionsMetadata? = nil
//
//        if let statisticallyAnalysableActionResult = result as? StatisticallyAnalysableActionResult {
//            switch statisticallyAnalysableActionResult {
//            case .writingSessionsMetadata(let writingSessions):
//                if !writingSessions.sessions.isEmpty {
//                    writingSessionsMetadata = writingSessions
//                }
//            }
//        }
        
        return DocumentMetadata.with {
            $0.id = self.id
            $0.name = self.name.value
            $0.releaseVersion = SemanticVersion.bundleSemanticVersion ?? Constants.Version.currentReleaseVersion
            if let sourceSetMetadata = self._sourceSetManager.value?.metadata {
                $0.sourceSet = sourceSetMetadata
            }
//            if StyloApplication.shared.product == .stylo || self.document.stylesLoadedFromOldStyloDocument {
//                if let styleSetMetadata = self.styleSetManager.value?.metadata {
//                    $0.styleSet = styleSetMetadata
//                }
//            }
            if let filesOutlineSetManagerMetadata = self.filesOutlineSetManager.value?.metadata {
                $0.filesOutlineSet = filesOutlineSetManagerMetadata
            }
//            if let writingSessionsMetadata = writingSessionsMetadata {
//                $0.writingSessions = writingSessionsMetadata
//            }
            $0.formatVersion = Constants.Versions.project
            if let globalStyleId = self.globalStyleId.value {
                $0.globalStyleID = globalStyleId
            }
        }
    }
}
