//
//  CommunityViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class CommunityViewModel: ViewModelType {
    struct Input {
        let fetchTeambuilds: Signal<Void>
    }
    
    struct Output {
        let teambuilds: Driver<[CommunityRecruit]>
    }
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let teambuilds = BehaviorRelay<[CommunityRecruit]>(value: [])
        
        input.fetchTeambuilds.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.communityRecruits)
            }
            .map(CommunityRecruitsResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    teambuilds.accept(result)
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(teambuilds: teambuilds.asDriver())
    }
}
