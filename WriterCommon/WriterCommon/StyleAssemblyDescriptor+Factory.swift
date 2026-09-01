//
//  StyleAssemblyDescriptor+Factories.swift
//  WriterCommon-mac
//
//  Created by Sebastien Hamel on 2020-05-07.
//  Copyright © 2020 Textually Inc. All rights reserved.
//

import Foundation

extension StyleAssemblyDescriptor {

    public static var textLightStyleAssemblyDescriptor: StyleAssemblyDescriptor {
        return StyleAssemblyDescriptor(appearance: .light)
    }

    public static var textDarkStyleAssemblyDescriptor: StyleAssemblyDescriptor {
        return StyleAssemblyDescriptor(appearance: .dark)
    }
    
    static public var cssLightStyleAssemblyDescriptor: StyleAssemblyDescriptor {
        return StyleAssemblyDescriptor(appearance: .light, traits: [.source])
    }

    static public var cssDarkStyleAssemblyDescriptor: StyleAssemblyDescriptor {
        return StyleAssemblyDescriptor(appearance: .dark, traits: [.source])
    }
    
}
