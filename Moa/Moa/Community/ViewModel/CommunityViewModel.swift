//
//  CommunityViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import Foundation

import RxSwift
import RxCocoa

final class CommunityViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let teambuilds: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let teambuilds = BehaviorRelay<[String]>(value: Array(repeating: "A", count: 10))
        return Output(teambuilds: teambuilds.asDriver())
    }
}
