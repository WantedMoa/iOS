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
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let posters = BehaviorRelay<[String]>(
            value: ["TestPoster1", "TestPoster2", "TestPoster3"]
        )
        let pagerControlTitle = BehaviorRelay<String>(value: "1 / \(posters.value.count)")
        
        input.pagerViewDidScrolled.emit { (num: Int) in
            pagerControlTitle.accept("\(num + 1) / \(posters.value.count)")
        }
        .disposed(by: disposeBag)
        
        return Output(
            posters: posters.asDriver(),
            pagerControlTitle: pagerControlTitle.asDriver()
        )
    }
}
