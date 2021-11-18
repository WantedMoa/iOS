//
//  MatchViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import Foundation

import RxSwift
import RxCocoa

final class MatchViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let myTeambuilds: Driver<[String]>
    }
    
    func transform(input: Input) -> Output {
        let myTeambuilds = BehaviorRelay<[String]>(value: ["A", "B", "C"])
        return Output(myTeambuilds: myTeambuilds.asDriver())
    }
}
