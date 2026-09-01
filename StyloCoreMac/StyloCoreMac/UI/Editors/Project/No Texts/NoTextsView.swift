//
//  NoTextsView.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-02-21.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Cocoa

class NoTextsView: ColoredView {
    
    private var projectTextEditorsList: ProjectTextEditorsList? {
        
        var responder = self.nextResponder
        while responder != nil {
            if let projectTextEditorsList = responder as? ProjectTextEditorsList {
                return projectTextEditorsList
            }
            responder = responder?.nextResponder
        }
        return nil
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        assert(self.projectTextEditorsList != nil)
        projectTextEditorsList?.selectedCurrentFilesOutlineManager()
        projectTextEditorsList?.updateLastEdited(toTextId: nil)
    }
}

