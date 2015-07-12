//
//  UIKit.swift
//  TipCal
//
//  Created by Oscar Swanros on 7/11/15.
//  Copyright (c) 2015 Pacific3. All rights reserved.
//

import UIKit

func configureUI() {
    let titleFontDescriptor = UIFontDescriptor(name: "AvenirNextCondensed-Bold", size: 23)
    UINavigationBar.appearance().titleTextAttributes = [
        NSForegroundColorAttributeName: UIColor.pt_lightGrayColor(),
        NSFontAttributeName: UIFont(descriptor: titleFontDescriptor, size: 0)
    ]
}

class PTNetworkActivityIndicator {
    static var count: Int = 0
    
    class func showNetworkActivityIndicator() {
        count++
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    class func hideNetworkActivityIndicator() {
        if count > 0 {
            count--
        }
        
        if count == 0 {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if hex.hasPrefix("#") {
            let index   = advance(hex.startIndex, 1)
            let hex     = hex.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (count(hex)) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                println("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    static func pt_redColor() -> UIColor {
        return UIColor(hex: "#C0392B")
    }
    
    static func pt_lightGrayColor() -> UIColor {
        return UIColor(hex: "#F2F1EF")
    }
    
    static func pt_darkGrayColor() -> UIColor {
        return UIColor(hex: "#777777")
    }
    
    static func pt_darkBlueColor() -> UIColor {
        return UIColor(hex: "#22313F")
    }
    
    static func pt_greenColor() -> UIColor {
        return UIColor(hex: "#3FC380")
    }
}