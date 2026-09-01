//
//  ProjectTextEditorsTableViewController+Scrolling.swift
//  StyloCoreMac
//
//  Created by Sebastien Hamel on 2020-05-24.
//  Copyright © 2020 Sebastien hamel. All rights reserved.
//

import Foundation
import WriterCommon
import Common
import os

extension ProjectTextEditorsTableViewController {
    
    ///
    /// Method to convert the file outline position to a valid
    /// point in the current scroll view.
    ///
    func scrollPoint(forFilesOutlinePosition filesOutlinePosition: FilesOutlinePosition) -> NSPoint? {
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPoint(forFilesOutlinePosition: %@)", log: Log.StyloCore.all, type: .info, %%filesOutlinePosition)
        #endif
        
        guard let projectTextEditorView = self.textEditor(forTextId: filesOutlinePosition.textId) else {
            assertionFailure("Error: projectTextEditorView is nil")
            return nil
        }
        
        guard projectTextEditorView.frame != .zero else {
            assertionFailure("Error: projectTextEditorView.frame is zero")
            return nil
        }
        
        guard let rect = projectTextEditorView.wordRect(in: filesOutlinePosition.range) else {
            assertionFailure("Error: rect is nil")
            return nil
        }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPoint:forFilesOutlinePosition -> rect: %@)", log: Log.StyloCore.all, type: .info, %%rect)
        #endif
        
        guard rect.minY >= 0 else {
            assertionFailure("Error: trying to scroll to a negative position: \(rect.minY)")
            return nil
        }
        
        let tableViewRect = self.projectTextEditorsTableView.convert(rect, from: projectTextEditorView)
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("scrollPoint:forFilesOutlinePosition -> tableViewRect: %@)", log: Log.StyloCore.all, type: .info, %%tableViewRect)
        #endif
        
        guard tableViewRect.minY >= 0 else {
             assertionFailure("Error: trying to scroll to a negative position: \(tableViewRect.minY)")
             return nil
         }
        
        #if (os(macOS) || os(iOS) || os(tvOS) || os(watchOS)) && DEBUG && DEBUG_LOGS_ENABLED
        os_log("converted files outline position with rect: %@ to %@", log: Log.StyloCore.all, type: .info, %%rect, %%tableViewRect)
        #endif
        
        return NSMakePoint(0, tableViewRect.maxY)
    }
}
