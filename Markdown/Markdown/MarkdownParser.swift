//
//  MarkdownParser.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-24.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

typealias MarkdownString = String

let config = [
    "all-available": Presets.GetEverythingAvailaiblePresets(),
    "default": Presets.GetDefaultPresets(),
    "zero": Presets.GetZeroPresets(),
    "commonmark": Presets.GetCommonMarkPresets()
]

///
/// class MarkdownParser (MarkdownIt)
///
/// Main parser/renderer class.
///
/// ##### Usage
///
/// ```javascript
/// // node.js, "classic" way:
/// var MarkdownIt = require('markdown-it'),
///     md = new MarkdownIt();
/// var result = md.render('# markdown-it rulezz!');
///
/// // node.js, the same, but with sugar:
/// var md = require('markdown-it')();
/// var result = md.render('# markdown-it rulezz!');
///
/// // browser without AMD, added to "window" on script load
/// // Note, there are no dash.
/// var md = window.markdownit();
/// var result = md.render('# markdown-it rulezz!');
/// ```
///
/// Single line rendering, without paragraph wrap:
///
/// ```javascript
/// var md = require('markdown-it')();
/// var result = md.renderInline('__markdown-it__ rulezz!');
/// ```
///

///
/// new MarkdownIt([presetName, options])
/// - presetName (String): optional, `commonmark` / `zero`
/// - options (Object)
///
/// Creates parser instanse with given config. Can be called without `new`.
///
/// ##### presetName
///
/// MarkdownIt provides named presets as a convenience to quickly
/// enable/disable active syntax rules and options for common use cases.
///
/// - ["commonmark"](https://github.com/markdown-it/markdown-it/blob/master/lib/presets/commonmark.js) -
///   configures parser to strict [CommonMark](http://commonmark.org/) mode.
/// - [default](https://github.com/markdown-it/markdown-it/blob/master/lib/presets/default.js) -
///   similar to GFM, used when no preset name given. Enables all available rules,
///   but still without html, typographer & autolinker.
/// - ["zero"](https://github.com/markdown-it/markdown-it/blob/master/lib/presets/zero.js) -
///   all rules disabled. Useful to quickly setup your config via `.enable()`.
///   For example, when you need only `bold` and `italic` markup and nothing else.
///
/// ##### options:
///
/// - __html__ - `false`. Set `true` to enable HTML tags in source. Be careful!
///   That's not safe! You may need external sanitizer to protect output from XSS.
///   It's better to extend features via plugins, instead of enabling HTML.
/// - __xhtmlOut__ - `false`. Set `true` to add '/' when closing single tags
///   (`<br />`). This is needed only for full CommonMark compatibility. In real
///   world you will need HTML output.
/// - __breaks__ - `false`. Set `true` to convert `\n` in paragraphs into `<br>`.
/// - __langPrefix__ - `language-`. CSS language class prefix for fenced blocks.
///   Can be useful for external highlighters.
/// - __linkify__ - `false`. Set `true` to autoconvert URL-like text to links.
/// - __typographer__  - `false`. Set `true` to enable [some language-neutral
///   replacement](https://github.com/markdown-it/markdown-it/blob/master/lib/rules_core/replacements.js) +
///   quotes beautification (smartquotes).
/// - __quotes__ - `“”‘’`, String or Array. Double + single quotes replacement
///   pairs, when typographer enabled and smartquotes on. For example, you can
///   use `'«»„“'` for Russian, `'„“‚‘'` for German, and
///   `['«\xA0', '\xA0»', '‹\xA0', '\xA0›']` for French (including nbsp).
/// - __highlight__ - `null`. Highlighter function for fenced code blocks.
///   Highlighter `function (str, lang)` should return escaped HTML. It can also
///   return empty string if the source was not changed and should be escaped externally.
///
/// ##### Example
///
/// ```javascript
/// // commonmark mode
/// var md = require('markdown-it')('commonmark');
///
/// // default mode
/// var md = require('markdown-it')();
///
/// // enable everything
/// var md = require('markdown-it')({
///   html: true,
///   linkify: true,
///   typographer: true
/// });
/// ```
///
/// ##### Syntax highlighting
///
/// ```js
/// var hljs = require('highlight.js') // https://highlightjs.org/
///
/// var md = require('markdown-it')({
///   highlight: function (str, lang) {
///     if (lang && hljs.getLanguage(lang)) {
///       try {
///         return hljs.highlight(lang, str).value;
///       } catch (__) {}
///     }
///
///     try {
///       return hljs.highlightAuto(str).value;
///     } catch (__) {}
///
///     return ''; // use external default escaping
///   }
/// });
/// ```
///
public final class MarkdownParser {
    
    ///
    /// MarkdownIt#inline -> ParserInline
    ///
    /// Instance of [[ParserInline]]. You may need it to add new rules when
    /// writing plugins. For simple rules control use [[MarkdownIt.disable]] and
    /// [[MarkdownIt.enable]].
    ///
    let inline: ParserInline
    
    ///
    /// MarkdownIt#block -> ParserBlock
    ///
    /// Instance of [[ParserBlock]]. You may need it to add new rules when
    /// writing plugins. For simple rules control use [[MarkdownIt.disable]] and
    /// [[MarkdownIt.enable]].
    ///
    let block: ParserBlock
    
    ///
    /// MarkdownIt#core -> Core
    ///
    /// Instance of [[Core]] chain executor. You may need it to add new rules when
    /// writing plugins. For simple rules control use [[MarkdownIt.disable]] and
    /// [[MarkdownIt.enable]].
    ///
    let core: ParserCore
    
    ///
    /// MarkdownIt#renderer -> Renderer
    ///
    /// Instance of [[Renderer]]. Use it to modify output look. Or to add rendering
    /// rules for new token types, generated by plugins.
    ///
    /// ##### Example
    ///
    /// ```javascript
    /// var md = require('markdown-it')();
    ///
    /// function myToken(tokens, idx, options, env, self) {
    ///   //...
    ///   return result;
    /// };
    ///
    /// md.renderer.rules['my_token'] = myToken
    /// ```
    ///
    /// See [[Renderer]] docs and [source code](https://github.com/markdown-it/markdown-it/blob/master/lib/renderer.js).
    ///
    /// FIXME: for the moment we take this approch but we will
    /// make it possible to use a same parser result and output it in
    /// different formats. Maybe it will not be needed, we will need to
    /// test this. But at the minimum, the MarkdownParser should take  renderer
    /// in argument so that it is possible to chose from outside which
    /// kind a rendering we want.
    /// Note the renderer should be passed to the render function.
    
    //    let renderer: Renderer
    
    ///
    /// MarkdownIt#linkify -> LinkifyIt
    ///
    /// [linkify-it](https://github.com/markdown-it/linkify-it) instance.
    /// Used by [linkify](https://github.com/markdown-it/markdown-it/blob/master/lib/rules_core/linkify.js)
    /// rule.
    ///
    /// FIXME: TODO
    //    let linkify = LinkifyIt
    
    
    /// Parser options
    var options: Options!
    
    ///
    /// Access to the source string from anywere
    ///
    var src: MarkdownString!
    
    ///
    /// This is the range of the token we should tentatively stop
    /// after if we reach it:
    ///
    ///                                                          Stop here
    ///                                                              |
    ///                                                              V
    /// <stopOpeningTokenRange>..<endTokenRange><startTokenRange><endTokenRange>
    private let stopOpeningTokenRange: NSRange?
    
    ///
    /// Variable used by the this class (MarkdownParser) to
    /// tell ParserBlock to stop under certain
    var shouldStop: Bool = false
    
    ///
    /// Variable that says if the parser has stopped
    /// when requested to do so. Used in partial compilation.
    ///
    var stopped: Bool = false
    
    
    ///
    /// When this value is set to true the parser will delete
    /// any references of referencing tokens in the env when
    /// they are included in the specified range. It should only be used
    /// as we compile partially.
    ///
    var cleanReferencesAsParsing: Bool
    
    ///
    /// Set to when partially compiling and to hanle the references
    /// in a
    ///
    var globalPositionOffset: Int?
    
    ///
    /// List of compiled references labels
    ///
    public var compiledReferencesLabels: Set<String>
    
    ///
    /// When a condition that triggers that we should
    /// stop parsing becomes true we set this variable
    /// to true, stating that from that point on, we should
    /// start counting the number of .closing tokens and
    /// stop when we reach the number maximumAllowedClosingTokensWhenCounting
    ///
    private var shouldCountValidEndTokens: Bool = false
    
    ///
    /// When shouldCountValidEndTokens is true we start counting
    /// the added tokens. This counter keeps how many we have added.
    ///
    private var validClosingTokensAddedCount: Int = 0
    
    ///
    /// The defined maximum number of tokens to add whe counting
    /// before setting shouldStop to true.
    ///
    private let maximumAllowedClosingTokensWhenCounting: Int = 1
    
    public init(presetName: String? = nil, options: Options? = nil, stopOpeningTokenRange: NSRange? = nil, cleanReferencesAsParsing: Bool = false, globalPositionOffset: Int? = nil) {
        
        self.inline = ParserInline()
        
        self.block = ParserBlock()
        
        self.core = ParserCore()
        
        self.compiledReferencesLabels = Set<String>()
        
        self.stopOpeningTokenRange = stopOpeningTokenRange
        
        self.cleanReferencesAsParsing = cleanReferencesAsParsing
        
        self.globalPositionOffset = globalPositionOffset
        
        #if DEBUG
        if cleanReferencesAsParsing {
            assert(globalPositionOffset != nil)
        }
        #endif
        
        if let presetName = presetName {
            
            configure(presetName)
        }
        else {
            
            #if DEBUG
            // FIXME: should be changed to default.
            configure("all-available")
            #else
            configure("default")
            #endif
        }
        
        // those options override the options
        // defined by the passed preset name or defined
        // in the default Presets.
        if let options = options {
            
            // we erase the options using the ones passed
            // in parameter to the init method. For the componenents
            // they will the ones defined in the default presets.
            self.options = options
        }
    }
    
    /// internal
    /// MarkdownIt.parse(src, env) -> Array
    /// - src (String): source string
    /// - env (Object): environment sandbox
    ///
    /// Parse input string and returns list of block tokens (special token type
    /// "inline" will contain list of inline tokens). You should not call this
    /// method directly, until you write custom renderer (for example, to produce
    /// AST).
    ///
    /// `env` is used to pass data between "distributed" rules and return additional
    /// metadata like reference info, needed for the renderer. It also can be used to
    /// inject data in specific cases. Usually, you will be ok to pass `{}`,
    /// and then pass updated object to renderer.
    @discardableResult
    public func parse(_ src: String, env: Env? = nil, tokens: Tokens? = nil, inlineMode: Bool = false) -> Tokens {
        
        var discard: Bool = false
        return self.parse(src, env: env, tokens: tokens, inlineMode: inlineMode, stopped: &discard)
    }
    
    
    /// internal
    /// MarkdownIt.parse(src, env) -> Array
    /// - src (String): source string
    /// - env (Object): environment sandbox
    ///
    /// Parse input string and returns list of block tokens (special token type
    /// "inline" will contain list of inline tokens). You should not call this
    /// method directly, until you write custom renderer (for example, to produce
    /// AST).
    ///
    /// `env` is used to pass data between "distributed" rules and return additional
    /// metadata like reference info, needed for the renderer. It also can be used to
    /// inject data in specific cases. Usually, you will be ok to pass `{}`,
    /// and then pass updated object to renderer.
    @discardableResult
    public func parse(_ src: String, env: Env? = nil, tokens: Tokens? = nil, inlineMode: Bool = false, stopped: inout Bool) -> Tokens {
        
        var localEnv = env
        
        if localEnv == nil {
            localEnv = StyloMarkdownEnv()
        }
        
        self.src = MarkdownString(string: src)
        let state = StateCore(src: self.src, md: self, env: localEnv!, tokens: tokens, inlineMode: inlineMode)
        
        core.process(state)
        stopped = self.stopped
        
        return state.tokens
    }
    
    @discardableResult
    public func parseInline(_ src: String, env: Env? = nil) -> Tokens {
        
        var localEnv = env
        
        if localEnv == nil {
            localEnv = StyloMarkdownEnv()
        }
        
        self.src = MarkdownString(string: src)
        let state = StateCore(src: self.src, md: self, env: localEnv!, tokens: nil, inlineMode: true)
        
        core.process(state)
        return state.tokens
    }
    
    func shouldStopToCompile(from startIndex: Int, tokenType: TokenType) -> Bool {
        
        if let stopOpeningTokenRange = self.stopOpeningTokenRange {
        
            assert(!shouldStop)
            if !shouldStop && startIndex == stopOpeningTokenRange.lowerBound {
            
                self.stopped = true 
                self.shouldStop = true
                return true
            }
        }
        return false
    }
    
    ///
    /// MarkdownIt.render(src [, env]) -> String
    /// - src (String): source string
    /// - env (Object): environment sandbox
    ///
    /// Render markdown string into html. It does all magic for you :).
    ///
    /// `env` can be used to inject additional metadata (`{}` by default).
    /// But you will not need it with high probability. See also comment
    /// in [[MarkdownIt.parse]].
    ///
    /// If tokens are nil, we will need to call parse before rendering. Otherwise
    /// the otkens are used to do the rendering. This is used to have multiple
    /// outputs from a same input without having to reparse each time. So we could simply
    /// use this like this:
    /// ```swift
    ///
    ///     let tokens = md.parse(string)
    ///     let htmlResult = md.render(tokens: tokens, src: String, env: Any? = nil, withRenderer renderer: Renderer)
    ///
    /// ```
    ///
    /// src String can not be nil since it is needed when rendering to compute the tokens content
    ///
    ///
    public func render<RendererType: Renderer>(_ tokens: Tokens? = nil, src: String, env: Env? = nil, withRenderer renderer: RendererType) -> RendererType.ReturnType {
        
        var localEnv = env
        
        if localEnv == nil {
            
            localEnv = StyloMarkdownEnv()
        }
        
        if let tokens = tokens {
            
            return renderer.render(tokens, options: options, env: env)
        }
        else {
            
            return renderer.render(parse(src, env: env), options: options, env: env)
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    ///
    /// This validator can prohibit more than really needed to prevent XSS. It's a
    /// tradeoff to keep code simple and to be secure by default.
    ///
    /// If you need different setup - override validator method as you wish. Or
    /// replace it with dummy function and use external sanitizer.
    ///
    func validateLink(_ url: String) -> Bool {
        
        // url should be normalized at this point, and existing entities are decoded
        let str = url.trimWhitespaces().lowercased()
        
        // The following is an optimisation over:
        // private let BAD_PROTO_RE = "^(vbscript|javascript|file|data):";
        // private let GOOD_DATA_RE = "^data:image/(gif|png|jpeg|webp);";
        // url should be normalized at this point, and existing entities are decoded
        // let str = url.trim().lowercaseString
        // if regex(BAD_PROTO_RE).test(str) {
        //    return regex(GOOD_DATA_RE).test(str)
        // }
        // return true
        
        
        if !str.hasPrefix("vbscript:")
            && !str.hasPrefix("javascript:")
            && !str.hasPrefix("file:")
            && !str.hasPrefix("data:") {
            
            if !str.hasPrefix("data:image/gif;")
                && !str.hasPrefix("data:image/png;")
                && !str.hasPrefix("data:image/jpeg;")
                && !str.hasPrefix("data:image/webp;") {
                
                return true
            }
            
            return false
        }
        
        return true
    }
    
    /** *not* chainable, internal
     * MarkdownIt.configure(presets)
     *
     * Batch load of all options and compenent settings. This is internal method,
     * and you probably will not need it. But if you with - see available presets
     * and data structure [here](https://github.com/markdown-it/markdown-it/tree/master/lib/presets)
     *
     * We strongly recommend to use presets instead of direct config loads. That
     * will give better compatibility with next versions.
     **/
    func configure(_ presetName: String) {
        
        if let presets = config[presetName] {
            
            if let options = presets.options {
                
                self.options = options
            }
            
            if let components = presets.components {
                
                core.ruler.enableOnly(components.core["rules"]!.map({§$0}))
                block.ruler.enableOnly(components.block["rules"]!.map({§$0}))
                inline.ruler.enableOnly(components.inline["rules"]!.map({§$0}))
                inline.ruler2.enableOnly(components.inline2["rules2"]!.map({§$0}))
            }
        }
        else {
            
            fatalError("Unknown preset with name \(presetName)")
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////
    
    let RECODE_HOSTNAME_FOR = [ "http:", "https:", "mailto:" ]
    
    /// TODO: NW-192: finish this implementation.
    func normalizeLink(_ url: String) -> String {
        
        var parsed = url.parseToMdUrl(true)
        
        if let hostname = parsed.hostname {
            
            let RECODE_HOSTNAME_FOR = ["http:", "https:", "mailto:"]
            
            // Encode hostnames in urls like:
            // `http://host/`, `https://host/`, `mailto:user@host`, `//host/`
            //
            // We don't encode unknown schemas, because it's likely that we encode
            // something we shouldn't (e.g. `skype:name` treated as `skype:host`)
            //
            if parsed.proto == nil || (parsed.proto != nil && RECODE_HOSTNAME_FOR.contains(parsed.proto!)) {
                
                parsed.hostname = hostname.encodedURL
            }
        }
        
        return parsed.format().encodeToHtml()
    }
    
    /// TODO: NW-192: finish this implementation.
    func normalizeLinkText(_ url: String) -> String {
        
        var parsed = url.parseToMdUrl(true)
        
        if let hostname = parsed.hostname {
            
            let RECODE_HOSTNAME_FOR = ["http:", "https:", "mailto:"]
            
            // Encode hostnames in urls like:
            // `http://host/`, `https://host/`, `mailto:user@host`, `//host/`
            //
            // We don't encode unknown schemas, because it's likely that we encode
            // something we shouldn't (e.g. `skype:name` treated as `skype:host`)
            //
            if parsed.proto == nil || (parsed.proto != nil && RECODE_HOSTNAME_FOR.contains(parsed.proto!)) {
                
                parsed.hostname = hostname.decodedURL
            }
        }
        return parsed.format().decode()
    }
    
}

