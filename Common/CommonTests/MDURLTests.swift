//
//  MDURLTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-06-11.
//  Copyright © 2016 NM. All rights reserved.
//

import XCTest
@testable import Common

class MDURLTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test(url: String, dict: [String: String]) {
        
        let expected = MDURL(json: dict)
                
        let mdurl = url.parseToMdUrl(false)
                
        XCTAssert(mdurl == expected, "key: \(url) \nnot parsed as expected: \n\(expected.format()) \n\nbut as: \n\n\(mdurl.format())\n\n")
    }

    func test1() {
    
        test(url: "//some_path", dict: [
            "pathname": "//some_path"
        ])
    }
    
    func test2() {
    
        test(url: "HTTP://www.example.com/", dict: [
        
            "proto": "HTTP:",
            "slashes": "true",
            "hostname": "www.example.com",
            "pathname": "/"
        ])
    }
    
    func test3() {
        
        test(url: "HTTP://www.example.com", dict: [
            "proto": "HTTP:",
            "slashes": "true",
            "hostname": "www.example.com",
            "pathname": ""
        ])
    }
    
    func test4() {
        test(url: "http://www.ExAmPlE.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "www.ExAmPlE.com",
            "pathname": "/"
        ])
    }
    
    func test5() {
        test(url: "http://user:pw@www.ExAmPlE.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pw",
            "hostname": "www.ExAmPlE.com",
            "pathname": "/"
        ])
    }
    
    func test6() {
        test(url: "http://USER:PW@www.ExAmPlE.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "USER:PW",
            "hostname": "www.ExAmPlE.com",
            "pathname": "/"
        ])
    }
    
    func test7() {
        test(url: "http://user@www.example.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user",
            "hostname": "www.example.com",
            "pathname": "/"
        ])
    }
    
    func test8() {
        test(url: "http://user%3Apw@www.example.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user%3Apw",
            "hostname": "www.example.com",
            "pathname": "/"
        ])
    }
    
    func test9() {
        test(url: "http://x.com/path?that\"s#all, folks", dict: [
            "proto": "http:",
            "hostname": "x.com",
            "slashes": "true",
            "search": "?that\"s",
            "pathname": "/path",
            "hash": "#all, folks"
        ])
    }
    
    func test10() {
        test(url: "http://X.COM/Y", dict: [
            "proto": "HTTP:",
            "slashes": "true",
            "hostname": "X.COM",
            "pathname": "/Y"
        ])
    }
    
    func test11() {
        test(url: "http://x.y.com+a/b/c", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "x.y.com+a",
            "pathname": "/b/c"
        ])
    }
    
    func test12() {
        test(url: "http://x.y.cOm;a/b/c?d=e#f g<h>i", dict: [
            "proto": "HtTp:",
            "slashes": "true",
            "hostname": "x.y.cOm",
            "pathname": ";a/b/c",
            "search": "?d=e",
            "hash": "#f g<h>i"
        ])
    }
    
    func test13() {
        test(url: "http://x.y.cOm;A/b/c?d=e#f g<h>i", dict: [
            "proto": "HtTp:",
            "slashes": "true",
            "hostname": "x.y.cOm",
            "pathname": ";A/b/c",
            "search": "?d=e",
            "hash": "#f g<h>i"
        ])
    }
    
    func test14() {
        test(url: "http://x...y...#p", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "x...y...",
            "hash": "#p",
            "pathname": ""
        ])
    }
    
    func test15() {
        test(url: "http://x/p/\"quoted\"", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "x",
            "pathname": "/p/\"quoted\""
        ])
    }
    
    func test16() {
        test(url: "<http://goo.corn/bread> Is a URL!", dict: [
            "pathname": "<http://goo.corn/bread> Is a URL!"
        ])
    }
    
    func test17() {
        test(url: "http://www.narwhaljs.org/blog/categories?id=news", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "www.narwhaljs.org",
            "search": "?id=news",
            "pathname": "/blog/categories"
        ])
    }
    
    func test18() {
        test(url: "http://mt0.google.com/vt/lyrs=m@114&hl=en&src=api&x=2&y=2&z=3&s=", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "mt0.google.com",
            "pathname": "/vt/lyrs=m@114&hl=en&src=api&x=2&y=2&z=3&s="
        ])
    }
    
    func test19() {
        test(url: "http://mt0.google.com/vt/lyrs=m@114???&hl=en&src=api&x=2&y=2&z=3&s=", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "mt0.google.com",
            "search": "???&hl=en&src=api&x=2&y=2&z=3&s=",
            "pathname": "/vt/lyrs=m@114"
        ])
    }
    
    func test20() {
        test(url: "http://user:pass@mt0.google.com/vt/lyrs=m@114???&hl=en&src=api&x=2&y=2&z=3&s=", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "hostname": "mt0.google.com",
            "search": "???&hl=en&src=api&x=2&y=2&z=3&s=",
            "pathname": "/vt/lyrs=m@114"
        ])
    }
    
    func test21() {
        test(url: "file:///etc/passwd", dict: [
            "slashes": "true",
            "proto": "file:",
            "pathname": "/etc/passwd",
            "hostname": ""
        ])
    }
    
    func test22() {
        test(url: "file://localhost/etc/passwd", dict: [
            "proto": "file:",
            "slashes": "true",
            "pathname": "/etc/passwd",
            "hostname": "localhost"
        ])
    }
    
    func test23() {
        test(url: "file://foo/etc/passwd", dict: [
            "proto": "file:",
            "slashes": "true",
            "pathname": "/etc/passwd",
            "hostname": "foo"
        ])
    }
    
    func test24() {
        test(url: "file:///etc/node/", dict: [
            "slashes": "true",
            "proto": "file:",
            "pathname": "/etc/node/",
            "hostname": ""
        ])
    }
    
    func test25() {
        test(url: "file://localhost/etc/node/", dict: [
            "proto": "file:",
            "slashes": "true",
            "pathname": "/etc/node/",
            "hostname": "localhost"
        ])
    }
    
    func test26() {
        test(url: "file://foo/etc/node/", dict: [
            "proto": "file:",
            "slashes": "true",
            "pathname": "/etc/node/",
            "hostname": "foo"
        ])
    }
    
    func test27() {
        test(url: "http:/baz/../foo/bar", dict: [
            "proto": "http:",
            "pathname": "/baz/../foo/bar"
        ])
    }
    
    func test28() {
        test(url: "http://user:pass@example.com:8000/foo/bar?baz=quux#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "port": "8000",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?baz=quux",
            "pathname": "/foo/bar"
        ])
    }
    
    func test29() {
        test(url: "//user:pass@example.com:8000/foo/bar?baz=quux#frag", dict: [
            "slashes": "true",
            "auth": "user:pass",
            "port": "8000",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?baz=quux",
            "pathname": "/foo/bar"
        ])
    }
    
    func test30() {
        test(url: "/foo/bar?baz=quux#frag", dict: [
            "hash": "#frag",
            "search": "?baz=quux",
            "pathname": "/foo/bar"
        ])
    }
    
    func test31() {
        test(url: "http:/foo/bar?baz=quux#frag", dict: [
            "proto": "http:",
            "hash": "#frag",
            "search": "?baz=quux",
            "pathname": "/foo/bar"
        ])
    }
    
    func test32() {
        test(url: "mailto:foo@bar.com?subject=hello", dict: [
            "proto": "mailto:",
            "auth" : "foo",
            "hostname" : "bar.com",
            "search": "?subject=hello"
        ])
    }
    
    func test33() {
        test(url: "javascript:alert(\"hello\");", dict: [
            "proto": "javascript:",
            "pathname": "alert(\"hello\");"
        ])
    }
    
    func test34() {
        test(url: "xmpp:isaacschlueter@jabber.org", dict: [
            "proto": "xmpp:",
            "auth": "isaacschlueter",
            "hostname": "jabber.org"
        ])
    }
    
    func test35() {
        test(url: "http://atpass:foo%40bar@127.0.0.1:8080/path?search=foo#bar", dict: [
            "proto" : "http:",
            "slashes": "true",
            "auth" : "atpass:foo%40bar",
            "hostname" : "127.0.0.1",
            "port" : "8080",
            "pathname": "/path",
            "search" : "?search=foo",
            "hash" : "#bar"
        ])
    }
    
    func test36() {
        test(url: "svn+ssh://foo/bar", dict: [
            "hostname": "foo",
            "proto": "svn+ssh:",
            "pathname": "/bar",
            "slashes": "true"
        ])
    }
    
    func test37() {
        test(url: "dash-test://foo/bar", dict: [
            "hostname": "foo",
            "proto": "dash-test:",
            "pathname": "/bar",
            "slashes": "true"
        ])
    }
    
    func test38() {
        test(url: "dash-test:foo/bar", dict: [
            "hostname": "foo",
            "proto": "dash-test:",
            "pathname": "/bar"
        ])
    }
    
    func test39() {
        test(url: "dot.test://foo/bar", dict: [
            "hostname": "foo",
            "proto": "dot.test:",
            "pathname": "/bar",
            "slashes": "true"
        ])
    }
    
    func test40() {
        test(url: "dot.test:foo/bar", dict: [
            "hostname": "foo",
            "proto": "dot.test:",
            "pathname": "/bar"
        ])
    }
    
    func test41() {
        test(url: "http://www.日本語.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "www.日本語.com",
            "pathname": "/"
        ])
    }
    
    func test42() {
        test(url: "http://example.Bücher.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.Bücher.com",
            "pathname": "/"
        ])
    }
    
    func test43() {
        test(url: "http://www.Äffchen.com/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "www.Äffchen.com",
            "pathname": "/"
        ])
    }
    
    func test44() {
        test(url: "http://www.Äffchen.cOm;A/b/c?d=e#f g<h>i", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "www.Äffchen.cOm",
            "pathname": ";A/b/c",
            "search": "?d=e",
            "hash": "#f g<h>i"
        ])
    }
    
    func test45() {
        test(url: "http://SÉLIER.COM/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "SÉLIER.COM",
            "pathname": "/"
        ])
    }
    
    func test46() {
        test(url: "http://ليهمابتكلموشعربي؟.ي؟/", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "ليهمابتكلموشعربي؟.ي؟",
            "pathname": "/"
        ])
    }
    
    func test47() {
        test(url: "http://➡.ws/➡", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "➡.ws",
            "pathname": "/➡"
        ])
    }
    
    func test48() {
        test(url: "http://bucket_name.s3.amazonaws.com/image.jpg", dict: [
            "proto" : "http:",
            "slashes" : "true",
            "hostname" : "bucket_name.s3.amazonaws.com",
            "pathname" : "/image.jpg"
        ])
    }
    
    func test49() {
        test(url: "git+http://github.com/joyent/node.git", dict: [
            "proto": "git+http:",
            "slashes": "true",
            "hostname": "github.com",
            "pathname": "/joyent/node.git"
        ])
    }
    
    func test50() {
        test(url: "local1@domain1", dict: [
            "pathname": "local1@domain1"
        ])
    }
    
    func test51() {
        test(url: "www.example.com", dict: [
            "pathname": "www.example.com"
        ])
    }
    
    func test52() {
        test(url: "[fe80::1]", dict: [
            "pathname": "[fe80::1]"
        ])
    }
    
    func test53() {
        test(url: "coap://[FEDC:BA98:7654:3210:FEDC:BA98:7654:3210]", dict: [
            "proto": "coap:",
            "slashes": "true",
            "hostname": "FEDC:BA98:7654:3210:FEDC:BA98:7654:3210"
        ])
    }
    
    func test54() {
        test(url: "coap://[1080:0:0:0:8:800:200C:417A]:61616/", dict: [
            "proto": "coap:",
            "slashes": "true",
            "port": "61616",
            "hostname": "1080:0:0:0:8:800:200C:417A",
            "pathname": "/"
        ])
    }
    
    func test55() {
        test(url: "http://user:password@[3ffe:2a00:100:7031::1]:8080", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:password",
            "port": "8080",
            "hostname": "3ffe:2a00:100:7031::1",
            "pathname": ""
        ])
    }
    
    func test56() {
        test(url: "coap://u:p@[::192.9.5.5]:61616/.well-known/r?n=Temperature", dict: [
            "proto": "coap:",
            "slashes": "true",
            "auth": "u:p",
            "port": "61616",
            "hostname": "::192.9.5.5",
            "search": "?n=Temperature",
            "pathname": "/.well-known/r"
        ])
    }
    
    func test57() {
        test(url: "http://example.com:", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "pathname": ":"
        ])
    }
    
    func test58() {
        test(url: "http://example.com:/a/b.html", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "pathname": ":/a/b.html"
        ])
    }
    
    func test59() {
        test(url: "http://example.com:?a=b", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "search": "?a=b",
            "pathname": ":"
        ])
    }
    
    func test60() {
        test(url: "http://example.com:#abc", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#abc",
            "pathname": ":"
        ])
    }
    
    func test61() {
        test(url: "http://[fe80::1]:/a/b?a=b#abc", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "fe80::1",
            "search": "?a=b",
            "hash": "#abc",
            "pathname": ":/a/b"
        ])
    }
    
    func test62() {
        test(url: "http://-lovemonsterz.tumblr.com/rss", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "-lovemonsterz.tumblr.com",
            "pathname": "/rss"
        ])
    }
    
    func test63() {
        test(url: "http://-lovemonsterz.tumblr.com:80/rss", dict: [
            "proto": "http:",
            "slashes": "true",
            "port": "80",
            "hostname": "-lovemonsterz.tumblr.com",
            "pathname": "/rss"
        ])
    }
    
    func test64() {
        test(url: "http://user:pass@-lovemonsterz.tumblr.com/rss", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "hostname": "-lovemonsterz.tumblr.com",
            "pathname": "/rss"
        ])
    }
    
    func test65() {
        test(url: "http://user:pass@-lovemonsterz.tumblr.com:80/rss", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "port": "80",
            "hostname": "-lovemonsterz.tumblr.com",
            "pathname": "/rss"
        ])
    }
    
    func test66() {
        test(url: "http://_jabber._tcp.google.com/test", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "_jabber._tcp.google.com",
            "pathname": "/test"
        ])
    }
    
    func test67() {
        test(url: "http://user:pass@_jabber._tcp.google.com/test", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "hostname": "_jabber._tcp.google.com",
            "pathname": "/test"
        ])
    }
    
    func test68() {
        test(url: "http://_jabber._tcp.google.com:80/test", dict: [
            "proto": "http:",
            "slashes": "true",
            "port": "80",
            "hostname": "_jabber._tcp.google.com",
            "pathname": "/test"
        ])
    }
    
    func test69() {
        test(url: "http://user:pass@_jabber._tcp.google.com:80/test", dict: [
            "proto": "http:",
            "slashes": "true",
            "auth": "user:pass",
            "port": "80",
            "hostname": "_jabber._tcp.google.com",
            "pathname": "/test"
        ])
    }
    
    func test70() {
        test(url: "http://x:1/\" <>\"`/{}|\\^~`/", dict: [
            "proto" : "http:",
            "slashes" : "true",
            "port" : "1",
            "hostname" : "x",
            "pathname" : "/\" <>\"`/{}|\\^~`/"
        ])
    }
    
    func test71() {
        test(url: "http://a@b@c/", dict: [
            "proto" : "http:",
            "slashes" : "true",
            "auth" : "a@b",
            "hostname" : "c",
            "pathname" : "/"
        ])
    }
    
    func test72() {
        test(url: "http://a@b?@c", dict: [
            "proto" : "http:",
            "slashes" : "true",
            "auth" : "a",
            "hostname" : "b",
            "pathname" : "",
            "search" : "?@c"
        ])
    }
    
    func test73() {
        test(url: "http://a\r\" \t\n<\"b:b@c\r\nd/e?f", dict: [
            "proto" : "http:",
            "slashes" : "true",
            "auth" : "a\r\" \t\n<\"b:b",
            "hostname" : "c",
            "search" : "?f",
            "pathname" : "\r\nd/e"
        ])
    }
    
    func test74() {
        test(url: "git+ssh://git@github.com:npm/npm", dict: [
            "proto" : "git+ssh:",
            "slashes" : "true",
            "auth" : "git",
            "hostname" : "github.com",
            "pathname" : ":npm/npm"
        ])
    }
    
    func test75() {
        test(url: "http://example.com?foo=bar#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?foo=bar",
            "pathname": ""
        ])
    }
    
    func test76() {
        test(url: "http://example.com?foo=@bar#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?foo=@bar",
            "pathname": ""
        ])
    }
    
    func test77() {
        test(url: "http://example.com?foo=/bar/#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?foo=/bar/",
            "pathname": ""
        ])
    }
    
    func test78() {
        test(url: "http://example.com?foo=?bar/#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#frag",
            "search": "?foo=?bar/",
            "pathname": ""
        ])
    }
    
    func test79() {
        test(url: "http://example.com#frag=?bar/#frag", dict: [
            "proto": "http:",
            "slashes": "true",
            "hostname": "example.com",
            "hash": "#frag=?bar/#frag",
            "pathname": ""
        ])
    }
    
    func test80() {
        test(url: "http://google.com\" onload=\"alert(42)/", dict: [
            "hostname": "google.com",
            "proto": "http:",
            "slashes": "true",
            "pathname": "\" onload=\"alert(42)/"
        ])
    }
    
    func test81() {
        test(url: "http://a.com/a/b/c?s#h", dict: [
            "proto": "http:",
            "slashes": "true",
            "pathname": "/a/b/c",
            "hostname": "a.com",
            "hash": "#h",
            "search": "?s"
        ])
    }
    
    func test82() {
        test(url: "http://atpass:foo%40bar@127.0.0.1/", dict: [
            "auth": "atpass:foo%40bar",
            "slashes": "true",
            "hostname": "127.0.0.1",
            "proto": "http:",
            "pathname": "/"
        ])
    }
    
    func test83() {
        test(url: "http://atslash%2F%40:%2F%40@foo/", dict: [
            "auth": "atslash%2F%40:%2F%40",
            "hostname": "foo",
            "proto": "http:",
            "pathname": "/",
            "slashes": "true"
        ])
    }
    
    func test84() {
        test(url: "coap:u:p@[::1]:61616/.well-known/r?n=Temperature", dict: [
            "proto": "coap:",
            "auth": "u:p",
            "hostname": "::1",
            "port": "61616",
            "pathname": "/.well-known/r",
            "search": "?n=Temperature"
        ])
    }
    
    func test85() {
        test(url: "coap:[fedc:ba98:7654:3210:fedc:ba98:7654:3210]:61616/s/stopButton", dict: [
            "hostname": "fedc:ba98:7654:3210:fedc:ba98:7654:3210",
            "port": "61616",
            "proto": "coap:",
            "pathname": "/s/stopButton"
        ])
    }
    
    func test86() {
        test(url: "http://ex.com/foo%3F100%m%23r?abc=the%231?&foo=bar#frag", dict: [
            "proto" : "http:",
            "hostname" : "ex.com",
            "hash" : "#frag",
            "search" : "?abc=the%231?&foo=bar",
            "pathname" : "/foo%3F100%m%23r",
            "slashes" : "true"
        ])
    }
    
    func test87() {
        test(url: "http://ex.com/fooA100%mBr?abc=the%231?&foo=bar#frag", dict: [
            "proto" : "http:",
            "hostname" : "ex.com",
            "hash" : "#frag",
            "search" : "?abc=the%231?&foo=bar",
            "pathname" : "/fooA100%mBr",
            "slashes" : "true"
        ])
    }
    
    func test88() {
        
        test(url: "http://nodeca.github.io/pica/demo/", dict: [
            "proto" : "http:",
            "hostname" : "nodeca.github.io",
            "pathname" : "/pica/demo/",
            "slashes" : "true"
        ])
    }
    
}
