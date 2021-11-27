//
//  BestTeamBuildViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class HomeBestTeamBuildViewController: UIViewController, IdentifierType, UnderLineNavBar {
    // MARK: - IBOutlet
    @IBOutlet private weak var bestTeamBuildCollectionView: UICollectionView!
    
    // ViewModel
    private lazy var input = HomeBestTeamBuildViewModel.Input(
        fetchTeamBuilds: fetchTeamBuilds.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    private let disposeBag = DisposeBag()
    
    
    private let fetchTeamBuilds = PublishRelay<Void>()
    
    // DI
    private let viewModel: HomeBestTeamBuildViewModel

    init() {
        self.viewModel = HomeBestTeamBuildViewModel()
        super.init(nibName: HomeBestTeamBuildViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        
        fetchTeamBuilds.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        output.teamBuildes.drive(bestTeamBuildCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        bestTeamBuildCollectionView.rx.modelSelected(HomePopularRecruit.self)
            .subscribe { [weak self] (item: HomePopularRecruit) in
                guard let self = self else { return }
                let vc = CommunityJoinTeambuildViewController(index: item.index)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "인기 팀원 모집 공고"
        addUnderLineOnNavBar()
        prepareBestTeamBuildCollectionView()
    }
    
    private func prepareBestTeamBuildCollectionView() {
        bestTeamBuildCollectionView.register(
            UINib(nibName: HomeDetailBestTeamBuildCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeDetailBestTeamBuildCell.identifier
        )
        bestTeamBuildCollectionView.register(
            UINib(nibName: HomeBestTeamBuildReusableView.identifier, bundle: nil),
            forSupplementaryViewOfKind: HomeBestTeamBuildReusableView.headerElementKind,
            withReuseIdentifier: HomeBestTeamBuildReusableView.identifier
        )
        bestTeamBuildCollectionView.delegate = self
    }
}

extension HomeBestTeamBuildViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.bounds.width - 12 - 16 * 2) / 2
        let height = width * 1.64
        return CGSize(width: width, height: height)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        let width = (view.bounds.width - 12 - 16 * 2) / 2
        return CGSize(width: width, height: 53)
    }
}

extension HomeBestTeamBuildViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<HomeBestTeamBuildSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell: {
            dataSource, collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeDetailBestTeamBuildCell.identifier,
                for: indexPath
            ) as? HomeDetailBestTeamBuildCell else {
                return UICollectionViewCell()
            }
            
            cell.update(by: dataSource[indexPath])
            return cell
        }, configureSupplementaryView: { _, collectionView, kind, indexPath in
            let reuseView = collectionView.dequeueReusableSupplementaryView(
                ofKind: HomeBestTeamBuildReusableView.headerElementKind,
                withReuseIdentifier: HomeBestTeamBuildReusableView.identifier,
                for: indexPath
            )
            return reuseView
        })
    }
}
