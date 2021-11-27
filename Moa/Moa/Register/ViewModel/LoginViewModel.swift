//
//  LoginViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class LoginViewModel: ViewModelType {
    struct Input {
        let loginUser: Signal<(String, String)>
    }
    
    struct Output {
        let alertMessage: Signal<String>
        let nextProgress: Signal<Void>
    }

    private let disposeBag = DisposeBag()
    
    private let loginProvider: MoyaProvider<LoginAPI>
    private let tokenManager: TokenManager

    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        self.loginProvider = MoyaProvider<LoginAPI>(plugins: [networkLogger])
        self.tokenManager = TokenManager()
    }
    
    func transform(input: Input) -> Output {
        let alertMessage = PublishRelay<String>()
        let nextProgress = PublishRelay<Void>()
        
        input.loginUser.asObservable()
            .flatMap { [weak self] (email, password) -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                let param: [String: Any] = [
                    "email": email,
                    "password": password,
                ]
                return self.loginProvider.rx.request(.loginUser(param: param))
            }
            .map(LoginUserResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    alertMessage.accept(response.message)
                    return
                }
                
                if let result = response.result {
                    self.tokenManager.jwt = result.jwt
                    nextProgress.accept(())
                }
            }, onError: { error in
                print(error)
                alertMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        return Output(
            alertMessage: alertMessage.asSignal(),
            nextProgress: nextProgress.asSignal()
        )
    }
}
