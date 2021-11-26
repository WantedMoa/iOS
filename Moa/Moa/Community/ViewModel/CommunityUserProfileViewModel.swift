//
//  CommunityUserProfileViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class CommunityUserProfileViewModel: ViewModelType {
    struct Input {
        let fetchUserProfile: Signal<Void>
    }
    
    struct Output {
        let name: Driver<String>
        let university: Driver<String>
        let bio: Driver<String>
        let experiance: Driver<String>
        let portfolio: Driver<String>
    }
    
    private let moaProvider: MoyaProvider<MoaAPI>
    private let index: Int
    
    init(index: Int) {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
        self.index = index
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let name = BehaviorRelay<String>(value: "")
        let university = BehaviorRelay<String>(value: "")
        let bio = BehaviorRelay<String>(value: "")
        let experiance = BehaviorRelay<String>(value: "")
        let portfolio = BehaviorRelay<String>(value: "")

        input.fetchUserProfile.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.communityUserProfile(index: self.index))
            }
            .map(CommunityUserProfileResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                let result = response.result
                name.accept(result.name)
                university.accept(result.university)
                bio.accept(result.bio)
                experiance.accept(result.experiance)
                portfolio.accept(result.portfolio)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            name: name.asDriver(),
            university: university.asDriver(),
            bio: bio.asDriver(),
            experiance: experiance.asDriver(),
            portfolio: portfolio.asDriver()
        )
    }
}
