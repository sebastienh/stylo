//
//  String+MDURL.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-08.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


let defaultChars = ";/?:@&=+$,#"

var decodeCache: [String: Array<String>] = [String: Array<String>]()

var encodeCache: [String: Array<String>] = [String: Array<String>]()

// RFC 2396: characters reserved for delimiting URLs.
// We actually just auto-escape these.
let Delims = [
    "<",
    ">",
    "\"",
    "`",
    " ",
    "\r",
    "\n",
    "\t"
]

// RFC 2396: characters not allowed for various reasons.
let Unwise = [
    "{",
    "}",
    "|",
    "\\",
    "^",
    "`",
    "<",
    ">",
    "\"",
    "`",
    " ",
    "\r",
    "\n",
    "\t"
]

// Allowed by RFCs, but cause of XSS attacks.  Always escape these.
let AutoEscape = [
    "'",
    "{",
    "}",
    "|",
    "\\",
    "^",
    "`",
    "<",
    ">",
    "\"",
    "`",
    " ",
    "\r",
    "\n",
    "\t"
]

// Characters that are never ever allowed in a hostname.
// Note that any invalid chars are also handled, but these
// are the ones that are *expected* to be seen, so we fast-path
// them.
let NonHostChars = [
    "%",
    "/",
    "?",
    ";",
    "#",
    "'",
    "{",
    "}",
    "|",
    "\\",
    "^",
    "`",
    "<",
    ">",
    "\"",
    "`",
    " ",
    "\r",
    "\n",
    "\t"
]

let HostlessProtocol: [String] = [
    "javascript",
    "javascript:"
]

let SlashedProtocol: [String] = [

    "http",
    "https",
    "ftp",
    "gopher",
    "file",
    "http",
    "https",
    "ftp",
    "gopher",
    "file"
]

let HostEndingChars = [
    "/",
    "?",
    "#"
]



extension String {
    
    ///
    ///
    ///
    public func parseToMdUrl(_ slashesDenoteHost: Bool) -> MDURL {
    
        var url = MDURL()
        
        var proto: String?
        var lowerProto: String?
        
        var hec: Int?
        
        var slashes: Bool = false
        
        // trim before proceeding.
        // This is to support parse stuff like "  http://foo.com  \n"
        var rest = trimWhitespaces()
        
        let splitedUrlArray = rest.split{$0 == "#"}.map(String.init)
        
        if !slashesDenoteHost && splitedUrlArray.count == 1 {
            
            // Try fast path regexp
            if let simplePathMatch = rest.matchSimplePathPattern() {
            
                if let pathMatch = simplePathMatch.first {
                    
                    url.pathname = rest.slice(pathMatch.start, end: pathMatch.end)?.string
                    
                    if simplePathMatch.count > 1 {
                        
                        url.search = rest.slice(simplePathMatch[1].start, end: simplePathMatch[1].end)?.string
                    }
                    
                    return url
                }
            }
        }
        
        let protoMatch = rest.matchProtocolPattern()
        
        if let protoMatch = protoMatch {
    
            if let protoMatch = protoMatch.first {
            
                proto = rest.slice(protoMatch.start, end: protoMatch.end)?.string
                lowerProto = proto!.lowercased()
                url.proto = proto
                rest = rest.slice(protoMatch.end)!.string
            }
        }
     
        // figure out if it's got a host
        // user@server is *always* interpreted as a hostname, and url
        // resolution will treat //foo/bar as host=foo,path=bar because that's
        // how the browser resolves relative URLs.
        if slashesDenoteHost || protoMatch != nil || rest.matchUsernameServerPattern() != nil {
            
            slashes = rest.beginsWith("//")
            
            if let proto = proto, !HostlessProtocol.contains(proto.lowercased()) && slashes {
                
                rest = rest.slice(2)?.string ?? ""
                url.slashes = true
            }
            else if proto == nil && slashes {
             
                rest = rest.slice(2)?.string ?? ""
                url.slashes = true
            }
        }
        
//        if (!hostlessProtocol[proto] &&
//            (slashes || (proto && !slashedProtocol[proto]))) {
        
        if (proto == nil || (proto != nil && !HostlessProtocol.contains(proto!.lowercased()))) &&
            (slashes || (proto != nil && !SlashedProtocol.contains(proto!.lowercased()))) {
            
            // there's a hostname.
            // the first instance of /, ?, ;, or # ends the host.
            //
            // If there is an @ in the hostname, then non-host chars *are* allowed
            // to the left of the last @ sign, unless some host-ending character
            // comes *before* the @-sign.
            // URLs are obnoxious.
            //
            // ex:
            // http://a@b@c/ => user:a@b host:c
            // http://a@b?@c => user:a host:c path:/?@c
            
            // v0.12 TODO(isaacs): This is not quite how Chrome does things.
            // Review our test case against browsers more comprehensively.
            
            // find the first instance of any hostEndingChars
            var hostEnd = -1
            
            for i in 0..<HostEndingChars.count {
                
                hec = rest.indexOf(HostEndingChars[i])
                
                if hec != nil && (hostEnd == -1 || hec < hostEnd) {
                    
                    hostEnd = hec!
                }
            }
            
            // at this point, either we have an explicit point where the
            // auth portion cannot go past, or the last @ char is the decider.
            var auth: String?
            var atSign: Int = -1
            
            if hostEnd == -1 {
               
                // atSign can be anywhere.
                
                let lastIndex = rest.lastIndexOf(§"@")
                
                atSign = lastIndex != nil ? lastIndex! : -1
            }
            else {
                
                // atSign must be in auth portion.
                // http://a@b/c@d => host:b auth:a path:/c@d
                
                let lastIndex = rest.lastIndexOf(§"@", fromIndex: hostEnd)
                
                atSign = lastIndex != nil ? lastIndex! : -1
            }
            
            // Now we have a portion which is definitely the auth.
            // Pull that off.
            if atSign != -1 {
                
                auth = rest.slice(0, end: atSign)?.string
                rest = rest.slice(atSign + 1)!.string
                url.auth = auth
            }
            
            // the host is the remaining to the left of the first non-host char
            hostEnd = -1
            
            for i in 0..<NonHostChars.count {
                
                hec = rest.indexOf(NonHostChars[i]);
                
                // if (hec !== -1 && (hostEnd === -1 || hec < hostEnd)) {
                if hec != nil && (hostEnd == -1 || (hec != nil && hec! < hostEnd)) {
                    
                    hostEnd = hec!
                }
            }
            // if we still have not hit it, then the entire thing is a host.
            if hostEnd == -1 {
                hostEnd = rest.length;
            }
            
            if let char = rest.charAt(hostEnd - 1), char == §":" {
                
                hostEnd -= 1 
            }
            
            let host = rest.slice(0, end: hostEnd)?.string ?? ""
            rest = rest.slice(hostEnd)?.string ?? ""
            
            // pull out port.
            let (_host, _port) = parseHostAndPort(host)
            
            
            url.port = _port != nil ? _port : ""
            
            // we've indicated that there is a hostname,
            // so even if it's empty, it has to be present.
            url.hostname = _host != nil ? _host : ""
            
            // if hostname begins with [ and ends with ]
            // assume that it's an IPv6 address.
            
            var ipv6Hostname: Bool = false
            
            if let first = url.hostname!.charAt(0), first == §"[" {
                
                if let last = url.hostname!.charAt(url.hostname!.length - 1), last == §"]" {
                
                    ipv6Hostname = true
                }
            }
            
            // validate a little.
            if !ipv6Hostname {
                
                var hostparts = url.hostname!.split{$0 == "."}.map(String.init)
                
                let l = hostparts.count
                
                for i in 0..<l {
                    
                    let part = hostparts[i]
                    
                    if part.length == 0 {
                        
                        continue
                    }
                    
                    if part.matchHostnamePartPattern() == nil {
                        
                        var newpart = ""
                        
                        let k = part.length
                        
                        for j in 0..<k {
                            
                            if let char = part.charAt(j) , char > 127 {
                            
                                // we replace non-ASCII char with a temporary placeholder
                                // we need this to make sure size of hostname is not
                                // broken by replacing non-ASCII by nothing
                                newpart += "x"
                            }
                            else if let char = part.charAt(j) {
                            
                                newpart += String.fromCharCode(char)
                            }
                        }
                        
                        // we test again with ASCII char only
                        if newpart.matchHostnamePartPattern() == nil {
                            
                            var validParts = Array(hostparts[0..<i])
                            var notHost = Array(hostparts[i + 1..<hostparts.count])
                            
                            if let bit = part.matchHostnamePartStart() {
                            
                                let validPart = part.slice(bit.first!.start, end: bit.first!.end)
                                validParts.append(validPart!.string)
                                
                                if bit.count > 1 {
                                
                                    let noHostPart = part.slice(bit[1].start, end: bit[1].end)
                                    notHost.insert(noHostPart!.string, at: 0)
                                }
                            }
                            if notHost.count > 0 {
                                
                                rest = notHost.joined(separator: ".") + rest;
                            }
                            url.hostname = validParts.joined(separator: ".")
                            break
                        }
                    }
                }
            }
            
            if url.hostname!.length > hostnameMaxLen {
                
                url.hostname = ""
            }
            
            // strip [ and ] from the hostname
            // the host field still retains them, though
            if ipv6Hostname {
                
                url.hostname = url.hostname!.substr(1, end: url.hostname!.length - 1)
            }
        }
        
        // chop off from the tail first.
        if let hash = rest.indexOf(§"#") {

            // got a fragment string.
            url.hash = rest.slice(hash)?.string
            rest = rest.slice(0, end: hash)!.string
        }
        if let qm = rest.indexOf(§"?") {

            url.search = rest.slice(qm)?.string
            rest = rest.slice(0, end: qm)!.string
        }
        if rest.length > 0 {
            
            url.pathname = rest
        }
        if (lowerProto != nil && SlashedProtocol.contains(lowerProto!) &&
            url.hostname != nil && url.pathname == nil) {
            
            url.pathname = ""
        }
        
        return url 
    }
    
    fileprivate func parseHostAndPort(_ host: String) -> (host: String?, port: String?) {
        
        var _port: String? = nil
        var _host: String? = host
        
        let portMatch = host.matchPortPattern()
        
        if let portMatchArray = portMatch {
            
            let portMatch = portMatchArray.first!
            
            let port = host.slice(portMatch.start, end: portMatch.end)!.string
            
            if port != ":" {
                
                _port = port.slice(1)!.string
            }
            
            _host = host.substr(0, end: host.length - port.length)
        }

        return (_host, _port)
    }
    
    ///
    ///
    ///
    /// Encode unsafe characters with percent-encoding, skipping already
    /// encoded sequences.
    ///
    ///  - string       - string to encode
    ///  - exclude      - list of characters to ignore (in addition to a-zA-Z0-9)
    ///
    public func encodeToHtml(_ exclude: String = ";/?:@&=+$,-_.!~*'()#") -> String {
    
        var result = ""
    
        var cache = getEncodeCache(exclude)
    
        let l = self.length
        
        var i = 0
        
        while i < l {
    
            if let code = charAt(i) {
    
                if startOfPercentEncoding(i) && i + 2 < l {
                    
                    result += self.slice(i, end: i + 3)!.string
                    i += 3
                    continue
                }
                
                if code < 128 {
                    
                    result += cache[Int(code)]
                    i += 1
                    continue
                }

                if code >= 0xD800 && code <= 0xDFFF {
                    
                    if code >= 0xD800 && code <= 0xDBFF && i + 1 < l {
                        
                        if let nextCode = self.charAt(i + 1) {
                        
                            if nextCode >= 0xDC00 && nextCode <= 0xDFFF {
                            
                                result += encodeURIComponent(String.fromCharCode(self.charAt(i)!) + String.fromCharCode(self.charAt(i + 1)!))
                                i += 1
                                continue
                            }
                        }
                    }
                    
                    result += "%EF%BF%BD"
                    continue
                }
            }
        
            result += encodeURIComponent(String.fromCharCode(self.charAt(i)!))
            
            i += 1 
        }

        return result
    }
    
    ///
    /// Decode percent-encoded string.
    ///
    public func decode(_ exclude: String? = nil) -> String {
        
        var localExclude = exclude
        
        if localExclude == nil {
        
            localExclude = defaultChars
        }
    
        var cache = getDecodeCache(localExclude!)
    
        var result = ""
        
        var i = 0
        
        while i < self.length {
            
            if let char = self.charAt(i) {
                
                if startOfPercentEncoding(i) {
                    
                    // convert the hex number string to Int
                    let b1 = parseInt(i + 1)
                    
                    if b1 < 0x80 {
                        
                        result += cache[b1]
                        i += 3
                        continue
                    }
                    
                    if startOfPercentEncoding(i + 3) && (b1 & 0xE0) == 0xC0 {
                        
                        // 110xxxxx 10xxxxxx
                        let b2 = parseInt(i + 4)
                        
                        if ((b2 & 0xC0) == 0x80) {
                            
                            let chr = ((b1 << 6) & 0x7C0) | (b2 & 0x3F)
                            
                            if chr < 0x80 {
                                
                                result += "\u{fffd}\u{fffd}"
                            }
                            else {
                                
                                result += String.fromCharCode(UInt16(chr))
                            }
                            
                            i += 6
                            continue
                        }
                    }
                    
                    if startOfPercentEncoding(i + 3) && startOfPercentEncoding(i + 6) && (b1 & 0xF0) == 0xE0 {
                        
                        // 1110xxxx 10xxxxxx 10xxxxxx
                        let b2 = parseInt(i + 4)
                        let b3 = parseInt(i + 7)
                        
                        if ((b2 & 0xC0) == 0x80 && (b3 & 0xC0) == 0x80) {
                            
                            let chr = ((b1 << 12) & 0xF000) | ((b2 << 6) & 0xFC0) | (b3 & 0x3F)
                            
                            if (chr < 0x800 || (chr >= 0xD800 && chr <= 0xDFFF)) {
                                
                                result += "\u{fffd}\u{fffd}\u{fffd}"
                            }
                            else {
                            
                                result += String.fromCharCode(UInt16(chr))
                            }
                            
                            i += 9
                            continue
                        }
                    }
                    
                    if startOfPercentEncoding(i + 3) && startOfPercentEncoding(i + 6) && startOfPercentEncoding(i + 9) && (b1 & 0xF8) == 0xF0 {
                        
                        // 111110xx 10xxxxxx 10xxxxxx 10xxxxxx
                        let b2 = parseInt(i + 4)
                        let b3 = parseInt(i + 7)
                        let b4 = parseInt(i + 10)
                        
                        if ((b2 & 0xC0) == 0x80 && (b3 & 0xC0) == 0x80 && (b4 & 0xC0) == 0x80) {
                            
                            let b1s = b1 << 18
                            let b2s = b2 << 12
                            let b3s = b3 << 6
                            
                            var chr = (b1s & 0x1C0000) | (b2s & 0x3F000) | (b3s & 0xFC0) | (b4 & 0x3F)
                            
                            if (chr < 0x10000 || chr > 0x10FFFF) {
                                
                                result += "\u{fffd}\u{fffd}\u{fffd}\u{fffd}"
                            }
                            else {
                            
                                chr -= 0x10000
                        
                                result += String.fromCharCode(UInt16(0xD800) + UInt16(chr >> 10))
                                result += String.fromCharCode(UInt16(0xDC00) + UInt16(chr & 0x3FF))
                            }
                            
                            i += 9
                            continue
                        }
                    }
                    
                    result += "\u{fffd}"
                }
                else {
                    
                    result += String.fromCharCode(char)
                }
            }
            
            i += 1
        }
        
        return result
    }

    // Create a lookup array where anything but characters in `chars` string
    // and alphanumeric chars is percent-encoded.
    //
    func getEncodeCache(_ exclude: String) -> Array<String> {
    
        if let cache = encodeCache[exclude] {
            
            return cache
        }

        var cache = Array<String>()
    
        for i: UInt16 in 0..<128 {
    
            let ch = String.fromCharCode(i)
    
            if Unicode.isAsciiLetterOrDigit(i) {
    
                // always allow unencoded alphanumeric characters
                cache.append(ch)
            }
            else {
    
                cache.append("%" + ("0" + String(i, radix: 16).uppercased()).slice(-2)!.string)
            }
        }

        for i in 0..<exclude.length {
    
            cache[Int(exclude.charAt(i)!)] = String.fromCharCode(exclude.charAt(i)!)
        }

        encodeCache[exclude] = cache
        
        return cache
    }
    
    
    func getDecodeCache(_ exclude: String) -> Array<String> {
    
        if let cache = decodeCache[exclude] {
            
            return cache
        }
    
        var cache = Array<String>()
    
        for i: UInt16 in 0..<128 {
    
            cache.append(String.fromCharCode(i))
        }
    
        for i in 0..<exclude.length {
            
            let ch = exclude.charAt(i)!
            
            cache[Int(ch)] = "%" + ("0" + String(ch, radix: 16).uppercased()).slice(-2)!.string
        }
    
        decodeCache[exclude] = cache
        
        return cache
    }

    
    fileprivate func startOfPercentEncoding(_ index: Int) -> Bool {
        
        if let percent = self.charAt(index), percent == §UnicodeCharacter.percentageSign {
            
            // the next two following characters must be [a-f0-9] case insensitive
            if let next = self.charAt(index + 1), UnicodeHexDigit.isUnicodeHexDigit(next) {
         
                if let secondNext = self.charAt(index + 2), UnicodeHexDigit.isUnicodeHexDigit(secondNext) {
                
                    return true
                }
            }
        }
        
        return false
    }

    fileprivate func encodeURIComponent(_ string: String) -> String {
    
        return string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }

    ///
    /// Method to convert
    fileprivate func parseInt(_ start: Int, base: Int32 = 16) -> Int {
        
        // extract the number part
        let hexNumber = self.slice(start, end: start + 2)!.string
        
        // convert the hex number string to Int
        return Int(strtoul(hexNumber, nil, base))
    }
    
}
