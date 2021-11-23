//
//  CommunityJoinTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class CommunityJoinTeambuildViewController: UIViewController {
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var joinTitleTextField: UITextField!
    @IBOutlet private weak var joinMessageTextView: UITextView!
    @IBOutlet private weak var joinMessagePlaceholderLabel: UILabel!
    
    private var navVC: MoaNavigationController? {
        return navigationController as? MoaNavigationController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        updateTagStackView(by: ["개발자", "디자이너", "기획자"])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navVC?.tintColor = .black
    }
    
    private func configureUI() {
        navVC?.tintColor = .white
        navigationItem.title = "지원하기"
        prepareJoinTitleTextField()
        prepareJoinMessageTextView()
    }
    
    private func bind() {
        
    }
    
    private func bindUI() {
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.view.endEditing(true)
            }
            .disposed(by: disposeBag)
        
        joinMessageTextView.rx.text
            .map { !($0?.isEmpty ?? true) }
            .bind(to: joinMessagePlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func prepareJoinTitleTextField() {
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? .systemFont(ofSize: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        joinTitleTextField.font = font
        joinTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "제목을 적어주세요",
            attributes:attributes
        )
    }
    
    private func prepareJoinMessageTextView() {
        joinMessageTextView.layer.masksToBounds = true
        joinMessageTextView.layer.cornerRadius = 10
        joinMessageTextView.layer.borderWidth = 1
        joinMessageTextView.layer.borderColor = UIColor(rgb: 0xdddddd).cgColor
        joinMessageTextView.textColor = .moaDarkColor
    }
}

// MARK: - Update Tag
extension CommunityJoinTeambuildViewController {
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel()
            label.text = "   " + tag + "   "
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel() -> UILabel {
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
        let label = UILabel()
        label.font = font
        label.textColor = .white
        label.backgroundColor = .black
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 11
        return label
    }
}
