//
//  MarkdownBasicTests.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2016-03-13.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
import Common
@testable import Markdown

struct StringChange: CustomDebugStringConvertible, CustomStringConvertible {
    
    let affectedRange: NSRange
    let replacementString: String
    var replacementRange: NSRange?
    
    var debugDescription: String {
        
        return description
    }
    
    var description: String {
        
        return "{ affectedRange: \(affectedRange), replacementString: ->\(replacementString)<-}, replacementRange: \(replacementRange)"
    }
    
    init(affectedRange: NSRange, replacementString: String) {
        
        self.affectedRange = affectedRange
        self.replacementString = replacementString
    }
    
    init(affectedRange: NSRange, replacementRange: NSRange, string: String) {
        
        self.affectedRange = affectedRange
        self.replacementRange = replacementRange
        self.replacementString = string.substring(replacementRange.location, length: replacementRange.length)!
    }
}

class MarkdownBasicTests: XCTestCase {
    
    var randomChangeType: SourceStringChangeDescription.ChangeType? {
        
        let changeType = Int.random(in: 0..<6)
        switch changeType {
        case 0:
            return .pureAddition
        case 1:
            return .pureRemoval
        case 2:
            return .pureReplace
        case 3:
            return .replaceAddition
        case 4:
            return .replaceRemoval
        case 5:
            return .unchanged
        default:
            return nil
        }
    }
    
    func randomStringChange(from sourceString: String, changeType: SourceStringChangeDescription.ChangeType) -> StringChange? {
        
        func randomRange() -> NSRange {
            
            let replacementOrigin = Int.random(in: 0...sourceString.utf16.count)
            let replacementEnd = Int.random(in: replacementOrigin...sourceString.utf16.count)
            let changeLenght = replacementEnd - replacementOrigin
            return NSMakeRange(replacementOrigin, changeLenght)
        }
        
        func randomRange(of length: Int) -> NSRange {
            
            let replacementOrigin = Int.random(in: 0..<sourceString.utf16.count-length)
            let replacementEnd = replacementOrigin + length
            let changeLenght = replacementEnd - replacementOrigin
            return NSMakeRange(replacementOrigin, changeLenght)
        }
        
        func randomRange(smallerThen length: Int) -> NSRange {
            
            let replacementLength = Int.random(in: 0..<length)
            let replacementOrigin = Int.random(in: 0...sourceString.utf16.count-replacementLength)
            let replacementEnd = replacementOrigin + replacementLength
            let changeLenght = replacementEnd - replacementOrigin
            return NSMakeRange(replacementOrigin, changeLenght)
        }
        
        func randomRange(biggerThen length: Int) -> NSRange {
            
            let replacementLength = Int.random(in: length+1..<sourceString.utf16.count)
            let replacementOrigin = Int.random(in: 0...sourceString.utf16.count-replacementLength)
            let replacementEnd = replacementOrigin + replacementLength
            let changeLenght = replacementEnd - replacementOrigin
            return NSMakeRange(replacementOrigin, changeLenght)
        }
        
        switch changeType {
            
        case .pureAddition:
            
            let replacementRange = randomRange()
            let replacementString = sourceString.substring(replacementRange.location, length: replacementRange.length)!
            let insertionIndex = Int.random(in: 0...sourceString.count)
            var stringChange = StringChange(affectedRange: NSMakeRange(insertionIndex, 0), replacementString: replacementString)
            stringChange.replacementRange = replacementRange
            return stringChange
            
        case .pureRemoval:
            
            return StringChange(affectedRange: randomRange(), replacementString: "")
            
        case .pureReplace:
            
            let replacedRange = randomRange()
            let replacementStringRange = randomRange(of: replacedRange.length)
            let replacementString = sourceString.substring(replacementStringRange.location, length: replacementStringRange.length)!
            var stringChange = StringChange(affectedRange: replacedRange, replacementString: replacementString)
            stringChange.replacementRange = replacementStringRange
            return stringChange
            
        case .replaceAddition:
            
            let replacedRange = randomRange()
            let replacementStringRange = randomRange(biggerThen: replacedRange.length)
            let replacementString = sourceString.substring(replacementStringRange.location, length: replacementStringRange.length)!
            var stringChange = StringChange(affectedRange: replacedRange, replacementString: replacementString)
            stringChange.replacementRange = replacementStringRange
            return stringChange
            
        case .replaceRemoval:
            
            let replacedRange = randomRange()
            let replacementStringRange = randomRange(smallerThen: replacedRange.length)
            let replacementString = sourceString.substring(replacementStringRange.location, length: replacementStringRange.length)!
            var stringChange = StringChange(affectedRange: replacedRange, replacementString: replacementString)
            stringChange.replacementRange = replacementStringRange
            return stringChange
            
        case .unchanged:
            
            return nil
        }
    }
    
    func executeTestWithString(_ string: String, andFile fileName: String) {
        
        let markdownItResultString = try! String(contentsOf: urlOfFile(named: fileName)!, encoding: String.Encoding.utf8)
        
        let md = MarkdownParser()
        
        let tokens = md.parse(string)
        
        XCTAssert(tokens.length != 0)
        
        let tokenString = replaceAllWhitespaces(tokens.toString())
        let expectedString = replaceAllWhitespaces(markdownItResultString)
        
//        if tokenString != expectedString {
//            
//            displayStringDifferences(tokenString, string2: expectedString)
//        }
        
        XCTAssert(tokenString == expectedString)
        
        print(tokens.toString())
    }
    
    func replaceAllWhitespaces(_ string: String) -> String {
        
        return string.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
    }
    
    func urlOfFile(named name: String) -> URL? {
        
        let unitTestBundle = Bundle(for: type(of: self))
        let resourcesDirectoryURL = unitTestBundle.resourceURL!
        let fileManager = FileManager.default
        let resourcesDirectoryURLs: [URL] = (try! fileManager.contentsOfDirectory(at: resourcesDirectoryURL, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants))
        
        for url in resourcesDirectoryURLs {
            
            let last = url.lastPathComponent
            
            if last == name {
                
                return url
            }
        }
        return nil
    }
    
    func displayStringDifferences(_ string1: String, string2: String) {
        
        let characterRange: Int = 5
        
        debugPrint("The two strings are different:")
        
        var index: Int = 0
        
        while let charString1 = string1.charAt(index), let charString2 = string2.charAt(index) {
            
            if charString1 != charString2 {
                
                debugPrint("characers are different at index: \(index): first string: \(String(describing: UnicodeScalar(charString1)!)), second string: \(String(describing: UnicodeScalar(charString2)!))")
                
                let firstStringExtract = string1.slice(index - characterRange, end: index + characterRange)
                let secondStringExtract = string2.slice(index - characterRange, end: index + characterRange)
                
                debugPrint("First string extract: \(firstStringExtract)")
                debugPrint("Second string extract: \(secondStringExtract)")
                break
            }
            
            index += 1 
        }
    }
}
