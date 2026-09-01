//
//  MacNodioDocument.swift
//  Stylo
//
//  Created by Sebastien hamel on 2019-09-18.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Foundation
import WriterCommon
import PromiseKit
import Common
import StyloCoreMac

class MacNodioDocument: MacStyloDocument {
    
    override var _topToolsButtons: [DisableableButton]? {
        return []
    }

    deinit {
        
    }
}

