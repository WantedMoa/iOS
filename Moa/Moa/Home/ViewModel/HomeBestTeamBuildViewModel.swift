//
//  HomeBestTeamBuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class HomeBestTeamBuildViewModel: ViewModelType {
    struct Input {
        let fetchTeamBuilds: Signal<Void>
    }
    
    struct Output {
        let teamBuildes: Driver<[HomeBestTeamBuildSectionModel]>
    }
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let teamBuildes = BehaviorRelay<[HomeBestTeamBuildSectionModel]>(value: [])
        
        input.fetchTeamBuilds.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homePopularRecruits)
            }
            .map(HomePopularRecruitsResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    teamBuildes.accept([.topten(items: result)])
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            teamBuildes: teamBuildes.asDriver()
        )
    }
}
