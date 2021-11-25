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
        let teambuilds: Driver<[TestbestMembers]>
    }
    
    func transform(input: Input) -> Output {
        let teambuilds =  BehaviorRelay<[TestbestMembers]>(value: [
            (image: "TestSquarePoster1", date: "09/27 - 11/30", title: "2021 인공지능 데이터 활용 경진대회", tags: ["개발자 급구"]),
            (image: "TestSquarePoster2", date: "10/19 - 11/21", title: "눈바디 AI 챌린지", tags: ["개발자 급구", "iOS 개발 경험"]),
            (image: "TestSquarePoster3", date: "11/05 - 11/07", title: "공공데이터 활용 문제해결 해커톤", tags: ["개발자", "기획자"]),
            (image: "TestSquarePoster4", date: "10/11 - 11/08", title: "NPHD 2021 - DATATHON", tags: ["개발자", "인공지능"]),
            (image: "TestSquarePoster5", date: "10/12 - 11/14", title: "원티드 해커톤해, 커리어", tags: ["개발자 급구", "iOS 개발 경험"])
        ])
        
        return Output(teambuilds: teambuilds.asDriver())
    }
}
