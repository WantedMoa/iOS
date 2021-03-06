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
import Kingfisher
import SafariServices

final class HomeViewController: UIViewController, IdentifierType, CustomAlert {
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
    @IBOutlet private weak var bestTeamBuildDetailButtonLabel: UILabel!
    
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ratingImageView: UIImageView!
    
    private let splashView: UIView = {
        let splashView = SplashView()
        splashView.translatesAutoresizingMaskIntoConstraints = false
        return splashView
    }()
    
    private var tabVC: UITabBarController? {
        return navigationController?.tabBarController
    }
    
    // ViewModel
    private lazy var input = HomeViewModel.Input(
        pagerViewDidScrolled: pagerViewDidScrolled.asSignal(),
        fetchPosters: fetchPosters.asSignal(),
        fetchBestMembers: fetchBestMembers.asSignal(),
        fetchPopularRecruits: fetchPopularRecruits.asSignal(),
        fetchUserProfile: fetchUserProfile.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    // Event
    private let pagerViewDidScrolled = PublishRelay<Int>()
    private let fetchPosters = PublishRelay<Void>()
    private let fetchBestMembers = PublishRelay<Void>()
    private let fetchPopularRecruits = PublishRelay<Void>()
    private let fetchUserProfile = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: HomeViewModel

    init() {
        self.viewModel = HomeViewModel()
        super.init(nibName: HomeViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        
        prepareSplashView()
        fetchPosters.accept(())
        fetchBestMembers.accept(())
        fetchPopularRecruits.accept(())
        fetchUserProfile.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func bind() {
        output.posters
            .drive(pagerView.rx.items(cellIdentifier: HomePagerCell.identifier)) {
                _, poster, cell in
                cell.imageView?.contentMode = .scaleToFill
                cell.imageView?.kf.setImage(
                    with: URL(string: poster.pictureURL)
                )
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
            ) { _, item, cell in
                cell.update(by: item)
            }
            .disposed(by: disposeBag)
        
        output.bestTeamBuilds
            .drive { [weak self] (posters: [HomePopularRecruit]) in
                guard let self = self else { return }
                let height = CGFloat(30 + posters.count * 100)
                self.bestTeamBuildCollectionViewHeight.constant = height
            }
            .disposed(by: disposeBag)
        
        output.userProfileImageURL
            .filter { !$0.isEmpty }
            .drive { [weak self] (url: String) in
                guard let self = self else { return }
                self.profileImageView.kf.setImage(
                    with: URL(string: url),
                    completionHandler: { [weak self] result in
                        guard let self = self else { return }
                        UIView.animate(withDuration: 0.15) {
                            self.splashView.alpha = 0
                        }
                    }
                )
            }
            .disposed(by: disposeBag)
        
        output.userName
            .drive(nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.userRatingImageName
            .map { UIImage(named: $0) }
            .drive(ratingImageView.rx.image)
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
                let vc = HomeBestMemberViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        bestTeamBuildDetailButtonLabel.rx.tapGesture()
            .when(.recognized)
            .subscribe { [weak self] (tapGesture: UITapGestureRecognizer) in
                guard let self = self else { return }
                let vc = HomeBestTeamBuildViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        bestMemberCollectionView.rx.modelSelected(HomePopularUser.self)
            .subscribe { [weak self] (item: HomePopularUser) in
                guard let self = self else { return }
                let vc = CommunityUserProfileViewController(index: item.index)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        bestTeamBuildCollectionView.rx.modelSelected(HomePopularRecruit.self)
            .subscribe { [weak self] (item: HomePopularRecruit) in
                guard let self = self else { return }
                let vc = CommunityJoinTeambuildViewController(index: item.index)
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
        pagerView.automaticSlidingInterval = 6.0
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
    
    private func prepareSplashView() {
        guard let tabVC = tabVC else { return }
        tabVC.view.addSubview(splashView)
        
        NSLayoutConstraint.activate([
            splashView.leadingAnchor.constraint(equalTo: tabVC.view.leadingAnchor),
            splashView.trailingAnchor.constraint(equalTo: tabVC.view.trailingAnchor),
            splashView.topAnchor.constraint(equalTo: tabVC.view.topAnchor),
            splashView.bottomAnchor.constraint(equalTo: tabVC.view.bottomAnchor)
        ])
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
        let count = viewModel.homeContests.count
        let currentIndex = index % count
        guard currentIndex >= 0 && currentIndex < count else { return false }
        guard let url = URL(string: viewModel.homeContests[currentIndex].linkURL) else { return false }
        let safariVC = SFSafariViewController(url: url)
        tabVC?.present(safariVC, animated: true)
        return false
    }
}
