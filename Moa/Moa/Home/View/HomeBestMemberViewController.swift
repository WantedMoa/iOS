//
//  BestMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/16.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class HomeBestMemberViewController: UIViewController, IdentifierType, UnderLineNavBar {
    // MARK: - IBOutlet
    @IBOutlet private weak var bestMemberCollectionView: UICollectionView!
    
    // ViewModel
    private lazy var input = HomeBestMemberViewModel.Input(
        fetchHomePopularUsersDetail: fetchHomePopularUsersDetail.asSignal()
    )
    private lazy var output = viewModel.transform(input: input)
    
    private let fetchHomePopularUsersDetail = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // DI
    private let viewModel: HomeBestMemberViewModel

    init() {
        self.viewModel = HomeBestMemberViewModel()
        super.init(nibName: HomeBestMemberViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
        fetchHomePopularUsersDetail.accept(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func bind() {
        output.sections
            .drive(bestMemberCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        bestMemberCollectionView.rx.modelSelected(HomePopularUsersDetail.self)
            .subscribe { [weak self] (item: HomePopularUsersDetail) in
                guard let self = self else { return }
                let vc = CommunityUserProfileViewController(index: item.index)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "인기 팀원"
        addUnderLineOnNavBar()
        prepareBestMemberCollectionView()
    }
    
    private func prepareBestMemberCollectionView() {
        bestMemberCollectionView.collectionViewLayout = generateLayout()
        bestMemberCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        bestMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
        bestMemberCollectionView.register(
            UINib(nibName: HomeBestMemberReusableView.identifier, bundle: nil),
            forSupplementaryViewOfKind: HomeBestMemberReusableView.headerElementKind,
            withReuseIdentifier: HomeBestMemberReusableView.identifier
        )
        bestMemberCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}

// MAKR: - Generate CollectionView Layout
extension HomeBestMemberViewController {
    private func generateLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(76),
                heightDimension: .absolute(100)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitem: item,
                count: 1
            )
            group.contentInsets = NSDirectionalEdgeInsets.zero
            
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(23)
            )
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: HomeBestMemberReusableView.headerElementKind,
                alignment: .top
            )
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(23)
                ),
                subitems: [group, group, group, group]
            )
            horizontalGroup.interItemSpacing = .flexible(10)
            
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.interGroupSpacing = 26
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .none
            // section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = .init(top: 16, leading: 16, bottom: 50, trailing: 16)
            return section
        }
        
        return layout
    }
}

extension HomeBestMemberViewController {
    private func dataSource() -> RxCollectionViewSectionedReloadDataSource<BestMemberSectionModel> {
        return RxCollectionViewSectionedReloadDataSource(configureCell: {
            dataSource, collectionView, indexPath, _ in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: HomeBestMemberCell.identifier,
                for: indexPath
            ) as? HomeBestMemberCell else {
                return UICollectionViewCell()
            }
            
            cell.update(by: dataSource[indexPath], isHiddenStatus: false)
            return cell
        }, configureSupplementaryView: {
            [weak self] dataSource, collectionView, kind, indexPath in
            guard let self = self else { return UICollectionReusableView() }
            guard let reuseView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeBestMemberReusableView.identifier,
                for: indexPath
            ) as? HomeBestMemberReusableView
            else {
                return UICollectionReusableView()
            }
            
            let title = self.viewModel.sectionTitles[indexPath.section]
            reuseView.update(by: title)
            return reuseView
        })
    }
}
