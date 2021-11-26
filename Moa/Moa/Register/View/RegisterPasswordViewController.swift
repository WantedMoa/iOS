//
//  RegisterPasswordViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class RegisterPasswordViewController: UIViewController, IdentifierType, CustomAlert {
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordCheckImageView: UIImageView!
    @IBOutlet private weak var passwordBottomLineView: UIView!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    
    private let disposeBag = DisposeBag()
    
    private lazy var input = RegisterPasswordViewModel.Input(
        changePassword: changePassword.asSignal(),
        moaButtonTapped: moaButtonTapped.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let changePassword = PublishRelay<String>()
    private let moaButtonTapped = PublishRelay<Void>()

    private let viewModel: RegisterPasswordViewModel
    
    init(email: String) {
        self.viewModel = RegisterPasswordViewModel(email: email)
        super.init(nibName: RegisterPasswordViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    private func bind() {
        output.alertMessage
            .emit { [weak self] (message: String) in
                guard let self = self else { return }
                self.presentBottomAlert(message: message)
            }
            .disposed(by: disposeBag)
        
        output.nextProgress
            .emit { [weak self] userInfo in
                guard let self = self else { return }
                let vc = RegisterNameViewController(email: userInfo.0, password: userInfo.1)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        passwordTextField.rx.text
            .compactMap { $0 }
            .bind(to: changePassword)
            .disposed(by: disposeBag)
        
        let isValidPassword = passwordTextField.rx.text
            .compactMap { $0 }
            .map { $0.isValidPassword() }
        
        isValidPassword
            .map { $0 ? UIColor.black : UIColor(rgb: 0xdddddd) }
            .bind(to: passwordBottomLineView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        isValidPassword
            .map { $0 ? "BlackCircleCheck" : "GreyCircleCheck" }
            .map { UIImage(named: $0) }
            .bind(to: passwordCheckImageView.rx.image)
            .disposed(by: disposeBag)
        
        isValidPassword
            .subscribe { [weak self] (isValid: Bool) in
                guard let self = self else { return }
                let textColor: UIColor = isValid ? .white : .black
                let viewColor: UIColor = isValid ? .black : .init(rgb: 0xdddddd)
                self.moaButtonView.titleLabel.textColor = textColor
                self.moaButtonView.contentView.backgroundColor = viewColor
            }
            .disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        moaButtonView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                
                if self.moaButtonView.contentView.backgroundColor == .black {
                    self.moaButtonTapped.accept(())
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        moaButtonView.titleLabel.text = "완료"
        preparePasswordTextField()
    }
    
    private func preparePasswordTextField() {
        let font = UIFont.notoSansRegular(size: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        passwordTextField.font = font
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
            attributes: attributes
        )
    }
}

