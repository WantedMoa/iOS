//
//  MatchTeamMemberViewController.swift
//  Moa
//
//  Created by won heo on 2021/11/27.
//

import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class MatchTeamMemberViewController: UIViewController, IdentifierType, UnderLineNavBar {
    
    @IBOutlet private weak var matchTeamMemberCollectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    private let sections: Driver<[BestMemberSectionModel]>
    
    init(members: [BestMemberSectionModel]) {
        self.sections = Driver.of(members)
        super.init(nibName: MatchTeamMemberViewController.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindUI()
        bind()
    }
    
    private func bind() {
        sections.drive(matchTeamMemberCollectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func bindUI() {
        matchTeamMemberCollectionView.rx.modelSelected(HomePopularUsersDetail.self)
            .subscribe { [weak self] (item: HomePopularUsersDetail) in
                guard let self = self else { return }
                let vc = CommunityUserProfileViewController(index: item.index)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI() {
        navigationItem.title = "추천 팀원"
        addUnderLineOnNavBar()
        prepareBestMemberCollectionView()
    }
    
    
    private func prepareBestMemberCollectionView() {
        matchTeamMemberCollectionView.collectionViewLayout = generateLayout()
        matchTeamMemberCollectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        matchTeamMemberCollectionView.register(
            UINib(nibName: HomeBestMemberCell.identifier, bundle: nil),
            forCellWithReuseIdentifier: HomeBestMemberCell.identifier
        )
        matchTeamMemberCollectionView.register(
            UINib(nibName: HomeBestMemberReusableView.identifier, bundle: nil),
            forSupplementaryViewOfKind: HomeBestMemberReusableView.headerElementKind,
            withReuseIdentifier: HomeBestMemberReusableView.identifier
        )
        matchTeamMemberCollectionView.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}

// MAKR: - Generate CollectionView Layout
extension MatchTeamMemberViewController {
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

extension MatchTeamMemberViewController {
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
            guard let reuseView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HomeBestMemberReusableView.identifier,
                for: indexPath
            ) as? HomeBestMemberReusableView
            else {
                return UICollectionReusableView()
            }
            
            let titles = ["디자이너", "개발자"]
            let title = titles[indexPath.section]
            reuseView.update(by: title)
            return reuseView
        })
    }
}
