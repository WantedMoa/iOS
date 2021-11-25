//
//  SettingReviewTeamMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/25.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import RxGesture

final class SettingReviewTeamMemberViewController: UIViewController {
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var reviewTextView: UITextView!
    @IBOutlet private weak var reviewPlaceholder: UILabel!
    @IBOutlet private weak var reviewStackView: UIStackView!
    @IBOutlet private weak var reviewSilder: UISlider!
    @IBOutlet private weak var moaButtonView: MoaButtonView!
    @IBOutlet private weak var dismissImageView: UIImageView!
    @IBOutlet private weak var contentViewBottomHeight: NSLayoutConstraint!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
    }

    private func configureUI() {
        moaButtonView.titleLabel.text = "완료"
        initTagStackView()
        prepareProfileImageView()
        prepareReviewTextView()
    }
    
    private func bindUI() {
        dismissImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reviewSilder.rx.value
            .map { Int(ceil($0)) }
            .distinctUntilChanged()
            .subscribe { [weak self] (value: Int) in
                guard let self = self else { return }
                self.updateTagStackView(by: value)
            }
            .disposed(by: disposeBag)
        
        reviewSilder.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (tapGesture: UITapGestureRecognizer) in
                guard let self = self else { return }
                let slider: UISlider = self.reviewSilder
                let location = tapGesture.location(in: slider)
                let percent = 0 + Float(location.x / slider.bounds.width) * 5
                slider.setValue(percent, animated: true)
                slider.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
        
        reviewTextView.rx.text
            .map { !($0?.isEmpty ?? true) }
            .bind(to: reviewPlaceholder.rx.isHidden)
            .disposed(by: disposeBag)
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.reviewTextView.resignFirstResponder()
            }
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
          .drive(onNext: { [weak self] keyboardVisibleHeight in
              guard let self = self else { return }
              self.contentViewBottomHeight.constant = keyboardVisibleHeight
              
              UIView.animate(withDuration: 0.1) {
                  self.view.layoutIfNeeded()
              }
          })
          .disposed(by: disposeBag)
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 120 / 2
    }
    
    private func prepareReviewTextView() {
        reviewTextView.layer.masksToBounds = true
        reviewTextView.layer.cornerRadius = 10
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor(rgb: 0xdddddd).cgColor
        reviewTextView.textColor = .moaDarkColor
    }
}

extension SettingReviewTeamMemberViewController {
    private func updateTagStackView(by value: Int) {
        let count = 5
        let fillCount = value
        let emptyCount = count - value
        
        initTagStackView()
        
        for _ in 0..<fillCount {
            let imageView = generateImageView(isEmptySubtract: false)
            reviewStackView.addArrangedSubview(imageView)
        }
        
        for _ in 0..<emptyCount {
            let imageView = generateImageView()
            reviewStackView.addArrangedSubview(imageView)
        }
    }
    
    private func initTagStackView() {
        for subView in reviewStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
        
        for _ in 0..<5 {
            let imageView = generateImageView()
            reviewStackView.addArrangedSubview(imageView)
        }
    }
    
    private func resetTagStackView() {
        for subView in reviewStackView.arrangedSubviews {
            subView.removeFromSuperview()
        }
    }
    
    private func generateImageView(isEmptySubtract: Bool = true) -> UIImageView {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        let imageName = isEmptySubtract ? "EmptySubtract" : "FillSubtract"
        imageView.image = UIImage(named: imageName)
        return imageView
    }
}
