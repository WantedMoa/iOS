//
//  LoginViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class LoginViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var idTextField: UITextField!
    @IBOutlet private weak var idBottomLineView: UIView!
    @IBOutlet private weak var idCheckImageView: UIImageView!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var passwordBottomLineView: UIView!
    @IBOutlet private weak var passwordCheckImageView: UIImageView!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    @IBOutlet private weak var registerLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    init() {
        
        super.init(nibName: LoginViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }
    
    private func bindUI() {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        let isValidID = idTextField.rx.text
            .compactMap { $0 }
            .map { $0.isValidEmail() }

        let isValidPassword = passwordTextField.rx.text
            .compactMap { $0 }
            .map { $0.isValidPassword()  }
        
        let isValidButton = Observable.combineLatest(isValidID, isValidPassword).map { $0 && $1 }
        
        isValidID
            .map { $0 ? UIColor.black : UIColor(rgb: 0xdddddd) }
            .bind(to: idBottomLineView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        isValidID
            .map { $0 ? "BlackCircleCheck" : "GreyCircleCheck" }
            .map { UIImage(named: $0) }
            .bind(to: idCheckImageView.rx.image)
            .disposed(by: disposeBag)
        
        isValidPassword
            .map { $0 ? UIColor.black : UIColor(rgb: 0xdddddd) }
            .bind(to: passwordBottomLineView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        isValidPassword
            .map { $0 ? "BlackCircleCheck" : "GreyCircleCheck" }
            .map { UIImage(named: $0) }
            .bind(to: passwordCheckImageView.rx.image)
            .disposed(by: disposeBag)
        
        isValidButton
            .subscribe { [weak self] (isValid: Bool) in
                guard let self = self else { return }
                let textColor: UIColor = isValid ? .white : .black
                let viewColor: UIColor = isValid ? .black : .init(rgb: 0xdddddd)
                self.moaButtonView.titleLabel.textColor = textColor
                self.moaButtonView.contentView.backgroundColor = viewColor
            }
            .disposed(by: disposeBag)
        
        registerLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = RegisterEmailViewController()
                let nc = MoaNavigationController(rootViewController: vc)
                nc.modalPresentationStyle = .fullScreen
                self.present(nc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        moaButtonView.titleLabel.text = "로그인"
        moaButtonView.titleLabel.textColor = .black
        moaButtonView.contentView.backgroundColor = .init(rgb: 0xdddddd)
        prepareIdTextField()
        preparePasswordTextField()
    }
    
    private func prepareIdTextField() {
        let font = UIFont.notoSansRegular(size: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        idTextField.font = font
        idTextField.attributedPlaceholder = NSAttributedString(
            string: "아이디(학교 이메일)",
            attributes: attributes
        )
    }
    
    private func preparePasswordTextField() {
        let font = UIFont.notoSansRegular(size: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        passwordTextField.font = font
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: attributes
        )
    }
}
