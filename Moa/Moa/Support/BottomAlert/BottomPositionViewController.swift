//
//  BottomPositionViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/26.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class BottomPositionViewController: UIViewController {
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var productManagerView: UIView!
    @IBOutlet private weak var designerView: UIView!
    @IBOutlet private weak var progrmmerView: UIView!
    @IBOutlet private weak var markerterView: UIView!
    @IBOutlet private weak var cancelView: UIView!
    
    private let disposeBag = DisposeBag()
    
    // DI
    var blurVC: BackgroundBlur?
    var positionHandler: ((String, Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        prepareBottomViewRoundCorner()
    }
    
    private func bindUI() {
        cancelView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
        
        productManagerView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.positionHandler?("기획자", 1)
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
        
        designerView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.positionHandler?("디자이너", 2)
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
        
        progrmmerView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.positionHandler?("개발자", 3)
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
        
        markerterView.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (_: UITapGestureRecognizer) in
                guard let self = self else { return }
                self.positionHandler?("마케터", 4)
                self.dismissAndFadeOut()
            }
            .disposed(by: disposeBag)
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true)
    }
    
    private func prepareBottomViewRoundCorner() {
        bottomView.clipsToBounds = true
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
}
