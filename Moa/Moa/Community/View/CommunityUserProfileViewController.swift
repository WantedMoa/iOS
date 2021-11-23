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

final class CommunityUserProfileViewController: UIViewController {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var dismissImageView: UIImageView!
    @IBOutlet private weak var tagStackView: UIStackView!
    @IBOutlet private weak var profileViewHeightContraint: NSLayoutConstraint!
    @IBOutlet private weak var profileExpandButtonImageView: UIImageView!
    @IBOutlet private weak var profileView: UIView!
     
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private let disposeBag = DisposeBag()
    
    private let profileViewHeight: CGFloat = 650
    private var userProfileExpand = UserProfileExpand.open
     
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        updateTagStackView(by: ["일러스트", "포토샵", "XD", "Sketch"])
    }
    
    private func bindUI() {
        dismissImageView.rx.tapGesture()
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        profileExpandButtonImageView.rx.tapGesture()
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                var height: CGFloat = 0
                var alpha: CGFloat = 0
                
                if self.userProfileExpand == .open { // close
                    self.profileExpandButtonImageView.image = self.userProfileExpand.image
                    height = 0
                    alpha = 0
                    self.userProfileExpand = .close
                } else { // open
                    self.profileExpandButtonImageView.image = self.userProfileExpand.image
                    height = self.profileViewHeight
                    alpha = 1
                    self.userProfileExpand = .open
                }
                
                self.profileViewHeightContraint.constant = height
                
                UIView.animate(withDuration: 0.5) {
                    self.profileView.alpha = alpha
                    self.view.layoutIfNeeded()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareProfileImageView()
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 128 / 2
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
        
        let font = UIFont(name: "NotoSansKR-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16)
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
