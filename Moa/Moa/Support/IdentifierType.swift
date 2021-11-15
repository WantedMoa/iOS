//
//  IdentifierType.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import Foundation

protocol IdentifierType: AnyObject {}

extension IdentifierType {
    static var identifier: String {
        return String(describing: self)
    }
}

