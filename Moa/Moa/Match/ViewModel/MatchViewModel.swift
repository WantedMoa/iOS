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
        let fetchRecommends: Signal<Int>
        let fetchUserProfile: Signal<Void>
    }
    
    struct Output {
        let myTeambuilds: Driver<[MatchRecruit]>
        let myTeamTitle: Driver<String>
        let recommendCount: Driver<Int>
        let innerImageURL: Driver<String>
        let outerFirstImageURL: Driver<String>
        let outerSecondImageURL: Driver<String>
        let outerThirdImageURL: Driver<String>
        let profileImageURL: Driver<String>
        let name: Driver<String>
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
        let recommendCount = BehaviorRelay<Int>(value: 0)
        let innerImageURL = BehaviorRelay<String>(value: "")
        let outerFirstImageURL = BehaviorRelay<String>(value: "")
        let outerSecondImageURL = BehaviorRelay<String>(value: "")
        let outerThirdImageURL = BehaviorRelay<String>(value: "")
        let profileImageURL = BehaviorRelay<String>(value: "")
        let name = BehaviorRelay<String>(value: "")

        let imageDrivers = [innerImageURL, outerFirstImageURL, outerSecondImageURL, outerThirdImageURL]
        
        let fetchInitRecommends = PublishRelay<Int>()

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
                    
                    if let firstItem = result.first {
                        myTeamTitle.accept(firstItem.title)
                        fetchInitRecommends.accept(firstItem.index)
                    }
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        Signal.merge([fetchInitRecommends.asSignal(), input.fetchRecommends])
            .asObservable()
            .flatMap { [weak self] (index: Int) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.matchRecommends(index: index))
            }
            .map(MatchRecommendsResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    return
                }
                
                if let result = response.result {
                    recommendCount.accept(result.count)
                    
                    for (imageDriver, recommend) in zip(imageDrivers, result) {
                        imageDriver.accept(recommend.profileImgURL)
                    }
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.fetchUserProfile.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.settingUserProfile)
            }
            .map(SettingProfileResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let user = response.result.first {
                    profileImageURL.accept(user.profileImg)
                    let names = user.name.map { $0 }
                    name.accept(String(names.suffix(names.count - 1) + "님"))
                }
            
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            myTeambuilds: myTeambuilds.asDriver(),
            myTeamTitle: myTeamTitle.asDriver(),
            recommendCount: recommendCount.asDriver(),
            innerImageURL: innerImageURL.asDriver(),
            outerFirstImageURL: outerFirstImageURL.asDriver(),
            outerSecondImageURL: outerSecondImageURL.asDriver(),
            outerThirdImageURL: outerThirdImageURL.asDriver(),
            profileImageURL: profileImageURL.asDriver(),
            name: name.asDriver()
        )
    }
}
