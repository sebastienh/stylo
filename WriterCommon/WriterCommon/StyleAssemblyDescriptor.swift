//
//  StyleAssemblyDescriptor.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-04-08.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation
import Web

public struct StyleAssemblyDescriptor: Equatable, Hashable {

    public let appearance: AppearanceMode
    
    public let traits: [StyleTrait]

    var isLight: Bool {
        switch self.appearance {
        case .light:
            return true
        case .dark:
            return false
        }
    }
    
    var isDark: Bool {
        switch self.appearance {
        case .light:
            return false
        case .dark:
            return true
        }
    }
    
    let key: StyleAssemblyDescriptorKey
    
    static func from(_ key: StyleAssemblyDescriptorKey) -> StyleAssemblyDescriptor? {
        
        let values = key.split(separator: "-")
        
        guard let appearanceKey = values.first else {
            assertionFailure("Error: appearanceKey is nil")
            return nil
        }
        
        guard let appearanceMode = AppearanceMode(rawValue: String(appearanceKey)) else {
            assertionFailure("Error: appearanceMode is nil for key: \(appearanceKey)")
            return nil
        }
        
        var traits: [StyleTrait] = []
        
        for i in 1..<values.count {
            let traitKey = values[i]
            guard let styleTrait = StyleTrait.from(key: String(traitKey)) else {
                assertionFailure("Error: styleTrait is nil from key \(traitKey)")
                continue
            }
            traits.append(styleTrait)
        }
        
        return StyleAssemblyDescriptor(appearance: appearanceMode, traits: traits)
    }
    
    public init(appearance: AppearanceMode, traits: [StyleTrait] = []) {
        
        func traitsKeyString(fromTraits traits: [StyleTrait]) -> String {
            return traits.sorted().reduce("") { (prev, trait) -> String in
                var dash: String = ""
                if !prev.isEmpty {
                    dash = "-"
                }
                return prev + dash + trait.key
            }
        }
        
        self.appearance = appearance
        self.traits = traits
        var key = "\(appearance)"
        let traitsKey = traitsKeyString(fromTraits: traits)
        if !traitsKey.isEmpty {
            key += "-\(traitsKey)"
        }
        self.key = key
    }
    
    func same(forAppearance appearance: AppearanceMode) -> StyleAssemblyDescriptor {
    
        return StyleAssemblyDescriptor(appearance: appearance, traits: self.traits)
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.key)
    }
}
