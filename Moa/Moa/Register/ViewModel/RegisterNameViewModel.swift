//
//  RegisterNameViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class RegisterNameViewModel: ViewModelType {
    struct Input {
        let changeName: Signal<String>
        let changePosition: Signal<Int>
        let moaButtonTapped: Signal<Void>
    }
    
    struct Output {
        let alertMessage: Signal<String>
        let nextProgress: Signal<Void>
    }

    private let disposeBag = DisposeBag()
    
    private let loginProvider: MoyaProvider<LoginAPI>
    private let email: String
    private let password: String

    init(email: String, password: String) {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        loginProvider = MoyaProvider<LoginAPI>(plugins: [networkLogger])
        self.email = email
        self.password = password
    }
    
    func transform(input: Input) -> Output {
        let alertMessage = PublishRelay<String>()
        let nextProgress = PublishRelay<Void>()
        let name = BehaviorRelay<String>(value: "")
        
        input.changeName
            .emit(to: name)
            .disposed(by: disposeBag)
        
        input.moaButtonTapped
            .emit { [weak self] (_: Void) in
                guard let self = self else { return }
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            alertMessage: alertMessage.asSignal(),
            nextProgress: nextProgress.asSignal()
        )
    }
}
