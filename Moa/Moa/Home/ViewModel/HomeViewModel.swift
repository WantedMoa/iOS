//
//  HomeViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

// typealias TestbestMembers = (image: String, date: String, title: String, tags: [String])
typealias HomeBestMember = (profileImage: String, name: String)

final class HomeViewModel: ViewModelType {
    struct Input {
        let pagerViewDidScrolled: Signal<Int>
        let fetchPosters: Signal<Void>
        let fetchBestMembers: Signal<Void>
        let fetchPopularRecruits: Signal<Void>
        let fetchUserProfile: Signal<Void>
    }
    
    struct Output {
        let posters: Driver<[HomeContest]>
        let pagerControlTitle: Driver<String>
        let bestMembers: Driver<[HomePopularUser]>
        let bestTeamBuilds: Driver<[HomePopularRecruit]>
        let userName: Driver<String>
        let userProfileImageURL: Driver<String>
        let userRatingImageName: Driver<String>
    }
    
    var homeContests: [HomeContest] = []
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let posters = BehaviorRelay<[HomeContest]>(value: [])
        let pagerControlTitle = BehaviorRelay<String>(value: "1 / \(posters.value.count)")
        let bestMembers = BehaviorRelay<[HomePopularUser]>(value: [])
        let bestTeamBuilds = BehaviorRelay<[HomePopularRecruit]>(value: [])
        
        let userName = BehaviorRelay<String>(value: "")
        let userProfileImageURL = BehaviorRelay<String>(value: "")
        let userRatingImageName = BehaviorRelay<String>(value: "0")
        
        input.pagerViewDidScrolled.emit { (num: Int) in
            pagerControlTitle.accept("\(num + 1) / \(posters.value.count)")
        }
        .disposed(by: disposeBag)
        
        input.fetchPosters.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homeContests)
            }
            .map(HomeContestsResponse.self)
            .subscribe(onNext: { [weak self] response in
                guard let self = self else { return }
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    self.homeContests = result
                    posters.accept(result)
                    pagerControlTitle.accept("1 / \(result.count)")
                }
        
            }, onError: { error in
                print("fetchPosters")
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.fetchBestMembers.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homePopularUsers)
            }
            .map(HomePopularUsersResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    bestMembers.accept(Array(result.prefix(5)))
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.fetchPopularRecruits.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homePopularRecruits)
            }
            .map(HomePopularRecruitsResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    bestTeamBuilds.accept(Array(result.prefix(4)))
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
                    userName.accept(user.name)
                    userProfileImageURL.accept(user.profileImg)
                    userRatingImageName.accept("\(user.rating)")
                }
        
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            posters: posters.asDriver(),
            pagerControlTitle: pagerControlTitle.asDriver(),
            bestMembers: bestMembers.asDriver(),
            bestTeamBuilds: bestTeamBuilds.asDriver(),
            userName: userName.asDriver(),
            userProfileImageURL: userProfileImageURL.asDriver(),
            userRatingImageName: userRatingImageName.asDriver()
        )
    }
}
