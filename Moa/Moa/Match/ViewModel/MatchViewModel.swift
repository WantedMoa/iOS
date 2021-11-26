//
//  MatchViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/18.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class MatchViewModel: ViewModelType {
    struct Input {
        let fetchMyTeambuilds: Signal<Void>
    }
    
    struct Output {
        let myTeambuilds: Driver<[MatchRecruit]>
        let myTeamTitle: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    let myTeambuilds = BehaviorRelay<[MatchRecruit]>(value: [])

    private let moaProvider: MoyaProvider<MoaAPI>
    private let tokenManager: TokenManager

    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        self.moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
        self.tokenManager = TokenManager()
    }
    
    func transform(input: Input) -> Output {
        let myTeamTitle = BehaviorRelay<String>(value: "나의 팀")

        input.fetchMyTeambuilds.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.matchRecruits)
            }
            .map(MatchRecruitsResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    return
                }
                
                if let result = response.result {
                    self.myTeambuilds.accept(result)
                    myTeamTitle.accept(result.first?.title ?? "나의 팀")
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            myTeambuilds: myTeambuilds.asDriver(),
            myTeamTitle: myTeamTitle.asDriver()
        )
    }
}
