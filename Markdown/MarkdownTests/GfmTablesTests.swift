//
//  GfmTablesTests.swift

//  Created by Sébastien Hamel on 2016-04-18.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest

class GfmTablesTests : MarkdownSpecTestsBase {
    
    func test1() {
        let parseResult = parseToHTML("| Heading 1 | Heading 2\n| --------- | ---------\n| Cell 1    | Cell 2\n| Cell 3    | Cell 4\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Heading 1</th>\n<th>Heading 2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Cell 1</td>\n<td>Cell 2</td>\n</tr>\n<tr>\n<td>Cell 3</td>\n<td>Cell 4</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test2() {
        
        let expected = "<table>\n<thead>\n<tr>\n<th style=\"text-align:center\">Header 1</th>\n<th style=\"text-align:right\">Header 2</th>\n<th style=\"text-align:left\">Header 3</th>\n<th>Header 4</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align:center\">Cell 1</td>\n<td style=\"text-align:right\">Cell 2</td>\n<td style=\"text-align:left\">Cell 3</td>\n<td>Cell 4</td>\n</tr>\n<tr>\n<td style=\"text-align:center\">Cell 5</td>\n<td style=\"text-align:right\">Cell 6</td>\n<td style=\"text-align:left\">Cell 7</td>\n<td>Cell 8</td>\n</tr>\n</tbody>\n</table>\n"
        
        
        let parseResult = parseToHTML("| Header 1 | Header 2 | Header 3 | Header 4 |\n| :------: | -------: | :------- | -------- |\n| Cell 1   | Cell 2   | Cell 3   | Cell 4   |\n| Cell 5   | Cell 6   | Cell 7   | Cell 8   |\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected), received: \n\(parseResult)")
    }
    
    func test3() {
        let parseResult = parseToHTML("Header 1|Header 2|Header 3|Header 4\n:-------|:------:|-------:|--------\nCell 1  |Cell 2  |Cell 3  |Cell 4\n*Cell 5*|Cell 6  |Cell 7  |Cell 8\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th style=\"text-align:left\">Header 1</th>\n<th style=\"text-align:center\">Header 2</th>\n<th style=\"text-align:right\">Header 3</th>\n<th>Header 4</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align:left\">Cell 1</td>\n<td style=\"text-align:center\">Cell 2</td>\n<td style=\"text-align:right\">Cell 3</td>\n<td>Cell 4</td>\n</tr>\n<tr>\n<td style=\"text-align:left\"><em>Cell 5</em></td>\n<td style=\"text-align:center\">Cell 6</td>\n<td style=\"text-align:right\">Cell 7</td>\n<td>Cell 8</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test4() {
        let parseResult = parseToHTML("> foo|foo\n> ---|---\n> bar|bar\nbaz|baz\n")
        XCTAssert("<blockquote>\n<table>\n<thead>\n<tr>\n<th>foo</th>\n<th>foo</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>bar</td>\n<td>bar</td>\n</tr>\n</tbody>\n</table>\n</blockquote>\n<p>baz|baz</p>\n" == parseResult)
    }
    
    func test5() {
        let parseResult = parseToHTML("| foo\n|----\n| test2\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>foo</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>test2</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test6() {
        let parseResult = parseToHTML("-   foo|foo\n---|---\nbar|bar\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>-   foo</th>\n<th>foo</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>bar</td>\n<td>bar</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test7() {
        let expected = "<p>foo|foo\n---|---s\nbar|bar</p>\n"
        let parseResult = parseToHTML("foo|foo\n---|---s\nbar|bar\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    func test8() {
        let parseResult = parseToHTML("foo|foo\n---:---\nbar|bar\n")
        XCTAssert("<p>foo|foo\n---:---\nbar|bar</p>\n" == parseResult)
    }
    
    func test9() {
        
        let expected = "<p>foo|foo\n---||---\nbar|bar</p>\n"
        let parseResult = parseToHTML("foo|foo\n---||---\nbar|bar\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    func test10() {
        let expected = "<p>foo|foo\n---|-::-\nbar|bar</p>\n"
        let parseResult = parseToHTML("foo|foo\n---|-::-\nbar|bar\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    func test11() {
        let parseResult = parseToHTML("foo\n---|---\nbar|bar\n")
        XCTAssert("<p>foo\n---|---\nbar|bar</p>\n" == parseResult)
    }
    
    func test12() {
        let parseResult = parseToHTML("|    foo    |    bar    |\n|    ---    |    ---    |\n|    baz    |    quux    |\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>foo</th>\n<th>bar</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>baz</td>\n<td>quux</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test13() {
        let parseResult = parseToHTML("paragraph\nfoo|foo\n---|---\nbar|bar\n")
        XCTAssert("<p>paragraph</p>\n<table>\n<thead>\n<tr>\n<th>foo</th>\n<th>foo</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>bar</td>\n<td>bar</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test14() {
        let parseResult = parseToHTML("foo|foo\n---|---\nparagraph\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>foo</th>\n<th>foo</th>\n</tr>\n</thead>\n<tbody></tbody>\n</table>\n<p>paragraph</p>\n" == parseResult)
    }
    
    func test15() {
        let expected = "<table>\n<thead>\n<tr>\n<th>Heading 1 \\\\</th>\n<th>Heading 2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Cell|1|</td>\n<td>Cell|2</td>\n</tr>\n<tr>\n<td>| Cell\\|3 \\</td>\n<td>Cell|4</td>\n</tr>\n</tbody>\n</table>\n"
        let parseResult = parseToHTML("| Heading 1 \\\\\\\\| Heading 2\n| --------- | ---------\n| Cell\\|1\\|| Cell\\|2\n\\| Cell\\\\\\|3 \\\\| Cell\\|4\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    func test16() {
        let parseResult = parseToHTML("| Heading 1 | Heading 2\n| --------- | ---------\n| Cell 1 | Cell 2\n| `Cell|3` | Cell 4\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Heading 1</th>\n<th>Heading 2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Cell 1</td>\n<td>Cell 2</td>\n</tr>\n<tr>\n<td><code>Cell|3</code></td>\n<td>Cell 4</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    func test17() {
        let parseResult = parseToHTML("| Heading 1 | Heading 2\n| --------- | ---------\n| Cell 1 | Cell 2\n| `Cell 3| Cell 4\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Heading 1</th>\n<th>Heading 2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Cell 1</td>\n<td>Cell 2</td>\n</tr>\n<tr>\n<td>`Cell 3</td>\n<td>Cell 4</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // Another complicated backticks case
    func test18() {
        let parseResult = parseToHTML("| Heading 1 | Heading 2\n| --------- | ---------\n| Cell 1 | Cell 2\n| \\\\\\`|\\\\\\`\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Heading 1</th>\n<th>Heading 2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Cell 1</td>\n<td>Cell 2</td>\n</tr>\n<tr>\n<td>\\`</td>\n<td>\\`</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // `\` in tables should not count as escaped backtick
    func test19() {
        let expected = "<table>\n<thead>\n<tr>\n<th>#</th>\n<th>1</th>\n<th>2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>x</td>\n<td><code>\\</code></td>\n<td><code>x</code></td>\n</tr>\n</tbody>\n</table>\n"
        let parseResult = parseToHTML("# | 1 | 2\n--|--|--\nx | `\\` | `x`\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    // Tables should handle escaped backticks
    func test20() {
        let parseResult = parseToHTML("# | 1 | 2\n--|--|--\nx | \\`\\` | `x`\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>#</th>\n<th>1</th>\n<th>2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>x</td>\n<td>``</td>\n<td><code>x</code></td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // An amount of rows might be different across the table (issue #171):
    func test21() {
        let expected = "<table>\n<thead>\n<tr>\n<th style=\"text-align:center\">1</th>\n<th style=\"text-align:center\">2</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align:center\">3</td>\n<td style=\"text-align:center\">4</td>\n</tr>\n</tbody>\n</table>\n"
        let parseResult = parseToHTML("| 1 | 2 |\n| :-----: |  :-----: |  :-----: |\n| 3 | 4 | 5 | 6 |\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    // An amount of rows might be different across the table #2:
    func test22() {
        let parseResult = parseToHTML("| 1 | 2 | 3 | 4 |\n| :-----: |  :-----: |  :-----: |  :-----: |\n| 5 | 6 |\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th style=\"text-align:center\">1</th>\n<th style=\"text-align:center\">2</th>\n<th style=\"text-align:center\">3</th>\n<th style=\"text-align:center\">4</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align:center\">5</td>\n<td style=\"text-align:center\">6</td>\n<td style=\"text-align:center\"></td>\n<td style=\"text-align:center\"></td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // Allow one-column tables (issue #171):
    func test23() {
        let parseResult = parseToHTML("| foo |\n:-----:\n| bar |\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th style=\"text-align:center\">foo</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td style=\"text-align:center\">bar</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // Allow indented tables (issue #325):
    func test24() {
        let parseResult = parseToHTML("| Col1a | Col2a |\n| ----- | ----- |\n| Col1b | Col2b |\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Col1a</th>\n<th>Col2a</th>\n</tr>\n</thead>\n<tbody>\n<tr>\n<td>Col1b</td>\n<td>Col2b</td>\n</tr>\n</tbody>\n</table>\n" == parseResult)
    }
    
    // Tables should not be indented more than 4 spaces (1st line):
    func test25() {
        let expected = "<pre><code>| Col1a | Col2a |\n</code></pre>\n<p>| ----- | ----- |\n| Col1b | Col2b |</p>\n"
        let parseResult = parseToHTML("    | Col1a | Col2a |\n| ----- | ----- |\n| Col1b | Col2b |\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    // Tables should not be indented more than 4 spaces (2nd line):
    func test26() {
        let expected = "<p>| Col1a | Col2a |\n| ----- | ----- |\n| Col1b | Col2b |</p>\n"
        let parseResult = parseToHTML("| Col1a | Col2a |\n    | ----- | ----- |\n| Col1b | Col2b |\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    // Tables should not be indented more than 4 spaces (3rd line):
    func test27() {
        let expected = "<table>\n<thead>\n<tr>\n<th>Col1a</th>\n<th>Col2a</th>\n</tr>\n</thead>\n<tbody></tbody>\n</table>\n<pre><code>| Col1b | Col2b |\n</code></pre>\n"
        let parseResult = parseToHTML("| Col1a | Col2a |\n| ----- | ----- |\n    | Col1b | Col2b |\n")
        XCTAssert(expected == parseResult, "Expected:\n\(expected)\nreceived: \n\(parseResult)")
    }
    
    func test28() {
        let parseResult = parseToHTML("| Col1a | Col2a |\n| ----- | ----- |\n")
        XCTAssert("<table>\n<thead>\n<tr>\n<th>Col1a</th>\n<th>Col2a</th>\n</tr>\n</thead>\n<tbody></tbody>\n</table>\n" == parseResult)
    }
    
    func test29() {
        let parseResult = parseToHTML("Col1a | Col1b | Col1c\n----- | -----\nCol2a | Col2b | Col2c\n")
        XCTAssert("<p>Col1a | Col1b | Col1c\n----- | -----\nCol2a | Col2b | Col2c</p>\n" == parseResult)
    }
    
    
}
