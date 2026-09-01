//
//  DisappearableView.swift
//  Stylo Writer
//
//  Created by Sébastien Hamel on 2017-02-17.
//  Copyright © 2017 Textually Inc. All rights reserved.
//

import Foundation
import Cocoa

protocol DisappearableView: class {
    
    var visibleBackgroundColor: CGColor? { get set }
    
    var appearAnimation: CABasicAnimation { get }
    
    var appearAnimationCompletionBlock: () -> Void { get }
    
    var disappearAnimation: CABasicAnimation { get }
    
    var disappearAnimationCompletionBlock: () -> Void { get }
    
    func addDisappearAnimation()
    
    func addAppearAnimation()
}

extension DisappearableView where Self: NSView {
    
    var appearAnimation: CABasicAnimation {
        
        // CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        let anime = CABasicAnimation(keyPath: "isHidden")
        
        // anime.fromValue = (id)[layer backgroundColor];
        anime.fromValue = true
        
        // anime.toValue = (id)CGColorCreateGenericGray(0.0f, 1.0f);
        anime.toValue = false
        
        return anime
    }
    
    var appearAnimationCompletionBlock: () -> Void {
    
        return { () in
            
            self.isHidden = false
        }
    }
    
    func addAppearAnimation() {
        
        layer!.add(appearAnimation, forKey:"isHidden")
    }
    
    var disappearAnimation: CABasicAnimation {
        
        // CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        let anime = CABasicAnimation(keyPath: "isHidden")
        
        // anime.fromValue = (id)[layer backgroundColor];
        anime.fromValue = false
        
        // anime.toValue = (id)CGColorCreateGenericGray(0.0f, 1.0f);
        anime.toValue = true
        
        return anime
    }
    
    var disappearAnimationCompletionBlock: () -> Void {
        
        return { () in
            
            self.isHidden = true
        }
    }
    
    func addDisappearAnimation() {
        
        layer!.add(disappearAnimation, forKey:"isHidden")
    }
}

extension DisappearableView where Self: NSButton {
    
    var appearAnimation: CABasicAnimation {
        
        // CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        let anime = CABasicAnimation(keyPath: "isHidden")
        
        anime.fromValue = self.isHidden
        
        // anime.toValue = (id)CGColorCreateGenericGray(0.0f, 1.0f);
        anime.toValue = false
        
        return anime
    }
    
    var appearAnimationCompletionBlock: () -> Void {
        
        return { () in
            
            self.isHidden = false
        }
    }
    
    func addAppearAnimation() {
        
        layer!.add(appearAnimation, forKey:"isHidden")
    }
    
    var disappearAnimation: CABasicAnimation {
        
        // CABasicAnimation *anime = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        let anime = CABasicAnimation(keyPath: "isHidden")
        
        anime.fromValue = self.isHidden
        
        // anime.toValue = (id)CGColorCreateGenericGray(0.0f, 1.0f);
        anime.toValue = true
        
        return anime
    }
    
    var disappearAnimationCompletionBlock: () -> Void {
        
        return { () in
            
            self.isHidden = true
        }
    }
    
    func addDisappearAnimation() {
        
        layer!.add(disappearAnimation, forKey:"isHidden")
    }
}
