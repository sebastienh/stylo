//
//  Collection+Positionnable+CloseElementsIndexesTests.swift
//  Common
//
//  Created by Sébastien Hamel on 2018-06-06.
//  Copyright © 2018 NM. All rights reserved.
//

import XCTest
@testable import Common

fileprivate struct Element: Positionnable {
    
    var sourceStringFragment: SourceStringFragment?
    
    init(sourceStringFragment: SourceStringFragment?) {
        
        self.sourceStringFragment = sourceStringFragment
    }
}

class Collection_Positionnable_CloseElementsIndexesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCloseElementsIndexesStart1() {
        
        let collection = buildBasicCollection()
        let range = NSMakeRange(0,0)
        let closeIndexes = collection.adjacencies(from: range)
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .start:
                break
            default:
                XCTAssert(false, "Expected .start, received: \(closeIndexes)")
            }
        }
    }

    func testCloseElementsIndexesStart2() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(0,4))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .start:
                break
            default:
                XCTAssert(false, "Expected .start, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesStart3() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(4,0))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .start:
                break
            default:
                XCTAssert(false, "Expected .start, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesStart4() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(1,3))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .start:
                break
            default:
                XCTAssert(false, "Expected .start, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering1() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(0,5))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [0])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering2() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(0,60))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [0,1,2])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering3() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(4,26))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [0,1])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering4() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(4,10))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [0])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering5() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(16,10))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [1])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering6() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(40,10))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [2])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering7() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(16,40))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [1,2])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering8() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(18,22))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [1])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering9() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(18,23))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [1,2])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering10() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(25,15))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [1])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesCovering11() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(38,15))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .covering(let indexes):
                XCTAssert(indexes == [2])
            default:
                XCTAssert(false, "Expected .covering, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesBetween1() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(14,1))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .between(let low, let up):
                XCTAssert(low == 0)
                XCTAssert(up == 1)
            default:
                XCTAssert(false, "Expected .between, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesBetween2() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(14,2))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .between(let low, let up):
                XCTAssert(low == 0)
                XCTAssert(up == 1)
            default:
                XCTAssert(false, "Expected .between, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesBetween3() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(26,2))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .between(let low, let up):
                XCTAssert(low == 1)
                XCTAssert(up == 2)
            default:
                XCTAssert(false, "Expected .between, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesBetween4() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(26,14))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .between(let low, let up):
                XCTAssert(low == 1)
                XCTAssert(up == 2)
            default:
                XCTAssert(false, "Expected .between, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesExclusivelyInside1() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(4,1))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .exclusivelyInside(let index):
                XCTAssert(index == 0)
            default:
                XCTAssert(false, "Expected .exclusivelyInside, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesExclusivelyInside2() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(4,9))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .exclusivelyInside(let index):
                XCTAssert(index == 0)
            default:
                XCTAssert(false, "Expected .exclusivelyInside, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesExclusivelyInside3() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(5,8))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .exclusivelyInside(let index):
                XCTAssert(index == 0)
            default:
                XCTAssert(false, "Expected .exclusivelyInside, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesExclusivelyInside4() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(16,8))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .exclusivelyInside(let index):
                XCTAssert(index == 1)
            default:
                XCTAssert(false, "Expected .exclusivelyInside, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesExclusivelyInside5() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(40,8))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .exclusivelyInside(let index):
                XCTAssert(index == 2)
            default:
                XCTAssert(false, "Expected .exclusivelyInside, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesEnd1() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(50,0))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .end:
                break
            default:
                XCTAssert(false, "Expected .end, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesEnd2() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(50,10))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .end:
                break
            default:
                XCTAssert(false, "Expected .end, received: \(closeIndexes)")
            }
        }
    }
    
    func testCloseElementsIndexesEnd3() {
        
        let collection = buildBasicCollection()
        let closeIndexes = collection.adjacencies(from: NSMakeRange(52,10))
        
        XCTAssert(closeIndexes != nil)
        if let closeIndexes = closeIndexes {
            
            switch closeIndexes {
            case .end:
                break
            default:
                XCTAssert(false, "Expected .end, received: \(closeIndexes)")
            }
        }
    }
    
    private func buildBasicCollection() -> [Element] {
        
        let element1 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(4, 10)))
        let element2 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(16, 10)))
        let element3 = Element(sourceStringFragment: SourceStringSegment(range: NSMakeRange(40, 10)))
        return [element1, element2, element3]
    }
    
}
