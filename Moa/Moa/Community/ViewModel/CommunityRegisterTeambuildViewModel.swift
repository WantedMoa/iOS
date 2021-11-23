//
//  CommunityRegisterTeambuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import Foundation

import RxSwift
import RxCocoa

final class CommunityRegisterTeambuildViewModel: ViewModelType {
    struct Input {
        let changeTeambuildEndDate: Signal<Date>
        let changeCompetitionStartDate: Signal<Date>
        let changeCompetitionEndDate: Signal<Date>
    }
    
    struct Output {
        let teambuildEndDateTitle: Driver<String>
        let competitionStartDateTitle: Driver<String>
        let competitionEndDateTitle: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let teambuildEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionStartDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        let competitionEndDateTitle = BehaviorRelay<String>(value: "날짜를 선택하세요")
        
        return Output(
            teambuildEndDateTitle: teambuildEndDateTitle.asDriver(),
            competitionStartDateTitle: competitionStartDateTitle.asDriver(),
            competitionEndDateTitle: competitionEndDateTitle.asDriver()
        )
    }
}
