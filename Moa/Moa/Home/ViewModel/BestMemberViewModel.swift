//
//  BestMemberViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxSwift
import RxCocoa

final class BestMemberViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[BestMemberSectionModel]>
    }
    
    var sectionTitles = ["인기 PM", "인기 디자이너", "인기 기획자", "인기 개발자"]
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let dummys = [
            (profileImage: "TestProfile2", name: "김원영"),
            (profileImage: "TestProfile3", name: "김유진"),
            (profileImage: "TestProfile4", name: "노기태"),
            (profileImage: "TestProfile5", name: "송나영"),
            (profileImage: "TestProfile6", name: "이민영")
        ]
        
        let sections = BehaviorRelay<[BestMemberSectionModel]>(value: [
            .projectManager(items: dummys),
            .designer(items: dummys),
            .productDesigner(items: dummys),
            .programmer(items: dummys)
        ])
 
        return Output(
            sections: sections.asDriver()
        )
    }
}
