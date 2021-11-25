//
//  BestMemberViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxSwift
import RxCocoa

final class HomeBestMemberViewModel: ViewModelType {
    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[BestMemberSectionModel]>
    }
    
    var sectionTitles = ["인기 PM", "인기 디자이너", "인기 개발자"]
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let dummy1 = [
            (profileImage: "TestProfile2", name: "김원영"),
            (profileImage: "TestProfile3", name: "김유진"),
            (profileImage: "TestProfile4", name: "노기태"),
            (profileImage: "TestProfile5", name: "송나영"),
            // (profileImage: "TestProfile6", name: "이민영")
        ]
        
        let dummy2 = [
            (profileImage: "TestProfile7", name: "이든"),
            (profileImage: "TestProfile8", name: "임현석"),
            (profileImage: "TestProfile9", name: "이성민"),
            (profileImage: "TestProfile10", name: "김연정"),
            // (profileImage: "TestProfile11", name: "김범석")
        ]
        
        let dummy3 = [
            (profileImage: "TestProfile12", name: "허원"),
            (profileImage: "TestProfile13", name: "김기현"),
            (profileImage: "TestProfile14", name: "송찬영"),
            (profileImage: "TestProfile15", name: "이승빈"),
            // (profileImage: "TestProfile16", name: "강찬")
        ]
        
        let dummy4 = [
            (profileImage: "TestProfile17", name: "김민정"),
            (profileImage: "TestProfile18", name: "유동균"),
            (profileImage: "TestProfile19", name: "김탁현"),
            // (profileImage: "TestProfile20", name: "장동근"),
            // (profileImage: "TestProfile1", name: "이민정")
        ]
        
        let sections = BehaviorRelay<[BestMemberSectionModel]>(value: [
            .projectManager(items: dummy1),
            .designer(items: dummy2),
            // .productDesigner(items: dummy3),
            .programmer(items: dummy4)
        ])
 
        return Output(
            sections: sections.asDriver()
        )
    }
}
