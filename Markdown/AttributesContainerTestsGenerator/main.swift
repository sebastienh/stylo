//
//  main.swift
//  TablesTestsGenerator
//
//  Created by Sébastien Hamel on 2016-05-20.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation

extension String {
    
    ///
    public var inlineBufferEnabled: Bool {
        
        get {
            return false
        }
        set {
            // nothing to do
        }
    }
    
    public init(string: String) {
        
        self.init(string)
    }
    
    public var string: String {
        
        return self
    }
    
    mutating public func replaceAll(_ expression: NSRegularExpression, withTemplate template: String) {
        
        replaceAll(expression, withTemplate: template)
    }
    
    public func replacingOccurrences(of target: String, with replacement: String) -> String {
        
        return (self as NSString).replacingOccurrences(of: target, with: replacement, range: NSMakeRange(0, length))
    }
    
    public func charAt(_ index: Int, isEqualTo char: UTF16.CodeUnit) -> Bool {
        
        if let charAtIndex = charAt(index), charAtIndex == char {
            
            return true
        }
        return false
    }
    
    public func charAt(_ integerIndex: Int) -> UTF16.CodeUnit? {
        
        if integerIndex < 0 {
            return nil
        }
        
        let index = String.UTF16Index(encodedOffset: integerIndex)
        
        if index < utf16.endIndex{
            return utf16[index]
        }
        
        return nil
    }
    
    public var length: Int {
        
        return utf16.count
    }
    
    /// Method that return the substring based on the String.Index unit, the Character.
    /// The end index is the up-to index (not including)
    public func slice(_ start: Int, end: Int? = nil) -> String? {
        
        let length = self.length
        var localEnd = end
        let localStart = start < 0 ? length + start : start
        
        if let _localEnd = localEnd {
            
            if start == _localEnd {
                
                return ""
            }
            
            if _localEnd < 0 {
                
                localEnd = length + _localEnd
            }
        }
        else {
            
            localEnd = length
        }
        let utf16View = self.utf16
        
        let _startIndex = utf16View.index(utf16View.startIndex, offsetBy: localStart)
        
        if localEnd! == utf16.count {
            
            return String(utf16View[_startIndex..<utf16View.endIndex])
        }
        else {
            
            let _endIndex = utf16View.index(_startIndex, offsetBy: localEnd! - localStart)
            
            return String(utf16View[_startIndex..<_endIndex])
        }
    }
    
    public func extractStringFromSegment(_ segment: (start: Int, end: Int)) -> String? {
        
        let utf16View = self.utf16
        
        let startIndex = utf16View.index(utf16View.startIndex, offsetBy: segment.start)
        
        if segment.end == utf16View.count {
            return String(utf16View[startIndex..<utf16View.endIndex])
        }
        else {
            let endIndex = utf16View.index(utf16View.startIndex, offsetBy: segment.end - segment.start)
            return String(utf16View[startIndex..<endIndex])
        }
    }
    
    public func trimWhitespaces() -> String {
        //Returns "Let's trim the whitespace"
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    public func hasPrefixFromPositionCaseSensitive(_ prefix: String, fromPosition position: Int = 0) -> Bool {
        
        let count = min(length, prefix.length)
        
        if count < prefix.length {
            return false
        }
        
        var i = position
        var prefixIndex = 0
        
        while prefixIndex < prefix.length {
            if !charAt(i, isEqualTo: prefix.charAt(prefixIndex)!) {
                return false
            }
            prefixIndex += 1
            i += 1
        }
        
        return true
    }
    
    public func hasPrefix(_ prefix: String) -> Bool {
        
        return hasPrefixFromPositionCaseSensitive(prefix)
    }
}

let markdownSourceTestPrefix = "```````````````````````````````` example"
let markdownSourceTestSuffix = "````````````````````````````````"

if CommandLine.arguments.count != 2 {
    
    print("Run like: ./MarkdownSpecTestsGenerator ./spec.txt.\n")
    exit(EXIT_FAILURE)
}

let path = CommandLine.arguments[1]
let url = NSURL.fileURL(withPath: path)

let specString = try! String(contentsOf: url)

func parseTests(specString: String) -> String {
    
    var tests = "//\n"
    tests += "//  MarkdownAttributesContainerTests.swift\n"
    tests += "\n"
    tests += "//  Created by Sébastien Hamel on 2016-04-18.\n"
    tests += "//  Copyright © 2016 Textually Inc. All rights reserved.\n"
    tests += "//\n"
    tests += "\n"
    tests += "import XCTest\n"
    tests += "\n"
    
    tests += "class MarkdownAttributesContainerTests : MarkdownSpecTestsBase {\n\n"
    
    var currentStringIndex = 0
    
    var testNumber = 1
    
    while specString.charAt(currentStringIndex) != nil {
        
        if isStartOfTestAtIndex(currentStringIndex: currentStringIndex, string: specString) {
            
            let (testString, _currentStringIndex) = createTest(currentStringIndex: currentStringIndex, testString: specString, withNumber: testNumber)
            
            tests += testString
            currentStringIndex = _currentStringIndex
            
            testNumber += 1
        }
        else {
            
            currentStringIndex += 1
        }
    }
    
    tests += "\n}"
    
    return tests
}

func createTest(currentStringIndex: Int, testString: String, withNumber number: Int) -> (String, Int) {
    
    var (markdowSource, expectedHTMLIndex) = parseTestMarkdownSource(testString: testString, fromIndex: currentStringIndex)
    var (expectedHTML, endTestIndex) = parserTestExpectedHTML(testString: testString, fromIndex: expectedHTMLIndex)
    
    var testString = ""
    
    testString += "func test\(number)() {\n"
    
    markdowSource = markdowSource.replacingOccurrences(of: "\\", with: "\\\\")
    markdowSource = markdowSource.replacingOccurrences(of: "\"", with: "\\\"")
    markdowSource = markdowSource.replacingOccurrences(of: "\n", with: "\\n")
    markdowSource = markdowSource.replacingOccurrences(of: "→", with: "\\t")
    expectedHTML = expectedHTML.replacingOccurrences(of: "\\", with: "\\\\")
    expectedHTML = expectedHTML.replacingOccurrences(of: "\"", with: "\\\"")
    expectedHTML = expectedHTML.replacingOccurrences(of: "\n", with: "\\n")
    expectedHTML = expectedHTML.replacingOccurrences(of: "→", with: "\\t")
    
    //    if(number == 53
    //        || number == 68
    //        || number == 83
    //        || number == 82
    //        || number == 88
    //        || number == 87
    //        || number == 89
    //        || number == 90
    //        || number == 91
    //        || number == 92
    //        || number == 95
    //        || number == 96
    //        || number == 98
    //        || number == 99
    //        || number == 100
    //        || number == 102
    //        || number == 103
    //        || number == 107
    //        || number == 108
    //        || number == 109
    //        || number == 110
    //        || number == 113
    //        ) {
    //
    //        expectedHTML = expectedHTML.stringByReplacingOccurrencesOfString("</code", withString: "\\n</code")
    //    }
    //
    //    if(number == 85) {
    //
    //        expectedHTML = expectedHTML.stringByReplacingOccurrencesOfString("</code", withString: "\\n\\n</code")
    //    }
    
    testString += "    let parseResult = parseToHTML(\"\(markdowSource)\")\n"
    testString += "    XCTAssert(\"\(expectedHTML)\" == parseResult)\n"
    testString += "}\n\n"
    
    //    print("test: \(testString)")
    
    return (testString, endTestIndex)
}

func parseTestMarkdownSource(testString: String, fromIndex index: Int) -> (String, Int) {
    
    // when starting this function when should be in front of a newline
    let startIndex = index + 1 + markdownSourceTestPrefix.length
    var endIndex = startIndex
    
    while !isSeparatorAtIndex(index: endIndex, string: testString) && endIndex < testString.length {
        
        endIndex += 1
    }
    
    // remove the last newline
    let markdownSource = testString.slice(startIndex, end: endIndex)
    
    return (markdownSource!, endIndex + 2)
}

func isSeparatorAtIndex(index: Int, string: String) -> Bool {
    
    if string.charAt(index) == 0x2e /* . */ && string.charAt(index + 1)! == 0xa && string.charAt(index - 1)! == 0xa {
        
        return true
    }
    
    return false
}

func parserTestExpectedHTML(testString: String, fromIndex index: Int) -> (String, Int) {
    
    // when starting this function when should be in front of a newline
    let startIndex = index
    var endIndex = startIndex
    
    while !testString.hasPrefixFromPositionCaseSensitive(markdownSourceTestSuffix, fromPosition: endIndex) {
        
        endIndex += 1
    }
    
    var markdownSource = ""
    
    // remove the last newline
    if startIndex < endIndex {
        
        markdownSource = testString.slice(startIndex, end: endIndex)!
    }
    
    return (markdownSource, endIndex + markdownSourceTestSuffix.length)
}

func isStartOfTestAtIndex(currentStringIndex: Int, string: String) -> Bool {
    
    if string.hasPrefixFromPositionCaseSensitive(markdownSourceTestPrefix, fromPosition: currentStringIndex) {
        
        return true
    }
    
    return false
}

print(parseTests(specString: specString))

exit(EXIT_SUCCESS)
