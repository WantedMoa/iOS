//
//  CommunityJoinTeambuildViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa

import Moya

final class CommunityJoinTeambuildViewModel: ViewModelType {
    struct Input {
        let fetchTeambuild: Signal<Void>
    }
    
    struct Output {
        let endDateTitle: Driver<String>
        let startDateTitle: Driver<String>
        let deadlineDateTitle: Driver<String>
        let tags: Driver<[String]>
        let content: Driver<String>
        let profileImageURL: Signal<String>
        let competitionTitle: Driver<String>
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
        let endDateTitle = BehaviorRelay<String>(value: "")
        let startDateTitle = BehaviorRelay<String>(value: "")
        let deadlineDateTitle = BehaviorRelay<String>(value: "")
        let tags = BehaviorRelay<[String]>(value: [])
        let content = BehaviorRelay<String>(value: "")
        let profileImageURL = PublishRelay<String>()
        let competitionTitle = BehaviorRelay<String>(value: "")

        input.fetchTeambuild.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.communityDetailRecruit(index: self.index))
            }
            .map(CommunityDetailRecruitResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    endDateTitle.accept(result.endDate)
                    startDateTitle.accept(result.startDate)
                    deadlineDateTitle.accept(result.deadline)
                    tags.accept(result.position)
                    content.accept(result.content)
                    profileImageURL.accept(result.pictureURL)
                    competitionTitle.accept(result.title)
                }
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(
            endDateTitle: endDateTitle.asDriver(),
            startDateTitle: startDateTitle.asDriver(),
            deadlineDateTitle: deadlineDateTitle.asDriver(),
            tags: tags.asDriver(),
            content: content.asDriver(),
            profileImageURL: profileImageURL.asSignal(),
            competitionTitle: competitionTitle.asDriver()
        )
    }
}
