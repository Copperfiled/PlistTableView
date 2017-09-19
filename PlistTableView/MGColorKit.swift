//
//  MGColorKit.swift
//  MogoPartner
//
//  Created by Hanguang on 2017/5/14.
//  Copyright © 2017年 mogoroom. All rights reserved.
//

import Foundation
import UIKit

/// Color palette
public extension UIColor {
    class var mgDodgerBlue: UIColor {
        return UIColor(hex: 0x2e8af1)
    }
    
    class var mgTableViewWhite: UIColor {
        return UIColor(hex: 0xf3f5fa)
    }
    
    class var mgTitleBlack: UIColor {
        return UIColor(hex: 0x323232)
    }
    
    class var mgWarmGrey: UIColor {
        return UIColor(hex: 0x909090)
    }
    
}

/// Hex color
public extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        
        if scanner.scanHexInt32(&color) {
            self.init(hex: color)
        } else {
            self.init(hex: 0x000000)
        }
    }
    
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex) & mask
        
        let red = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue = CGFloat(b) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) {
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    class func rgbColor(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(r, g, b)
    }
}
