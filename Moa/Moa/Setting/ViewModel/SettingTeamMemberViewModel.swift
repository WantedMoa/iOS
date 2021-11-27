//
//  SettingTeamMemberViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class SettingTeamMemberViewModel: ViewModelType {
    struct Input {
        let fetchSections: Signal<Void>
    }
    
    struct Output {
        let sections: Driver<[BestMemberSectionModel]>
    }
        
    private let disposeBag = DisposeBag()
    private let index: Int
    
    private let moaProvider: MoyaProvider<MoaAPI>
    
    init(index: Int) {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        moaProvider = MoyaProvider<MoaAPI>(plugins: [networkLogger])
        self.index = index
    }
    
    func transform(input: Input) -> Output {
        let sections = BehaviorRelay<[BestMemberSectionModel]>(value: [
            // .projectManager(items: dummy1)
        ])
        
        return Output(
            sections: sections.asDriver()
        )
    }
}
