//
//  SettingProfileViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/24.
//

import UIKit
import SafariServices

import RxCocoa
import RxGesture
import RxSwift

final class SettingProfileViewController: UIViewController {
    
    @IBOutlet private weak var bio: UILabel!
    @IBOutlet private weak var experience: UILabel!
    @IBOutlet private weak var university: UILabel!
    @IBOutlet private weak var portfolio: UILabel!
    @IBOutlet private weak var tagStackView: UIStackView!

    private lazy var input = SettingProfileViewModel.Input(fetchProfile: fetchProfile.asSignal())
    private lazy var output = viewModel.transform(input: input)
    private let viewModel = SettingProfileViewModel()
    
    private let fetchProfile = PublishRelay<Void>()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTagStackView(by: ["Swift", "XCode", "UIKit"])
        bindUI()
        bind()
        
        fetchProfile.accept(())
    }
    
    private func bind() {
        output.bio
            .drive(bio.rx.text)
            .disposed(by: disposeBag)

        output.university
            .drive(university.rx.text)
            .disposed(by: disposeBag)

        output.experience
            .drive(experience.rx.text)
            .disposed(by: disposeBag)
        
        output.portfolio
            .drive(portfolio.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        portfolio.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                guard let link = self.portfolio.text else { return }
                guard let url = URL(string: link) else { return }
                let safariVC = SFSafariViewController(url: url)
                safariVC.modalPresentationStyle = .fullScreen
                self.present(safariVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Update Tag
extension SettingProfileViewController {
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
