//
//  CustomPropertyCycleDetectionTests.swift
//  Web
//
//  Created by Sebastien Hamel on 2020-08-13.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import XCTest
@testable import Web

class CustomPropertyCycleDetectionTests: TestCascading {
    
    func testCycleDetectionDisjointDependencies2() {
         
         let stylingSourceString = """
                 :root {
                     --1: var(--2);
                     --2: var(--3);
                    --3: var(--1);
                    --4: blue;
                     --5: var(--1);
                      --6: var(--3);
                    --7: var(--other);
                    --8: var(--7, var(--1));
                 }
             """;
         
         if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
             
             let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
             XCTAssert(_styleRule != nil)
             
             guard let styleRule = _styleRule else {
                 return
             }
             
             let _style = styleRule.style
             XCTAssert(_style != nil)
             
             guard let style = _style else {
                 return
             }
             
             XCTAssert(style.propertyStyleDeclarations.count == 8)
             
             for (name, declaration) in style.propertyStyleDeclarations {
                 style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
             }
             
             let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
             XCTAssert(_dependencyGraph != nil)
             
             guard let dependencyGraph = _dependencyGraph else {
                 return
             }
             
             XCTAssert(dependencyGraph.count == 8)
             
             let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
             
             XCTAssert(inCycle.count == 6, "Received: \(inCycle.count)")
             XCTAssert(outCycle.count == 2, "Received: \(outCycle.count)")
             
         }
         else {
             
             XCTAssert(false, "stylingCssStyleSheet is nil")
         }
     }
    
    func testCycleDetectionDisjointDependencies1() {
        
        let stylingSourceString = """
                :root {
                    --1: var(--2);
                    --2: var(--3);
                   --3: var(--1);
                   --4: blue;
                    --5: var(--1);
                     --6: var(--3);
                }
            """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            XCTAssert(style.propertyStyleDeclarations.count == 6)
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 6)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 5, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 1, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    func testCycleDetectionInDefaultValue() {
        
        let stylingSourceString = """
               :root {
                   --1: var(--2, var(--5));
                   --2: var(--3);
                  --3: var(--1);
                  --4: blue;
                    --5: var(--3);
               }
           """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 5)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 4, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 1, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    func testCycleDetectionOneCycleOneNodeOutside() {
        
        let stylingSourceString = """
              :root {
                  --1: var(--2);
                  --2: var(--3);
                 --3: var(--1);
                 --4: blue;
              }
          """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 4)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 3, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 1, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    func testCycleDetectionOneCycleNoCycle() {
        
        let stylingSourceString = """
              :root {
                  --1: var(--2);
                  --2: var(--3);
                 --3: var(--1, var(--4));
                 --4: var(--5);
                --5: blue;
              }
          """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph["--1"]!.dependencies.contains(dependencyGraph["--2"]!))
            XCTAssert(dependencyGraph["--2"]!.dependencies.contains(dependencyGraph["--3"]!))
            XCTAssert(dependencyGraph["--3"]!.dependencies.contains(dependencyGraph["--1"]!))
            XCTAssert(dependencyGraph["--3"]!.dependencies.contains(dependencyGraph["--4"]!))
            XCTAssert(dependencyGraph["--4"]!.dependencies.contains(dependencyGraph["--5"]!))
            XCTAssert(dependencyGraph["--5"]!.dependencies.isEmpty)
            
            XCTAssert(dependencyGraph.count == 5)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 3, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 2, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    func testCycleDetectionOneLoop() {
        
        let stylingSourceString = """
              :root {
                  --custom-1: var(--other-2);
                  --other-2: var(--custom-3);
                 --custom-3: var(--custom-1);
                 --other-4: var(--custom-3);
              }
          """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 4)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 4, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 0, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    func testTwoCycleDetection() {
        
        let stylingSourceString = """
             :root {
                 --custom-1: var(--other-1);
                 --other-1: var(--custom-1);
                --custom-2: var(--other-2);
                --other-2: var(--custom-2);
             }
         """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 4)
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 4, "Received: \(inCycle.count)")
            XCTAssert(outCycle.count == 0, "Received: \(outCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    
    func testOneCycleDetection() {
        
        let stylingSourceString = """
            :root {
                --custom-property-x: var(--other-property);
                --other-property: var(--custom-property-x);
            }
        """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 2)
            XCTAssert(dependencyGraph["--custom-property-x"] != nil)
            XCTAssert(dependencyGraph["--custom-property-x"]?.dependencies.count == 1)
            XCTAssert(dependencyGraph["--custom-property-x"]?.dependencies.first?.name == "--other-property")
            XCTAssert(dependencyGraph["--other-property"] != nil)
            XCTAssert(dependencyGraph["--other-property"]?.dependencies.count == 1)
            XCTAssert(dependencyGraph["--other-property"]?.dependencies.first?.name == "--custom-property-x")
            
            let (inCycle, outCycle) = style.customPropertiesInsideOutsideCycles(fromdirectedDependencyGraph: dependencyGraph)
            
            XCTAssert(inCycle.count == 2, "Received: \(inCycle.count)")
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    func testOneCycle() {
        
        let stylingSourceString = """
            :root {
                --custom-property-x: var(--other-property);
                --other-property: var(--custom-property-x);
            }
        """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 2)
            XCTAssert(dependencyGraph["--custom-property-x"] != nil)
            XCTAssert(dependencyGraph["--custom-property-x"]?.dependencies.count == 1)
            XCTAssert(dependencyGraph["--custom-property-x"]?.dependencies.first?.name == "--other-property")
            XCTAssert(dependencyGraph["--other-property"] != nil)
            XCTAssert(dependencyGraph["--other-property"]?.dependencies.count == 1)
            XCTAssert(dependencyGraph["--other-property"]?.dependencies.first?.name == "--custom-property-x")
            
            
            
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
    
    func testNoCycle() {
        
        let stylingSourceString = """
            :root {
                --custom-property-x: var(--other-level-property);
            }
        """;
        
        if let styleSheet = getStylingCSSStyleSheet(sourceString: stylingSourceString as NSString) {
            
            let _styleRule = styleSheet.cssRules.first as? CSSStyleRule
            XCTAssert(_styleRule != nil)
            
            guard let styleRule = _styleRule else {
                return
            }
            
            let _style = styleRule.style
            XCTAssert(_style != nil)
            
            guard let style = _style else {
                return
            }
            
            for (name, declaration) in style.propertyStyleDeclarations {
                style.propertyValues[name] = CSSPropertyValueContainer.customValue(declaration)
            }
            
            let _dependencyGraph = style.localPropertiesDirectedDependencyGraph
            XCTAssert(_dependencyGraph != nil)
            
            guard let dependencyGraph = _dependencyGraph else {
                return
            }
            
            XCTAssert(dependencyGraph.count == 1)
            XCTAssert(dependencyGraph["--custom-property-x"] != nil)
            XCTAssert(dependencyGraph["--custom-property-x"]?.dependencies.isEmpty == true)
        }
        else {
            
            XCTAssert(false, "stylingCssStyleSheet is nil")
        }
    }
    
}
