//
//  Punycode.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
//
//  Punycode.swift
//
//  Created by Mike Kasianowicz on 9/7/15.
//  Copyright © 2015 Mike Kasianowicz. All rights reserved.
//

import Foundation

public final class Punycode {
    //MARK: public static
    
    // RFC 3492 implementation
    public static let official = Punycode(
        delimiter: "-",
        encodeTable: "abcdefghijklmnopqrstuvwxyz0123456789"
    )
    
    // used for Swift name mangling - presumably to avoid digit interference
    public static let swift = Punycode(
        delimiter: "_",
        encodeTable: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJ"
    )
    
    //MARK: variables
    fileprivate let base = 36
    fileprivate let tMin = 1
    fileprivate let tMax = 26
    fileprivate let skew = 38
    fileprivate let damp = 700
    fileprivate let initialBias = 72
    fileprivate let initialN = 0x80
    
    fileprivate let delimiter : Character
    fileprivate let encodeTable : [Character]
    fileprivate let decodeTable : [Character : Int]
    
    
    //MARK: initializers
    public convenience init(delimiter: Character, encodeTable: String) {
        self.init(delimiter: delimiter, encodeTable: [Character](encodeTable))
        
    }
    
    public required init(delimiter: Character, encodeTable: [Character]) {
        self.delimiter = delimiter
        self.encodeTable = encodeTable
        var decodeTable = [Character : Int]()
        encodeTable.enumerated().forEach { ( kvp: (Int, Character)) -> () in
            decodeTable[kvp.1] = kvp.0
        }
        self.decodeTable = decodeTable
    }
    
    //MARK: encode
    public func encode(_ unicode: String) -> String {
        var retval = ""
        var extendedChars = Array<Int>()
        
        for c in unicode.unicodeScalars {
            let ci = Int(c.value)
            if ci < initialN {
                retval.append(String(c))
            } else {
                extendedChars.append(ci)
            }
        }
        
        if extendedChars.count == 0 {
            return retval
        }
        
        retval.append(delimiter)
        
        extendedChars.sorted()
        
        var bias = initialBias
        var delta = 0
        var n = initialN
        var h = retval.unicodeScalars.count - 1
        let b = retval.unicodeScalars.count - 1
        var i = 0
        while h < unicode.unicodeScalars.count {
            let char = extendedChars[i]
            i += 1
            delta = delta + (char - n) * (h + 1)
            n = char
            
            for c in unicode.unicodeScalars {
                let ci = Int(c.value)
                if ci < n || ci < initialN {
                    delta += 1
                }
                
                if ci == n {
                    var q = delta
                    var k = self.base
                    while true {
                        let t = max(min(k - bias, self.tMax), self.tMin)
                        if q < t {
                            break
                        }
                        
                        let code = t + ((q - t) % (self.base - t))
                        retval.append(self.encodeTable[code])
                        
                        q = (q - t) / (self.base - t)
                        k += base
                    }
                    
                    retval.append(self.encodeTable[q])
                    bias = self.adapt(delta, h + 1, h == b)
                    delta = 0
                    h += 1
                }
            }
            
            delta += 1
            n += 1
        }
        return retval
    }
    
    fileprivate func adapt(_ delta: Int, _ numPoints: Int, _ firstTime: Bool) -> Int {
        var localDelta = delta / (firstTime ? self.damp : 2)
        
        localDelta += localDelta / numPoints
        var k = 0
        while (delta > ((self.base - self.tMin) * self.tMax) / 2) {
            localDelta = localDelta / (self.base - self.tMin)
            k = k + self.base
        }
        k += ((self.base - self.tMin + 1) * localDelta) / (localDelta + self.skew)
        return k
    }
    
    //MARK: decode
    
    public func decode(_ punycode: String) -> String {
        var input = Array<Character>(punycode)
        var n = self.initialN
        var i = 0
        var bias = self.initialBias
        var output = Array<Character>()
        
        var pos = 0
        if let ipos = input.index(of: self.delimiter) {
            pos = ipos
            output.append(contentsOf: input[0..<pos])
            pos += 1
        }
        
        var outputLength = output.count
        let inputLength = input.count
        while pos < inputLength {
            let oldi = i
            var w = 1
            var k = self.base
            while true  {
                let digit = self.decodeTable[input[pos]]!
                pos += 1
                i = i + (digit * w)
                let t = max(min(k - bias, self.tMax), self.tMin)
                if (digit < t) {
                    break
                }
                w = w * (self.base - t)
                k += self.base
            }
            outputLength += 1
            bias = self.adapt(i - oldi, outputLength, (oldi == 0))
            n = n + i / outputLength
            i = i % outputLength
            output.insert(Character(UnicodeScalar(n)!), at: i)
            i += 1
        }
        return String(output)
    }
}
