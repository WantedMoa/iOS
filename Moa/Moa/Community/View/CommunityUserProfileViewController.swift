//
//  CommunityUserProfileViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

enum UserProfileExpand {
    case open
    case close
    
    var image: UIImage? {
        switch self {
        case .open:
            return UIImage(named: "ChevronDown")
        case .close:
            return UIImage(named: "ChevronUp")
        }
    }
}

final class CommunityUserProfileViewController: UIViewController, IdentifierType {
    @IBOutlet private weak var dismissImageView: UIImageView!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var profileViewHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var profileExpandButtonImageView: UIImageView!
    @IBOutlet private weak var profileView: UIView!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    
    // message
    @IBOutlet private weak var messageTitleTextField: UITextField!
    @IBOutlet private weak var messageTextView: UITextView!
    @IBOutlet private weak var messagePlaceholderLabel: UILabel!
    // user
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var ratingImageView: UIImageView!
    @IBOutlet private weak var introduceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var experienceLabel: UILabel!
    @IBOutlet private weak var portfolioLabel: UILabel!
    @IBOutlet private weak var universityLabel: UILabel!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let disposeBag = DisposeBag()
    
    private let profileViewHeight: CGFloat = 650
    private var userProfileExpand = UserProfileExpand.open
    
    private let fetchUserProfile = PublishRelay<Void>()
     
    private lazy var input = CommunityUserProfileViewModel.Input(
        fetchUserProfile: fetchUserProfile.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
     
    private let viewModel: CommunityUserProfileViewModel
     
    init(index: Int) {
        self.viewModel = CommunityUserProfileViewModel(index: index)
        super.init(nibName: CommunityUserProfileViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        updateTagStackView(by: ["일러스트", "포토샵", "XD", "Sketch"])
    }
    
    private func bind() {
        output.name.drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.university.drive(universityLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.portfolio.drive(portfolioLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.experiance.drive(experienceLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        dismissImageView.rx.tapGesture()
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        profileExpandButtonImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                var height: CGFloat = 0
                var alpha: CGFloat = 0
                
                if self.userProfileExpand == .open { // close
                    height = 0
                    alpha = 0
                    self.userProfileExpand = .close
                    self.profileExpandButtonImageView.image = self.userProfileExpand.image
                } else { // open
                    height = self.profileViewHeight
                    alpha = 1
                    self.userProfileExpand = .open
                    self.profileExpandButtonImageView.image = self.userProfileExpand.image
                }
                
                self.profileViewHeightContraint.constant = height
                
                UIView.animate(withDuration: 0.5) {
                    self.profileView.alpha = alpha
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
        
        messageTextView.rx.text
            .map { !($0?.isEmpty ?? true) }
            .bind(to: messagePlaceholderLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        moaButtonView.titleLabel.text = "쪽지 보내기"
        prepareProfileImageView()
        prepareMessageTextView()
        prepareMessageTitleTextField()
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 128 / 2
    }
    
    private func prepareMessageTitleTextField() {
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? .systemFont(ofSize: 16)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: font
        ]

        messageTitleTextField.font = font
        messageTitleTextField.attributedPlaceholder = NSAttributedString(
            string: "쪽지 제목을 적어주세요",
            attributes: attributes
        )
    }
    
    private func prepareMessageTextView() {
        messageTextView.layer.masksToBounds = true
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.borderWidth = 1
        messageTextView.layer.borderColor = UIColor(rgb: 0xdddddd).cgColor
        messageTextView.textColor = .moaDarkColor
    }
}

// MARK: - Update Tag
extension CommunityUserProfileViewController {
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
