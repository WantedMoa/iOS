//
//  HomeViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    struct Input {
        let pagerViewDidScrolled: Signal<Int>
    }
    
    struct Output {
        let posters: Driver<[String]>
        let pagerControlTitle: Driver<String>
        let bestMembers: Driver<[HomeBestMember]>
        let bestTeamBuilds: Driver<[String]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let posters = BehaviorRelay<[String]>(
            value: ["TestPoster1", "TestPoster2", "TestPoster3"]
        )
        let pagerControlTitle = BehaviorRelay<String>(value: "1 / \(posters.value.count)")
        let bestMembers = BehaviorRelay<[HomeBestMember]>(
            value: [
                (profileImage: "TestProfile2", name: "김원영"),
                (profileImage: "TestProfile3", name: "김유진"),
                (profileImage: "TestProfile4", name: "노기태"),
                (profileImage: "TestProfile5", name: "송나영"),
                (profileImage: "TestProfile6", name: "이민영")
            ]
        )
        let bestTeamBuilds = BehaviorRelay<[String]>(value: ["A", "B", "C", "D", "A", "B", "C", "D"])
        
        input.pagerViewDidScrolled.emit { (num: Int) in
            pagerControlTitle.accept("\(num + 1) / \(posters.value.count)")
        }
        .disposed(by: disposeBag)
        
        return Output(
            posters: posters.asDriver(),
            pagerControlTitle: pagerControlTitle.asDriver(),
            bestMembers: bestMembers.asDriver(),
            bestTeamBuilds: bestTeamBuilds.asDriver()
        )
    }
}
