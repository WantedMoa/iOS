//
//  RegisterEmailViewModel.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import Foundation

import RxSwift
import RxCocoa
import Moya

final class RegisterEmailViewModel: ViewModelType {
    struct Input {
        let changeEmail: Signal<String>
        let sendEmailAuth: Signal<Void>
        let moaButtonTapped: Signal<Void>
    }
    
    struct Output {
        let alertMessage: Signal<String>
        let nextProgress: Signal<String>
    }

    private let disposeBag = DisposeBag()
    
    private let loginProvider: MoyaProvider<LoginAPI>

    init() {
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        let networkLogger = NetworkLoggerPlugin(configuration: loggerConfig)
        loginProvider = MoyaProvider<LoginAPI>(plugins: [networkLogger])
    }
    
    func transform(input: Input) -> Output {
        let alertMessage = PublishRelay<String>()
        let nextProgress = PublishRelay<String>()
        let email = BehaviorRelay<String>(value: "")
        
        input.changeEmail
            .emit(to: email)
            .disposed(by: disposeBag)
        
        input.sendEmailAuth.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                let param: [String: Any] = [
                    "email": email.value
                ]
                return self.loginProvider.rx.request(.requestEmailAuth(param: param))
            }
            .map(MoaResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    alertMessage.accept(response.message)
                    return
                }
                
                alertMessage.accept("인증 이메일이 전송되었습니다")
            }, onError: { error in
                print(error)
                alertMessage.accept(error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
        
        input.moaButtonTapped.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                return self.loginProvider.rx.request(.checkEmailAuth(email: email.value))
            }
            .map(MoaResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    alertMessage.accept(response.message)
                    return
                }
                
                nextProgress.accept(email.value)
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
