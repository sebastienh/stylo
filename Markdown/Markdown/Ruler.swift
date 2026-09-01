//
//  Ruler.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-22.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation
import Common

/**
 * class Ruler
 *
 * Helper class, used by [[MarkdownIt#core]], [[MarkdownIt#block]] and
 * [[MarkdownIt#inline]] to manage sequences of functions (rules):
 *
 * - keep rules in defined order
 * - assign the name to each rule
 * - enable/disable rules
 * - add/replace rulvar * - allow assign rules to additional named chains (in the same)
 * - cacheing lists of active rules
 *
 * You will not need use this class directly until write plugins. For simple
 * rules control use [[MarkdownIt.disable]], [[MarkdownIt.enable]] and
 * [[MarkdownIt.use]].
 **/
final class Ruler<F> {
    
    /// List of added rules. Each element is:
    ///
    /// {
    ///   name: XXX,
    ///   enabled: Boolean,
    ///   fn: Function(),
    ///   alt: [ name2, name3 ]
    /// }
    ///
    private var rules: [Rule<F>]
    
    
    /// Cached rule chains.
    ///
    /// First level - chain name, '' for default.
    /// Second level - diginal anchor for fast filtering by charcodes.
    private var cache: [String: [Rule<F>]]?
    
    /// execution queue 
    private let rulesQueue = DispatchQueue(label: "rules", attributes: .concurrent)
    
    init(rules: [Rule<F>]? = nil) {

        if let rules = rules {
            
            self.rules = rules
        }
        else {
        
            self.rules = [Rule]()
        }
    }
    
    /// Find rule index by name
    ///
    private func find(_ name: String) -> Int? {
        
        for (index, rule) in rules.enumerated() {
            
            if rule.name == name {
                
                return index
            }
        }
        
        return nil
    }
    
    /// Build rules lookup cache
    ///
    private func compile() {

        var chains: [String] = [""]
    
        // collect unique names
        for rule in rules {
            
            if rule.enabled {
                
                for alternateRuleName in rule.alt {
                    
                    if !chains.contains(alternateRuleName) {
                        
                        chains.append(alternateRuleName)
                    }
                }
            }
        }

        self.cache = [String: [Rule<F>]]()
    
        for chain in chains {
            
            cache![chain] = [Rule<F>]()
            
            for rule in rules {
                
                if !rule.enabled {
                    
                    continue
                }
                
                if !rule.alt.contains(chain) && chain.count != 0 {
                    
                    continue
                }
                
                cache![chain]!.append(rule)
            }
        }
    }
    
    ///
    /// Ruler.at(name, fn [, options])
    /// - name (String): rule name to replace.
    /// - fn (Function): new rule function.
    /// - options (Object): new rule options (not mandatory).
    ///
    /// Replace rule by name with new function & options. Throws error if name not
    /// found.
    ///
    /// ##### Options:
    ///
    /// - __alt__ - array with names of "alternate" chains.
    ///
    /// ##### Example
    ///
    /// Replace existing typorgapher replacement rule with new one:
    ///
    /// ```javascript
    /// var md = require('markdown-it')();
    ///
    /// md.core.ruler.at('replacements', function replace(state) {
    ///   //...
    /// });
    /// ```
    ///
    func at(_ name: String, fn: F, options: [String]?) {
        
        rulesQueue.sync(flags: .barrier) {
        
            let index = find(name)
        
            if let index = index {

                var ruleToChange = rules[index]
                
                ruleToChange.fn = fn
                
                if let options = options {
                    
                    ruleToChange.alt = options
                }
                
                rules[index] = ruleToChange
                
                cache = nil
            }
            else {
                
                debugPrint("Error: parser rule named: \(name) not found!")
            }
        }
    }
    
    ///
    /// Ruler.before(beforeName, ruleName, fn [, options])
    /// - beforeName (String): new rule will be added before this one.
    /// - ruleName (String): name of added rule.
    /// - fn (Function): rule function.
    /// - options (Object): rule options (not mandatory).
    ///
    /// Add new rule to chain before one with given name. See also
    /// [[Ruler.after]], [[Ruler.push]].
    ///
    /// ##### Options:
    ///
    /// - __alt__ - array with names of "alternate" chains.
    ///
    /// ##### Example
    ///
    /// ```javascript
    /// var md = require('markdown-it')();
    ///
    /// md.block.ruler.before('paragraph', 'my_rule', function replace(state) {
    ///   //...
    /// });
    /// ```
    ///
    func before(_ beforeName: String, rule: Rule<F>) {
        
        rulesQueue.sync(flags: .barrier) {
    
            let index = find(beforeName)!
            
            rules.insert(rule, at: index)
            
            // this should displace the beforeRule to an index further
            #if DEBUG
            assert(find(beforeName) == index + 1)
            #endif
            
            cache = nil
        }
    }
    
    ///
    /// Ruler.after(afterName, ruleName, fn [, options])
    /// - afterName (String): new rule will be added after this one.
    /// - ruleName (String): name of added rule.
    /// - fn (Function): rule function.
    /// - options (Object): rule options (not mandatory).
    ///
    /// Add new rule to chain after one with given name. See also
    /// [[Ruler.before]], [[Ruler.push]].
    ///
    /// ##### Options:
    ///
    /// - __alt__ - array with names of "alternate" chains.
    ///
    /// ##### Example
    ///
    /// ```javascript
    /// var md = require('markdown-it')();
    ///
    /// md.inline.ruler.after('text', 'my_rule', function replace(state) {
    ///   //...
    /// });
    /// ```
    ///
    func after(_ afterName: String, rule: Rule<F>) {

        rulesQueue.sync(flags: .barrier) {
        
            let index = find(afterName)!
            
            rules.insert(rule, at: index + 1)
            
            // this should displace the beforeRule to an index further
            #if DEBUG
            assert(find(afterName) == index)
            #endif
            
            cache = nil
        }
    }
    
    ///
    /// Ruler.push(ruleName, fn [, options])
    /// - ruleName (String): name of added rule.
    /// - fn (Function): rule function.
    /// - options (Object): rule options (not mandatory).
    ///
    /// Push new rule to the end of chain. See also
    /// [[Ruler.before]], [[Ruler.after]].
    ///
    /// ##### Options:
    ///
    /// - __alt__ - array with names of "alternate" chains.
    ///
    /// ##### Example
    ///
    /// ```javascript
    /// var md = require('markdown-it')();
    ///
    /// md.core.ruler.push('my_rule', function replace(state) {
    ///   //...
    /// });
    /// ```
    ///
    func push(_ rule: Rule<F>) {
        
        rulesQueue.sync(flags: .barrier) {
    
            rules.append(rule)
            
            cache = nil
        }
    }
    
    ///
    /// Ruler.enable(list [, ignoreInvalid]) -> Array
    /// - list (String|Array): list of rule names to enable.
    /// - ignoreInvalid (Boolean): set `true` to ignore errors when rule not found.
    ///
    /// Enable rules with given names. If any rule name not found - throw Error.
    /// Errors can be disabled by second param.
    ///
    /// Returns list of found rule names (if no exception happened).
    ///
    /// See also [[Ruler.disable]], [[Ruler.enableOnly]].
    ///
    public  func enable(_ list: [String]) -> [String] {
    
        return rulesQueue.sync(flags: .barrier) {
            
            return _enable(list)
        }
    }
    
    private func _enable(_ list: [String]) -> [String] {
        
        var result = [String]()
        
        // Search by name and enable
        for name in list {
            
            let index = find(name)!
            
            rules[index].enabled = true
            
            result.append(name)
        }
        
        cache = nil
        
        return result
    }
    
    ///
    /// Ruler.enableOnly(list [, ignoreInvalid])
    /// - list (String|Array): list of rule names to enable (whitelist).
    /// - ignoreInvalid (Boolean): set `true` to ignore errors when rule not found.
    ///
    /// Enable rules with given names, and disable everything else. If any rule name
    /// not found - throw Error. Errors can be disabled by second param.
    ///
    /// See also [[Ruler.disable]], [[Ruler.enable]].
    ///
    @discardableResult
    public func enableOnly(_ list: [String]) -> [String] {
    
        return rulesQueue.sync(flags: .barrier) {
        
            for var rule in rules {
                
                rule.enabled = false
            }
        
            return _enable(list)
        }
    }
    
    ///
    /// Ruler.disable(list [, ignoreInvalid]) -> Array
    /// - list (String|Array): list of rule names to disable.
    /// - ignoreInvalid (Boolean): set `true` to ignore errors when rule not found.
    ///
    /// Disable rules with given names. If any rule name not found - throw Error.
    /// Errors can be disabled by second param.
    ///
    /// Returns list of found rule names (if no exception happened).
    ///
    /// See also [[Ruler.enable]], [[Ruler.enableOnly]].
    ///
    func disable(_ list: [String]) -> [String] {
    
        return rulesQueue.sync(flags: .barrier) {
        
            var result = [String]()
        
            // Search by name and disable
            for name in list {
                
                rules[find(name)!].enabled = false
                
                result.append(name)
            }
            
            cache = nil
            
            return result
        }
    }
    
    ///
    /// Ruler.getRules(chainName) -> Array
    ///
    /// Return array of active functions (rules) for given chain name. It analyzes
    /// rules configuration, compiles caches if not exists and returns result.
    ///
    /// Default chain name is `''` (empty string). It can't be skipped. That's
    /// done intentionally, to keep signature monomorphic for high speed.
    ///
    func getRules(_ chainName: String) -> [Rule<F>] {

        return rulesQueue.sync(flags: .barrier) {
        
            if cache == nil {
            
                compile()
            }
        
            if cache!.index(forKey: chainName) != nil {
                
                return cache![chainName]!
            }
            
            // Chain can be empty, if rules disabled. But we still have to return Array.
            return [Rule<F>]()
        }
    }
    
}







