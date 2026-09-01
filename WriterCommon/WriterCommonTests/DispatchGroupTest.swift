//
//  DispatchGroupTest.swift
//  WriterCommon
//
//  Created by Sébastien Hamel on 2016-10-29.
//  Copyright © 2016 Textually Inc. All rights reserved.
//

import XCTest
@testable import WriterCommon

class DispatchGroupTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDispatchGroup() {
        
        let group = DispatchGroup()
        let backgroundQueue = DispatchQueue(label: "backgroundQueue",  attributes: .concurrent)
        
        backgroundQueue.async(group: group, qos: .background, flags: .enforceQoS, execute: {
            
            
            var fill = [Int]()
            
            for item in 0...10000 {
                
                if item > 50 {
                    fill.append(item)
                }
            }
            
            print("finished work")
        })
        
        group.notify(queue: backgroundQueue) {
            
            print("started work on item 1")
            
            var fill = [Int]()
            
            for item in 0...10000 {
                
                if item > 50 {
                    fill.append(item)
                }
            }
            
            print("finished work on item 1")
        }
        
        group.notify(queue: backgroundQueue) {
            
            print("started work on item 2")
        }
    }
}
