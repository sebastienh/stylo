//
//  TextStatistics.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-14.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public struct TextStatistics {
    
    /// Return a slow reading time in seconds.
    public var slowReadingTimeString: String {
        
        let totalSeconds = Int((Double(self.wordsCount)/Constants.TextStatistics.wordsPerMinuteSlow)*60)
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: totalSeconds)
        return timeString(from: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Return a fast reading time in seconds.
    public var fastReadingTimeString: String {
        
        let totalSeconds = Int((Double(self.wordsCount)/Constants.TextStatistics.wordsPerMinuteFast)*60)
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: totalSeconds)
        return timeString(from: hours, minutes: minutes, seconds: seconds)
    }
    
    /// Return an average reading time in seconds.
    public var averageReadingTimeString: String {
        
        let totalSeconds = Int((Double(self.wordsCount)/Constants.TextStatistics.wordsPerMinuteAverage)*60)
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: totalSeconds)
        return timeString(from: hours, minutes: minutes, seconds: seconds)
    }
    
    public var charactersCountString: String {
        
        return String(charactersCount)
    }
    
    public var wordsCountString: String {
        
        return String(wordsCount)
    }
    
    public var sentencesCountString: String {
        
        return String(sentencesCount)
    }
    
    public var paragraphsCountString: String {
        
        return String(paragraphsCount)
    }
    
    public var pagesCountString: String {
        
        return String(format: "%.1f", locale: Locale.current, arguments: [pagesCount])
    }
    
    public var charactersCount: Int
    
    public var wordsCount: Int
    
    public var sentencesCount: Int
    
    public var paragraphsCount: Int
    
    public var pagesCount: Float
    
    public static func from(_ string: String) -> TextStatistics {
        
        var textStatistics = TextStatistics()
        
        textStatistics.updateCharactersCount(from: string)
        textStatistics.updateWordsCount(from: string)
        textStatistics.updateSentencesCount(from: string)
        textStatistics.updateParagraphsCount(from: string)
        textStatistics.updatePagesCount(from: string)
        return textStatistics
    }
    
    
    init() {
        
        self.charactersCount = 0
        self.wordsCount = 0
        self.sentencesCount = 0
        self.paragraphsCount = 0
        self.pagesCount = 0
    }
    
    init(_ charactersCount: Int, _ wordsCount: Int, _ sentencesCount: Int, _ paragraphsCount: Int, _ pagesCount: Float) {
        
        self.charactersCount = charactersCount
        self.wordsCount = wordsCount
        self.sentencesCount = sentencesCount
        self.paragraphsCount = paragraphsCount
        self.pagesCount = pagesCount
    }
    
    private mutating func updateCharactersCount(from string: String) {
        
        self.charactersCount = string.filter({ (character) -> Bool in
            return !character.isNewline && !character.isWhitespace
        }).count
    }
    
    private mutating func updateWordsCount(from string: String) {
        
        var wordsCount: Int = 0
        let wholeString = string.startIndex..<string.endIndex
        
        string.enumerateSubstrings(in: wholeString, options: String.EnumerationOptions.byWords) { (_, _, _, _) in
            wordsCount += 1
        }
        self.wordsCount = wordsCount
    }
    
    private mutating func updatePagesCount(from string: String) {
        
        var linesCount: Int = 0
        let wholeString = string.startIndex..<string.endIndex
        
        string.enumerateSubstrings(in: wholeString, options: String.EnumerationOptions.byLines) { (string, _, _, _) in
            if string?.count == 0 {
                return
            }
            if string?.count == 1 && (string?.first?.isNewline == true || string?.first?.isWhitespace == true) {
                return
            }
            linesCount += 1
        }
        self.pagesCount = Float(Float(linesCount)/Float(30))
    }
    
    private mutating func updateSentencesCount(from string: String) {
        
        var sentencesCount: Int = 0
        let wholeString = string.startIndex..<string.endIndex
        
        string.enumerateSubstrings(in: wholeString, options: String.EnumerationOptions.bySentences) { (string, _, _, _) in
            if string?.count == 1 && (string?.first?.isNewline == true || string?.first?.isWhitespace == true) {
                return
            }
            sentencesCount += 1
        }
        self.sentencesCount = sentencesCount
    }
    
    private mutating func updateParagraphsCount(from string: String) {
        
        var paragraphsCount: Int = 0
        let wholeString = string.startIndex..<string.endIndex
        
        string.enumerateSubstrings(in: wholeString, options: String.EnumerationOptions.byParagraphs) { (string, _, _, _) in
            if string?.count == 0 {
                return
            }
            if string?.count == 1 && (string?.first?.isNewline == true || string?.first?.isWhitespace == true) {
                return
            }
            paragraphsCount += 1
        }
        self.paragraphsCount = paragraphsCount
    }
    
    private func timeString(from hours: Int, minutes: Int, seconds: Int) -> String {
        
        var timeString = ""
        
        if hours > 0 {
            timeString = "\(minutes) min \(timeString)"
            timeString = "\(hours) h \(timeString)"
        }
        else {
            timeString = "\(seconds) sec"
            timeString = "\(minutes) min \(timeString)"
        }
        
        return timeString
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
}

extension TextStatistics {

    static public func -(lhs: TextStatistics, rhs: TextStatistics) -> TextStatistics {
    
        return TextStatistics(lhs.charactersCount - rhs.charactersCount, lhs.wordsCount - rhs.wordsCount, lhs.sentencesCount - rhs.sentencesCount, lhs.paragraphsCount - rhs.paragraphsCount, lhs.pagesCount - rhs.pagesCount)
    }
}
