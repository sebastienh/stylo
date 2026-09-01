//
//  MardownSpecTests.swift

//  Created by Sébastien Hamel on 2016-04-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class MardownSpecTests: MarkdownSpecTestsBase {
    
    func test1() {
        let parseResult = parseToHTML("\tfoo\tbaz\t\tbim\n")
        XCTAssert("<pre><code>foo\tbaz\t\tbim\n</code></pre>\n" == parseResult)
    }
    
    func test2() {
        let parseResult = parseToHTML("  \tfoo\tbaz\t\tbim\n")
        XCTAssert("<pre><code>foo\tbaz\t\tbim\n</code></pre>\n" == parseResult)
    }
    
    func test3() {
        let parseResult = parseToHTML("    a\ta\n    ὐ\ta\n")
        XCTAssert("<pre><code>a\ta\nὐ\ta\n</code></pre>\n" == parseResult)
    }
    
    func test4() {
        let parseResult = parseToHTML("  - foo\n\n\tbar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test5() {
        let parseResult = parseToHTML("- foo\n\n\t\tbar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<pre><code>  bar\n</code></pre>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test6() {
        let parseResult = parseToHTML(">\t\tfoo\n")
        XCTAssert("<blockquote>\n<pre><code>  foo\n</code></pre>\n</blockquote>\n" == parseResult)
    }
    
    func test7() {
        let parseResult = parseToHTML("-\t\tfoo\n")
        XCTAssert("<ul>\n<li>\n<pre><code>  foo\n</code></pre>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test8() {
        let parseResult = parseToHTML("    foo\n\tbar\n")
        XCTAssert("<pre><code>foo\nbar\n</code></pre>\n" == parseResult)
    }
    
    func test9() {
        let parseResult = parseToHTML(" - foo\n   - bar\n\t - baz\n")
        XCTAssert("<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test10() {
        let parseResult = parseToHTML("#\tFoo\n")
        XCTAssert("<h1>Foo</h1>\n" == parseResult)
    }
    
    func test11() {
        let parseResult = parseToHTML("*\t*\t*\t\n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test12() {
        let parseResult = parseToHTML("- `one\n- two`\n")
        XCTAssert("<ul>\n<li>`one</li>\n<li>two`</li>\n</ul>\n" == parseResult)
    }
    
    func test13() {
        let parseResult = parseToHTML("***\n---\n___\n")
        XCTAssert("<hr />\n<hr />\n<hr />\n" == parseResult)
    }
    
    func test14() {
        let parseResult = parseToHTML("+++\n")
        XCTAssert("<p>+++</p>\n" == parseResult)
    }
    
    func test15() {
        let parseResult = parseToHTML("===\n")
        XCTAssert("<p>===</p>\n" == parseResult)
    }
    
    func test16() {
        let parseResult = parseToHTML("--\n**\n__\n")
        XCTAssert("<p>--\n**\n__</p>\n" == parseResult)
    }
    
    func test17() {
        let parseResult = parseToHTML(" ***\n  ***\n   ***\n")
        XCTAssert("<hr />\n<hr />\n<hr />\n" == parseResult)
    }
    
    func test18() {
        let parseResult = parseToHTML("    ***\n")
        XCTAssert("<pre><code>***\n</code></pre>\n" == parseResult)
    }
    
    func test19() {
        let parseResult = parseToHTML("Foo\n    ***\n")
        XCTAssert("<p>Foo\n***</p>\n" == parseResult)
    }
    
    func test20() {
        let parseResult = parseToHTML("_____________________________________\n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test21() {
        let parseResult = parseToHTML(" - - -\n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test22() {
        let parseResult = parseToHTML(" **  * ** * ** * **\n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test23() {
        let parseResult = parseToHTML("-     -      -      -\n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test24() {
        let parseResult = parseToHTML("- - - -    \n")
        XCTAssert("<hr />\n" == parseResult)
    }
    
    func test25() {
        let parseResult = parseToHTML("_ _ _ _ a\n\na------\n\n---a---\n")
        XCTAssert("<p>_ _ _ _ a</p>\n<p>a------</p>\n<p>---a---</p>\n" == parseResult)
    }
    
    func test26() {
        let parseResult = parseToHTML(" *-*\n")
        XCTAssert("<p><em>-</em></p>\n" == parseResult)
    }
    
    func test27() {
        let parseResult = parseToHTML("- foo\n***\n- bar\n")
        XCTAssert("<ul>\n<li>foo</li>\n</ul>\n<hr />\n<ul>\n<li>bar</li>\n</ul>\n" == parseResult)
    }
    
    func test28() {
        let parseResult = parseToHTML("Foo\n***\nbar\n")
        XCTAssert("<p>Foo</p>\n<hr />\n<p>bar</p>\n" == parseResult)
    }
    
    func test29() {
        let parseResult = parseToHTML("Foo\n---\nbar\n")
        XCTAssert("<h2>Foo</h2>\n<p>bar</p>\n" == parseResult)
    }
    
    func test30() {
        let parseResult = parseToHTML("* Foo\n* * *\n* Bar\n")
        XCTAssert("<ul>\n<li>Foo</li>\n</ul>\n<hr />\n<ul>\n<li>Bar</li>\n</ul>\n" == parseResult)
    }
    
    func test31() {
        let parseResult = parseToHTML("- Foo\n- * * *\n")
        XCTAssert("<ul>\n<li>Foo</li>\n<li>\n<hr />\n</li>\n</ul>\n" == parseResult)
    }
    
    func test32() {
        let parseResult = parseToHTML("# foo\n## foo\n### foo\n#### foo\n##### foo\n###### foo\n")
        XCTAssert("<h1>foo</h1>\n<h2>foo</h2>\n<h3>foo</h3>\n<h4>foo</h4>\n<h5>foo</h5>\n<h6>foo</h6>\n" == parseResult)
    }
    
    func test33() {
        let parseResult = parseToHTML("####### foo\n")
        XCTAssert("<p>####### foo</p>\n" == parseResult)
    }
    
    func test34() {
        let parseResult = parseToHTML("#5 bolt\n\n#hashtag\n")
        XCTAssert("<p>#5 bolt</p>\n<p>#hashtag</p>\n" == parseResult)
    }
    
    func test35() {
        let parseResult = parseToHTML("\\## foo\n")
        XCTAssert("<p>## foo</p>\n" == parseResult)
    }
    
    func test36() {
        let parseResult = parseToHTML("# foo *bar* \\*baz\\*\n")
        XCTAssert("<h1>foo <em>bar</em> *baz*</h1>\n" == parseResult)
    }
    
    func test37() {
        let parseResult = parseToHTML("#                  foo                     \n")
        XCTAssert("<h1>foo</h1>\n" == parseResult)
    }
    
    func test38() {
        let parseResult = parseToHTML(" ### foo\n  ## foo\n   # foo\n")
        XCTAssert("<h3>foo</h3>\n<h2>foo</h2>\n<h1>foo</h1>\n" == parseResult)
    }
    
    func test39() {
        let parseResult = parseToHTML("    # foo\n")
        XCTAssert("<pre><code># foo\n</code></pre>\n" == parseResult)
    }
    
    func test40() {
        let parseResult = parseToHTML("foo\n    # bar\n")
        XCTAssert("<p>foo\n# bar</p>\n" == parseResult)
    }
    
    func test41() {
        let parseResult = parseToHTML("## foo ##\n  ###   bar    ###\n")
        XCTAssert("<h2>foo</h2>\n<h3>bar</h3>\n" == parseResult)
    }
    
    func test42() {
        let parseResult = parseToHTML("# foo ##################################\n##### foo ##\n")
        XCTAssert("<h1>foo</h1>\n<h5>foo</h5>\n" == parseResult)
    }
    
    func test43() {
        let parseResult = parseToHTML("### foo ###     \n")
        XCTAssert("<h3>foo</h3>\n" == parseResult)
    }
    
    func test44() {
        let parseResult = parseToHTML("### foo ### b\n")
        XCTAssert("<h3>foo ### b</h3>\n" == parseResult)
    }
    
    func test45() {
        let parseResult = parseToHTML("# foo#\n")
        XCTAssert("<h1>foo#</h1>\n" == parseResult)
    }
    
    func test46() {
        let parseResult = parseToHTML("### foo \\###\n## foo #\\##\n# foo \\#\n")
        XCTAssert("<h3>foo ###</h3>\n<h2>foo ###</h2>\n<h1>foo #</h1>\n" == parseResult)
    }
    
    func test47() {
        let parseResult = parseToHTML("****\n## foo\n****\n")
        XCTAssert("<hr />\n<h2>foo</h2>\n<hr />\n" == parseResult)
    }
    
    func test48() {
        let parseResult = parseToHTML("Foo bar\n# baz\nBar foo\n")
        XCTAssert("<p>Foo bar</p>\n<h1>baz</h1>\n<p>Bar foo</p>\n" == parseResult)
    }
    
    // we fail this because for us a # mark
    // without a space after is not a header
    func test49() {
        let parseResult = parseToHTML("## \n#\n### ###\n")
        XCTAssert("<h2></h2>\n<h1></h1>\n<h3></h3>\n" == parseResult)
    }
    
    func test50() {
        let parseResult = parseToHTML("Foo *bar*\n=========\n\nFoo *bar*\n---------\n")
        XCTAssert("<h1>Foo <em>bar</em></h1>\n<h2>Foo <em>bar</em></h2>\n" == parseResult)
    }
    
    func test51() {
        let parseResult = parseToHTML("Foo *bar\nbaz*\n====\n")
        XCTAssert("<h1>Foo <em>bar\nbaz</em></h1>\n" == parseResult)
    }
    
    func test52() {
        let parseResult = parseToHTML("Foo\n-------------------------\n\nFoo\n=\n")
        XCTAssert("<h2>Foo</h2>\n<h1>Foo</h1>\n" == parseResult)
    }
    
    func test53() {
        let parseResult = parseToHTML("   Foo\n---\n\n  Foo\n-----\n\n  Foo\n  ===\n")
        XCTAssert("<h2>Foo</h2>\n<h2>Foo</h2>\n<h1>Foo</h1>\n" == parseResult)
    }
    
    func test54() {
        let parseResult = parseToHTML("    Foo\n    ---\n\n    Foo\n---\n")
        XCTAssert("<pre><code>Foo\n---\n\nFoo\n</code></pre>\n<hr />\n" == parseResult)
    }
    
    func test55() {
        let parseResult = parseToHTML("Foo\n   ----      \n")
        XCTAssert("<h2>Foo</h2>\n" == parseResult)
    }
    
    func test56() {
        let parseResult = parseToHTML("Foo\n    ---\n")
        XCTAssert("<p>Foo\n---</p>\n" == parseResult)
    }
    
    func test57() {
        let parseResult = parseToHTML("Foo\n= =\n\nFoo\n--- -\n")
        XCTAssert("<p>Foo\n= =</p>\n<p>Foo</p>\n<hr />\n" == parseResult)
    }
    
    func test58() {
        let parseResult = parseToHTML("Foo  \n-----\n")
        XCTAssert("<h2>Foo</h2>\n" == parseResult)
    }
    
    func test59() {
        let parseResult = parseToHTML("Foo\\\n----\n")
        XCTAssert("<h2>Foo\\</h2>\n" == parseResult)
    }
    
    func test60() {
        let parseResult = parseToHTML("`Foo\n----\n`\n\n<a title=\"a lot\n---\nof dashes\"/>\n")
        XCTAssert("<h2>`Foo</h2>\n<p>`</p>\n<h2>&lt;a title=&quot;a lot</h2>\n<p>of dashes&quot;/&gt;</p>\n" == parseResult)
    }
    
    func test61() {
        let parseResult = parseToHTML("> Foo\n---\n")
        XCTAssert("<blockquote>\n<p>Foo</p>\n</blockquote>\n<hr />\n" == parseResult)
    }
    
    func test62() {
        let parseResult = parseToHTML("> foo\nbar\n===\n")
        XCTAssert("<blockquote>\n<p>foo\nbar\n===</p>\n</blockquote>\n" == parseResult)
    }
    
    func test63() {
        let parseResult = parseToHTML("- Foo\n---\n")
        XCTAssert("<ul>\n<li>Foo</li>\n</ul>\n<hr />\n" == parseResult)
    }
    
    func test64() {
        let parseResult = parseToHTML("Foo\nBar\n---\n")
        XCTAssert("<h2>Foo\nBar</h2>\n" == parseResult)
    }
    
    func test65() {
        let parseResult = parseToHTML("---\nFoo\n---\nBar\n---\nBaz\n")
        XCTAssert("<hr />\n<h2>Foo</h2>\n<h2>Bar</h2>\n<p>Baz</p>\n" == parseResult)
    }
    
    func test66() {
        let parseResult = parseToHTML("\n====\n")
        XCTAssert("<p>====</p>\n" == parseResult)
    }
    
    func test67() {
        let parseResult = parseToHTML("---\n---\n")
        XCTAssert("<hr />\n<hr />\n" == parseResult)
    }
    
    func test68() {
        let parseResult = parseToHTML("- foo\n-----\n")
        XCTAssert("<ul>\n<li>foo</li>\n</ul>\n<hr />\n" == parseResult)
    }
    
    func test69() {
        let parseResult = parseToHTML("    foo\n---\n")
        XCTAssert("<pre><code>foo\n</code></pre>\n<hr />\n" == parseResult)
    }
    
    func test70() {
        let parseResult = parseToHTML("> foo\n-----\n")
        XCTAssert("<blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n" == parseResult)
    }
    
    func test71() {
        let parseResult = parseToHTML("\\> foo\n------\n")
        XCTAssert("<h2>&gt; foo</h2>\n" == parseResult)
    }
    
    func test72() {
        let parseResult = parseToHTML("Foo\n\nbar\n---\nbaz\n")
        XCTAssert("<p>Foo</p>\n<h2>bar</h2>\n<p>baz</p>\n" == parseResult)
    }
    
    func test73() {
        let parseResult = parseToHTML("Foo\nbar\n\n---\n\nbaz\n")
        XCTAssert("<p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n" == parseResult)
    }
    
    func test74() {
        let parseResult = parseToHTML("Foo\nbar\n* * *\nbaz\n")
        XCTAssert("<p>Foo\nbar</p>\n<hr />\n<p>baz</p>\n" == parseResult)
    }
    
    func test75() {
        let parseResult = parseToHTML("Foo\nbar\n\\---\nbaz\n")
        XCTAssert("<p>Foo\nbar\n---\nbaz</p>\n" == parseResult)
    }
    
    func test76() {
        let parseResult = parseToHTML("    a simple\n      indented code block\n")
        XCTAssert("<pre><code>a simple\n  indented code block\n</code></pre>\n" == parseResult)
    }
    
    func test77() {
        let parseResult = parseToHTML("  - foo\n\n    bar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test78() {
        let parseResult = parseToHTML("1.  foo\n\n    - bar\n")
        XCTAssert("<ol>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test79() {
        let parseResult = parseToHTML("    <a/>\n    *hi*\n\n    - one\n")
        XCTAssert("<pre><code>&lt;a/&gt;\n*hi*\n\n- one\n</code></pre>\n" == parseResult)
    }
    
    func test80() {
        let parseResult = parseToHTML("    chunk1\n\n    chunk2\n  \n \n \n    chunk3\n")
        XCTAssert("<pre><code>chunk1\n\nchunk2\n\n\n\nchunk3\n</code></pre>\n" == parseResult)
    }
    
    func test81() {
        let parseResult = parseToHTML("    chunk1\n      \n      chunk2\n")
        XCTAssert("<pre><code>chunk1\n  \n  chunk2\n</code></pre>\n" == parseResult)
    }
    
    func test82() {
        let parseResult = parseToHTML("Foo\n    bar\n\n")
        XCTAssert("<p>Foo\nbar</p>\n" == parseResult)
    }
    
    func test83() {
        let parseResult = parseToHTML("    foo\nbar\n")
        XCTAssert("<pre><code>foo\n</code></pre>\n<p>bar</p>\n" == parseResult)
    }
    
    func test84() {
        let parseResult = parseToHTML("# Heading\n    foo\nHeading\n------\n    foo\n----\n")
        XCTAssert("<h1>Heading</h1>\n<pre><code>foo\n</code></pre>\n<h2>Heading</h2>\n<pre><code>foo\n</code></pre>\n<hr />\n" == parseResult)
    }
    
    func test85() {
        let parseResult = parseToHTML("        foo\n    bar\n")
        XCTAssert("<pre><code>    foo\nbar\n</code></pre>\n" == parseResult)
    }
    
    func test86() {
        let parseResult = parseToHTML("\n    \n    foo\n    \n\n")
        XCTAssert("<pre><code>foo\n</code></pre>\n" == parseResult)
    }
    
    func test87() {
        let parseResult = parseToHTML("    foo  \n")
        XCTAssert("<pre><code>foo  \n</code></pre>\n" == parseResult)
    }
    
    func test88() {
        let parseResult = parseToHTML("```\n<\n >\n```\n")
        XCTAssert("<pre><code>&lt;\n &gt;\n</code></pre>\n" == parseResult)
    }
    
    func test89() {
        let parseResult = parseToHTML("~~~\n<\n >\n~~~\n")
        XCTAssert("<pre><code>&lt;\n &gt;\n</code></pre>\n" == parseResult)
    }
    
    func test90() {
        let parseResult = parseToHTML("``\nfoo\n``\n")
        XCTAssert("<p><code>foo</code></p>\n" == parseResult)
    }
    
    func test91() {
        let parseResult = parseToHTML("```\naaa\n~~~\n```\n")
        XCTAssert("<pre><code>aaa\n~~~\n</code></pre>\n" == parseResult)
    }
    
    func test92() {
        let parseResult = parseToHTML("~~~\naaa\n```\n~~~\n")
        XCTAssert("<pre><code>aaa\n```\n</code></pre>\n" == parseResult)
    }
    
    func test93() {
        let parseResult = parseToHTML("````\naaa\n```\n``````\n")
        XCTAssert("<pre><code>aaa\n```\n</code></pre>\n" == parseResult)
    }
    
    func test94() {
        let parseResult = parseToHTML("~~~~\naaa\n~~~\n~~~~\n")
        XCTAssert("<pre><code>aaa\n~~~\n</code></pre>\n" == parseResult)
    }
    
    func test95() {
        let parseResult = parseToHTML("```\n")
        XCTAssert("<pre><code></code></pre>\n" == parseResult)
    }
    
    func test96() {
        let parseResult = parseToHTML("`````\n\n```\naaa\n")
        XCTAssert("<pre><code>\n```\naaa\n</code></pre>\n" == parseResult)
    }
    
    func test97() {
        let parseResult = parseToHTML("> ```\n> aaa\n\nbbb\n")
        XCTAssert("<blockquote>\n<pre><code>aaa\n</code></pre>\n</blockquote>\n<p>bbb</p>\n" == parseResult)
    }
    
    func test98() {
        let parseResult = parseToHTML("```\n\n  \n```\n")
        XCTAssert("<pre><code>\n  \n</code></pre>\n" == parseResult)
    }
    
    func test99() {
        let parseResult = parseToHTML("```\n```\n")
        XCTAssert("<pre><code></code></pre>\n" == parseResult)
    }
    
    func test100() {
        let parseResult = parseToHTML(" ```\n aaa\naaa\n```\n")
        XCTAssert("<pre><code>aaa\naaa\n</code></pre>\n" == parseResult)
    }
    
    func test101() {
        let parseResult = parseToHTML("  ```\naaa\n  aaa\naaa\n  ```\n")
        XCTAssert("<pre><code>aaa\naaa\naaa\n</code></pre>\n" == parseResult)
    }
    
    func test102() {
        let parseResult = parseToHTML("   ```\n   aaa\n    aaa\n  aaa\n   ```\n")
        XCTAssert("<pre><code>aaa\n aaa\naaa\n</code></pre>\n" == parseResult)
    }
    
    func test103() {
        let parseResult = parseToHTML("    ```\n    aaa\n    ```\n")
        XCTAssert("<pre><code>```\naaa\n```\n</code></pre>\n" == parseResult)
    }
    
    func test104() {
        let parseResult = parseToHTML("```\naaa\n  ```\n")
        XCTAssert("<pre><code>aaa\n</code></pre>\n" == parseResult)
    }
    
    func test105() {
        let parseResult = parseToHTML("   ```\naaa\n  ```\n")
        XCTAssert("<pre><code>aaa\n</code></pre>\n" == parseResult)
    }
    
    func test106() {
        let parseResult = parseToHTML("```\naaa\n    ```\n")
        XCTAssert("<pre><code>aaa\n    ```\n</code></pre>\n" == parseResult)
    }
    
    func test107() {
        let parseResult = parseToHTML("``` ```\naaa\n")
        XCTAssert("<p><code></code>\naaa</p>\n" == parseResult)
    }
    
    func test108() {
        let parseResult = parseToHTML("~~~~~~\naaa\n~~~ ~~\n")
        XCTAssert("<pre><code>aaa\n~~~ ~~\n</code></pre>\n" == parseResult)
    }
    
    func test109() {
        let parseResult = parseToHTML("foo\n```\nbar\n```\nbaz\n")
        XCTAssert("<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n" == parseResult)
    }
    
    func test110() {
        let parseResult = parseToHTML("foo\n---\n~~~\nbar\n~~~\n# baz\n")
        XCTAssert("<h2>foo</h2>\n<pre><code>bar\n</code></pre>\n<h1>baz</h1>\n" == parseResult)
    }
    
    func test111() {
        let parseResult = parseToHTML("```ruby\ndef foo(x)\n  return 3\nend\n```\n")
        XCTAssert("<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n" == parseResult)
    }
    
    func test112() {
        let parseResult = parseToHTML("~~~~    ruby startline=3 $%@#$\ndef foo(x)\n  return 3\nend\n~~~~~~~\n")
        XCTAssert("<pre><code class=\"language-ruby\">def foo(x)\n  return 3\nend\n</code></pre>\n" == parseResult)
    }
    
    func test113() {
        let parseResult = parseToHTML("````;\n````\n")
        XCTAssert("<pre><code class=\"language-;\"></code></pre>\n" == parseResult)
    }
    
    func test114() {
        let parseResult = parseToHTML("``` aa ```\nfoo\n")
        XCTAssert("<p><code>aa</code>\nfoo</p>\n" == parseResult)
    }
    
    func test115() {
        let parseResult = parseToHTML("~~~ aa ``` ~~~\nfoo\n~~~\n")
        XCTAssert("<pre><code class=\"language-aa\">foo\n</code></pre>\n" == parseResult)
    }
    
    func test116() {
        let parseResult = parseToHTML("```\n``` aaa\n```\n")
        XCTAssert("<pre><code>``` aaa\n</code></pre>\n" == parseResult)
    }
    
    func test117() {
        let parseResult = parseToHTML("<table><tr><td>\n<pre>\n**Hello**,\n\n_world_.\n</pre>\n</td></tr></table>\n")
        XCTAssert("<table><tr><td>\n<pre>\n**Hello**,\n<p><em>world</em>.\n</pre></p>\n</td></tr></table>\n" == parseResult)
    }
    
    func test118() {
        let parseResult = parseToHTML("<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n\nokay.\n")
        XCTAssert("<table>\n  <tr>\n    <td>\n           hi\n    </td>\n  </tr>\n</table>\n<p>okay.</p>\n" == parseResult)
    }
    
    func test119() {
        let parseResult = parseToHTML(" <div>\n  *hello*\n         <foo><a>\n")
        XCTAssert(" <div>\n  *hello*\n         <foo><a>\n" == parseResult)
    }
    
    func test120() {
        let parseResult = parseToHTML("</div>\n*foo*\n")
        XCTAssert("</div>\n*foo*\n" == parseResult)
    }
    
    func test121() {
        let parseResult = parseToHTML("<DIV CLASS=\"foo\">\n\n*Markdown*\n\n</DIV>\n")
        XCTAssert("<DIV CLASS=\"foo\">\n<p><em>Markdown</em></p>\n</DIV>\n" == parseResult)
    }
    
    func test122() {
        let parseResult = parseToHTML("<div id=\"foo\"\n  class=\"bar\">\n</div>\n")
        XCTAssert("<div id=\"foo\"\n  class=\"bar\">\n</div>\n" == parseResult)
    }
    
    func test123() {
        let parseResult = parseToHTML("<div id=\"foo\" class=\"bar\n  baz\">\n</div>\n")
        XCTAssert("<div id=\"foo\" class=\"bar\n  baz\">\n</div>\n" == parseResult)
    }
    
    func test124() {
        let parseResult = parseToHTML("<div>\n*foo*\n\n*bar*\n")
        XCTAssert("<div>\n*foo*\n<p><em>bar</em></p>\n" == parseResult)
    }
    
    func test125() {
        let parseResult = parseToHTML("<div id=\"foo\"\n*hi*\n")
        XCTAssert("<div id=\"foo\"\n*hi*\n" == parseResult)
    }
    
    func test126() {
        let parseResult = parseToHTML("<div class\nfoo\n")
        XCTAssert("<div class\nfoo\n" == parseResult)
    }
    
    func test127() {
        let parseResult = parseToHTML("<div *???-&&&-<---\n*foo*\n")
        XCTAssert("<div *???-&&&-<---\n*foo*\n" == parseResult)
    }
    
    func test128() {
        let parseResult = parseToHTML("<div><a href=\"bar\">*foo*</a></div>\n")
        XCTAssert("<div><a href=\"bar\">*foo*</a></div>\n" == parseResult)
    }
    
    func test129() {
        let parseResult = parseToHTML("<table><tr><td>\nfoo\n</td></tr></table>\n")
        XCTAssert("<table><tr><td>\nfoo\n</td></tr></table>\n" == parseResult)
    }
    
    func test130() {
        let parseResult = parseToHTML("<div></div>\n``` c\nint x = 33;\n```\n")
        XCTAssert("<div></div>\n``` c\nint x = 33;\n```\n" == parseResult)
    }
    
    func test131() {
        let parseResult = parseToHTML("<a href=\"foo\">\n*bar*\n</a>\n")
        XCTAssert("<a href=\"foo\">\n*bar*\n</a>\n" == parseResult)
    }
    
    func test132() {
        let parseResult = parseToHTML("<Warning>\n*bar*\n</Warning>\n")
        XCTAssert("<Warning>\n*bar*\n</Warning>\n" == parseResult)
    }
    
    func test133() {
        let parseResult = parseToHTML("<i class=\"foo\">\n*bar*\n</i>\n")
        XCTAssert("<i class=\"foo\">\n*bar*\n</i>\n" == parseResult)
    }
    
    func test134() {
        let parseResult = parseToHTML("</ins>\n*bar*\n")
        XCTAssert("</ins>\n*bar*\n" == parseResult)
    }
    
    func test135() {
        let parseResult = parseToHTML("<del>\n*foo*\n</del>\n")
        XCTAssert("<del>\n*foo*\n</del>\n" == parseResult)
    }
    
    func test136() {
        let parseResult = parseToHTML("<del>\n\n*foo*\n\n</del>\n")
        XCTAssert("<del>\n<p><em>foo</em></p>\n</del>\n" == parseResult)
    }
    
    func test137() {
        let parseResult = parseToHTML("<del>*foo*</del>\n")
        XCTAssert("<p><del><em>foo</em></del></p>\n" == parseResult)
    }
    
    func test138() {
        let parseResult = parseToHTML("<pre language=\"haskell\"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>\nokay\n")
        XCTAssert("<pre language=\"haskell\"><code>\nimport Text.HTML.TagSoup\n\nmain :: IO ()\nmain = print $ parseTags tags\n</code></pre>\n<p>okay</p>\n" == parseResult)
    }
    
    func test139() {
        let parseResult = parseToHTML("<script type=\"text/javascript\">\n// JavaScript example\n\ndocument.getElementById(\"demo\").innerHTML = \"Hello JavaScript!\";\n</script>\nokay\n")
        XCTAssert("<script type=\"text/javascript\">\n// JavaScript example\n\ndocument.getElementById(\"demo\").innerHTML = \"Hello JavaScript!\";\n</script>\n<p>okay</p>\n" == parseResult)
    }
    
    func test140() {
        let parseResult = parseToHTML("<style\n  type=\"text/css\">\nh1 {color:red;}\n\np {color:blue;}\n</style>\nokay\n")
        XCTAssert("<style\n  type=\"text/css\">\nh1 {color:red;}\n\np {color:blue;}\n</style>\n<p>okay</p>\n" == parseResult)
    }
    
    func test141() {
        let parseResult = parseToHTML("<style\n  type=\"text/css\">\n\nfoo\n")
        XCTAssert("<style\n  type=\"text/css\">\n\nfoo\n" == parseResult)
    }
    
    func test142() {
        let parseResult = parseToHTML("> <div>\n> foo\n\nbar\n")
        XCTAssert("<blockquote>\n<div>\nfoo\n</blockquote>\n<p>bar</p>\n" == parseResult)
    }
    
    func test143() {
        let parseResult = parseToHTML("- <div>\n- foo\n")
        XCTAssert("<ul>\n<li>\n<div>\n</li>\n<li>foo</li>\n</ul>\n" == parseResult)
    }
    
    func test144() {
        let parseResult = parseToHTML("<style>p{color:red;}</style>\n*foo*\n")
        XCTAssert("<style>p{color:red;}</style>\n<p><em>foo</em></p>\n" == parseResult)
    }
    
    func test145() {
        let parseResult = parseToHTML("<!-- foo -->*bar*\n*baz*\n")
        XCTAssert("<!-- foo -->*bar*\n<p><em>baz</em></p>\n" == parseResult)
    }
    
    func test146() {
        let parseResult = parseToHTML("<script>\nfoo\n</script>1. *bar*\n")
        XCTAssert("<script>\nfoo\n</script>1. *bar*\n" == parseResult)
    }
    
    func test147() {
        let parseResult = parseToHTML("<!-- Foo\n\nbar\n   baz -->\nokay\n")
        XCTAssert("<!-- Foo\n\nbar\n   baz -->\n<p>okay</p>\n" == parseResult)
    }
    
    func test148() {
        let parseResult = parseToHTML("<?php\n\n  echo '>';\n\n?>\nokay\n")
        XCTAssert("<?php\n\n  echo '>';\n\n?>\n<p>okay</p>\n" == parseResult)
    }
    
    func test149() {
        let parseResult = parseToHTML("<!DOCTYPE html>\n")
        XCTAssert("<!DOCTYPE html>\n" == parseResult)
    }
    
    func test150() {
        let parseResult = parseToHTML("<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>\nokay\n")
        XCTAssert("<![CDATA[\nfunction matchwo(a,b)\n{\n  if (a < b && a < 0) then {\n    return 1;\n\n  } else {\n\n    return 0;\n  }\n}\n]]>\n<p>okay</p>\n" == parseResult)
    }
    
    func test151() {
        let parseResult = parseToHTML("  <!-- foo -->\n\n    <!-- foo -->\n")
        XCTAssert("  <!-- foo -->\n<pre><code>&lt;!-- foo --&gt;\n</code></pre>\n" == parseResult)
    }
    
    func test152() {
        let parseResult = parseToHTML("  <div>\n\n    <div>\n")
        XCTAssert("  <div>\n<pre><code>&lt;div&gt;\n</code></pre>\n" == parseResult)
    }
    
    func test153() {
        let parseResult = parseToHTML("Foo\n<div>\nbar\n</div>\n")
        XCTAssert("<p>Foo</p>\n<div>\nbar\n</div>\n" == parseResult)
    }
    
    func test154() {
        let parseResult = parseToHTML("<div>\nbar\n</div>\n*foo*\n")
        XCTAssert("<div>\nbar\n</div>\n*foo*\n" == parseResult)
    }
    
    func test155() {
        let parseResult = parseToHTML("Foo\n<a href=\"bar\">\nbaz\n")
        XCTAssert("<p>Foo\n<a href=\"bar\">\nbaz</p>\n" == parseResult)
    }
    
    func test156() {
        let parseResult = parseToHTML("<div>\n\n*Emphasized* text.\n\n</div>\n")
        XCTAssert("<div>\n<p><em>Emphasized</em> text.</p>\n</div>\n" == parseResult)
    }
    
    func test157() {
        let parseResult = parseToHTML("<div>\n*Emphasized* text.\n</div>\n")
        XCTAssert("<div>\n*Emphasized* text.\n</div>\n" == parseResult)
    }
    
    func test158() {
        let parseResult = parseToHTML("<table>\n\n<tr>\n\n<td>\nHi\n</td>\n\n</tr>\n\n</table>\n")
        XCTAssert("<table>\n<tr>\n<td>\nHi\n</td>\n</tr>\n</table>\n" == parseResult)
    }
    
    func test159() {
        let parseResult = parseToHTML("<table>\n\n  <tr>\n\n    <td>\n      Hi\n    </td>\n\n  </tr>\n\n</table>\n")
        XCTAssert("<table>\n  <tr>\n<pre><code>&lt;td&gt;\n  Hi\n&lt;/td&gt;\n</code></pre>\n  </tr>\n</table>\n" == parseResult)
    }
    
    func test160() {
        let parseResult = parseToHTML("[foo]: /url \"title\"\n\n[foo]\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test161() {
        let parseResult = parseToHTML("   [foo]: \n      /url  \n           'the title'  \n\n[foo]\n")
        XCTAssert("<p><a href=\"/url\" title=\"the title\">foo</a></p>\n" == parseResult)
    }
    
    func test162() {
        let parseResult = parseToHTML("[Foo*bar\\]]:my_(url) 'title (with parens)'\n\n[Foo*bar\\]]\n")
        XCTAssert("<p><a href=\"my_(url)\" title=\"title (with parens)\">Foo*bar]</a></p>\n" == parseResult)
    }
    
    func test163() {
        let parseResult = parseToHTML("[Foo bar]:\n<my url>\n'title'\n\n[Foo bar]\n")
        XCTAssert("<p><a href=\"my%20url\" title=\"title\">Foo bar</a></p>\n" == parseResult)
    }
    
    func test164() {
        let parseResult = parseToHTML("[foo]: /url '\ntitle\nline1\nline2\n'\n\n[foo]\n")
        XCTAssert("<p><a href=\"/url\" title=\"\ntitle\nline1\nline2\n\">foo</a></p>\n" == parseResult)
    }
    
    func test165() {
        let parseResult = parseToHTML("[foo]: /url 'title\n\nwith blank line'\n\n[foo]\n")
        XCTAssert("<p>[foo]: /url 'title</p>\n<p>with blank line'</p>\n<p>[foo]</p>\n" == parseResult)
    }
    
    func test166() {
        let parseResult = parseToHTML("[foo]:\n/url\n\n[foo]\n")
        XCTAssert("<p><a href=\"/url\">foo</a></p>\n" == parseResult)
    }
    
    func test167() {
        let parseResult = parseToHTML("[foo]:\n\n[foo]\n")
        XCTAssert("<p>[foo]:</p>\n<p>[foo]</p>\n" == parseResult)
    }
    
    func test168() {
        let parseResult = parseToHTML("[foo]: <bar>(baz)\n\n[foo]\n")
        XCTAssert("<p>[foo]: <bar>(baz)</p>\n<p>[foo]</p>\n" == parseResult)
    }
    
    func test169() {
        let parseResult = parseToHTML("[foo]: /url\\bar\\*baz \"foo\\\"bar\\baz\"\n\n[foo]\n")
        XCTAssert("<p><a href=\"/url%5Cbar*baz\" title=\"foo&quot;bar\\baz\">foo</a></p>\n" == parseResult)
    }
    
    func test170() {
        let parseResult = parseToHTML("[foo]\n\n[foo]: url\n")
        XCTAssert("<p><a href=\"url\">foo</a></p>\n" == parseResult)
    }
    
    func test171() {
        let parseResult = parseToHTML("[foo]\n\n[foo]: first\n[foo]: second\n")
        XCTAssert("<p><a href=\"first\">foo</a></p>\n" == parseResult)
    }
    
    func test172() {
        let parseResult = parseToHTML("[FOO]: /url\n\n[Foo]\n")
        XCTAssert("<p><a href=\"/url\">Foo</a></p>\n" == parseResult)
    }
    
    func test173() {
        let parseResult = parseToHTML("[ΑΓΩ]: /φου\n\n[αγω]\n")
        XCTAssert("<p><a href=\"/%CF%86%CE%BF%CF%85\">αγω</a></p>\n" == parseResult)
    }
    
    func test174() {
        let parseResult = parseToHTML("[foo]: /url\n")
        XCTAssert("" == parseResult)
    }
    
    func test175() {
        let parseResult = parseToHTML("[\nfoo\n]: /url\nbar\n")
        XCTAssert("<p>bar</p>\n" == parseResult)
    }
    
    func test176() {
        let parseResult = parseToHTML("[foo]: /url \"title\" ok\n")
        XCTAssert("<p>[foo]: /url &quot;title&quot; ok</p>\n" == parseResult)
    }
    
    func test177() {
        let parseResult = parseToHTML("[foo]: /url\n\"title\" ok\n")
        XCTAssert("<p>&quot;title&quot; ok</p>\n" == parseResult)
    }
    
    func test178() {
        let parseResult = parseToHTML("    [foo]: /url \"title\"\n\n[foo]\n")
        XCTAssert("<pre><code>[foo]: /url &quot;title&quot;\n</code></pre>\n<p>[foo]</p>\n" == parseResult)
    }
    
    func test179() {
        let parseResult = parseToHTML("```\n[foo]: /url\n```\n\n[foo]\n")
        XCTAssert("<pre><code>[foo]: /url\n</code></pre>\n<p>[foo]</p>\n" == parseResult)
    }
    
    func test180() {
        let parseResult = parseToHTML("Foo\n[bar]: /baz\n\n[bar]\n")
        XCTAssert("<p>Foo\n[bar]: /baz</p>\n<p>[bar]</p>\n" == parseResult)
    }
    
    func test181() {
        let parseResult = parseToHTML("# [Foo]\n[foo]: /url\n> bar\n")
        XCTAssert("<h1><a href=\"/url\">Foo</a></h1>\n<blockquote>\n<p>bar</p>\n</blockquote>\n" == parseResult)
    }
    
    func test182() {
        let parseResult = parseToHTML("[foo]: /foo-url \"foo\"\n[bar]: /bar-url\n  \"bar\"\n[baz]: /baz-url\n\n[foo],\n[bar],\n[baz]\n")
        XCTAssert("<p><a href=\"/foo-url\" title=\"foo\">foo</a>,\n<a href=\"/bar-url\" title=\"bar\">bar</a>,\n<a href=\"/baz-url\">baz</a></p>\n" == parseResult)
    }
    
    func test183() {
        let parseResult = parseToHTML("[foo]\n\n> [foo]: /url\n")
        XCTAssert("<p><a href=\"/url\">foo</a></p>\n<blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test184() {
        let parseResult = parseToHTML("aaa\n\nbbb\n")
        XCTAssert("<p>aaa</p>\n<p>bbb</p>\n" == parseResult)
    }
    
    func test185() {
        let parseResult = parseToHTML("aaa\nbbb\n\nccc\nddd\n")
        XCTAssert("<p>aaa\nbbb</p>\n<p>ccc\nddd</p>\n" == parseResult)
    }
    
    func test186() {
        let parseResult = parseToHTML("aaa\n\n\nbbb\n")
        XCTAssert("<p>aaa</p>\n<p>bbb</p>\n" == parseResult)
    }
    
    func test187() {
        let parseResult = parseToHTML("  aaa\n bbb\n")
        XCTAssert("<p>aaa\nbbb</p>\n" == parseResult)
    }
    
    func test188() {
        let parseResult = parseToHTML("aaa\n             bbb\n                                       ccc\n")
        XCTAssert("<p>aaa\nbbb\nccc</p>\n" == parseResult)
    }
    
    func test189() {
        let parseResult = parseToHTML("   aaa\nbbb\n")
        XCTAssert("<p>aaa\nbbb</p>\n" == parseResult)
    }
    
    func test190() {
        let parseResult = parseToHTML("    aaa\nbbb\n")
        XCTAssert("<pre><code>aaa\n</code></pre>\n<p>bbb</p>\n" == parseResult)
    }
    
    func test191() {
        let parseResult = parseToHTML("aaa     \nbbb     \n")
        XCTAssert("<p>aaa<br />\nbbb</p>\n" == parseResult)
    }
    
    func test192() {
        let parseResult = parseToHTML("  \n\naaa\n  \n\n# aaa\n\n  \n")
        XCTAssert("<p>aaa</p>\n<h1>aaa</h1>\n" == parseResult)
    }
    
    func test193() {
        let parseResult = parseToHTML("> # Foo\n> bar\n> baz\n")
        XCTAssert("<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n" == parseResult)
    }
    
    func test194() {
        let parseResult = parseToHTML("># Foo\n>bar\n> baz\n")
        XCTAssert("<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n" == parseResult)
    }
    
    func test195() {
        let parseResult = parseToHTML("   > # Foo\n   > bar\n > baz\n")
        XCTAssert("<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n" == parseResult)
    }
    
    func test196() {
        let parseResult = parseToHTML("    > # Foo\n    > bar\n    > baz\n")
        XCTAssert("<pre><code>&gt; # Foo\n&gt; bar\n&gt; baz\n</code></pre>\n" == parseResult)
    }
    
    func test197() {
        let parseResult = parseToHTML("> # Foo\n> bar\nbaz\n")
        XCTAssert("<blockquote>\n<h1>Foo</h1>\n<p>bar\nbaz</p>\n</blockquote>\n" == parseResult)
    }
    
    func test198() {
        let parseResult = parseToHTML("> bar\nbaz\n> foo\n")
        XCTAssert("<blockquote>\n<p>bar\nbaz\nfoo</p>\n</blockquote>\n" == parseResult)
    }
    
    func test199() {
        let parseResult = parseToHTML("> foo\n---\n")
        XCTAssert("<blockquote>\n<p>foo</p>\n</blockquote>\n<hr />\n" == parseResult)
    }
    
    func test200() {
        let parseResult = parseToHTML("> - foo\n- bar\n")
        XCTAssert("<blockquote>\n<ul>\n<li>foo</li>\n</ul>\n</blockquote>\n<ul>\n<li>bar</li>\n</ul>\n" == parseResult)
    }
    
    func test201() {
        let parseResult = parseToHTML(">     foo\n    bar\n")
        XCTAssert("<blockquote>\n<pre><code>foo\n</code></pre>\n</blockquote>\n<pre><code>bar\n</code></pre>\n" == parseResult)
    }
    
    func test202() {
        let parseResult = parseToHTML("> ```\nfoo\n```\n")
        XCTAssert("<blockquote>\n<pre><code></code></pre>\n</blockquote>\n<p>foo</p>\n<pre><code></code></pre>\n" == parseResult)
    }
    
    func test203() {
        let parseResult = parseToHTML("> foo\n    - bar\n")
        XCTAssert("<blockquote>\n<p>foo\n- bar</p>\n</blockquote>\n" == parseResult)
    }
    
    // failed in md-it
    func test204() {
        let parseResult = parseToHTML(">\n")
        XCTAssert("<blockquote>\n</blockquote>\n" == parseResult)
    }
    
    // failed in md-it
    func test205() {
        let parseResult = parseToHTML(">\n>  \n> \n")
        XCTAssert("<blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test206() {
        let parseResult = parseToHTML(">\n> foo\n>  \n")
        XCTAssert("<blockquote>\n<p>foo</p>\n</blockquote>\n" == parseResult)
    }
    
    func test207() {
        let parseResult = parseToHTML("> foo\n\n> bar\n")
        XCTAssert("<blockquote>\n<p>foo</p>\n</blockquote>\n<blockquote>\n<p>bar</p>\n</blockquote>\n" == parseResult)
    }
    
    func test208() {
        let parseResult = parseToHTML("> foo\n> bar\n")
        XCTAssert("<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n" == parseResult)
    }
    
    func test209() {
        let parseResult = parseToHTML("> foo\n>\n> bar\n")
        XCTAssert("<blockquote>\n<p>foo</p>\n<p>bar</p>\n</blockquote>\n" == parseResult)
    }
    
    func test210() {
        let parseResult = parseToHTML("foo\n> bar\n")
        XCTAssert("<p>foo</p>\n<blockquote>\n<p>bar</p>\n</blockquote>\n" == parseResult)
    }
    
    func test211() {
        let parseResult = parseToHTML("> aaa\n***\n> bbb\n")
        XCTAssert("<blockquote>\n<p>aaa</p>\n</blockquote>\n<hr />\n<blockquote>\n<p>bbb</p>\n</blockquote>\n" == parseResult)
    }
    
    func test212() {
        let parseResult = parseToHTML("> bar\nbaz\n")
        XCTAssert("<blockquote>\n<p>bar\nbaz</p>\n</blockquote>\n" == parseResult)
    }
    
    func test213() {
        let parseResult = parseToHTML("> bar\n\nbaz\n")
        XCTAssert("<blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n" == parseResult)
    }
    
    func test214() {
        let parseResult = parseToHTML("> bar\n>\nbaz\n")
        XCTAssert("<blockquote>\n<p>bar</p>\n</blockquote>\n<p>baz</p>\n" == parseResult)
    }
    
    func test215() {
        let parseResult = parseToHTML("> > > foo\nbar\n")
        XCTAssert("<blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar</p>\n</blockquote>\n</blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test216() {
        let parseResult = parseToHTML(">>> foo\n> bar\n>>baz\n")
        XCTAssert("<blockquote>\n<blockquote>\n<blockquote>\n<p>foo\nbar\nbaz</p>\n</blockquote>\n</blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test217() {
        let parseResult = parseToHTML(">     code\n\n>    not code\n")
        XCTAssert("<blockquote>\n<pre><code>code\n</code></pre>\n</blockquote>\n<blockquote>\n<p>not code</p>\n</blockquote>\n" == parseResult)
    }
    
    func test218() {
        let parseResult = parseToHTML("A paragraph\nwith two lines.\n\n    indented code\n\n> A block quote.\n")
        XCTAssert("<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n" == parseResult)
    }
    
    func test219() {
        let parseResult = parseToHTML("1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.\n")
        XCTAssert("<ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test220() {
        let parseResult = parseToHTML("- one\n\n two\n")
        XCTAssert("<ul>\n<li>one</li>\n</ul>\n<p>two</p>\n" == parseResult)
    }
    
    func test221() {
        let parseResult = parseToHTML("- one\n\n  two\n")
        XCTAssert("<ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test222() {
        let parseResult = parseToHTML(" -    one\n\n     two\n")
        XCTAssert("<ul>\n<li>one</li>\n</ul>\n<pre><code> two\n</code></pre>\n" == parseResult)
    }
    
    func test223() {
        let parseResult = parseToHTML(" -    one\n\n      two\n")
        XCTAssert("<ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test224() {
        let parseResult = parseToHTML("   > > 1.  one\n>>\n>>     two\n")
        XCTAssert("<blockquote>\n<blockquote>\n<ol>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ol>\n</blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test225() {
        let parseResult = parseToHTML(">>- one\n>>\n  >  > two\n")
        XCTAssert("<blockquote>\n<blockquote>\n<ul>\n<li>one</li>\n</ul>\n<p>two</p>\n</blockquote>\n</blockquote>\n" == parseResult)
    }
    
    func test226() {
        let parseResult = parseToHTML("-one\n\n2.two\n")
        XCTAssert("<p>-one</p>\n<p>2.two</p>\n" == parseResult)
    }
    
    func test227() {
        let parseResult = parseToHTML("- foo\n\n\n  bar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test228() {
        let parseResult = parseToHTML("1.  foo\n\n    ```\n    bar\n    ```\n\n    baz\n\n    > bam\n")
        XCTAssert("<ol>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n<blockquote>\n<p>bam</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test229() {
        let parseResult = parseToHTML("- Foo\n\n      bar\n\n\n      baz\n")
        XCTAssert("<ul>\n<li>\n<p>Foo</p>\n<pre><code>bar\n\n\nbaz\n</code></pre>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test230() {
        let parseResult = parseToHTML("123456789. ok\n")
        XCTAssert("<ol start=\"123456789\">\n<li>ok</li>\n</ol>\n" == parseResult)
    }
    
    func test231() {
        let parseResult = parseToHTML("1234567890. not ok\n")
        XCTAssert("<p>1234567890. not ok</p>\n" == parseResult)
    }
    
    func test232() {
        let parseResult = parseToHTML("0. ok\n")
        XCTAssert("<ol start=\"0\">\n<li>ok</li>\n</ol>\n" == parseResult)
    }
    
    func test233() {
        let parseResult = parseToHTML("003. ok\n")
        XCTAssert("<ol start=\"3\">\n<li>ok</li>\n</ol>\n" == parseResult)
    }
    
    func test234() {
        let parseResult = parseToHTML("-1. not ok\n")
        XCTAssert("<p>-1. not ok</p>\n" == parseResult)
    }
    
    func test235() {
        let parseResult = parseToHTML("- foo\n\n      bar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test236() {
        let parseResult = parseToHTML("  10.  foo\n\n           bar\n")
        XCTAssert("<ol start=\"10\">\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test237() {
        let parseResult = parseToHTML("    indented code\n\nparagraph\n\n    more code\n")
        XCTAssert("<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n" == parseResult)
    }
    
    func test238() {
        let parseResult = parseToHTML("1.     indented code\n\n   paragraph\n\n       more code\n")
        XCTAssert("<ol>\n<li>\n<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test239() {
        let parseResult = parseToHTML("1.      indented code\n\n   paragraph\n\n       more code\n")
        XCTAssert("<ol>\n<li>\n<pre><code> indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test240() {
        let parseResult = parseToHTML("   foo\n\nbar\n")
        XCTAssert("<p>foo</p>\n<p>bar</p>\n" == parseResult)
    }
    
    func test241() {
        let parseResult = parseToHTML("-    foo\n\n  bar\n")
        XCTAssert("<ul>\n<li>foo</li>\n</ul>\n<p>bar</p>\n" == parseResult)
    }
    
    func test242() {
        let parseResult = parseToHTML("-  foo\n\n   bar\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test243() {
        let parseResult = parseToHTML("-\n  foo\n-\n  ```\n  bar\n  ```\n-\n      baz\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li>\n<pre><code>bar\n</code></pre>\n</li>\n<li>\n<pre><code>baz\n</code></pre>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test244() {
        let parseResult = parseToHTML("-   \n  foo\n")
        XCTAssert("<ul>\n<li>foo</li>\n</ul>\n" == parseResult)
    }
    
    func test245() {
        let parseResult = parseToHTML("-\n\n  foo\n")
        XCTAssert("<ul>\n<li></li>\n</ul>\n<p>foo</p>\n" == parseResult)
    }
    
    func test246() {
        let parseResult = parseToHTML("- foo\n-\n- bar\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n" == parseResult)
    }
    
    func test247() {
        let parseResult = parseToHTML("- foo\n-   \n- bar\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n" == parseResult)
    }
    
    func test248() {
        let parseResult = parseToHTML("1. foo\n2.\n3. bar\n")
        XCTAssert("<ol>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ol>\n" == parseResult)
    }
    
    func test249() {
        let parseResult = parseToHTML("*\n")
        XCTAssert("<ul>\n<li></li>\n</ul>\n" == parseResult)
    }
    
    func test250() {
        let parseResult = parseToHTML("foo\n*\n\nfoo\n1.\n")
        XCTAssert("<p>foo\n*</p>\n<p>foo\n1.</p>\n" == parseResult)
    }
    
    func test251() {
        let parseResult = parseToHTML(" 1.  A paragraph\n     with two lines.\n\n         indented code\n\n     > A block quote.\n")
        XCTAssert("<ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test252() {
        let parseResult = parseToHTML("  1.  A paragraph\n      with two lines.\n\n          indented code\n\n      > A block quote.\n")
        XCTAssert("<ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test253() {
        let parseResult = parseToHTML("   1.  A paragraph\n       with two lines.\n\n           indented code\n\n       > A block quote.\n")
        XCTAssert("<ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test254() {
        let parseResult = parseToHTML("    1.  A paragraph\n        with two lines.\n\n            indented code\n\n        > A block quote.\n")
        XCTAssert("<pre><code>1.  A paragraph\n    with two lines.\n\n        indented code\n\n    &gt; A block quote.\n</code></pre>\n" == parseResult)
    }
    
    func test255() {
        let parseResult = parseToHTML("  1.  A paragraph\nwith two lines.\n\n          indented code\n\n      > A block quote.\n")
        XCTAssert("<ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test256() {
        let parseResult = parseToHTML("  1.  A paragraph\n    with two lines.\n")
        XCTAssert("<ol>\n<li>A paragraph\nwith two lines.</li>\n</ol>\n" == parseResult)
    }
    
    func test257() {
        let parseResult = parseToHTML("> 1. > Blockquote\ncontinued here.\n")
        XCTAssert("<blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n" == parseResult)
    }
    
    func test258() {
        let parseResult = parseToHTML("> 1. > Blockquote\n> continued here.\n")
        XCTAssert("<blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n" == parseResult)
    }
    
    func test259() {
        let parseResult = parseToHTML("- foo\n  - bar\n    - baz\n      - boo\n")
        XCTAssert("<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz\n<ul>\n<li>boo</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test260() {
        let parseResult = parseToHTML("- foo\n - bar\n  - baz\n   - boo\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n<li>boo</li>\n</ul>\n" == parseResult)
    }
    
    func test261() {
        let parseResult = parseToHTML("10) foo\n    - bar\n")
        XCTAssert("<ol start=\"10\">\n<li>foo\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test262() {
        let parseResult = parseToHTML("10) foo\n   - bar\n")
        XCTAssert("<ol start=\"10\">\n<li>foo</li>\n</ol>\n<ul>\n<li>bar</li>\n</ul>\n" == parseResult)
    }
    
    func test263() {
        let parseResult = parseToHTML("- - foo\n")
        XCTAssert("<ul>\n<li>\n<ul>\n<li>foo</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test264() {
        let parseResult = parseToHTML("1. - 2. foo\n")
        XCTAssert("<ol>\n<li>\n<ul>\n<li>\n<ol start=\"2\">\n<li>foo</li>\n</ol>\n</li>\n</ul>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test265() {
        let parseResult = parseToHTML("- # Foo\n- Bar\n  ---\n  baz\n")
        XCTAssert("<ul>\n<li>\n<h1>Foo</h1>\n</li>\n<li>\n<h2>Bar</h2>\nbaz</li>\n</ul>\n" == parseResult)
    }
    
    func test266() {
        let parseResult = parseToHTML("- foo\n- bar\n+ baz\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<ul>\n<li>baz</li>\n</ul>\n" == parseResult)
    }
    
    func test267() {
        let parseResult = parseToHTML("1. foo\n2. bar\n3) baz\n")
        XCTAssert("<ol>\n<li>foo</li>\n<li>bar</li>\n</ol>\n<ol start=\"3\">\n<li>baz</li>\n</ol>\n" == parseResult)
    }
    
    func test268() {
        let parseResult = parseToHTML("Foo\n- bar\n- baz\n")
        XCTAssert("<p>Foo</p>\n<ul>\n<li>bar</li>\n<li>baz</li>\n</ul>\n" == parseResult)
    }
    
    func test269() {
        let parseResult = parseToHTML("The number of windows in my house is\n14.  The number of doors is 6.\n")
        XCTAssert("<p>The number of windows in my house is\n14.  The number of doors is 6.</p>\n" == parseResult)
    }
    
    func test270() {
        let parseResult = parseToHTML("The number of windows in my house is\n1.  The number of doors is 6.\n")
        XCTAssert("<p>The number of windows in my house is</p>\n<ol>\n<li>The number of doors is 6.</li>\n</ol>\n" == parseResult)
    }
    
    func test271() {
        let parseResult = parseToHTML("- foo\n\n- bar\n\n\n- baz\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n</li>\n<li>\n<p>bar</p>\n</li>\n<li>\n<p>baz</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test272() {
        let parseResult = parseToHTML("- foo\n  - bar\n    - baz\n\n\n      bim\n")
        XCTAssert("<ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>\n<p>baz</p>\n<p>bim</p>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test273() {
        let parseResult = parseToHTML("- foo\n- bar\n\n<!-- -->\n\n- baz\n- bim\n")
        XCTAssert("<ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<!-- -->\n<ul>\n<li>baz</li>\n<li>bim</li>\n</ul>\n" == parseResult)
    }
    
    func test274() {
        let parseResult = parseToHTML("-   foo\n\n    notcode\n\n-   foo\n\n<!-- -->\n\n    code\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<p>notcode</p>\n</li>\n<li>\n<p>foo</p>\n</li>\n</ul>\n<!-- -->\n<pre><code>code\n</code></pre>\n" == parseResult)
    }
    
    func test275() {
        let parseResult = parseToHTML("- a\n - b\n  - c\n   - d\n  - e\n - f\n- g\n")
        XCTAssert("<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d</li>\n<li>e</li>\n<li>f</li>\n<li>g</li>\n</ul>\n" == parseResult)
    }
    
    func test276() {
        let parseResult = parseToHTML("1. a\n\n  2. b\n\n   3. c\n")
        XCTAssert("<ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ol>\n" == parseResult)
    }
    
    // failed in md-it
    func test277() {
        let parseResult = parseToHTML("- a\n - b\n  - c\n   - d\n    - e\n")
        XCTAssert("<ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d\n- e</li>\n</ul>\n" == parseResult)
    }
    
    // failed in md-it
    func test278() {
        let parseResult = parseToHTML("1. a\n\n  2. b\n\n    3. c\n")
        XCTAssert("<ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n</ol>\n<pre><code>3. c\n</code></pre>\n" == parseResult)
    }
    
    func test279() {
        let parseResult = parseToHTML("- a\n- b\n\n- c\n")
        XCTAssert("<ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test280() {
        let parseResult = parseToHTML("* a\n*\n\n* c\n")
        XCTAssert("<ul>\n<li>\n<p>a</p>\n</li>\n<li></li>\n<li>\n<p>c</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test281() {
        let parseResult = parseToHTML("- a\n- b\n\n  c\n- d\n")
        XCTAssert("<ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test282() {
        let parseResult = parseToHTML("- a\n- b\n\n  [ref]: /url\n- d\n")
        XCTAssert("<ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test283() {
        let parseResult = parseToHTML("- a\n- ```\n  b\n\n\n  ```\n- c\n")
        XCTAssert("<ul>\n<li>a</li>\n<li>\n<pre><code>b\n\n\n</code></pre>\n</li>\n<li>c</li>\n</ul>\n" == parseResult)
    }
    
    func test284() {
        let parseResult = parseToHTML("- a\n  - b\n\n    c\n- d\n")
        XCTAssert("<ul>\n<li>a\n<ul>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n</ul>\n</li>\n<li>d</li>\n</ul>\n" == parseResult)
    }
    
    func test285() {
        let parseResult = parseToHTML("* a\n  > b\n  >\n* c\n")
        XCTAssert("<ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n</li>\n<li>c</li>\n</ul>\n" == parseResult)
    }
    
    func test286() {
        let parseResult = parseToHTML("- a\n  > b\n  ```\n  c\n  ```\n- d\n")
        XCTAssert("<ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n<pre><code>c\n</code></pre>\n</li>\n<li>d</li>\n</ul>\n" == parseResult)
    }
    
    func test287() {
        let parseResult = parseToHTML("- a\n")
        XCTAssert("<ul>\n<li>a</li>\n</ul>\n" == parseResult)
    }
    
    func test288() {
        let parseResult = parseToHTML("- a\n  - b\n")
        XCTAssert("<ul>\n<li>a\n<ul>\n<li>b</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test289() {
        let parseResult = parseToHTML("1. ```\n   foo\n   ```\n\n   bar\n")
        XCTAssert("<ol>\n<li>\n<pre><code>foo\n</code></pre>\n<p>bar</p>\n</li>\n</ol>\n" == parseResult)
    }
    
    func test290() {
        let parseResult = parseToHTML("* foo\n  * bar\n\n  baz\n")
        XCTAssert("<ul>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n<p>baz</p>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test291() {
        let parseResult = parseToHTML("- a\n  - b\n  - c\n\n- d\n  - e\n  - f\n")
        XCTAssert("<ul>\n<li>\n<p>a</p>\n<ul>\n<li>b</li>\n<li>c</li>\n</ul>\n</li>\n<li>\n<p>d</p>\n<ul>\n<li>e</li>\n<li>f</li>\n</ul>\n</li>\n</ul>\n" == parseResult)
    }
    
    func test292() {
        let parseResult = parseToHTML("`hi`lo`\n")
        XCTAssert("<p><code>hi</code>lo`</p>\n" == parseResult)
    }
    
    func test293() {
        let parseResult = parseToHTML("\\!\\\"\\#\\$\\%\\&\\'\\(\\)\\*\\+\\,\\-\\.\\/\\:\\;\\<\\=\\>\\?\\@\\[\\\\\\]\\^\\_\\`\\{\\|\\}\\~\n")
        XCTAssert("<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\\]^_`{|}~</p>\n" == parseResult)
    }
    
    func test294() {
        let parseResult = parseToHTML("\\\t\\A\\a\\ \\3\\φ\\«\n")
        XCTAssert("<p>\\\t\\A\\a\\ \\3\\φ\\«</p>\n" == parseResult)
    }
    
    func test295() {
        let parseResult = parseToHTML("\\*not emphasized*\n\\<br/> not a tag\n\\[not a link](/foo)\n\\`not code`\n1\\. not a list\n\\* not a list\n\\# not a heading\n\\[foo]: /url \"not a reference\"\n")
        XCTAssert("<p>*not emphasized*\n&lt;br/&gt; not a tag\n[not a link](/foo)\n`not code`\n1. not a list\n* not a list\n# not a heading\n[foo]: /url &quot;not a reference&quot;</p>\n" == parseResult)
    }
    
    func test296() {
        let parseResult = parseToHTML("\\\\*emphasis*\n")
        XCTAssert("<p>\\<em>emphasis</em></p>\n" == parseResult)
    }
    
    func test297() {
        let parseResult = parseToHTML("foo\\\nbar\n")
        XCTAssert("<p>foo<br />\nbar</p>\n" == parseResult)
    }
    
    func test298() {
        let parseResult = parseToHTML("`` \\[\\` ``\n")
        XCTAssert("<p><code>\\[\\`</code></p>\n" == parseResult)
    }
    
    func test299() {
        let parseResult = parseToHTML("    \\[\\]\n")
        XCTAssert("<pre><code>\\[\\]\n</code></pre>\n" == parseResult)
    }
    
    func test300() {
        let parseResult = parseToHTML("~~~\n\\[\\]\n~~~\n")
        XCTAssert("<pre><code>\\[\\]\n</code></pre>\n" == parseResult)
    }
    
    func test301() {
        let parseResult = parseToHTML("<http://example.com?find=\\*>\n")
        XCTAssert("<p><a href=\"http://example.com?find=%5C*\">http://example.com?find=\\*</a></p>\n" == parseResult)
    }
    
    func test302() {
        let parseResult = parseToHTML("<a href=\"/bar\\/)\">\n")
        XCTAssert("<a href=\"/bar\\/)\">\n" == parseResult)
    }
    
    func test303() {
        let parseResult = parseToHTML("[foo](/bar\\* \"ti\\*tle\")\n")
        XCTAssert("<p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n" == parseResult)
    }
    
    func test304() {
        let parseResult = parseToHTML("[foo]\n\n[foo]: /bar\\* \"ti\\*tle\"\n")
        XCTAssert("<p><a href=\"/bar*\" title=\"ti*tle\">foo</a></p>\n" == parseResult)
    }
    
    func test305() {
        let parseResult = parseToHTML("``` foo\\+bar\nfoo\n```\n")
        XCTAssert("<pre><code class=\"language-foo+bar\">foo\n</code></pre>\n" == parseResult)
    }
    
    func test306() {
        let parseResult = parseToHTML("&nbsp; &amp; &copy; &AElig; &Dcaron;\n&frac34; &HilbertSpace; &DifferentialD;\n&ClockwiseContourIntegral; &ngE;\n")
                // <p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n
                // <p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n
        
        debugPrint("result: \(parseResult)")
        
        XCTAssert("<p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n".count == parseResult.count)
        for i in 0..<parseResult.count {
        
            let resChar = parseResult.utf16[String.UTF16View.Index(encodedOffset: i)]
            let expChar = "<p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n".utf16[String.UTF16View.Index(encodedOffset: i)]
            
            XCTAssert(resChar == expChar, "chars at \(i) are different.")
        }
        XCTAssert("<p>  &amp; © Æ Ď\n¾ ℋ ⅆ\n∲ ≧̸</p>\n" == parseResult)
    }
    
    func test307() {
        let parseResult = parseToHTML("&#35; &#1234; &#992; &#0;\n")
        XCTAssert("<p># Ӓ Ϡ �</p>\n" == parseResult)
    }
    
    func test308() {
        let parseResult = parseToHTML("&#X22; &#XD06; &#xcab;\n")
        XCTAssert("<p>&quot; ആ ಫ</p>\n" == parseResult)
    }
    
    func test309() {
        let parseResult = parseToHTML("&nbsp &x; &#; &#x;\n&#987654321;\n&#abcdef0;\n&ThisIsNotDefined; &hi?;\n")
        //            &    nbsp &    x; &    #; &    #x;\n&#987654321;\n&#abcdef0;\n&ThisIsNotDefined; &hi?;\n
        // stylo:  <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n�\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>\n
        // md-it:  <p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#987654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>
        XCTAssert("<p>&amp;nbsp &amp;x; &amp;#; &amp;#x;\n&amp;#987654321;\n&amp;#abcdef0;\n&amp;ThisIsNotDefined; &amp;hi?;</p>\n" == parseResult)
    }
    
    func test310() {
        let parseResult = parseToHTML("&copy\n")
        XCTAssert("<p>&amp;copy</p>\n" == parseResult)
    }
    
    func test311() {
        let parseResult = parseToHTML("&MadeUpEntity;\n")
        XCTAssert("<p>&amp;MadeUpEntity;</p>\n" == parseResult)
    }
    
    func test312() {
        let parseResult = parseToHTML("<a href=\"&ouml;&ouml;.html\">\n")
        XCTAssert("<a href=\"&ouml;&ouml;.html\">\n" == parseResult)
    }
    
    func test313() {
        let parseResult = parseToHTML("[foo](/f&ouml;&ouml; \"f&ouml;&ouml;\")\n")
        XCTAssert("<p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n" == parseResult)
    }
    
    func test314() {
        let parseResult = parseToHTML("[foo]\n\n[foo]: /f&ouml;&ouml; \"f&ouml;&ouml;\"\n")
        XCTAssert("<p><a href=\"/f%C3%B6%C3%B6\" title=\"föö\">foo</a></p>\n" == parseResult)
    }
    
    func test315() {
        let parseResult = parseToHTML("``` f&ouml;&ouml;\nfoo\n```\n")
        XCTAssert("<pre><code class=\"language-föö\">foo\n</code></pre>\n" == parseResult)
    }
    
    func test316() {
        let parseResult = parseToHTML("`f&ouml;&ouml;`\n")
        XCTAssert("<p><code>f&amp;ouml;&amp;ouml;</code></p>\n" == parseResult)
    }
    
    func test317() {
        let parseResult = parseToHTML("    f&ouml;f&ouml;\n")
        XCTAssert("<pre><code>f&amp;ouml;f&amp;ouml;\n</code></pre>\n" == parseResult)
    }
    
    func test318() {
        let parseResult = parseToHTML("`foo`\n")
        XCTAssert("<p><code>foo</code></p>\n" == parseResult)
    }
    
    func test319() {
        let parseResult = parseToHTML("`` foo ` bar ``\n")
        XCTAssert("<p><code>foo ` bar</code></p>\n" == parseResult)
    }
    
    func test320() {
        let parseResult = parseToHTML("` `` `\n")
        XCTAssert("<p><code>``</code></p>\n" == parseResult)
    }
    
    func test321() {
        let parseResult = parseToHTML("`  ``  `\n")
        XCTAssert("<p><code> `` </code></p>\n" == parseResult)
    }
    
    func test322() {
        let parseResult = parseToHTML("` a`\n")
        XCTAssert("<p><code> a</code></p>\n" == parseResult)
    }
    
    func test323() {
        let parseResult = parseToHTML("`\tb\t`\n")
        XCTAssert("<p><code>\tb\t</code></p>\n" == parseResult)
    }
    
    func test324() {
        let parseResult = parseToHTML("``\nfoo\nbar  \nbaz\n``\n")
        XCTAssert("<p><code>foo bar   baz</code></p>\n" == parseResult)
    }
    
    func test325() {
        let parseResult = parseToHTML("``\nfoo \n``\n")
        XCTAssert("<p><code>foo </code></p>\n" == parseResult)
    }
    
    func test326() {
        let parseResult = parseToHTML("`foo   bar \nbaz`\n")
        XCTAssert("<p><code>foo   bar  baz</code></p>\n" == parseResult)
    }
    
    func test327() {
        let parseResult = parseToHTML("`foo\\`bar`\n")
        XCTAssert("<p><code>foo\\</code>bar`</p>\n" == parseResult)
    }
    
    func test328() {
        let parseResult = parseToHTML("``foo`bar``\n")
        XCTAssert("<p><code>foo`bar</code></p>\n" == parseResult)
    }
    
    func test329() {
        let parseResult = parseToHTML("` foo `` bar `\n")
        XCTAssert("<p><code>foo `` bar</code></p>\n" == parseResult)
    }
    
    func test330() {
        let parseResult = parseToHTML("*foo`*`\n")
        XCTAssert("<p>*foo<code>*</code></p>\n" == parseResult)
    }
    
    func test331() {
        let parseResult = parseToHTML("[not a `link](/foo`)\n")
        XCTAssert("<p>[not a <code>link](/foo</code>)</p>\n" == parseResult)
    }
    
    func test332() {
        let parseResult = parseToHTML("`<a href=\"`\">`\n")
        XCTAssert("<p><code>&lt;a href=&quot;</code>&quot;&gt;`</p>\n" == parseResult)
    }
    
    func test333() {
        let parseResult = parseToHTML("<a href=\"`\">`\n")
        XCTAssert("<p><a href=\"`\">`</p>\n" == parseResult)
    }
    
    func test334() {
        let parseResult = parseToHTML("`<http://foo.bar.`baz>`\n")
        XCTAssert("<p><code>&lt;http://foo.bar.</code>baz&gt;`</p>\n" == parseResult)
    }
    
    func test335() {
        let parseResult = parseToHTML("<http://foo.bar.`baz>`\n")
        XCTAssert("<p><a href=\"http://foo.bar.%60baz\">http://foo.bar.`baz</a>`</p>\n" == parseResult)
    }
    
    func test336() {
        let parseResult = parseToHTML("```foo``\n")
        XCTAssert("<p>```foo``</p>\n" == parseResult)
    }
    
    func test337() {
        let parseResult = parseToHTML("`foo\n")
        XCTAssert("<p>`foo</p>\n" == parseResult)
    }
    
    func test338() {
        let parseResult = parseToHTML("`foo``bar``\n")
        XCTAssert("<p>`foo<code>bar</code></p>\n" == parseResult)
    }
    
    func test339() {
        let parseResult = parseToHTML("*foo bar*\n")
        XCTAssert("<p><em>foo bar</em></p>\n" == parseResult)
    }
    
    func test340() {
        let parseResult = parseToHTML("a * foo bar*\n")
        XCTAssert("<p>a * foo bar*</p>\n" == parseResult)
    }
    
    func test341() {
        let parseResult = parseToHTML("a*\"foo\"*\n")
        XCTAssert("<p>a*&quot;foo&quot;*</p>\n" == parseResult)
    }
    
    // fail in markdown-it
    func test342() {
        let parseResult = parseToHTML("* a *\n")
        XCTAssert("<p>* a *</p>\n" == parseResult)
    }
    
    func test343() {
        let parseResult = parseToHTML("foo*bar*\n")
        XCTAssert("<p>foo<em>bar</em></p>\n" == parseResult)
    }
    
    func test344() {
        let parseResult = parseToHTML("5*6*78\n")
        XCTAssert("<p>5<em>6</em>78</p>\n" == parseResult)
    }
    
    func test345() {
        let parseResult = parseToHTML("_foo bar_\n")
        XCTAssert("<p><em>foo bar</em></p>\n" == parseResult)
    }
    
    func test346() {
        let parseResult = parseToHTML("_ foo bar_\n")
        XCTAssert("<p>_ foo bar_</p>\n" == parseResult)
    }
    
    func test347() {
        let parseResult = parseToHTML("a_\"foo\"_\n")
        XCTAssert("<p>a_&quot;foo&quot;_</p>\n" == parseResult)
    }
    
    func test348() {
        let parseResult = parseToHTML("foo_bar_\n")
        XCTAssert("<p>foo_bar_</p>\n" == parseResult)
    }
    
    func test349() {
        let parseResult = parseToHTML("5_6_78\n")
        XCTAssert("<p>5_6_78</p>\n" == parseResult)
    }
    
    func test350() {
        let parseResult = parseToHTML("пристаням_стремятся_\n")
        XCTAssert("<p>пристаням_стремятся_</p>\n" == parseResult)
    }
    
    func test351() {
        let parseResult = parseToHTML("aa_\"bb\"_cc\n")
        XCTAssert("<p>aa_&quot;bb&quot;_cc</p>\n" == parseResult)
    }
    
    func test352() {
        let parseResult = parseToHTML("foo-_(bar)_\n")
        XCTAssert("<p>foo-<em>(bar)</em></p>\n" == parseResult)
    }
    
    func test353() {
        let parseResult = parseToHTML("_foo*\n")
        XCTAssert("<p>_foo*</p>\n" == parseResult)
    }
    
    func test354() {
        let parseResult = parseToHTML("*foo bar *\n")
        XCTAssert("<p>*foo bar *</p>\n" == parseResult)
    }
    
    func test355() {
        let parseResult = parseToHTML("*foo bar\n*\n")
        XCTAssert("<p>*foo bar\n*</p>\n" == parseResult)
    }
    
    func test356() {
        let parseResult = parseToHTML("*(*foo)\n")
        XCTAssert("<p>*(*foo)</p>\n" == parseResult)
    }
    
    func test357() {
        let parseResult = parseToHTML("*(*foo*)*\n")
        XCTAssert("<p><em>(<em>foo</em>)</em></p>\n" == parseResult)
    }
    
    func test358() {
        let parseResult = parseToHTML("*foo*bar\n")
        XCTAssert("<p><em>foo</em>bar</p>\n" == parseResult)
    }
    
    func test359() {
        let parseResult = parseToHTML("_foo bar _\n")
        XCTAssert("<p>_foo bar _</p>\n" == parseResult)
    }
    
    func test360() {
        let parseResult = parseToHTML("_(_foo)\n")
        XCTAssert("<p>_(_foo)</p>\n" == parseResult)
    }
    
    func test361() {
        let parseResult = parseToHTML("_(_foo_)_\n")
        XCTAssert("<p><em>(<em>foo</em>)</em></p>\n" == parseResult)
    }
    
    func test362() {
        let parseResult = parseToHTML("_foo_bar\n")
        XCTAssert("<p>_foo_bar</p>\n" == parseResult)
    }
    
    func test363() {
        let parseResult = parseToHTML("_пристаням_стремятся\n")
        XCTAssert("<p>_пристаням_стремятся</p>\n" == parseResult)
    }
    
    func test364() {
        let parseResult = parseToHTML("_foo_bar_baz_\n")
        XCTAssert("<p><em>foo_bar_baz</em></p>\n" == parseResult)
    }
    
    func test365() {
        let parseResult = parseToHTML("_(bar)_.\n")
        XCTAssert("<p><em>(bar)</em>.</p>\n" == parseResult)
    }
    
    func test366() {
        let parseResult = parseToHTML("**foo bar**\n")
        XCTAssert("<p><strong>foo bar</strong></p>\n" == parseResult)
    }
    
    func test367() {
        let parseResult = parseToHTML("** foo bar**\n")
        XCTAssert("<p>** foo bar**</p>\n" == parseResult)
    }
    
    func test368() {
        let parseResult = parseToHTML("a**\"foo\"**\n")
        XCTAssert("<p>a**&quot;foo&quot;**</p>\n" == parseResult)
    }
    
    func test369() {
        let parseResult = parseToHTML("foo**bar**\n")
        XCTAssert("<p>foo<strong>bar</strong></p>\n" == parseResult)
    }
    
    func test370() {
        let parseResult = parseToHTML("__foo bar__\n")
        XCTAssert("<p><strong>foo bar</strong></p>\n" == parseResult)
    }
    
    func test371() {
        let parseResult = parseToHTML("__ foo bar__\n")
        XCTAssert("<p>__ foo bar__</p>\n" == parseResult)
    }
    
    func test372() {
        let parseResult = parseToHTML("__\nfoo bar__\n")
        XCTAssert("<p>__\nfoo bar__</p>\n" == parseResult)
    }
    
    func test373() {
        let parseResult = parseToHTML("a__\"foo\"__\n")
        XCTAssert("<p>a__&quot;foo&quot;__</p>\n" == parseResult)
    }
    
    func test374() {
        let parseResult = parseToHTML("foo__bar__\n")
        XCTAssert("<p>foo__bar__</p>\n" == parseResult)
    }
    
    func test375() {
        let parseResult = parseToHTML("5__6__78\n")
        XCTAssert("<p>5__6__78</p>\n" == parseResult)
    }
    
    func test376() {
        let parseResult = parseToHTML("пристаням__стремятся__\n")
        XCTAssert("<p>пристаням__стремятся__</p>\n" == parseResult)
    }
    
    func test377() {
        let parseResult = parseToHTML("__foo, __bar__, baz__\n")
        XCTAssert("<p><strong>foo, <strong>bar</strong>, baz</strong></p>\n" == parseResult)
    }
    
    func test378() {
        let parseResult = parseToHTML("foo-__(bar)__\n")
        XCTAssert("<p>foo-<strong>(bar)</strong></p>\n" == parseResult)
    }
    
    func test379() {
        let parseResult = parseToHTML("**foo bar **\n")
        XCTAssert("<p>**foo bar **</p>\n" == parseResult)
    }
    
    func test380() {
        let parseResult = parseToHTML("**(**foo)\n")
        XCTAssert("<p>**(**foo)</p>\n" == parseResult)
    }
    
    func test381() {
        let parseResult = parseToHTML("*(**foo**)*\n")
        XCTAssert("<p><em>(<strong>foo</strong>)</em></p>\n" == parseResult)
    }
    
    func test382() {
        let parseResult = parseToHTML("**Gomphocarpus (*Gomphocarpus physocarpus*, syn.\n*Asclepias physocarpa*)**\n")
        XCTAssert("<p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.\n<em>Asclepias physocarpa</em>)</strong></p>\n" == parseResult)
    }
    
    func test383() {
        let parseResult = parseToHTML("**foo \"*bar*\" foo**\n")
        XCTAssert("<p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>\n" == parseResult)
    }
    
    func test384() {
        let parseResult = parseToHTML("**foo**bar\n")
        XCTAssert("<p><strong>foo</strong>bar</p>\n" == parseResult)
    }
    
    func test385() {
        let parseResult = parseToHTML("__foo bar __\n")
        XCTAssert("<p>__foo bar __</p>\n" == parseResult)
    }
    
    func test386() {
        let parseResult = parseToHTML("__(__foo)\n")
        XCTAssert("<p>__(__foo)</p>\n" == parseResult)
    }
    
    func test387() {
        let parseResult = parseToHTML("_(__foo__)_\n")
        XCTAssert("<p><em>(<strong>foo</strong>)</em></p>\n" == parseResult)
    }
    
    func test388() {
        let parseResult = parseToHTML("__foo__bar\n")
        XCTAssert("<p>__foo__bar</p>\n" == parseResult)
    }
    
    func test389() {
        let parseResult = parseToHTML("__пристаням__стремятся\n")
        XCTAssert("<p>__пристаням__стремятся</p>\n" == parseResult)
    }
    
    func test390() {
        let parseResult = parseToHTML("__foo__bar__baz__\n")
        XCTAssert("<p><strong>foo__bar__baz</strong></p>\n" == parseResult)
    }
    
    func test391() {
        let parseResult = parseToHTML("__(bar)__.\n")
        XCTAssert("<p><strong>(bar)</strong>.</p>\n" == parseResult)
    }
    
    func test392() {
        let parseResult = parseToHTML("*foo [bar](/url)*\n")
        XCTAssert("<p><em>foo <a href=\"/url\">bar</a></em></p>\n" == parseResult)
    }
    
    func test393() {
        let parseResult = parseToHTML("*foo\nbar*\n")
        XCTAssert("<p><em>foo\nbar</em></p>\n" == parseResult)
    }
    
    func test394() {
        let parseResult = parseToHTML("_foo __bar__ baz_\n")
        XCTAssert("<p><em>foo <strong>bar</strong> baz</em></p>\n" == parseResult)
    }
    
    func test395() {
        let parseResult = parseToHTML("_foo _bar_ baz_\n")
        XCTAssert("<p><em>foo <em>bar</em> baz</em></p>\n" == parseResult)
    }
    
    func test396() {
        let parseResult = parseToHTML("__foo_ bar_\n")
        XCTAssert("<p><em><em>foo</em> bar</em></p>\n" == parseResult)
    }
    
    func test397() {
        let parseResult = parseToHTML("*foo *bar**\n")
        XCTAssert("<p><em>foo <em>bar</em></em></p>\n" == parseResult)
    }
    
    func test398() {
        let parseResult = parseToHTML("*foo **bar** baz*\n")
        XCTAssert("<p><em>foo <strong>bar</strong> baz</em></p>\n" == parseResult)
    }
    
    func test399() {
        let parseResult = parseToHTML("*foo**bar**baz*\n")
        XCTAssert("<p><em>foo<strong>bar</strong>baz</em></p>\n" == parseResult)
    }
    
    func test400() {
        let parseResult = parseToHTML("*foo**bar*\n")
        XCTAssert("<p><em>foo**bar</em></p>\n" == parseResult)
    }
    
    func test401() {
        let parseResult = parseToHTML("***foo** bar*\n")
        XCTAssert("<p><em><strong>foo</strong> bar</em></p>\n" == parseResult)
    }
    
    func test402() {
        let parseResult = parseToHTML("*foo **bar***\n")
        XCTAssert("<p><em>foo <strong>bar</strong></em></p>\n" == parseResult)
    }
    
    func test403() {
        let parseResult = parseToHTML("*foo**bar***\n")
        XCTAssert("<p><em>foo<strong>bar</strong></em></p>\n" == parseResult)
    }
    
    func test404() {
        let parseResult = parseToHTML("*foo **bar *baz* bim** bop*\n")
        XCTAssert("<p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>\n" == parseResult)
    }
    
    func test405() {
        let parseResult = parseToHTML("*foo [*bar*](/url)*\n")
        XCTAssert("<p><em>foo <a href=\"/url\"><em>bar</em></a></em></p>\n" == parseResult)
    }
    
    func test406() {
        let parseResult = parseToHTML("** is not an empty emphasis\n")
        XCTAssert("<p>** is not an empty emphasis</p>\n" == parseResult)
    }
    
    func test407() {
        let parseResult = parseToHTML("**** is not an empty strong emphasis\n")
        XCTAssert("<p>**** is not an empty strong emphasis</p>\n" == parseResult)
    }
    
    func test408() {
        let parseResult = parseToHTML("**foo [bar](/url)**\n")
        XCTAssert("<p><strong>foo <a href=\"/url\">bar</a></strong></p>\n" == parseResult)
    }
    
    func test409() {
        let parseResult = parseToHTML("**foo\nbar**\n")
        XCTAssert("<p><strong>foo\nbar</strong></p>\n" == parseResult)
    }
    
    func test410() {
        let parseResult = parseToHTML("__foo _bar_ baz__\n")
        XCTAssert("<p><strong>foo <em>bar</em> baz</strong></p>\n" == parseResult)
    }
    
    func test411() {
        let parseResult = parseToHTML("__foo __bar__ baz__\n")
        XCTAssert("<p><strong>foo <strong>bar</strong> baz</strong></p>\n" == parseResult)
    }
    
    func test412() {
        let parseResult = parseToHTML("____foo__ bar__\n")
        XCTAssert("<p><strong><strong>foo</strong> bar</strong></p>\n" == parseResult)
    }
    
    func test413() {
        let parseResult = parseToHTML("**foo **bar****\n")
        XCTAssert("<p><strong>foo <strong>bar</strong></strong></p>\n" == parseResult)
    }
    
    func test414() {
        let parseResult = parseToHTML("**foo *bar* baz**\n")
        XCTAssert("<p><strong>foo <em>bar</em> baz</strong></p>\n" == parseResult)
    }
    
    func test415() {
        let parseResult = parseToHTML("**foo*bar*baz**\n")
        XCTAssert("<p><strong>foo<em>bar</em>baz</strong></p>\n" == parseResult)
    }
    
    func test416() {
        let parseResult = parseToHTML("***foo* bar**\n")
        XCTAssert("<p><strong><em>foo</em> bar</strong></p>\n" == parseResult)
    }
    
    func test417() {
        let parseResult = parseToHTML("**foo *bar***\n")
        XCTAssert("<p><strong>foo <em>bar</em></strong></p>\n" == parseResult)
    }
    
    func test418() {
        let parseResult = parseToHTML("**foo *bar **baz**\nbim* bop**\n")
        XCTAssert("<p><strong>foo <em>bar <strong>baz</strong>\nbim</em> bop</strong></p>\n" == parseResult)
    }
    
    func test419() {
        let parseResult = parseToHTML("**foo [*bar*](/url)**\n")
        XCTAssert("<p><strong>foo <a href=\"/url\"><em>bar</em></a></strong></p>\n" == parseResult)
    }
    
    func test420() {
        let parseResult = parseToHTML("__ is not an empty emphasis\n")
        XCTAssert("<p>__ is not an empty emphasis</p>\n" == parseResult)
    }
    
    func test421() {
        let parseResult = parseToHTML("____ is not an empty strong emphasis\n")
        XCTAssert("<p>____ is not an empty strong emphasis</p>\n" == parseResult)
    }
    
    func test422() {
        let parseResult = parseToHTML("foo ***\n")
        XCTAssert("<p>foo ***</p>\n" == parseResult)
    }
    
    func test423() {
        let parseResult = parseToHTML("foo *\\**\n")
        XCTAssert("<p>foo <em>*</em></p>\n" == parseResult)
    }
    
    func test424() {
        let parseResult = parseToHTML("foo *_*\n")
        XCTAssert("<p>foo <em>_</em></p>\n" == parseResult)
    }
    
    func test425() {
        let parseResult = parseToHTML("foo *****\n")
        XCTAssert("<p>foo *****</p>\n" == parseResult)
    }
    
    func test426() {
        let parseResult = parseToHTML("foo **\\***\n")
        XCTAssert("<p>foo <strong>*</strong></p>\n" == parseResult)
    }
    
    func test427() {
        let parseResult = parseToHTML("foo **_**\n")
        XCTAssert("<p>foo <strong>_</strong></p>\n" == parseResult)
    }
    
    func test428() {
        let parseResult = parseToHTML("**foo*\n")
        XCTAssert("<p>*<em>foo</em></p>\n" == parseResult)
    }
    
    func test429() {
        let parseResult = parseToHTML("*foo**\n")
        XCTAssert("<p><em>foo</em>*</p>\n" == parseResult)
    }
    
    func test430() {
        let parseResult = parseToHTML("***foo**\n")
        XCTAssert("<p>*<strong>foo</strong></p>\n" == parseResult)
    }
    
    func test431() {
        let parseResult = parseToHTML("****foo*\n")
        XCTAssert("<p>***<em>foo</em></p>\n" == parseResult)
    }
    
    func test432() {
        let parseResult = parseToHTML("**foo***\n")
        XCTAssert("<p><strong>foo</strong>*</p>\n" == parseResult)
    }
    
    func test433() {
        let parseResult = parseToHTML("*foo****\n")
        XCTAssert("<p><em>foo</em>***</p>\n" == parseResult)
    }
    
    func test434() {
        let parseResult = parseToHTML("foo ___\n")
        XCTAssert("<p>foo ___</p>\n" == parseResult)
    }
    
    func test435() {
        let parseResult = parseToHTML("foo _\\__\n")
        XCTAssert("<p>foo <em>_</em></p>\n" == parseResult)
    }
    
    func test436() {
        let parseResult = parseToHTML("foo _*_\n")
        XCTAssert("<p>foo <em>*</em></p>\n" == parseResult)
    }
    
    func test437() {
        let parseResult = parseToHTML("foo _____\n")
        XCTAssert("<p>foo _____</p>\n" == parseResult)
    }
    
    func test438() {
        let parseResult = parseToHTML("foo __\\___\n")
        XCTAssert("<p>foo <strong>_</strong></p>\n" == parseResult)
    }
    
    func test439() {
        let parseResult = parseToHTML("foo __*__\n")
        XCTAssert("<p>foo <strong>*</strong></p>\n" == parseResult)
    }
    
    func test440() {
        let parseResult = parseToHTML("__foo_\n")
        XCTAssert("<p>_<em>foo</em></p>\n" == parseResult)
    }
    
    func test441() {
        let parseResult = parseToHTML("_foo__\n")
        XCTAssert("<p><em>foo</em>_</p>\n" == parseResult)
    }
    
    func test442() {
        let parseResult = parseToHTML("___foo__\n")
        XCTAssert("<p>_<strong>foo</strong></p>\n" == parseResult)
    }
    
    func test443() {
        let parseResult = parseToHTML("____foo_\n")
        XCTAssert("<p>___<em>foo</em></p>\n" == parseResult)
    }
    
    func test444() {
        let parseResult = parseToHTML("__foo___\n")
        XCTAssert("<p><strong>foo</strong>_</p>\n" == parseResult)
    }
    
    func test445() {
        let parseResult = parseToHTML("_foo____\n")
        XCTAssert("<p><em>foo</em>___</p>\n" == parseResult)
    }
    
    func test446() {
        let parseResult = parseToHTML("**foo**\n")
        XCTAssert("<p><strong>foo</strong></p>\n" == parseResult)
    }
    
    func test447() {
        let parseResult = parseToHTML("*_foo_*\n")
        XCTAssert("<p><em><em>foo</em></em></p>\n" == parseResult)
    }
    
    func test448() {
        let parseResult = parseToHTML("__foo__\n")
        XCTAssert("<p><strong>foo</strong></p>\n" == parseResult)
    }
    
    func test449() {
        let parseResult = parseToHTML("_*foo*_\n")
        XCTAssert("<p><em><em>foo</em></em></p>\n" == parseResult)
    }
    
    func test450() {
        let parseResult = parseToHTML("****foo****\n")
        XCTAssert("<p><strong><strong>foo</strong></strong></p>\n" == parseResult)
    }
    
    func test451() {
        let parseResult = parseToHTML("____foo____\n")
        XCTAssert("<p><strong><strong>foo</strong></strong></p>\n" == parseResult)
    }
    
    func test452() {
        let parseResult = parseToHTML("******foo******\n")
        XCTAssert("<p><strong><strong><strong>foo</strong></strong></strong></p>\n" == parseResult)
    }
    
    func test453() {
        let parseResult = parseToHTML("***foo***\n")
        XCTAssert("<p><em><strong>foo</strong></em></p>\n" == parseResult)
    }
    
    func test454() {
        let parseResult = parseToHTML("_____foo_____\n")
        XCTAssert("<p><em><strong><strong>foo</strong></strong></em></p>\n" == parseResult)
    }
    
    func test455() {
        let parseResult = parseToHTML("*foo _bar* baz_\n")
        XCTAssert("<p><em>foo _bar</em> baz_</p>\n" == parseResult)
    }
    
    func test456() {
        let parseResult = parseToHTML("*foo __bar *baz bim__ bam*\n")
        XCTAssert("<p><em>foo <strong>bar *baz bim</strong> bam</em></p>\n" == parseResult)
    }
    
    func test457() {
        let parseResult = parseToHTML("**foo **bar baz**\n")
        XCTAssert("<p>**foo <strong>bar baz</strong></p>\n" == parseResult)
    }
    
    func test458() {
        let parseResult = parseToHTML("*foo *bar baz*\n")
        XCTAssert("<p>*foo <em>bar baz</em></p>\n" == parseResult)
    }
    
    func test459() {
        let parseResult = parseToHTML("*[bar*](/url)\n")
        XCTAssert("<p>*<a href=\"/url\">bar*</a></p>\n" == parseResult)
    }
    
    func test460() {
        let parseResult = parseToHTML("_foo [bar_](/url)\n")
        XCTAssert("<p>_foo <a href=\"/url\">bar_</a></p>\n" == parseResult)
    }
    
    func test461() {
        let parseResult = parseToHTML("*<img src=\"foo\" title=\"*\"/>\n")
        XCTAssert("<p>*<img src=\"foo\" title=\"*\"/></p>\n" == parseResult)
    }
    
    func test462() {
        let parseResult = parseToHTML("**<a href=\"**\">\n")
        XCTAssert("<p>**<a href=\"**\"></p>\n" == parseResult)
    }
    
    func test463() {
        let parseResult = parseToHTML("__<a href=\"__\">\n")
        XCTAssert("<p>__<a href=\"__\"></p>\n" == parseResult)
    }
    
    func test464() {
        let parseResult = parseToHTML("*a `*`*\n")
        XCTAssert("<p><em>a <code>*</code></em></p>\n" == parseResult)
    }
    
    func test465() {
        let parseResult = parseToHTML("_a `_`_\n")
        XCTAssert("<p><em>a <code>_</code></em></p>\n" == parseResult)
    }
    
    func test466() {
        let parseResult = parseToHTML("**a<http://foo.bar/?q=**>\n")
        XCTAssert("<p>**a<a href=\"http://foo.bar/?q=**\">http://foo.bar/?q=**</a></p>\n" == parseResult)
    }
    
    func test467() {
        let parseResult = parseToHTML("__a<http://foo.bar/?q=__>\n")
        XCTAssert("<p>__a<a href=\"http://foo.bar/?q=__\">http://foo.bar/?q=__</a></p>\n" == parseResult)
    }
    
    func test468() {
        let parseResult = parseToHTML("[link](/uri \"title\")\n")
        XCTAssert("<p><a href=\"/uri\" title=\"title\">link</a></p>\n" == parseResult)
    }
    
    func test469() {
        let parseResult = parseToHTML("[link](/uri)\n")
        XCTAssert("<p><a href=\"/uri\">link</a></p>\n" == parseResult)
    }
    
    func test470() {
        let parseResult = parseToHTML("[link]()\n")
        XCTAssert("<p><a href=\"\">link</a></p>\n" == parseResult)
    }
    
    func test471() {
        let parseResult = parseToHTML("[link](<>)\n")
        XCTAssert("<p><a href=\"\">link</a></p>\n" == parseResult)
    }
    
    func test472() {
        let parseResult = parseToHTML("[link](/my uri)\n")
        XCTAssert("<p>[link](/my uri)</p>\n" == parseResult)
    }
    
    func test473() {
        let parseResult = parseToHTML("[link](</my uri>)\n")
        XCTAssert("<p><a href=\"/my%20uri\">link</a></p>\n" == parseResult)
    }
    
    func test474() {
        let parseResult = parseToHTML("[link](foo\nbar)\n")
        XCTAssert("<p>[link](foo\nbar)</p>\n" == parseResult)
    }
    
    func test475() {
        let parseResult = parseToHTML("[link](<foo\nbar>)\n")
        XCTAssert("<p>[link](<foo\nbar>)</p>\n" == parseResult)
    }
    
    func test476() {
        let parseResult = parseToHTML("[link](\\(foo\\))\n")
        XCTAssert("<p><a href=\"(foo)\">link</a></p>\n" == parseResult)
    }
    
    func test477() {
        let parseResult = parseToHTML("[link](foo(and(bar)))\n")
        XCTAssert("<p><a href=\"foo(and(bar))\">link</a></p>\n" == parseResult)
    }
    
    func test478() {
        let parseResult = parseToHTML("[link](foo\\(and\\(bar\\))\n")
        XCTAssert("<p><a href=\"foo(and(bar)\">link</a></p>\n" == parseResult)
    }
    
    func test479() {
        let parseResult = parseToHTML("[link](<foo(and(bar)>)\n")
        XCTAssert("<p><a href=\"foo(and(bar)\">link</a></p>\n" == parseResult)
    }
    
    func test480() {
        let parseResult = parseToHTML("[link](foo\\)\\:)\n")
        XCTAssert("<p><a href=\"foo):\">link</a></p>\n" == parseResult)
    }
    
    func test481() {
        let parseResult = parseToHTML("[link](#fragment)\n\n[link](http://example.com#fragment)\n\n[link](http://example.com?foo=3#frag)\n")
        XCTAssert("<p><a href=\"#fragment\">link</a></p>\n<p><a href=\"http://example.com#fragment\">link</a></p>\n<p><a href=\"http://example.com?foo=3#frag\">link</a></p>\n" == parseResult)
    }
    
    func test482() {
        let parseResult = parseToHTML("[link](foo\\bar)\n")
        XCTAssert("<p><a href=\"foo%5Cbar\">link</a></p>\n" == parseResult)
    }
    
    func test483() {
        let parseResult = parseToHTML("[link](foo%20b&auml;)\n")
        XCTAssert("<p><a href=\"foo%20b%C3%A4\">link</a></p>\n" == parseResult)
    }
    
    func test484() {
        let parseResult = parseToHTML("[link](\"title\")\n")
        XCTAssert("<p><a href=\"%22title%22\">link</a></p>\n" == parseResult)
    }
    
    func test485() {
        let parseResult = parseToHTML("[link](/url \"title\")\n[link](/url 'title')\n[link](/url (title))\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a>\n<a href=\"/url\" title=\"title\">link</a></p>\n" == parseResult)
    }
    
    func test486() {
        let parseResult = parseToHTML("[link](/url \"title \\\"&quot;\")\n")
        XCTAssert("<p><a href=\"/url\" title=\"title &quot;&quot;\">link</a></p>\n" == parseResult)
    }
    
    func test487() {
        let parseResult = parseToHTML("[link](/url\u{000c}\"title\")\n")
        XCTAssert("<p><a href=\"/url%0C%22title%22\">link</a></p>\n" == parseResult)
    }
    
    func test488() {
        let parseResult = parseToHTML("[link](/url \"title \"and\" title\")\n")
        XCTAssert("<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>\n" == parseResult)
    }
    
    func test489() {
        let parseResult = parseToHTML("[link](/url 'title \"and\" title')\n")
        XCTAssert("<p><a href=\"/url\" title=\"title &quot;and&quot; title\">link</a></p>\n" == parseResult)
    }
    
    func test490() {
        let parseResult = parseToHTML("[link](   /uri\n  \"title\"  )\n")
        XCTAssert("<p><a href=\"/uri\" title=\"title\">link</a></p>\n" == parseResult)
    }
    
    func test491() {
        let parseResult = parseToHTML("[link] (/uri)\n")
        XCTAssert("<p>[link] (/uri)</p>\n" == parseResult)
    }
    
    func test492() {
        let parseResult = parseToHTML("[link [foo [bar]]](/uri)\n")
        XCTAssert("<p><a href=\"/uri\">link [foo [bar]]</a></p>\n" == parseResult)
    }
    
    func test493() {
        let parseResult = parseToHTML("[link] bar](/uri)\n")
        XCTAssert("<p>[link] bar](/uri)</p>\n" == parseResult)
    }
    
    func test494() {
        let parseResult = parseToHTML("[link [bar](/uri)\n")
        XCTAssert("<p>[link <a href=\"/uri\">bar</a></p>\n" == parseResult)
    }
    
    func test495() {
        let parseResult = parseToHTML("[link \\[bar](/uri)\n")
        XCTAssert("<p><a href=\"/uri\">link [bar</a></p>\n" == parseResult)
    }
    
    func test496() {
        let parseResult = parseToHTML("[link *foo **bar** `#`*](/uri)\n")
        XCTAssert("<p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n" == parseResult)
    }
    
    func test497() {
        let parseResult = parseToHTML("[![moon](moon.jpg)](/uri)\n")
        XCTAssert("<p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n" == parseResult)
    }
    
    func test498() {
        let parseResult = parseToHTML("[foo [bar](/uri)](/uri)\n")
        XCTAssert("<p>[foo <a href=\"/uri\">bar</a>](/uri)</p>\n" == parseResult)
    }
    
    func test499() {
        let parseResult = parseToHTML("[foo *[bar [baz](/uri)](/uri)*](/uri)\n")
        XCTAssert("<p>[foo <em>[bar <a href=\"/uri\">baz</a>](/uri)</em>](/uri)</p>\n" == parseResult)
    }
    
    func test500() {
        let parseResult = parseToHTML("![[[foo](uri1)](uri2)](uri3)\n")
        XCTAssert("<p><img src=\"uri3\" alt=\"[foo](uri2)\" /></p>\n" == parseResult)
    }
    
    func test501() {
        let parseResult = parseToHTML("*[foo*](/uri)\n")
        XCTAssert("<p>*<a href=\"/uri\">foo*</a></p>\n" == parseResult)
    }
    
    func test502() {
        let parseResult = parseToHTML("[foo *bar](baz*)\n")
        XCTAssert("<p><a href=\"baz*\">foo *bar</a></p>\n" == parseResult)
    }
    
    func test503() {
        let parseResult = parseToHTML("*foo [bar* baz]\n")
        XCTAssert("<p><em>foo [bar</em> baz]</p>\n" == parseResult)
    }
    
    func test504() {
        let parseResult = parseToHTML("[foo <bar attr=\"](baz)\">\n")
        XCTAssert("<p>[foo <bar attr=\"](baz)\"></p>\n" == parseResult)
    }
    
    func test505() {
        let parseResult = parseToHTML("[foo`](/uri)`\n")
        XCTAssert("<p>[foo<code>](/uri)</code></p>\n" == parseResult)
    }
    
    func test506() {
        let parseResult = parseToHTML("[foo<http://example.com/?search=](uri)>\n")
        XCTAssert("<p>[foo<a href=\"http://example.com/?search=%5D(uri)\">http://example.com/?search=](uri)</a></p>\n" == parseResult)
    }
    
    func test507() {
        let parseResult = parseToHTML("[foo][bar]\n\n[bar]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test508() {
        let parseResult = parseToHTML("[link [foo [bar]]][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p><a href=\"/uri\">link [foo [bar]]</a></p>\n" == parseResult)
    }
    
    func test509() {
        let parseResult = parseToHTML("[link \\[bar][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p><a href=\"/uri\">link [bar</a></p>\n" == parseResult)
    }
    
    func test510() {
        let parseResult = parseToHTML("[link *foo **bar** `#`*][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p><a href=\"/uri\">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>\n" == parseResult)
    }
    
    func test511() {
        let parseResult = parseToHTML("[![moon](moon.jpg)][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p><a href=\"/uri\"><img src=\"moon.jpg\" alt=\"moon\" /></a></p>\n" == parseResult)
    }
    
    func test512() {
        let parseResult = parseToHTML("[foo [bar](/uri)][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p>[foo <a href=\"/uri\">bar</a>]<a href=\"/uri\">ref</a></p>\n" == parseResult)
    }
    
    func test513() {
        let parseResult = parseToHTML("[foo *bar [baz][ref]*][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p>[foo <em>bar <a href=\"/uri\">baz</a></em>]<a href=\"/uri\">ref</a></p>\n" == parseResult)
    }
    
    func test514() {
        let parseResult = parseToHTML("*[foo*][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p>*<a href=\"/uri\">foo*</a></p>\n" == parseResult)
    }
    
    func test515() {
        let parseResult = parseToHTML("[foo *bar][ref]\n\n[ref]: /uri\n")
        XCTAssert("<p><a href=\"/uri\">foo *bar</a></p>\n" == parseResult)
    }
    
    func test516() {
        let parseResult = parseToHTML("[foo <bar attr=\"][ref]\">\n\n[ref]: /uri\n")
        XCTAssert("<p>[foo <bar attr=\"][ref]\"></p>\n" == parseResult)
    }
    
    func test517() {
        let parseResult = parseToHTML("[foo`][ref]`\n\n[ref]: /uri\n")
        XCTAssert("<p>[foo<code>][ref]</code></p>\n" == parseResult)
    }
    
    func test518() {
        let parseResult = parseToHTML("[foo<http://example.com/?search=][ref]>\n\n[ref]: /uri\n")
        XCTAssert("<p>[foo<a href=\"http://example.com/?search=%5D%5Bref%5D\">http://example.com/?search=][ref]</a></p>\n" == parseResult)
    }
    
    func test519() {
        let parseResult = parseToHTML("[foo][BaR]\n\n[bar]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test520() {
        let parseResult = parseToHTML("[Толпой][Толпой] is a Russian word.\n\n[ТОЛПОЙ]: /url\n")
        XCTAssert("<p><a href=\"/url\">Толпой</a> is a Russian word.</p>\n" == parseResult)
    }
    
    func test521() {
        let parseResult = parseToHTML("[Foo\n  bar]: /url\n\n[Baz][Foo bar]\n")
        XCTAssert("<p><a href=\"/url\">Baz</a></p>\n" == parseResult)
    }
    
    func test522() {
        let parseResult = parseToHTML("[foo] [bar]\n\n[bar]: /url \"title\"\n")
        XCTAssert("<p>[foo] <a href=\"/url\" title=\"title\">bar</a></p>\n" == parseResult)
    }
    
    func test523() {
        let parseResult = parseToHTML("[foo]\n[bar]\n\n[bar]: /url \"title\"\n")
        XCTAssert("<p>[foo]\n<a href=\"/url\" title=\"title\">bar</a></p>\n" == parseResult)
    }
    
    func test524() {
        let parseResult = parseToHTML("[foo]: /url1\n\n[foo]: /url2\n\n[bar][foo]\n")
        XCTAssert("<p><a href=\"/url1\">bar</a></p>\n" == parseResult)
    }
    
    func test525() {
        let parseResult = parseToHTML("[bar][foo\\!]\n\n[foo!]: /url\n")
        XCTAssert("<p>[bar][foo!]</p>\n" == parseResult)
    }
    
    func test526() {
        let parseResult = parseToHTML("[foo][ref[]\n\n[ref[]: /uri\n")
        XCTAssert("<p>[foo][ref[]</p>\n<p>[ref[]: /uri</p>\n" == parseResult)
    }
    
    func test527() {
        let parseResult = parseToHTML("[foo][ref[bar]]\n\n[ref[bar]]: /uri\n")
        XCTAssert("<p>[foo][ref[bar]]</p>\n<p>[ref[bar]]: /uri</p>\n" == parseResult)
    }
    
    func test528() {
        let parseResult = parseToHTML("[[[foo]]]\n\n[[[foo]]]: /url\n")
        XCTAssert("<p>[[[foo]]]</p>\n<p>[[[foo]]]: /url</p>\n" == parseResult)
    }
    
    func test529() {
        let parseResult = parseToHTML("[foo][ref\\[]\n\n[ref\\[]: /uri\n")
        XCTAssert("<p><a href=\"/uri\">foo</a></p>\n" == parseResult)
    }
    
    func test530() {
        let parseResult = parseToHTML("[bar\\\\]: /uri\n\n[bar\\\\]\n")
        XCTAssert("<p><a href=\"/uri\">bar\\</a></p>\n" == parseResult)
    }
    
    func test531() {
        let parseResult = parseToHTML("[]\n\n[]: /uri\n")
        XCTAssert("<p>[]</p>\n<p>[]: /uri</p>\n" == parseResult)
    }
    
    func test532() {
        let parseResult = parseToHTML("[\n ]\n\n[\n ]: /uri\n")
        XCTAssert("<p>[\n]</p>\n<p>[\n]: /uri</p>\n" == parseResult)
    }
    
    func test533() {
        let parseResult = parseToHTML("[foo][]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test534() {
        let parseResult = parseToHTML("[*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n" == parseResult)
    }
    
    func test535() {
        let parseResult = parseToHTML("[Foo][]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">Foo</a></p>\n" == parseResult)
    }
    
    func test536() {
        let parseResult = parseToHTML("[foo] \n[]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a>\n[]</p>\n" == parseResult)
    }
    
    func test537() {
        let parseResult = parseToHTML("[foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test538() {
        let parseResult = parseToHTML("[*foo* bar]\n\n[*foo* bar]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\"><em>foo</em> bar</a></p>\n" == parseResult)
    }
    
    func test539() {
        let parseResult = parseToHTML("[[*foo* bar]]\n\n[*foo* bar]: /url \"title\"\n")
        XCTAssert("<p>[<a href=\"/url\" title=\"title\"><em>foo</em> bar</a>]</p>\n" == parseResult)
    }
    
    func test540() {
        let parseResult = parseToHTML("[[bar [foo]\n\n[foo]: /url\n")
        XCTAssert("<p>[[bar <a href=\"/url\">foo</a></p>\n" == parseResult)
    }
    
    func test541() {
        let parseResult = parseToHTML("[Foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><a href=\"/url\" title=\"title\">Foo</a></p>\n" == parseResult)
    }
    
    func test542() {
        let parseResult = parseToHTML("[foo] bar\n\n[foo]: /url\n")
        XCTAssert("<p><a href=\"/url\">foo</a> bar</p>\n" == parseResult)
    }
    
    func test543() {
        let parseResult = parseToHTML("\\[foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p>[foo]</p>\n" == parseResult)
    }
    
    func test544() {
        let parseResult = parseToHTML("[foo*]: /url\n\n*[foo*]\n")
        XCTAssert("<p>*<a href=\"/url\">foo*</a></p>\n" == parseResult)
    }
    
    func test545() {
        let parseResult = parseToHTML("[foo][bar]\n\n[foo]: /url1\n[bar]: /url2\n")
        XCTAssert("<p><a href=\"/url2\">foo</a></p>\n" == parseResult)
    }
    
    func test546() {
        let parseResult = parseToHTML("[foo][]\n\n[foo]: /url1\n")
        XCTAssert("<p><a href=\"/url1\">foo</a></p>\n" == parseResult)
    }
    
    func test547() {
        let parseResult = parseToHTML("[foo]()\n\n[foo]: /url1\n")
        XCTAssert("<p><a href=\"\">foo</a></p>\n" == parseResult)
    }
    
    func test548() {
        let parseResult = parseToHTML("[foo](not a link)\n\n[foo]: /url1\n")
        XCTAssert("<p><a href=\"/url1\">foo</a>(not a link)</p>\n" == parseResult)
    }
    
    func test549() {
        let parseResult = parseToHTML("[foo][bar][baz]\n\n[baz]: /url\n")
        XCTAssert("<p>[foo]<a href=\"/url\">bar</a></p>\n" == parseResult)
    }
    
    func test550() {
        let parseResult = parseToHTML("[foo][bar][baz]\n\n[baz]: /url1\n[bar]: /url2\n")
        XCTAssert("<p><a href=\"/url2\">foo</a><a href=\"/url1\">baz</a></p>\n" == parseResult)
    }
    
    func test551() {
        let parseResult = parseToHTML("[foo][bar][baz]\n\n[baz]: /url1\n[foo]: /url2\n")
        XCTAssert("<p>[foo]<a href=\"/url1\">bar</a></p>\n" == parseResult)
    }
    
    func test552() {
        let parseResult = parseToHTML("![foo](/url \"title\")\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test553() {
        let parseResult = parseToHTML("![foo *bar*]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n")
        XCTAssert("<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n" == parseResult)
    }
    
    func test554() {
        let parseResult = parseToHTML("![foo ![bar](/url)](/url2)\n")
        XCTAssert("<p><img src=\"/url2\" alt=\"foo bar\" /></p>\n" == parseResult)
    }
    
    func test555() {
        let parseResult = parseToHTML("![foo [bar](/url)](/url2)\n")
        XCTAssert("<p><img src=\"/url2\" alt=\"foo bar\" /></p>\n" == parseResult)
    }
    
    func test556() {
        let parseResult = parseToHTML("![foo *bar*][]\n\n[foo *bar*]: train.jpg \"train & tracks\"\n")
        XCTAssert("<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n" == parseResult)
    }
    
    func test557() {
        let parseResult = parseToHTML("![foo *bar*][foobar]\n\n[FOOBAR]: train.jpg \"train & tracks\"\n")
        XCTAssert("<p><img src=\"train.jpg\" alt=\"foo bar\" title=\"train &amp; tracks\" /></p>\n" == parseResult)
    }
    
    func test558() {
        let parseResult = parseToHTML("![foo](train.jpg)\n")
        XCTAssert("<p><img src=\"train.jpg\" alt=\"foo\" /></p>\n" == parseResult)
    }
    
    func test559() {
        let parseResult = parseToHTML("My ![foo bar](/path/to/train.jpg  \"title\"   )\n")
        XCTAssert("<p>My <img src=\"/path/to/train.jpg\" alt=\"foo bar\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test560() {
        let parseResult = parseToHTML("![foo](<url>)\n")
        XCTAssert("<p><img src=\"url\" alt=\"foo\" /></p>\n" == parseResult)
    }
    
    func test561() {
        let parseResult = parseToHTML("![](/url)\n")
        XCTAssert("<p><img src=\"/url\" alt=\"\" /></p>\n" == parseResult)
    }
    
    func test562() {
        let parseResult = parseToHTML("![foo][bar]\n\n[bar]: /url\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" /></p>\n" == parseResult)
    }
    
    func test563() {
        let parseResult = parseToHTML("![foo][bar]\n\n[BAR]: /url\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" /></p>\n" == parseResult)
    }
    
    func test564() {
        let parseResult = parseToHTML("![foo][]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test565() {
        let parseResult = parseToHTML("![*foo* bar][]\n\n[*foo* bar]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test566() {
        let parseResult = parseToHTML("![Foo][]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test567() {
        let parseResult = parseToHTML("![foo] \n[]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" title=\"title\" />\n[]</p>\n" == parseResult)
    }
    
    func test568() {
        let parseResult = parseToHTML("![foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test569() {
        let parseResult = parseToHTML("![*foo* bar]\n\n[*foo* bar]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"foo bar\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test570() {
        let parseResult = parseToHTML("![[foo]]\n\n[[foo]]: /url \"title\"\n")
        XCTAssert("<p>![[foo]]</p>\n<p>[[foo]]: /url &quot;title&quot;</p>\n" == parseResult)
    }
    
    func test571() {
        let parseResult = parseToHTML("![Foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p><img src=\"/url\" alt=\"Foo\" title=\"title\" /></p>\n" == parseResult)
    }
    
    func test572() {
        let parseResult = parseToHTML("!\\[foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p>![foo]</p>\n" == parseResult)
    }
    
    func test573() {
        let parseResult = parseToHTML("\\![foo]\n\n[foo]: /url \"title\"\n")
        XCTAssert("<p>!<a href=\"/url\" title=\"title\">foo</a></p>\n" == parseResult)
    }
    
    func test574() {
        let parseResult = parseToHTML("<http://foo.bar.baz>\n")
        XCTAssert("<p><a href=\"http://foo.bar.baz\">http://foo.bar.baz</a></p>\n" == parseResult)
    }
    
    func test575() {
        let parseResult = parseToHTML("<http://foo.bar.baz/test?q=hello&id=22&boolean>\n")
        XCTAssert("<p><a href=\"http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean\">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>\n" == parseResult)
    }
    
    func test576() {
        let parseResult = parseToHTML("<irc://foo.bar:2233/baz>\n")
        XCTAssert("<p><a href=\"irc://foo.bar:2233/baz\">irc://foo.bar:2233/baz</a></p>\n" == parseResult)
    }
    
    func test577() {
        let parseResult = parseToHTML("<MAILTO:FOO@BAR.BAZ>\n")
        XCTAssert("<p><a href=\"MAILTO:FOO@BAR.BAZ\">MAILTO:FOO@BAR.BAZ</a></p>\n" == parseResult)
    }
    
    func test578() {
        let parseResult = parseToHTML("<a+b+c:d>\n")
        XCTAssert("<p><a href=\"a+b+c:d\">a+b+c:d</a></p>\n" == parseResult)
    }
    
    func test579() {
        let parseResult = parseToHTML("<made-up-scheme://foo,bar>\n")
        XCTAssert("<p><a href=\"made-up-scheme://foo,bar\">made-up-scheme://foo,bar</a></p>\n" == parseResult)
    }
    
    func test580() {
        let parseResult = parseToHTML("<http://../>\n")
        XCTAssert("<p><a href=\"http://../\">http://../</a></p>\n" == parseResult)
    }
    
    func test581() {
        let parseResult = parseToHTML("<localhost:5001/foo>\n")
        XCTAssert("<p><a href=\"localhost:5001/foo\">localhost:5001/foo</a></p>\n" == parseResult)
    }
    
    func test582() {
        let parseResult = parseToHTML("<http://foo.bar/baz bim>\n")
        XCTAssert("<p>&lt;http://foo.bar/baz bim&gt;</p>\n" == parseResult)
    }
    
    func test583() {
        let parseResult = parseToHTML("<http://example.com/\\[\\>\n")
        XCTAssert("<p><a href=\"http://example.com/%5C%5B%5C\">http://example.com/\\[\\</a></p>\n" == parseResult)
    }
    
    func test584() {
        let parseResult = parseToHTML("<foo@bar.example.com>\n")
        XCTAssert("<p><a href=\"mailto:foo@bar.example.com\">foo@bar.example.com</a></p>\n" == parseResult)
    }
    
    func test585() {
        let parseResult = parseToHTML("<foo+special@Bar.baz-bar0.com>\n")
        XCTAssert("<p><a href=\"mailto:foo+special@Bar.baz-bar0.com\">foo+special@Bar.baz-bar0.com</a></p>\n" == parseResult)
    }
    
    func test586() {
        let parseResult = parseToHTML("<foo\\+@bar.example.com>\n")
        XCTAssert("<p>&lt;foo+@bar.example.com&gt;</p>\n" == parseResult)
    }
    
    func test587() {
        let parseResult = parseToHTML("<>\n")
        XCTAssert("<p>&lt;&gt;</p>\n" == parseResult)
    }
    
    func test588() {
        let parseResult = parseToHTML("< http://foo.bar >\n")
        XCTAssert("<p>&lt; http://foo.bar &gt;</p>\n" == parseResult)
    }
    
    func test589() {
        let parseResult = parseToHTML("<m:abc>\n")
        XCTAssert("<p>&lt;m:abc&gt;</p>\n" == parseResult)
    }
    
    func test590() {
        let parseResult = parseToHTML("<foo.bar.baz>\n")
        XCTAssert("<p>&lt;foo.bar.baz&gt;</p>\n" == parseResult)
    }
    
    func test591() {
        let parseResult = parseToHTML("http://example.com\n")
        XCTAssert("<p>http://example.com</p>\n" == parseResult)
    }
    
    func test592() {
        let parseResult = parseToHTML("foo@bar.example.com\n")
        XCTAssert("<p>foo@bar.example.com</p>\n" == parseResult)
    }
    
    func test593() {
        let parseResult = parseToHTML("<a><bab><c2c>\n")
        XCTAssert("<p><a><bab><c2c></p>\n" == parseResult)
    }
    
    func test594() {
        let parseResult = parseToHTML("<a/><b2/>\n")
        XCTAssert("<p><a/><b2/></p>\n" == parseResult)
    }
    
    func test595() {
        let parseResult = parseToHTML("<a  /><b2\ndata=\"foo\" >\n")
        XCTAssert("<p><a  /><b2\ndata=\"foo\" ></p>\n" == parseResult)
    }
    
    func test596() {
        let parseResult = parseToHTML("<a foo=\"bar\" bam = 'baz <em>\"</em>'\n_boolean zoop:33=zoop:33 />\n")
        XCTAssert("<p><a foo=\"bar\" bam = 'baz <em>\"</em>'\n_boolean zoop:33=zoop:33 /></p>\n" == parseResult)
    }
    
    func test597() {
        let parseResult = parseToHTML("Foo <responsive-image src=\"foo.jpg\" />\n")
        XCTAssert("<p>Foo <responsive-image src=\"foo.jpg\" /></p>\n" == parseResult)
    }
    
    func test598() {
        let parseResult = parseToHTML("<33> <__>\n")
        XCTAssert("<p>&lt;33&gt; &lt;__&gt;</p>\n" == parseResult)
    }
    
    func test599() {
        let parseResult = parseToHTML("<a h*#ref=\"hi\">\n")
        XCTAssert("<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>\n" == parseResult)
    }
    
    func test600() {
        let parseResult = parseToHTML("<a href=\"hi'> <a href=hi'>\n")
        XCTAssert("<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>\n" == parseResult)
    }
    
    func test601() {
        let parseResult = parseToHTML("< a><\nfoo><bar/ >\n<foo bar=baz\nbim!bop />\n")
        XCTAssert("<p>&lt; a&gt;&lt;\nfoo&gt;&lt;bar/ &gt;\n&lt;foo bar=baz\nbim!bop /&gt;</p>\n" == parseResult)
    }
    
    func test602() {
        let parseResult = parseToHTML("<a href='bar'title=title>\n")
        XCTAssert("<p>&lt;a href='bar'title=title&gt;</p>\n" == parseResult)
    }
    
    func test603() {
        let parseResult = parseToHTML("</a></foo >\n")
        XCTAssert("<p></a></foo ></p>\n" == parseResult)
    }
    
    func test604() {
        let parseResult = parseToHTML("</a href=\"foo\">\n")
        XCTAssert("<p>&lt;/a href=&quot;foo&quot;&gt;</p>\n" == parseResult)
    }
    
    func test605() {
        let parseResult = parseToHTML("foo <!-- this is a\ncomment - with hyphen -->\n")
        XCTAssert("<p>foo <!-- this is a\ncomment - with hyphen --></p>\n" == parseResult)
    }
    
    func test606() {
        let parseResult = parseToHTML("foo <!-- not a comment -- two hyphens -->\n")
        XCTAssert("<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>\n" == parseResult)
    }
    
    func test607() {
        let parseResult = parseToHTML("foo <!--> foo -->\n\nfoo <!-- foo--->\n")
        XCTAssert("<p>foo &lt;!--&gt; foo --&gt;</p>\n<p>foo &lt;!-- foo---&gt;</p>\n" == parseResult)
    }
    
    func test608() {
        let parseResult = parseToHTML("foo <?php echo $a; ?>\n")
        XCTAssert("<p>foo <?php echo $a; ?></p>\n" == parseResult)
    }
    
    func test609() {
        let parseResult = parseToHTML("foo <!ELEMENT br EMPTY>\n")
        XCTAssert("<p>foo <!ELEMENT br EMPTY></p>\n" == parseResult)
    }
    
    func test610() {
        let parseResult = parseToHTML("foo <![CDATA[>&<]]>\n")
        XCTAssert("<p>foo <![CDATA[>&<]]></p>\n" == parseResult)
    }
    
    func test611() {
        let parseResult = parseToHTML("foo <a href=\"&ouml;\">\n")
        XCTAssert("<p>foo <a href=\"&ouml;\"></p>\n" == parseResult)
    }
    
    func test612() {
        let parseResult = parseToHTML("foo <a href=\"\\*\">\n")
        XCTAssert("<p>foo <a href=\"\\*\"></p>\n" == parseResult)
    }
    
    func test613() {
        let parseResult = parseToHTML("<a href=\"\\\"\">\n")
        XCTAssert("<p>&lt;a href=&quot;&quot;&quot;&gt;</p>\n" == parseResult)
    }
    
    func test614() {
        let parseResult = parseToHTML("foo  \nbaz\n")
        XCTAssert("<p>foo<br />\nbaz</p>\n" == parseResult)
    }
    
    func test615() {
        let parseResult = parseToHTML("foo\\\nbaz\n")
        XCTAssert("<p>foo<br />\nbaz</p>\n" == parseResult)
    }
    
    func test616() {
        let parseResult = parseToHTML("foo       \nbaz\n")
        XCTAssert("<p>foo<br />\nbaz</p>\n" == parseResult)
    }
    
    func test617() {
        let parseResult = parseToHTML("foo  \n     bar\n")
        XCTAssert("<p>foo<br />\nbar</p>\n" == parseResult)
    }
    
    func test618() {
        let parseResult = parseToHTML("foo\\\n     bar\n")
        XCTAssert("<p>foo<br />\nbar</p>\n" == parseResult)
    }
    
    func test619() {
        let parseResult = parseToHTML("*foo  \nbar*\n")
        XCTAssert("<p><em>foo<br />\nbar</em></p>\n" == parseResult)
    }
    
    func test620() {
        let parseResult = parseToHTML("*foo\\\nbar*\n")
        XCTAssert("<p><em>foo<br />\nbar</em></p>\n" == parseResult)
    }
    
    func test621() {
        let parseResult = parseToHTML("`code \nspan`\n")
        XCTAssert("<p><code>code  span</code></p>\n" == parseResult)
    }
    
    func test622() {
        let parseResult = parseToHTML("`code\\\nspan`\n")
        XCTAssert("<p><code>code\\ span</code></p>\n" == parseResult)
    }
    
    func test623() {
        let parseResult = parseToHTML("<a href=\"foo  \nbar\">\n")
        XCTAssert("<p><a href=\"foo  \nbar\"></p>\n" == parseResult)
    }
    
    func test624() {
        let parseResult = parseToHTML("<a href=\"foo\\\nbar\">\n")
        XCTAssert("<p><a href=\"foo\\\nbar\"></p>\n" == parseResult)
    }
    
    func test625() {
        let parseResult = parseToHTML("foo\\\n")
        XCTAssert("<p>foo\\</p>\n" == parseResult)
    }
    
    func test626() {
        let parseResult = parseToHTML("foo  \n")
        XCTAssert("<p>foo</p>\n" == parseResult)
    }
    
    func test627() {
        let parseResult = parseToHTML("### foo\\\n")
        XCTAssert("<h3>foo\\</h3>\n" == parseResult)
    }
    
    func test628() {
        let parseResult = parseToHTML("### foo  \n")
        XCTAssert("<h3>foo</h3>\n" == parseResult)
    }
    
    func test629() {
        let parseResult = parseToHTML("foo\nbaz\n")
        XCTAssert("<p>foo\nbaz</p>\n" == parseResult)
    }
    
    func test630() {
        let parseResult = parseToHTML("foo \n baz\n")
        XCTAssert("<p>foo\nbaz</p>\n" == parseResult)
    }
    
    func test631() {
        let parseResult = parseToHTML("hello $.;'there\n")
        XCTAssert("<p>hello $.;'there</p>\n" == parseResult)
    }
    
    func test632() {
        let parseResult = parseToHTML("Foo χρῆν\n")
        XCTAssert("<p>Foo χρῆν</p>\n" == parseResult)
    }
    
    func test633() {
        let parseResult = parseToHTML("Multiple     spaces\n")
        XCTAssert("<p>Multiple     spaces</p>\n" == parseResult)
    }
    
    
}
