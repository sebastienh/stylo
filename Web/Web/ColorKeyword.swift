//
//  ColorKeyword.swift
//  Web
//
//  Created by Sébastien Hamel on 2015-03-17.
//  Copyright (c) 2015 NM. All rights reserved.
//

import Foundation
import Common
import CoreImage

public enum ColorKeyword : String {
    
    case black = "black"                    // [0,0,0,1]
    case blanchedalmond  = "blanchedalmond"  // [255,235,205,1]
    case transparent = "transparent"        // [0,0,0,0]
    case aliceblue = "aliceblue" // [240,248,255,1]
    case antiquewhite = "antiquewhite" // [250,235,215,1]
    case aqua = "aqua" // [0,255,255,1]
    case aquamarine = "aquamarine" // [127,255,212,1]
    case azure = "azure" // [240,255,255,1]
    case beige = "beige" // [245,245,220,1]
    case bisque = "bisque" // [255,228,196,1]
    case blue = "blue" // [0,0,255,1]
    case blueviolet = "blueviolet" // [138,43,226,1]
    case brown = "brown" // [165,42,42,1]
    case burlywood = "burlywood" // [222,184,135,1
    case cadetblue = "cadetblue" // [95,158,160,1]
    case chartreuse = "chartreuse" // [127,255,0,1]
    case chocolate = "chocolate" // [210,105,30,1]
    case coral = "coral" // [255,127,80,1]
    case cornflowerblue = "cornflowerblue" // [100,149,237,1]
    case cornsilk = "cornsilk" // [255,248,220,1]
    case crimson = "crimson" // [220,20,60,1]
    case cyan = "cyan" // [0,255,255,1]
    case darkblue = "darkblue" // [0,0,139,1]
    case darkcyan = "darkcyan" // [0,139,139,1]
    case darkgoldenrod = "darkgoldenrod" // [184,134,11,1]
    case darkgray = "darkgray" // [169,169,169,1]
    case darkgreen = "darkgreen" // [0,100,0,1]
    case darkgrey = "darkgrey" // [169,169,169,1]
    case darkkhaki = "darkkhaki" // [189,183,107,1]
    case darkmagenta = "darkmagenta" // [139,0,139,1]
    case darkolivegreen = "darkolivegreen" // [85,107,47,1]
    case darkorange = "darkorange" // [255,140,0,1]
    case darkorchid = "darkorchid" // [153,50,204,1]
    case darkred = "darkred" // [139,0,0,1]
    case darksalmon = "darksalmon" // [233,150,122,1]
    case darkseagreen = "darkseagreen" // [143,188,143,1]
    case darkslateblue = "darkslateblue" // [72,61,139,1]
    case darkslategray = "darkslategray" // [47,79,79,1]
    case darkslategrey = "darkslategrey" // [47,79,79,1]
    case darkturquoise = "darkturquoise" // [0,206,209,1]
    case darkviolet = "darkviolet" // [148,0,211,1]
    case deeppink = "deeppink" // [255,20,147,1]
    case deepskyblue = "deepskyblue" // [0,191,255,1]
    case dimgray = "dimgray" // [105,105,105,1]
    case dimgrey = "dimgrey" // [105,105,105,1]
    case dodgerblue = "dodgerblue" // [30,144,255,1]
    case firebrick = "firebrick" // [178,34,34,1]
    case floralwhite = "floralwhite" // [255,250,240,1]
    case forestgreen = "forestgreen" // [34,139,34,1]
    case fuchsia = "fuchsia" // [255,0,255,1]
    case gainsboro = "gainsboro" // [220,220,220,1]
    case ghostwhite = "ghostwhite" // [248,248,255,1]
    case gold = "gold" // [255,215,0,1]
    case goldenrod = "goldenrod" // [218,165,32,1]
    case gray = "gray" // [128,128,128,1]
    case green = "green" // [0,128,0,1]
    case greenyellow = "greenyellow" // [173,255,47,1]
    case grey = "grey" // [128,128,128,1]
    case honeydew = "honeydew" // [240,255,240,1]
    case hotpink = "hotpink" // [255,105,180,1]
    case indianred = "indianred" // [205,92,92,1]
    case indigo = "indigo" // [75,0,130,1]
    case ivory = "ivory" // [255,255,240,1]
    case khaki = "khaki" // [240,230,140,1]
    case lavender = "lavender" // [230,230,250,1]
    case lavenderblush = "lavenderblush" // [255,240,245,1]
    case lawngreen = "lawngreen" // [124,252,0,1]
    case lemonchiffon = "lemonchiffon" // [255,250,205,1]
    case lightblue = "lightblue" // [173,216,230,1]
    case lightcoral = "lightcoral" // [240,128,128,1]
    case lightcyan = "lightcyan" // [224,255,255,1]
    case lightgoldenrodyellow = "lightgoldenrodyellow" // [250,250,210,1]
    case lightgray = "lightgray" // [211,211,211,1]
    case lightgreen = "lightgreen" // [144,238,144,1]
    case lightgrey = "lightgrey" // [211,211,211,1]
    case lightpink = "lightpink" // [255,182,193,1]
    case lightsalmon = "lightsalmon" // [255,160,122,1]
    case lightseagreen = "lightseagreen" // [32,178,170,1]
    case lightskyblue = "lightskyblue" // [135,206,250,1]
    case lightslategray = "lightslategray" // [119,136,153,1]
    case lightslategrey = "lightslategrey" // [119,136,153,1]
    case lightsteelblue = "lightsteelblue" // [176,196,222,1]
    case lightyellow = "lightyellow" // [255,255,224,1]
    case lime = "lime" // [0,255,0,1]
    case limegreen = "limegreen" // [50,205,50,1]
    case linen = "linen" // [250,240,230,1]
    case magenta = "magenta" // [255,0,255,1]
    case maroon = "maroon" // [128,0,0,1]
    case mediumaquamarine = "mediumaquamarine" // [102,205,170,1]
    case mediumblue = "mediumblue" // [0,0,205,1]
    case mediumorchid = "mediumorchid" // [186,85,211,1]
    case mediumpurple = "mediumpurple" // [147,112,219,1]
    case mediumseagreen = "mediumseagreen" // [60,179,113,1]
    case mediumslateblue = "mediumslateblue" // [123,104,238,1]
    case mediumspringgreen = "mediumspringgreen" // [0,250,154,1]
    case mediumturquoise = "mediumturquoise" // [72,209,204,1]
    case mediumvioletred = "mediumvioletred" // [199,21,133,1]
    case midnightblue = "midnightblue" // [25,25,112,1]
    case mintcream = "mintcream" // [245,255,250,1]
    case mistyrose = "mistyrose" // [255,228,225,1]
    case moccasin = "moccasin" // [255,228,181,1]
    case navajowhite = "navajowhite" // [255,222,173,1]
    case navy = "navy" // [0,0,128,1]
    case oldlace = "oldlace" // [253,245,230,1]
    case olive = "olive" // [128,128,0,1]
    case olivedrab = "olivedrab" // [107,142,35,1]
    case orange = "orange" // [255,165,0,1]
    case orangered = "orangered" // [255,69,0,1]
    case orchid = "orchid" // [218,112,214,1]
    case palegoldenrod = "palegoldenrod" // [238,232,170,1]
    case palegreen = "palegreen" // [152,251,152,1]
    case paleturquoise = "paleturquoise" // [175,238,238,1]
    case palevioletred = "palevioletred" // [219,112,147,1]
    case papayawhip = "papayawhip" // [255,239,213,1]
    case peachpuff = "peachpuff" // [255,218,185,1]
    case peru = "peru" // [205,133,63,1]
    case pink = "pink" // [255,192,203,1]
    case plum = "plum" // [221,160,221,1]
    case powderblue = "powderblue" // [176,224,230,1]
    case purple = "purple" // [128,0,128,1]
    case red = "red" // [255,0,0,1]
    case rosybrown = "rosybrown" // [188,143,143,1]
    case royalblue = "royalblue" // [65,105,225,1]
    case saddlebrown = "saddlebrown" // [139,69,19,1]
    case salmon = "salmon" // [250,128,114,1]
    case sandybrown = "sandybrown" // [244,164,96,1]
    case seagreen = "seagreen" // [46,139,87,1]
    case seashell = "seashell" // [255,245,238,1]
    case sienna = "sienna" // [160,82,45,1]
    case silver = "silver" // [192,192,192,1]
    case skyblue = "skyblue" // [135,206,235,1]
    case slateblue = "slateblue" // [106,90,205,1]
    case slategray = "slategray" // [112,128,144,1]
    case slategrey = "slategrey" // [112,128,144,1]
    case snow = "snow" // [255,250,250,1]
    case springgreen = "springgreen" // [0,255,127,1]
    case steelblue = "steelblue" // [70,130,180,1]
    case tan = "tan" // [210,180,140,1]
    case teal = "teal" // [0,128,128,1]
    case thistle = "thistle" // [216,191,216,1]
    case tomato = "tomato" // [255,99,71,1]
    case turquoise = "turquoise" // [64,224,208,1]
    case violet = "violet" // [238,130,238,1]
    case wheat = "wheat" // [245,222,179,1]
    case white = "white" // [255,255,255,1]
    case whitesmoke = "whitesmoke" // [245,245,245,1]
    case yellow = "yellow" // [255,255,0,1]
    case yellowgreen = "yellowgreen" // [154,205,50,1]
    
    // FIXME: This method should return a generic color representation
    // maybe in the form of a triplet. 
    func colorFromKeyword() -> CIColor {
            
        switch self {
            
        case .black:                    // [0,0,0,1]
            return CIColor(red: 0/255, green: 0, blue: 0, alpha: 1)
        case .blanchedalmond :
            return CIColor(red: 255/255, green: 235/255, blue: 205/255, alpha: 1)
        case .transparent:
            return CIColor(red: 0, green: 0, blue: 0, alpha: 0)
        case .aliceblue:
            return CIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1)
        case .antiquewhite:
            return CIColor(red: 250/255, green: 235/255, blue: 215/255, alpha: 1)
        case .aqua:
            return CIColor(red: 0, green: 255/255, blue: 255/255, alpha: 1)
        case .aquamarine:
            return CIColor(red: 127/255, green: 255/255, blue: 212/255, alpha: 1)
        case .azure:
            return CIColor(red: 240/255, green: 255/255, blue: 255/255, alpha: 1)
        case .beige:
            return CIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 1)
        case .bisque:
            return CIColor(red: 255/255, green: 228/255, blue: 196/255, alpha: 1)
        case .blue:
            return CIColor(red: 0, green: 0, blue: 255/255, alpha: 1)
        case .blueviolet:
            return CIColor(red: 138/255, green: 43/255, blue: 226/255, alpha: 1)
        case .brown:
            return CIColor(red: 165/255, green: 42/255, blue: 42/255, alpha: 1)
        case .burlywood:
            return CIColor(red: 22/2552, green: 184/255, blue: 135/255, alpha: 1)
        case .cadetblue:
            return CIColor(red: 95/255, green: 158/255, blue: 160/255, alpha: 1)
        case .chartreuse:
            return CIColor(red: 127/255, green: 255/255, blue: 0, alpha: 1)
        case .chocolate:
            return CIColor(red: 210/255, green: 105/255, blue: 30/255, alpha: 1)
        case .coral:
            return CIColor(red: 255/255, green: 127/255, blue: 80/255, alpha: 1)
        case .cornflowerblue:
            return CIColor(red: 100/255, green: 149/255, blue: 237/255, alpha: 1)
        case .cornsilk:
            return CIColor(red: 255/255, green: 248/255, blue: 220/255, alpha: 1)
        case .crimson:
            return CIColor(red: 220/255, green: 20/255, blue: 60/255, alpha: 1)
        case .cyan:
            return CIColor(red: 0, green: 255/255, blue: 255/255, alpha: 1)
        case .darkblue:
            return CIColor(red: 0, green: 0, blue: 139/255, alpha: 1)
        case .darkcyan:
            return CIColor(red: 0, green: 139/255, blue: 139/255, alpha: 1)
        case .darkgoldenrod:
            return CIColor(red: 184/255, green: 134/255, blue: 11/255, alpha: 1)
        case .darkgray:
            return CIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        case .darkgreen:
            return CIColor(red: 0, green: 100/255, blue: 0, alpha: 1)
        case .darkgrey:
            return CIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
        case .darkkhaki:
            return CIColor(red: 189/255, green: 183/255, blue: 107/255, alpha: 1)
        case .darkmagenta:
            return CIColor(red: 139/255, green: 0, blue: 139/255, alpha: 1)
        case .darkolivegreen:
            return CIColor(red: 85/255, green: 107/255, blue: 47/255, alpha: 1)
        case .darkorange:
            return CIColor(red: 255/255, green: 140/255, blue: 0, alpha: 1)
        case .darkorchid:
            return CIColor(red: 153/255, green: 50/255, blue: 204/255, alpha: 1)
        case .darkred:
            return CIColor(red: 139/255, green: 0, blue: 0, alpha: 1)
        case .darksalmon:
            return CIColor(red: 233/255, green: 150/255, blue: 122/255, alpha: 1)
        case .darkseagreen:
            return CIColor(red: 143/255, green: 188/255, blue: 143/255, alpha: 1)
        case .darkslateblue:
            return CIColor(red: 72/255, green: 61/255, blue: 139/255, alpha: 1)
        case .darkslategray:
            return CIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
        case .darkslategrey:
            return CIColor(red: 47/255, green: 79/255, blue: 79/255, alpha: 1)
        case .darkturquoise:
            return CIColor(red: 0, green: 206/255, blue: 209/255, alpha: 1)
        case .darkviolet:
            return CIColor(red: 148/255, green: 0, blue: 211/255, alpha: 1)
        case .deeppink:
            return CIColor(red: 255/255, green: 20/255, blue: 147/255, alpha: 1)
        case .deepskyblue:
            return CIColor(red: 0, green: 191/255, blue: 255/255, alpha: 1)
        case .dimgray:
            return CIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
        case .dimgrey:
            return CIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
        case .dodgerblue:
            return CIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        case .firebrick:
            return CIColor(red: 178/255, green: 34/255, blue: 34/255, alpha: 1)
        case .floralwhite:
            return CIColor(red: 255/255, green: 250/255, blue: 240/255, alpha: 1)
        case .forestgreen:
            return CIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        case .fuchsia:
            return CIColor(red: 255/255, green: 0, blue: 255/255, alpha: 1)
        case .gainsboro:
            return CIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        case .ghostwhite:
            return CIColor(red: 248/255, green: 248/255, blue: 255/255, alpha: 1)
        case .gold:
            return CIColor(red: 255/255, green: 215/255, blue: 0, alpha: 1)
        case .goldenrod:
            return CIColor(red: 218/255, green: 165/255, blue: 32/255, alpha: 1)
        case .gray:
            return CIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        case .green:
            return CIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
        case .greenyellow:
            return CIColor(red: 173/255, green: 255/255, blue: 47/255, alpha: 1)
        case .grey:
            return CIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 1)
        case .honeydew:
            return CIColor(red: 240/255, green: 255/255, blue: 240/255, alpha: 1)
        case .hotpink:
            return CIColor(red: 255/255, green: 105/255, blue: 180/255, alpha: 1)
        case .indianred:
            return CIColor(red: 205/255, green: 92/255, blue: 92/255, alpha: 1)
        case .indigo:
            return CIColor(red: 75/255, green: 0, blue: 130/255, alpha: 1)
        case .ivory:
            return CIColor(red: 255/255, green: 255/255, blue: 240/255, alpha: 1)
        case .khaki:
            return CIColor(red: 240/255, green: 230/255, blue: 140/255, alpha: 1)
        case .lavender:
            return CIColor(red: 230/255, green: 230/255, blue: 250/255, alpha: 1)
        case .lavenderblush:
            return CIColor(red: 255/255, green: 240/255, blue: 245/255, alpha: 1)
        case .lawngreen:
            return CIColor(red: 124/255, green: 252/255, blue: 0, alpha: 1)
        case .lemonchiffon:
            return CIColor(red: 255/255, green: 250/255, blue: 205/255, alpha: 1)
        case .lightblue:
            return CIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1)
        case .lightcoral:
            return CIColor(red: 240/255, green: 128/255, blue: 128/255, alpha: 1)
        case .lightcyan:
            return CIColor(red: 224/255, green: 255/255, blue: 255/255, alpha: 1)
        case .lightgoldenrodyellow:
            return CIColor(red: 250/255, green: 250/255, blue: 210/255, alpha: 1)
        case .lightgray:
            return CIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        case .lightgreen:
            return CIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1)
        case .lightgrey:
            return CIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1)
        case .lightpink:
            return CIColor(red: 255/255, green: 182/255, blue: 193/255, alpha: 1)
        case .lightsalmon:
            return CIColor(red: 255/255, green: 160/255, blue: 122/255, alpha: 1)
        case .lightseagreen:
            return CIColor(red: 32/255, green: 178/255, blue: 170/255, alpha: 1)
        case .lightskyblue:
            return CIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 1)
        case .lightslategray:
            return CIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        case .lightslategrey:
            return CIColor(red: 119/255, green: 136/255, blue: 153/255, alpha: 1)
        case .lightsteelblue:
            return CIColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 1)
        case .lightyellow:
            return CIColor(red: 255/255, green: 255/255, blue: 224/255, alpha: 1)
        case .lime:
            return CIColor(red: 0, green: 255/255, blue: 0, alpha: 1)
        case .limegreen:
            return CIColor(red: 50/255, green: 205/255, blue: 50/255, alpha: 1)
        case .linen:
            return CIColor(red: 250/255, green: 240/255, blue: 230/255, alpha: 1)
        case .magenta:
            return CIColor(red: 255/255, green: 0, blue: 255/255, alpha: 1)
        case .maroon:
            return CIColor(red: 128/255, green: 0, blue: 0, alpha: 1)
        case .mediumaquamarine:
            return CIColor(red: 102/255, green: 205/255, blue: 170/255, alpha: 1)
        case .mediumblue:
            return CIColor(red: 0, green: 0, blue: 205/255, alpha: 1)
        case .mediumorchid:
            return CIColor(red: 186/255, green: 85/255, blue: 211/255, alpha: 1)
        case .mediumpurple:
            return CIColor(red: 147/255, green: 112/255, blue: 219/255, alpha: 1)
        case .mediumseagreen:
            return CIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 1)
        case .mediumslateblue:
            return CIColor(red: 123/255, green: 104/255, blue: 238/255, alpha: 1)
        case .mediumspringgreen:
            return CIColor(red: 0, green: 250/255, blue: 154/255, alpha: 1)
        case .mediumturquoise:
            return CIColor(red: 72/255, green: 209/255, blue: 204/255, alpha: 1)
        case .mediumvioletred:
            return CIColor(red: 199/255, green: 21/255, blue: 133/255, alpha: 1)
        case .midnightblue:
            return CIColor(red: 25/255, green: 25/255, blue: 112/255, alpha: 1)
        case .mintcream:
            return CIColor(red: 245/255, green: 255/255, blue: 250/255, alpha: 1)
        case .mistyrose:
            return CIColor(red: 255/255, green: 228/255, blue: 225/255, alpha: 1)
        case .moccasin:
            return CIColor(red: 255/255, green: 228/255, blue: 181/255, alpha: 1)
        case .navajowhite:
            return CIColor(red: 255/255, green: 222/255, blue: 173/255, alpha: 1)
        case .navy:
            return CIColor(red: 0, green: 0, blue: 128/255, alpha: 1)
        case .oldlace:
            return CIColor(red: 253/255, green: 245/255, blue: 230/255, alpha: 1)
        case .olive:
            return CIColor(red: 128/255, green: 128/255, blue: 0, alpha: 1)
        case .olivedrab:
            return CIColor(red: 107/255, green: 142/255, blue: 35/255, alpha: 1)
        case .orange:
            return CIColor(red: 255/255, green: 165/255, blue: 0, alpha: 1)
        case .orangered:
            return CIColor(red: 255/255, green: 69/255, blue: 0, alpha: 1)
        case .orchid:
            return CIColor(red: 218/255, green: 112/255, blue: 214/255, alpha: 1)
        case .palegoldenrod:
            return CIColor(red: 238/255, green: 232/255, blue: 170/255, alpha: 1)
        case .palegreen:
            return CIColor(red: 152/255, green: 251/255, blue: 152/255, alpha: 1)
        case .paleturquoise:
            return CIColor(red: 175/255, green: 238/255, blue: 238/255, alpha: 1)
        case .palevioletred:
            return CIColor(red: 219/255, green: 112/255, blue: 147/255, alpha: 1)
        case .papayawhip:
            return CIColor(red: 255/255, green: 239/255, blue: 213/255, alpha: 1)
        case .peachpuff:
            return CIColor(red: 255/255, green: 218/255, blue: 185/255, alpha: 1)
        case .peru:
            return CIColor(red: 205/255, green: 133/255, blue: 63/255, alpha: 1)
        case .pink:
            return CIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 1)
        case .plum:
            return CIColor(red: 221/255, green: 160/255, blue: 221/255, alpha: 1)
        case .powderblue:
            return CIColor(red: 176/255, green: 224/255, blue: 230/255, alpha: 1)
        case .purple:
            return CIColor(red: 128/255, green: 0, blue: 128/255, alpha: 1)
        case .red:
            return CIColor(red: 255/255, green: 0, blue: 0, alpha: 1)
        case .rosybrown:
            return CIColor(red: 188/255, green: 143/255, blue: 143/255, alpha: 1)
        case .royalblue:
            return CIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1)
        case .saddlebrown:
            return CIColor(red: 139/255, green: 69/255, blue: 19/255, alpha: 1)
        case .salmon:
            return CIColor(red: 250/255, green: 128/255, blue: 114/255, alpha: 1)
        case .sandybrown:
            return CIColor(red: 244/255, green: 164/255, blue: 96/255, alpha: 1)
        case .seagreen:
            return CIColor(red: 46/255, green: 139/255, blue: 87/255, alpha: 1)
        case .seashell:
            return CIColor(red: 255/255, green: 245/255, blue: 238/255, alpha: 1)
        case .sienna:
            return CIColor(red: 160/255, green: 82/255, blue: 45/255, alpha: 1)
        case .silver:
            return CIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 1)
        case .skyblue:
            return CIColor(red: 135/255, green: 206/255, blue: 235/255, alpha: 1)
        case .slateblue:
            return CIColor(red: 106/255, green: 90/255, blue: 205/255, alpha: 1)
        case .slategray:
            return CIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 1)
        case .slategrey:
            return CIColor(red: 112/255, green: 128/255, blue: 144/255, alpha: 1)
        case .snow:
            return CIColor(red: 255/255, green: 250/255, blue: 250/255, alpha: 1)
        case .springgreen:
            return CIColor(red: 0, green: 255/255, blue: 127/255, alpha: 1)
        case .steelblue:
            return CIColor(red: 70/255, green: 130/255, blue: 180/255, alpha: 1)
        case .tan:
            return CIColor(red: 210/255, green: 180/255, blue: 140/255, alpha: 1)
        case .teal:
            return CIColor(red: 0, green: 128/255, blue: 128/255, alpha: 1)
        case .thistle:
            return CIColor(red: 216/255, green: 191/255, blue: 216/255, alpha: 1)
        case .tomato:
            return CIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1)
        case .turquoise:
            return CIColor(red: 64/255, green: 224/255, blue: 208/255, alpha: 1)
        case .violet:
            return CIColor(red: 238/255, green: 130/255, blue: 238/255, alpha: 1)
        case .wheat:
            return CIColor(red: 245/255, green: 222/255, blue: 179/255, alpha: 1)
        case .white:
            return CIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        case .whitesmoke:
            return CIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        case .yellow:
            return CIColor(red: 255/255, green: 255/255, blue: 0, alpha: 1)
        case .yellowgreen:
            return CIColor(red: 154/255, green: 205/255, blue: 50/255, alpha: 1)
        }
    }
    
    public static var values: [ColorKeyword] {
        
        return [
        
        .black,
        .blanchedalmond,
        .transparent,
        .aliceblue,
        .antiquewhite,
        .aqua,
        .aquamarine,
        .azure,
        .beige,
        .bisque,
        .blue,
        .blueviolet,
        .brown,
        .burlywood,
        .cadetblue,
        .chartreuse,
        .chocolate,
        .coral,
        .cornflowerblue,
        .cornsilk,
        .crimson,
        .cyan,
        .darkblue,
        .darkcyan,
        .darkgoldenrod,
        .darkgray,
        .darkgreen,
        .darkgrey,
        .darkkhaki,
        .darkmagenta,
        .darkolivegreen,
        .darkorange,
        .darkorchid,
        .darkred,
        .darksalmon,
        .darkseagreen,
        .darkslateblue,
        .darkslategray,
        .darkslategrey,
        .darkturquoise,
        .darkviolet,
        .deeppink,
        .deepskyblue,
        .dimgray,
        .dimgrey,
        .dodgerblue,
        .firebrick,
        .floralwhite,
        .forestgreen,
        .fuchsia,
        .gainsboro,
        .ghostwhite,
        .gold,
        .goldenrod,
        .gray,
        .green,
        .greenyellow,
        .grey,
        .honeydew,
        .hotpink,
        .indianred,
        .indigo,
        .ivory,
        .khaki,
        .lavender,
        .lavenderblush,
        .lawngreen,
        .lemonchiffon,
        .lightblue,
        .lightcoral,
        .lightcyan,
        .lightgoldenrodyellow,
        .lightgray,
        .lightgreen,
        .lightgrey,
        .lightpink,
        .lightsalmon,
        .lightseagreen,
        .lightskyblue,
        .lightslategray,
        .lightslategrey,
        .lightsteelblue,
        .lightyellow,
        .lime,
        .limegreen,
        .linen,
        .magenta,
        .maroon,
        .mediumaquamarine,
        .mediumblue,
        .mediumorchid,
        .mediumpurple,
        .mediumseagreen,
        .mediumslateblue,
        .mediumspringgreen,
        .mediumturquoise,
        .mediumvioletred,
        .midnightblue,
        .mintcream,
        .mistyrose,
        .moccasin,
        .navajowhite,
        .navy,
        .oldlace,
        .olive,
        .olivedrab,
        .orange,
        .orangered,
        .orchid,
        .palegoldenrod,
        .palegreen,
        .paleturquoise,
        .palevioletred,
        .papayawhip,
        .peachpuff,
        .peru,
        .pink,
        .plum,
        .powderblue,
        .purple,
        .red,
        .rosybrown,
        .royalblue,
        .saddlebrown,
        .salmon,
        .sandybrown,
        .seagreen,
        .seashell,
        .sienna,
        .silver,
        .skyblue,
        .slateblue,
        .slategray,
        .slategrey,
        .snow,
        .springgreen,
        .steelblue,
        .tan,
        .teal,
        .thistle,
        .tomato,
        .turquoise,
        .violet,
        .wheat,
        .white,
        .whitesmoke,
        .yellow,
        .yellowgreen]
    }
    
    
}
