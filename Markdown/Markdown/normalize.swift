//
//  normalize.swift
//  Markdown
//
//  Created by Sébastien Hamel on 2015-11-25.
//  Copyright © 2015 Textually Inc. All rights reserved.
//

import Foundation


//                 /\r[\n\u0085]|[\u2424\u2028\u0085]/g;
//var NULL_RE      = /\u0000/g;

/// In Stylo we accept carriage return and any other line ending 
/// characters coming from other encoding mecanisme because we want to 
/// keep the indexes in concordance with the source while parsing. 
/// When outputing to HTML though, there will be a "sanitize" rule
/// which will replaces those characters for the simpler line feed.
/// In consequence those lines of code from the original are removed:
///
/// var NEWLINES_RE  = /\r[\n\u0085]|[\u2424\u2028\u0085]/g;
/// it is handled in isPossibleNewLineStartCodePoint(...) method in utils.
/// // Normalize newlines
/// str = state.src.replace(NEWLINES_RE, '\n');
///
func normalize(_ state: StateCore) {
    
    // Replace NULL characters
    state.src = state.src.replacingOccurrences(of: "u{0000}", with: "u{FFFD}")
}
