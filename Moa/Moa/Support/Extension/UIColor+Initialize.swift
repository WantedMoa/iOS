//
//  UIColor+.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

public extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1.0
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static var moaDarkColor: UIColor {
        return .init(rgb: 0x000001)
    }
}
