//
//  ViewModelType.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
