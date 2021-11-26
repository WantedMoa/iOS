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
        let position = BehaviorRelay<Int>(value: 1)

        input.changeName
            .emit(to: name)
            .disposed(by: disposeBag)
        
        input.changePosition
            .emit(to: position)
            .disposed(by: disposeBag)
        
        input.moaButtonTapped.asObservable()
            .flatMap { [weak self] () -> Single<Response> in
                guard let self = self else { return Single<Response>.error(MoaError.flatMap) }
                let param: [String: Any] = [
                    "email": self.email,
                    "password": self.password,
                    "name": name.value,
                    "position": position.value
                ]
                return self.loginProvider.rx.request(.registerUser(param: param))
            }
            .map(MoaResponse.self)
            .subscribe(onNext: { response in
                guard response.isSuccess else {
                    alertMessage.accept(response.message)
                    return
                }
                
                nextProgress.accept(())
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
