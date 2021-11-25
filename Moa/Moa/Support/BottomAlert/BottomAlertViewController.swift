//
//  BottomAlertViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/24.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class BottomAlertViewController: UIViewController {
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var titleLable: UILabel!
    @IBOutlet private weak var messageTitle: UILabel!
    @IBOutlet private weak var moaButtonView: MoaButtonView!

    private let disposeBag = DisposeBag()
    
    // DI
    var blurVC: BackgroundBlur?
    var message: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAndFadeIn()
        configureUI()
        bindUI()
    }
    
    private func bindUI() {
        moaButtonView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        moaButtonView.titleLabel.text = "확인"
        messageTitle.text = message
        prepareAlertView()
    }

    private func prepareAlertView() {
        alertView.layer.masksToBounds = true
        alertView.layer.cornerRadius = 10
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true)
    }
}
