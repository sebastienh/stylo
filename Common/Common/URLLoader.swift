//
//  URLLoader.swift
//  Common
//
//  Created by Sébastien Hamel on 2015-04-01.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation

public final class URLLoader {

    /// Singleton instance.
    public static var shared = URLLoader()
    
    fileprivate init() {
        
    }
    
    @discardableResult
    public func loadStringContentFromURL(_ stringUrl: String, externalCompletionHandler: ((String?, NSError?) -> Void)? ) -> NSError? {

        var localError: NSError?
        
        let url = stringUrl.contructURL()
        
        if let url = url {
        
            if url.scheme == "https" {
             
                // FIXME: better error
                localError = NSError(domain: NSStyloErrorDomain, code: 5, userInfo: nil)

                if let externalCompletionHandler = externalCompletionHandler {
                    
                    externalCompletionHandler(nil, localError)
                }
                
                return localError
            }
            
//            let session = NSURLSession.sharedSession()
            
//            let task = session.dataTaskWithURL(url: url, completionHandler: { (data: NSData?, response: NSURLResponse!, error: NSError!) -> Void in
//            
//                if error != nil {
//                    // If there is an error in the web request, print it to the console
//                    // (error.localizedDescription)
//                    
//                    localError = error
//                }
//                
//                var stringContent: String?
//                
//                let encodingName: String? = response.textEncodingName
//                
//                if let encodingName = encodingName {
//                    
//                    let encoding = CFStringConvertIANACharSetNameToEncoding(encodingName)
//                    
//                    let encodingType = CFStringConvertEncodingToNSStringEncoding(encoding)
//                
//                    stringContent = (NSString(data: data, encoding: encodingType) as! String)
//                }
//                // default to UTF-8
//                else {
//                
//                    stringContent = (NSString(data: data, encoding: NSUTF8StringEncoding) as! String)
//                }
//                
//                if let externalCompletionHandler = externalCompletionHandler {
//                    
//                    externalCompletionHandler(stringContent, nil)
//                }
//            })
//        
//            task.resume()
        }
        
        return nil
    }
}
