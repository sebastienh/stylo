//
//  WritingSession.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import SwiftProtobuf

struct WritingSession {
    
    let startDate: Date
    
    var textStatistics: TextStatistics
    
    var writingSessionMetadata: WritingSessionMetadata {
        
        var writingSessionMetadata = WritingSessionMetadata()
        writingSessionMetadata.startDate = SwiftProtobuf.Google_Protobuf_Timestamp(date: startDate)
        writingSessionMetadata.charactersCount = Int32(textStatistics.charactersCount)
        writingSessionMetadata.wordsCount = Int32(textStatistics.wordsCount)
        writingSessionMetadata.sentencesCount = Int32(textStatistics.sentencesCount)
        writingSessionMetadata.paragraphsCount = Int32(textStatistics.paragraphsCount)
        writingSessionMetadata.pagesCount = textStatistics.pagesCount
        return writingSessionMetadata
    }
    
    init(session: WritingSessionMetadata) {
        
        let textStatistics = TextStatistics(Int(session.charactersCount), Int(session.wordsCount), Int(session.sentencesCount), Int(session.paragraphsCount), session.pagesCount)
        
        self.init(startDate: session.startDate.date, textStatistics: textStatistics)
        
    }
    
    init(textStatistics: TextStatistics) {
        
        self.startDate = Date()
        self.textStatistics = textStatistics
    }
    
    init(startDate: Date, textStatistics: TextStatistics) {
        
        self.startDate = startDate
        self.textStatistics = textStatistics
    }
    
}
