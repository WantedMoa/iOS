//
//  RegisterEmailViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class RegisterEmailViewController: UIViewController, IdentifierType, CustomAlert {
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var idCheckImageView: UIImageView!
    @IBOutlet private weak var idBottomLineView: UIView!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    @IBOutlet private weak var sendEmailLabel: UILabel!
    
    private lazy var input = RegisterEmailViewModel.Input(
        changeEmail: changeEmail.asSignal(),
        sendEmailAuth: sendEmailAuth.asSignal(),
        moaButtonTapped: moaButtonTapped.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let sendEmailAuth = PublishRelay<Void>()
    private let changeEmail = PublishRelay<String>()
    private let moaButtonTapped = PublishRelay<Void>()

    private let isValidEmail = BehaviorRelay<Bool>(value: false)
    
    private let disposeBag = DisposeBag()
    private let viewModel: RegisterEmailViewModel

    init() {
        self.viewModel = RegisterEmailViewModel()
        super.init(nibName: RegisterEmailViewController.identifier, bundle: nil)
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
    
    private func configureUI() {
        navigationController?.navigationBar.isHidden = true
        moaButtonView.titleLabel.text = "완료"
        moaButtonView.titleLabel.textColor = .black
        moaButtonView.contentView.backgroundColor = .init(rgb: 0xdddddd)
        prepareIdTextField()
    }
    
    private func bind() {
        output.alertMessage
            .emit { [weak self] (message: String) in
                guard let self = self else { return }
                self.presentBottomAlert(message: message)
            }
            .disposed(by: disposeBag)
        
        output.nextProgress
            .emit { [weak self] email in
                guard let self = self else { return }
                let vc = RegisterPasswordViewController(email: email)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        idTextField.rx.text
            .compactMap { $0 }
            .bind(to: changeEmail)
            .disposed(by: disposeBag)
        
        let isValidID = idTextField.rx.text
            .compactMap { $0 }
            .map { $0.isValidEmail() }
        
        isValidID
            .map { $0 ? UIColor.black : UIColor(rgb: 0xdddddd) }
            .bind(to: idBottomLineView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        isValidID
            .map { $0 ? "BlackCircleCheck" : "GreyCircleCheck" }
            .map { UIImage(named: $0) }
            .bind(to: idCheckImageView.rx.image)
            .disposed(by: disposeBag)
        
        isValidID
            .subscribe { [weak self] (isValid: Bool) in
                guard let self = self else { return }
                let textColor: UIColor = isValid ? .white : .black
                let viewColor: UIColor = isValid ? .black : .init(rgb: 0xdddddd)
                self.moaButtonView.titleLabel.textColor = textColor
                self.moaButtonView.contentView.backgroundColor = viewColor
            }
            .disposed(by: disposeBag)
        
        isValidID
            .bind(to: isValidEmail)
            .disposed(by: disposeBag)
        
        sendEmailLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                
                guard self.isValidEmail.value else {
                    self.presentBottomAlert(message: "이메일을 입력해주세요")
                    return
                }
                
                self.sendEmailAuth.accept(())
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
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func prepareIdTextField() {
        let font = UIFont.notoSansRegular(size: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        idTextField.font = font
        idTextField.attributedPlaceholder = NSAttributedString(
            string: "이메일 주소를 입력해주세요",
            attributes: attributes
        )
    }
}
