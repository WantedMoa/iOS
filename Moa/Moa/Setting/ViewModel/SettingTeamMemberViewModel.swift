//
//  SettingTeamMemberViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SettingTeamMemberViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[BestMemberSectionModel]>
    }
        
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let dummy1 = [
            (profileImage: "TestProfile12", name: "이성민"),
            (profileImage: "TestProfile3", name: "김유진"),
            (profileImage: "TestProfile4", name: "노기태"),
            (profileImage: "TestProfile5", name: "송나영"),
            (profileImage: "TestProfile6", name: "이민영")
        ]
        
        let sections = BehaviorRelay<[BestMemberSectionModel]>(value: [
            .projectManager(items: dummy1)
        ])
        
        return Output(
            sections: sections.asDriver()
        )
    }
}
