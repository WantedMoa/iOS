//
//  HomeViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import RxSwift
import RxCocoa
import RxFSPagerView

final class HomeViewController: UIViewController, IdentifierType {
    // MARK: - IBOutlet
    @IBOutlet private weak var pagerView: FSPagerView!
    @IBOutlet private weak var pageControlView: UIView!
    @IBOutlet private weak var pageControlLabel: UILabel!
    
    private lazy var input = HomeViewModel.Input(
        pagerViewDidScrolled: pagerViewDidScrolled.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let pagerViewDidScrolled = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    private let viewModel: HomeViewModel

    init() {
        self.viewModel = HomeViewModel()
        super.init(nibName: HomeViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    private func bind() {
        output.posters
            .drive(pagerView.rx.items(cellIdentifier: HomePagerViewCell.identifier)) {
            _, item, cell in
            cell.imageView?.image = UIImage(named: item)
        }
        .disposed(by: disposeBag)
        
        output.pagerControlTitle
            .drive(pageControlLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        pagerView.rx.itemScrolled
            .distinctUntilChanged()
            .bind(to: pagerViewDidScrolled)
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        preparePagerView()
        preparePageControlView()
    }
    
    private func preparePagerView() {
        pagerView.register(
            HomePagerViewCell.self,
            forCellWithReuseIdentifier: HomePagerViewCell.identifier
        )
        pagerView.isInfinite = true
        pagerView.automaticSlidingInterval = 3.0
        pagerView.layer.masksToBounds = true
        pagerView.layer.cornerRadius = 10
    }
    
    private func preparePageControlView() {
        pageControlView.layer.masksToBounds = true
        pageControlView.layer.cornerRadius = 10
    }
}
