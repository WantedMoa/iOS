//
//  RegisterNameViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class RegisterNameViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var nameCheckImageView: UIImageView!
    @IBOutlet private weak var nameBottomLineView: UIView!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    @IBOutlet private weak var postionStackView: UIStackView!
    @IBOutlet private weak var postionLabel: UILabel!
    
    private lazy var input = RegisterNameViewModel.Input(
        changeName: changeName.asSignal(),
        changePosition: changePosition.asSignal(),
        moaButtonTapped: moaButtonTapped.asSignal()
    )
    
    private lazy var output = viewModel.transform(input: input)
    
    private let disposeBag = DisposeBag()
    
    private let changeName = PublishRelay<String>()
    private let changePosition = PublishRelay<Int>()
    private let moaButtonTapped = PublishRelay<Void>()

    private let viewModel: RegisterNameViewModel
    
    init(email: String, password: String) {
        self.viewModel = RegisterNameViewModel(email: email, password: password)
        super.init(nibName: RegisterNameViewController.identifier, bundle: nil)
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
        nameTextField.rx.text
            .compactMap { $0 }
            .bind(to: changeName)
            .disposed(by: disposeBag)
        
        let isValidName = nameTextField.rx.text
            .compactMap { $0?.count }
            .map { $0 >= 2 && $0 < 10 && self.postionLabel.text != "직무를 선택해주세요" }
                        
        isValidName
            .map { $0 ? UIColor.black : UIColor(rgb: 0xdddddd) }
            .bind(to: nameBottomLineView.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        isValidName
            .map { $0 ? "BlackCircleCheck" : "GreyCircleCheck" }
            .map { UIImage(named: $0) }
            .bind(to: nameCheckImageView.rx.image)
            .disposed(by: disposeBag)
        
        isValidName
            .subscribe { [weak self] (isValid: Bool) in
                guard let self = self else { return }
                let textColor: UIColor = isValid ? .white : .black
                let viewColor: UIColor = isValid ? .black : .init(rgb: 0xdddddd)
                self.moaButtonView.titleLabel.textColor = textColor
                self.moaButtonView.contentView.backgroundColor = viewColor
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        moaButtonView.titleLabel.text = "완료"
        prepareNameTextField()
    }
    
    private func prepareNameTextField() {
        let font = UIFont.notoSansRegular(size: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        nameTextField.font = font
        nameTextField.attributedPlaceholder = NSAttributedString(
            string: "이름을 입력해주세요",
            attributes: attributes
        )
    }
}
