//
//  SettingMyPageViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class SettingMyPageViewModel: ViewModelType {
    struct Input {
        let fetchUserProfile: Signal<Void>
    }
    
    struct Output {
        let myTeambuilds: Driver<[(String, String)]>
        let email: Driver<String>
        let name: Driver<String>
        let profileImageURL: Driver<String>
        let ratingImageName: Driver<String>
    }
    
    private let disposeBag = DisposeBag()
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    func transform(input: Input) -> Output {
        let myTeambuilds = BehaviorRelay<[(String, String)]>(value: [
            ("원티드 해커톤해, 커리어", "11월 15일에 공고 완료 되어 만들어진 팀입니다"),
            ("NPHD 2021", "11월 01일 공고 완료되어 만들어진 팀입니다")
        ])
        
        let email = BehaviorRelay<String>(value: "")
        let name = BehaviorRelay<String>(value: "")
        let profileImageURL = BehaviorRelay<String>(value: "")
        let ratingImageName = BehaviorRelay<String>(value: "0")

        input.fetchUserProfile.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.settingUserProfile)
            }
            .map(SettingProfileResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let user = response.result.first {
                    name.accept(user.name)
                    profileImageURL.accept(user.profileImg)
                    ratingImageName.accept("\(user.rating)")
                    email.accept(user.email)
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            myTeambuilds: myTeambuilds.asDriver(),
            email: email.asDriver(),
            name: name.asDriver(),
            profileImageURL: profileImageURL.asDriver(),
            ratingImageName: ratingImageName.asDriver()
        )
    }
}
