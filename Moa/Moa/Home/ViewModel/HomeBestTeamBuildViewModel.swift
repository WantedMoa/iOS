//
//  HomeBestTeamBuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeBestTeamBuildViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let teamBuildes: Driver<[String]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let teamBuildes = BehaviorRelay<[String]>(
            value: ["A", "B", "C", "D", "E", "F", "G"]
        )
        
        return Output(
            teamBuildes: teamBuildes.asDriver()
        )
    }
}
