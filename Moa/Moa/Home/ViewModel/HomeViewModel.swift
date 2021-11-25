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

typealias TestbestMembers = (image: String, date: String, title: String, tags: [String])

final class HomeViewModel: ViewModelType {
    struct Input {
        let pagerViewDidScrolled: Signal<Int>
        let fetchPosters: Signal<Void>
    }
    
    struct Output {
        let posters: Driver<[HomeContest]>
        let pagerControlTitle: Driver<String>
        let bestMembers: Driver<[HomeBestMember]>
        let bestTeamBuilds: Driver<[TestbestMembers]>
    }
    
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
        let bestMembers = BehaviorRelay<[HomeBestMember]>(
            value: [
                (profileImage: "TestProfile2", name: "김원영"),
                (profileImage: "TestProfile3", name: "김유진"),
                (profileImage: "TestProfile4", name: "노기태"),
                (profileImage: "TestProfile5", name: "송나영"),
                (profileImage: "TestProfile6", name: "이민영")
            ]
        )
        let bestTeamBuilds = BehaviorRelay<[TestbestMembers]>(value: [
            (image: "TestSquarePoster1", date: "09/27 - 11/30", title: "2021 인공지능 데이터 활용 경진대회", tags: ["개발자 급구"]),
            (image: "TestSquarePoster2", date: "10/19 - 11/21", title: "눈바디 AI 챌린지", tags: ["개발자 급구", "iOS 개발 경험"]),
            (image: "TestSquarePoster3", date: "11/05 - 11/07", title: "공공데이터 활용 문제해결 해커톤", tags: ["개발자", "기획자"]),
            (image: "TestSquarePoster4", date: "10/11 - 11/08", title: "NPHD 2021 - DATATHON", tags: ["개발자", "인공지능"]),
            (image: "TestSquarePoster5", date: "10/12 - 11/14", title: "원티드 해커톤해, 커리어", tags: ["개발자 급구", "iOS 개발 경험"])
        ])
        
        input.fetchPosters.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.moaProvider.rx.request(.homeContest)
            }
            .map(HomeContestResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else { return }
                
                if let result = response.result {
                    posters.accept(result)
                }
        
            }, onError: { error in
                print("fetchPosters")
                print(error)
            })
            .disposed(by: disposeBag)
        
        input.pagerViewDidScrolled.emit { (num: Int) in
            pagerControlTitle.accept("\(num + 1) / \(posters.value.count)")
        }
        .disposed(by: disposeBag)
        
        return Output(
            posters: posters.asDriver(),
            pagerControlTitle: pagerControlTitle.asDriver(),
            bestMembers: bestMembers.asDriver(),
            bestTeamBuilds: bestTeamBuilds.asDriver()
        )
    }
}
