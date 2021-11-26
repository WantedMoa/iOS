//
//  RegisterPasswordViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class RegisterPasswordViewModel: ViewModelType {
    struct Input {
        let changePassword: Signal<String>
        let moaButtonTapped: Signal<Void>
    }
    
    struct Output {
        let alertMessage: Signal<String>
        let nextProgress: Signal<(String, String)>
    }

    private let disposeBag = DisposeBag()
    
    private let loginProvider: MoyaProvider<LoginAPI>
    private let email: String

    init(email: String) {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        loginProvider = MoyaProvider<LoginAPI>(plugins: [networkLogger])
        self.email = email
    }
    
    func transform(input: Input) -> Output {
        let alertMessage = PublishRelay<String>()
        let nextProgress = PublishRelay<(String, String)>()
        let password = BehaviorRelay<String>(value: "")
        
        input.changePassword
            .emit(to: password)
            .disposed(by: disposeBag)
        
        input.moaButtonTapped
            .emit { [weak self] (_: Void) in
                guard let self = self else { return }
                nextProgress.accept((self.email, password.value))
            }
            .disposed(by: disposeBag)
        
        return Output(
            alertMessage: alertMessage.asSignal(),
            nextProgress: nextProgress.asSignal()
        )
    }
}
