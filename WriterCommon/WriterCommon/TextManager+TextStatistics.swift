//
//  TextManager+TextStatistics.swift
//  WriterCommon-mac
//
//  Created by Sebastien hamel on 2018-11-18.
//  Copyright © 2018 Textually Inc. All rights reserved.
//

import Foundation
import PromiseKit
import Common
import Igloo
import os

extension TextManager {
    
    public func updateStatistics() -> Promise<Void> {

        let action = StatisticsAction.updateStatistics

        return Promise<Void> { fulfill, reject in

            firstly {
                self.dispatcher.async(store: self.markdownDocumentStore, action: action.asyncAction)
            }.then { _ in
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error in updateStatistics(): %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                assert(false)
                reject(error)
            }
        }
    }

    
    
    
    public func startWritingSession() -> Promise<Void> {

        return Promise<Void> { fulfill, reject in

            let action = StatisticsAction.startWritingSession
            firstly {
                self.dispatcher.async(store: self.markdownDocumentStore, action: action.asyncAction)
            }.then {_ in
                self.updateStatistics()
            }.then { () -> Void in
                self.showWritingSession()
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error in startWritingSession(): %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                assert(false)
            }
        }
    }

    @discardableResult
    public func showWritingSession() -> Promise<Void> {

        return Promise<Void> { fulfill, reject in

            firstly { () -> Promise<ActionResult?> in
                let action = StatisticsAction.show
                return self.dispatcher.async(store: self.markdownDocumentStore, action: action.asyncAction)
            }.then {_ -> Void in
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error in showWritingSession(): %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                assert(false)
                reject(error)
            }
        }
    }

    public func hideWritingSession() -> Promise<Void> {

        return Promise<Void> { fulfill, reject in

            firstly { () -> Promise<ActionResult?> in
                let action = StatisticsAction.hide
                return self.dispatcher.async(store: self.markdownDocumentStore, action: action.asyncAction)
            }.then { _ -> Void in
                fulfill(())
            }.catch { error in
                #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
                os_log("Error in hideWritingSession(): %@", log: Log.WriterCommon.all, type: .error, %%error)
                #endif
                assert(false)
                reject(error)
            }
        }
    }

}
