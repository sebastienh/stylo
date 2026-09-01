//
//  ExceptionCode.swift
//  ParseUtils
//
//  Created by Sébastien Hamel on 2015-01-20.
//  Copyright (c) 2015 CM. All rights reserved.
//

import Foundation

// http://www.w3.org/TR/dom/#domerror
public enum ExceptionCode {
    
    // default no error case
    case noError
    
    // Legacy : INDEX_SIZE_ERR (1)
    case indexSizeError             // The index is not in the allowed range.
    
    // Legacy : HIERARCHY_REQUEST_ERR (3)
    case hierarchyRequestError      // The operation would yield an incorrect node tree.
    
    // Legacy : WRONG_DOCUMENT_ERR (4)
    case wrongDocumentError         // The object is in the wrong document.
    
    // Legacy : INVALID_CHARACTER_ERR (5)
    case invalidCharacterError      // The string contains invalid characters.
    
    // Legacy : NO_MODIFICATION_ALLOWED_ERR (7)
    case noModificationAllowedError	// The object can not be modified.
    
    // Legacy : NOT_FOUND_ERR (8)
    case notFoundError              // The object can not be found here.
    
    // Legacy : NOT_SUPPORTED_ERR (9)
    case notSupportedError          // The operation is not supported.
    
    // Legacy : INVALID_STATE_ERR (11)
    case invalidStateError          // The object is in an invalid state.
    
    // Legacy : SYNTAX_ERR (12)
    case syntaxError                // The string did not match the expected pattern.
    
    // Legacy : INVALID_MODIFICATION_ERR (13)
    case invalidModificationError   // The object can not be modified in this way.
    
    // Legacy : NAMESPACE_ERR (14)
    case namespaceError             // The operation is not allowed by Namespaces in XML. [XMLNS]
    
    // Legacy : INVALID_ACCESS_ERR (15)
    case invalidAccessError         // The object does not support the operation or argument.
    
    // Legacy : SECURITY_ERR (18)
    case securityError              // The operation is insecure.
    
    // Legacy : NETWORK_ERR (19)
    case networkError               // A network error occurred.
    
    // Legacy : ABORT_ERR (20)
    case abortError                 // The operation was aborted.
    
    // Legacy : URL_MISMATCH_ERR (21)
    case urlMismatchError           // The given URL does not match another URL.
    
    // Legacy : QUOTA_EXCEEDED_ERR (22)
    case quotaExceededError         // The quota has been exceeded.
    
    // Legacy : TIMEOUT_ERR (23)
    case timeoutError               // The operation timed out.
    
    // Legacy : INVALID_NODE_TYPE_ERR (24)
    case invalidNodeTypeError       // The supplied node is incorrect or has an incorrect ancestor for this operation.
    
    // Legacy : DATA_CLONE_ERR (25)
    case dataCloneError             // The object can not be cloned.
    
    // Legacy : None
    case encodingError              // The encoding operation (either encoded or decoding) failed.
    
    // Legacy : None
    case notReadableError           // The I/O read operation failed.
    
    // Note: This error is missing in the standard
    case inUseAttributeError
    
}
