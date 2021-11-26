//
//  BestMemberViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class HomeBestMemberViewModel: ViewModelType {
    struct Input {
        let fetchHomePopularUsersDetail: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[BestMemberSectionModel]>
    }
    
    var sectionTitles = ["인기 PM", "인기 디자이너", "인기 개발자", "인기 마케터"]
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let sections = BehaviorRelay<[BestMemberSectionModel]>(value: [])
        
        input.fetchHomePopularUsersDetail.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homePopularUsersDetail)
            }
            .map(HomePopularUsersDetailResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    sections.accept([
                        .projectManager(items: result.projectManagers),
                        .productDesigner(items: result.designers),
                        .programmer(items: result.developers),
                        .marketer(items: result.marketers)
                    ])
                }
                
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
 
        return Output(
            sections: sections.asDriver()
        )
    }
}
