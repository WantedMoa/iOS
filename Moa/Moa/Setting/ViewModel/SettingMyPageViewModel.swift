//
//  SettingMyPageViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SettingMyPageViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let myTeambuilds: Driver<[(String, String)]>
    }
    
    func transform(input: Input) -> Output {
        let myTeambuilds = BehaviorRelay<[(String, String)]>(value: [
            ("원티드 해커톤해, 커리어", "11월 15일에 공고 완료 되어 만들어진 팀입니다"),
            ("NPHD 2021", "11월 01일 공고 완료되어 만들어진 팀입니다")
        ])
        return Output(myTeambuilds: myTeambuilds.asDriver())
    }
}
