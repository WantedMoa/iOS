//
//  SettingProfileViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/27.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class SettingProfileViewModel: ViewModelType {
    struct Input {
        let fetchProfile: Signal<Void>
    }
    
    struct Output {
        let bio: Driver<String>
        let experience: Driver<String>
        let university: Driver<String>
        let portfolio: Driver<String>
    }
        
    private let disposeBag = DisposeBag()
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    func transform(input: Input) -> Output {
        let bio = BehaviorRelay<String>(value: "")
        let experience = BehaviorRelay<String>(value: "")
        let university = BehaviorRelay<String>(value: "")
        let portfolio = BehaviorRelay<String>(value: "")
        
        input.fetchProfile.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.settingUserProfile)
            }
            .map(SettingProfileResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let user = response.result.first {
                    bio.accept(user.bio)
                    experience.accept(user.experiance)
                    university.accept(user.universityName + " 재학 중")
                    portfolio.accept(user.portfolio)
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        return Output(
            bio: bio.asDriver(),
            experience: experience.asDriver(),
            university: university.asDriver(),
            portfolio: portfolio.asDriver()
        )
    }
}
