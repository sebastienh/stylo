//
//  AppearanceFollowerButton.swift
//  Stylo
//
//  Created by Sebastien Hamel on 2019-12-23.
//  Copyright © 2019 Textually Inc. All rights reserved.
//

import Cocoa
import WriterCommon

public class AppearanceFollowerButton: MacDisableableButton {
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.listenToAppearanceChange()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.listenToAppearanceChange()
    }
    
    private func listenToAppearanceChange() {
        assert(StyloApplication.shared.computedAppearance.value?.appearance != nil)
        self.appearance = StyloApplication.shared.computedAppearance.value?.appearance ?? AppearanceMode.dark.appearance
        StyloApplication.shared.computedAppearance.subscribe({ [weak self](appearanceMode) in
            assert(appearanceMode != nil)
            self?.appearance = appearanceMode?.appearance ?? AppearanceMode.dark.appearance
        }, observer: self)
    }
    
    deinit {
        
        StyloApplication.shared.computedAppearance.unsubscribe(observer: self)
    }
    
}
