////
////  MarkdownDocumentReducer+HtmlPreviewableReducerType.swift
////  WriterCommon-mac
////
////  Created by Sébastien Hamel on 2018-02-10.
////  Copyright © 2018 Textually Inc. All rights reserved.
////
//
//import Foundation
//import Igloo
//import PromiseKit
//import Common
//
//extension MarkdownDocumentReducer: HtmlPreviewableReducerType {
//    
//    func handleHtmlPreviewableStoreAction<S: Store & HtmlPreviewableStoreType>(store: S, action: HtmlPreviewableStoreAction) -> Promise<ActionResult?> {
//        
//        return Promise<ActionResult?> { fulfill, reject in
//        
//            switch action {
//                
//            case .changeHtmlPreviewVisibility(let visible):
//                
//                store.htmlPreviewVisible.setValue(visible)
//                
//                // if set to visible then we need to update the
//                // html preview string
//                if visible && store.domDocument.value == nil {
//
//                    firstly { () -> Promise<Void> in
//                        // in the case here it will always update
//                        updateHtmlPreview(store: store, deletedNodes: nil, documentFragment: nil)
//                    }.then {
//                        //                                return Promise<Void> { fulfill, reject in
//                        //                                    markdownDocumentStore.htmlPreviewVisible.setValue(true)
//                        //                                    fulfill(())
//                        //                                }
//                        //                            }.then {
//                        fulfill(nil)
//                    }.catch { error in
//                        debugPrint("Error in promise: \(error)")
//                        reject(error)
//                    }
//                }
//                else {
//                    fulfill(nil)
//                }
//                
//            case .applyHtmlStyle(let style):
//                
//                store.htmlPreviewStyle.setValue(style)
//                
//                firstly {
//                    self.updateHtmlPreviewBackgroundColor(store: store, style: style)
//                }.then { () -> Void in
//                    fulfill(nil)
//                }.catch { error in
//                    debugPrint("Error in promise: \(error)")
//                    reject(error)
//                }
//                
//            case .updateHtmlSerializedString(let forced):
//                
//                firstly {
//                    self.updateHtmlString(store: store, forceUpdate: forced)
//                }.then { result in
//                    fulfill(result)
//                }.catch { error in
//                    reject(error)
//                }
//                
//            case .firstElementInRange(_):
//                
//                reject(NWError.custom(message: "firstElementInRange should be sync action"))
//                
//            case .firstVisibleElementIndex(let range):
//                
//                reject(NWError.custom(message: "firstVisibleElementIndex should be sync action"))
//            }
//        }
//    }
//}
