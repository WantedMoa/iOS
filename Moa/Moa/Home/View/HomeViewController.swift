//
//  HomeViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/15.
//

import UIKit

import RxCocoa
import RxFSPagerView
import RxGesture
import RxSwift

final class HomeViewController: UIViewController, IdentifierType {
    // MARK: - IBOutlet
    /// profile
    @IBOutlet private weak var profileImageView: UIImageView!
    /// pagerView
    @IBOutlet private weak var pagerView: FSPagerView!
    @IBOutlet private weak var pageControlView: UIView!
    @IBOutlet private weak var pageControlLabel: UILabel!
    /// bestMember
    @IBOutlet private weak var bestMemberCollectionView: UICollectionView!
    @IBOutlet private weak var bestMemberDetailButtonLabel: UILabel!
    /// bestTeamBuild
    @IBOutlet private weak var bestTeamBuildCollectionView: UICollectionView!
    @IBOutlet private weak var bestTeamBuildCollectionViewHeight: NSLayoutConstraint!
    
    // ViewModel
    private lazy var input = HomeViewModel.Input(
        pagerViewDidScrolled: pagerViewDidScrolled.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    // Event
    private let pagerViewDidScrolled = PublishRelay<Int>()
    private let disposeBag = DisposeBag()
    
    // DI
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func bind() {
        output.posters
            .drive(pagerView.rx.items(cellIdentifier: HomePagerCell.identifier)) {
                _, item, cell in
                cell.imageView?.image = UIImage(named: item)
            }
            .disposed(by: disposeBag)
        
        output.pagerControlTitle
            .drive(pageControlLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.bestMembers
            .drive(bestMemberCollectionView.rx.items(
                cellIdentifier: HomeBestMemberCell.identifier,
                cellType: HomeBestMemberCell.self)
            ) { _, item, cell in
                cell.update(by: item)
            }
            .disposed(by: disposeBag)
        
        output.bestTeamBuilds
            .drive(bestTeamBuildCollectionView.rx.items(
                cellIdentifier: HomeBestTeamBuildCell.identifier,
                cellType: HomeBestTeamBuildCell.self)
            ) {
                _, _, _ in
                
            }
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        pagerView.rx.itemScrolled
            .distinctUntilChanged()
            .bind(to: pagerViewDidScrolled)
            .disposed(by: disposeBag)
                
        bestMemberDetailButtonLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (tapGesture: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = BestMemberViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        prepareProfileImageView()
        preparePagerView()
        preparePageControlView()
        prepareBestMemberCollectionView()
        prepareBestTeamBuildCollectionView()
    }
    
    private func prepareProfileImageView() {
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = 56 / 2
    }
    
    private func preparePagerView() {
        pagerView.delegate = self
        pagerView.register(
            HomePagerCell.self,
            forCellWithReuseIdentifier: HomePagerCell.identifier
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
    
    private func prepareBestMemberCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 76, height: 100)
        layout.minimumInteritemSpacing = 16
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        bestMemberCollectionView.collectionViewLayout = layout
        bestMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
    }
    
    private func prepareBestTeamBuildCollectionView() {
        bestTeamBuildCollectionView.delegate = self
        bestTeamBuildCollectionView.register(
            UINib(nibName: HomeBestTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestTeamBuildCell.identifier
        )
        bestTeamBuildCollectionView.isScrollEnabled = false
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard collectionView === bestTeamBuildCollectionView else {
            return CGSize.zero
        }
        
        let width: CGFloat = view.bounds.width - (16 * 2)
        let height: CGFloat = 87
        return CGSize(width: width, height: height)
    }
}

// MARK: - FSPagerViewDelegate
extension HomeViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool {
        return false
    }
}
