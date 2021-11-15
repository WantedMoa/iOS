//
//  HomeViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import RxSwift
import RxRelay
import RxCocoa
import RxFSPagerView

final class HomeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet private weak var pagerView: FSPagerView!
    
    let items = Driver.of(["TestPoster", "TestPoster", "TestPoster", "TestPoster"])
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    private func bind() {
        items.drive(pagerView.rx.items(cellIdentifier: HomePagerViewCell.identifier)) {
            _, item, cell in
            cell.imageView?.image = UIImage(named: item)
        }
        .disposed(by: disposeBag)

    }
    
    private func bindUI() {
        pagerView.rx.itemScrolled
            .distinctUntilChanged()
            .subscribe({ number in
                print(number)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        preparePagerView()
    }
    
    private func preparePagerView() {
        pagerView.register(
            HomePagerViewCell.self,
            forCellWithReuseIdentifier: HomePagerViewCell.identifier
        )
        pagerView.isInfinite = true
        pagerView.layer.masksToBounds = true
        pagerView.layer.cornerRadius = 10
    }
}
