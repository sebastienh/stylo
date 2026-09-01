//
//  StatisticallyAnalysableStore.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-17.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import Igloo
import Common

enum StatisticsAction: ActionType {

    case load(writingSessions: WritingSessionsMetadata)
    
    case updateStatistics
    
    case selectionStatistics(selectionRange: NSRange?)
    
    case startWritingSession
    
    case show
    
    case hide
    
    case writingSessionsMetadata
}

enum StatisticsResult: ActionResult {
    
    case writingSessionsMetadata(writingSessions: WritingSessionsMetadata)
    
    case selectionStatisitics(statistics: TextStatistics?)
    
    var statistics: TextStatistics? {
        switch self {
        case .writingSessionsMetadata:
            return nil
        case .selectionStatisitics(statistics: let statistics):
            return statistics
        }
    }
    
}

protocol StatisticallyAnalysableStore {
    
    var totalStatistics: Dynamic<TextStatistics?> { get }
    
    var sessionStatistics: Dynamic<TextStatistics?> { get }
    
    var sessionStartDate: Dynamic<Date?> { get }
    
    var writingSessions: Dynamic<Array<WritingSession>> { get }
    
    var writingSessionHidden: Dynamic<Bool?> { get }
    
    var textStatisticsQueue: DispatchQueue { get }
}
