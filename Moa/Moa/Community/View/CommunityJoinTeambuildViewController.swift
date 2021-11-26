//
//  CommunityJoinTeambuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

import RxCocoa
import RxGesture
import RxKeyboard
import RxSwift
import Kingfisher

final class CommunityJoinTeambuildViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var joinTitleTextField: UITextField!
    @IBOutlet private weak var joinMessageTextView: UITextView!
    @IBOutlet private weak var joinMessagePlaceholderLabel: UILabel!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var scrollViewBottomLayout: NSLayoutConstraint!
    @IBOutlet private weak var competitionImageView: UIImageView!
    @IBOutlet private weak var competitionTitleLabel: UILabel!
    @IBOutlet private weak var endDateLabel: UILabel!
    @IBOutlet private weak var startDateLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var deadLineLabel: UILabel!

    private var navVC: MoaNavigationController? {
        return navigationController as? MoaNavigationController
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // ViewModel
    private lazy var input = CommunityJoinTeambuildViewModel.Input(
        fetchTeambuild: fetchTeambuild.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let fetchTeambuild = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: CommunityJoinTeambuildViewModel
    
    init(index: Int) {
        self.viewModel = CommunityJoinTeambuildViewModel(index: index)
        super.init(nibName: CommunityJoinTeambuildViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        
        fetchTeambuild.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navVC?.tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navVC?.tintColor = .black
    }
    
    private func configureUI() {
        navigationItem.title = "지원하기"
        prepareJoinTitleTextField()
        prepareJoinMessageTextView()
        prepareProfileImageView()
    }
    
    private func bind() {
        output.startDateTitle
            .drive(startDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.endDateTitle
            .drive(endDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.content
            .drive(contentLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.tags
            .drive { [weak self] (tags: [String]) in
                guard let self = self else { return }
                self.updateTagStackView(by: tags)
            }
            .disposed(by: disposeBag)
        
        output.profileImageURL
            .emit { [weak self] (profileImageURL: String) in
                guard let self = self else { return }
                self.competitionImageView.kf.setImage(with: URL(string: profileImageURL))
            }
            .disposed(by: disposeBag)
        
        output.competitionTitle.drive(competitionTitleLabel.rx.text)
            .disposed(by: disposeBag)
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
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = CommunityUserProfileViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
                
        RxKeyboard.instance.visibleHeight
          .drive(onNext: { [weak self] keyboardVisibleHeight in
              guard let self = self else { return }
              guard self.joinMessageTextView.isFirstResponder else { return }
              
              let scrollOffset: CGFloat = keyboardVisibleHeight > 0 ? 150 : -150
              self.scrollView.contentOffset.y += scrollOffset
              
              UIView.animate(withDuration: 0.1) {
                  self.view.layoutIfNeeded()
              }
          })
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
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 56 / 2
    }
}

// MARK: - Update Tag
extension CommunityJoinTeambuildViewController {
    private func updateTagStackView(by tags: [String]) {
        for subView in tagStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for tag in tags {
            let label = generateTagLabel(title: tag)
            tagStackView.addArrangedSubview(label)
        }
    }
    
    private func generateTagLabel(title: String) -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .black
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 16
        
        let font = UIFont.notoSansRegular(size: 16)
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.text = title
        label.textColor = .white
        label.sizeToFit()
        
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: CGFloat(20 + label.bounds.width)),
            contentView.heightAnchor.constraint(equalToConstant: 32),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        return contentView
    }
}
