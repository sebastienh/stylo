//
//  Pool.swift
//  Common
//
//  Created by Sébastien Hamel on 2016-09-04.
//  Copyright © 2016 NM. All rights reserved.
//

import Foundation


//open class Pool<T: Poolable> {
//    
//    var objects: ContiguousArray<T>
//    var freeObjects: ContiguousArray<T>
//    
//    var size: Int
//    
//    public init(size: Int) {
//        
//        self.size = size
//        self.objects = ContiguousArray<T>()
//        self.freeObjects = ContiguousArray<T>()
//        populateObjects(size)
//    }
//    
//    open func getObject() -> UnsafeMutablePointer<T> {
//        
//        if freeObjects.count == 0 {
//            
//            size = size * 2
//            populateObjects(size)
//        }
//        
//        let instance = freeObjects.removeLast()
//        let opaque = Unmanaged.passUnretained(instance).toOpaque()
//        return UnsafeMutablePointer<T>(opaque)
//    }
//    
//    /// see http://stackoverflow.com/questions/33294620/how-to-cast-self-to-unsafemutablepointervoid-type-in-swift
//    /// see http://sketchytech.blogspot.ca/2014/08/unsafe-pointers-in-swift-conversion-to.html
//    func bridge<T : AnyObject>(_ obj : T) -> UnsafeRawPointer {
//        return UnsafePointer(Unmanaged.passUnretained(obj).toOpaque())
//        // return unsafeAddressOf(obj) // ***
//    }
//    
////    func bridge<T : AnyObject>(obj : T) -> UnsafePointer<Void> {
////        return UnsafePointer(Unmanaged.passUnretained(obj).toOpaque())
////        // return unsafeAddressOf(obj) // ***
////    }
//    
//    open func returnObject(_ object: T) {
//        
//        freeObjects.append(object)
//    }
//    
//    fileprivate func populateObjects(_ number: Int) {
//        
//        objects.reserveCapacity(size)
//        
//        for _ in 0..<number {
//            
//            let object = T()
//            objects.append(object)
//            freeObjects.append(object)
//        }
//    }
//    
//}
