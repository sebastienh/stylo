//
//  StylableReducerType+Loading.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2017-10-06.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Igloo

extension EditableReducerType {

    func load(url: URL) -> Promise<String> {
        
        return Promise<String> { fulfill, reject in
            
            do {
                let contents = try String(contentsOf: url)
                fulfill(contents)
            }
            catch {
                let error = NWError.unableToLoad(url: url)
                debugPrint("Error: \(error)")
                reject(error)
            }
        }
    }
}
