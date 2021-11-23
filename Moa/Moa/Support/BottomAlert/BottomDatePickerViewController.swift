//
//  BottomDatePickerViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/23.
//

import UIKit

import RxCocoa
import RxGesture
import RxSwift

final class BottomDatePickerViewController: UIViewController {
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var cancelView: UIView!
    
    private let disposeBag = DisposeBag()
    
    // DI
    var blurVC: BackgroundBlur?
    var datePickerHandler: ((Date) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentAndFadeIn()
        configureUI()
        bindUI()
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
        
        datePicker.rx.date
            .subscribe { [weak self] (date: Date) in
                guard let self = self else { return }
                self.datePickerHandler?(date)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareDatePick()
    }
    
    private func presentAndFadeIn() {
        blurVC?.fadeInBackgroundViewAnimation()
    }
    
    private func dismissAndFadeOut() {
        blurVC?.fadeOutBackgroundViewAnimation()
        dismiss(animated: true)
    }
    
    private func prepareDatePick() {
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.backgroundColor = .black
    }
    
    private func prepareBottomViewRoundCorner() {
        bottomView.clipsToBounds = true
        bottomView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
}
