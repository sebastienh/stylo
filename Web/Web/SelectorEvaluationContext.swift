//
//  SelectorEvaluationContext.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-24.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

//struct SelectorEvaluationContext {
//    
//    let options: SelectionFilterOptions?
//    
//    let scopingMethod: ScopingMethod?
//    
//    let stylesheet: CSSStyleSheet?
//    
//    let filterContext: FilterContext?
//    
//    static func ==(lhs: SelectorEvaluationContext, rhs: SelectorEvaluationContext) -> Bool {
//        
//        if lhs.filterContext != rhs.filterContext {
//            return false
//        }
//        if lhs.options != rhs.options {
//            return false
//        }
//        if lhs.scopingMethod != rhs.scopingMethod {
//            return false
//        }
//        if lhs.stylesheet !== rhs.stylesheet {
//            return false
//        }
//        return true
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(self.filterContext)
//        hasher.combine(self.options)
//        hasher.combine(self.scopingMethod)
//        hasher.combine(self.scopingMethod)
//        let stylesheetIdentifier: ObjectIdentifier? = {
//            if let stylesheet = self.stylesheet {
//                return ObjectIdentifier(stylesheet)
//            }
//            return nil
//        }()
//        hasher.combine(stylesheetIdentifier)
//    }
//    
//}
