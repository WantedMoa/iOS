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
        let teamBuildes: Driver<[HomeBestTeamBuildSectionModel]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let teamBuildes = BehaviorRelay<[HomeBestTeamBuildSectionModel]>(
            value: .init([.topten(items: ["A", "B", "C", "D", "E", "F", "G"])])
        )
        
        
        return Output(
            teamBuildes: teamBuildes.asDriver()
        )
    }
}
