//
//  UIFont+.swift
//  Moa
//
//  Created by won heo on 2021/11/24.
//

import UIKit

extension UIFont {
    static func notoSansRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansKR-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func notoSansMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansKR-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
