//
//  IssuesReporterTableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2016-01-15.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import Foundation
import StyloCoreMac

final class IssuesReporterTableView: ClickableRowTableView {
    
    var isInLiveResize: Bool = false
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        
        intercellSpacing = NSMakeSize(0, 0)
        
        super.awakeFromNib()
    }
 
    override func viewWillStartLiveResize() {
        
        isInLiveResize = true
        
        super.viewWillStartLiveResize()
    }
    
    override func viewDidEndLiveResize() {
        
        isInLiveResize = false
        
        super.viewDidEndLiveResize()
    }
}
