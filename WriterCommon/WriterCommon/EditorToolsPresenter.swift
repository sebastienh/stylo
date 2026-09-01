//
//  EditorToolsPresenter.swift
//  WriterCommon-mac
//
//  Created by Sébastien Hamel on 2018-08-11.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation

public protocol EditorToolsPresenter {
    
    var presentingDom: Int { get set }
    var presentingErrors: Int { get set }
    var presentingHelp: Int { get set }
    
}
